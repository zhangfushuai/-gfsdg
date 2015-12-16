//
//  AllOrderView.m
//  几何社区
//
//  Created by KMING on 15/8/27.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "AllOrderView.h"
#import "Define.h"
#import "WaitForPayTableViewCell.h"
#import "CanceledFinishedOrderTableViewCell.h"
#import "OrderDetailViewController.h"
#import "NoOrderView.h"
#import "OrderCommentTableViewCell.h"
#import "WXApiObject.h"
#import <AlipaySDK/AlipaySDK.h>
#import "OrderCommentTableViewController.h"
@implementation AllOrderView

-(void)layoutSubviews{
    [super layoutSubviews];
    _manager.delegate =self;
    NSDictionary *dic =@{@"page":@"1"};
    [_manager getALLOrderWithPageParams:dic];
    
    self.delegate.myscroll.scrollEnabled=NO;
    for (UIButton *bt in self.delegate.topBtnArr) {
        bt.userInteractionEnabled=NO;
    }
    

}
- (id)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        // 初始化代码
        //self.backgroundColor = [UIColor blueColor];
        
        self.tableView = [[UITableView alloc]initWithFrame:self.bounds];
        [self addSubview:self.tableView];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.backgroundColor = HEADERVIEW_COLOR;
        [self.tableView setTableFooterView:[[UIView alloc]init]];
        self.allOrderArr = [NSMutableArray array];
        _manager = [JHDataManager getInstance];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cancelTheOrder:) name:@"cancelTheOrder" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(commentTheOrder:) name:@"commentTheOrder" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orderDetrailPageCanceled) name:@"orderDetrailPageCanceled" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orderDetailPageBack) name:@"orderDetailPageBack" object:nil];//详情页后退需要充值——manager
       
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(payTheOrder:) name:@"payTheOrder" object:nil];
       
       [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orderDetrailPagePaySuccess) name:@"orderDetrailPagePaySuccess" object:nil];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.labelText =@"加载中...";
        
        self.page = 1;
        self.header = [MJRefreshHeaderView header];
        self.header.scrollView = self.tableView;
        self.header.tag = 0;
        self.header.delegate = self;
        self.footer = [MJRefreshFooterView footer];
        self.footer.scrollView = self.tableView;
        self.footer.delegate = self;
        self.footer.tag = 1;
    }
    return self;
}
-(void)orderDetailPageBack{
    _manager.delegate = self;
}
#pragma mark - MJREfresh
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if (refreshView.tag==0) {
        self.page=1;
         NSDictionary *dic =@{@"page":@"1"};
        [_manager getALLOrderWithPageParams:dic];
    }
    else{
        if(self.allOrderArr.count!=0) {
            self.page = self.page+1;
        }
        NSDictionary *dic = @{@"page":[NSString stringWithFormat:@"%d",self.page]};
        [_manager getALLOrderWithPageParams:dic];
        
    }

}
#pragma mark - 支付成功
-(void)orderDetrailPagePaySuccess{
    //成功
    NSDictionary *dic =@{@"page":@"1"};
    [_manager getALLOrderWithPageParams:dic];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.labelText =@"加载中...";
}

-(void)payTheOrder:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification object];
    NSString *iid = [nameDictionary objectForKey:@"id"];
    NSString *payType = [nameDictionary objectForKey:@"payType"];

    if ([payType isEqualToString:@"微信支付"]) {
        _payWayFlag = WXPAY;
        [_manager getPaywayMessage:WXPAY withOrderID:iid];
    }else if([payType isEqualToString:@"支付宝支付"]){
        _payWayFlag =ALPAY;
        [_manager getPaywayMessage:ALPAY withOrderID:iid];
    }
    
}
- (void)sendALPay:(NSDictionary *)params
{
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"JhAlipay";
    //将商品信息拼接成字符串
    NSString *orderSpec = [params objectForKey:@"data"];
    [[AlipaySDK defaultService] payOrder:orderSpec fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        if([[resultDic objectForKey:@"resultStatus"] integerValue] == 9000){
            //成功
            NSDictionary *dic =@{@"page":@"1"};
            [_manager getALLOrderWithPageParams:dic];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
            hud.labelText =@"加载中...";
        }else{
            //失败
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"支付失败" message:@"请重新尝试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];

        }
    }];
}
- (void)sendWXPay:(NSDictionary *)params
{
    if (![WXApi isWXAppInstalled]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您尚未安装微信。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    JHGlobalApp.mainDelegate = self;
    //根据服务器端编码确定是否转码
    NSStringEncoding enc;
    //if UTF8编码
    //enc = NSUTF8StringEncoding;
    //if GBK编码
    enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSMutableString *stamp  = [params objectForKey:@"timestamp"];
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = [params objectForKey:@"appid"];
    req.partnerId           = [params objectForKey:@"partnerid"];
    req.prepayId            = [params objectForKey:@"prepayid"];
    req.nonceStr            = [params objectForKey:@"noncestr"];
    req.timeStamp           = stamp.intValue;
    req.package             = [params objectForKey:@"package"];
    req.sign                = [params objectForKey:@"sign"];
    [WXApi sendReq:req];
}
- (void)WXPay:(BaseResp *)resp  //
{
    if (resp.errCode == WXSuccess)
    { //微信支付成功
        
        NSDictionary *dic =@{@"page":@"1"};
        [_manager getALLOrderWithPageParams:dic];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
        hud.labelText =@"加载中...";
        
        
    }else{//
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"支付失败" message:@"请重新尝试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark -取消订单
-(void)orderDetrailPageCanceled{
    
    NSDictionary *dic =@{@"page":@"1"};
    [_manager getALLOrderWithPageParams:dic];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.labelText =@"加载中...";
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self.backV removeFromSuperview];
    }else{
        [self.backV removeFromSuperview];
        //queding
        NSDictionary *params = @{@"id":self.iid};
        [_manager cancelOrderWithParams:params];
        
    }
    
}

-(void)cancelTheOrder:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification object];
    self.iid = [nameDictionary objectForKey:@"id"];
    
    UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"是否确定取消此订单" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
    self.backV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.backV.backgroundColor = [UIColor darkGrayColor];
    self.backV.alpha = 0.1;
    [[UIApplication sharedApplication].keyWindow addSubview:self.backV];
    [as showInView:self.backV];
    
    
}
#pragma mark - 评论已完成的order
-(void)commentTheOrder:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification object];
    MyOrderModel *model = [nameDictionary objectForKey:@"model"];
    OrderCommentTableViewController *vc = [[OrderCommentTableViewController alloc]init];
    vc.products = model.products;
    [self.delegate.navigationController pushViewController:vc animated:YES];

}
-(void)requestSuccess:(id)object withRequestType:(RequestType)requestType{
    switch (requestType) {
        case JHGETALLORDER:
        {
            [self.header endRefreshing];
            [self.footer endRefreshing];
            NSArray *orderArr = object;
            if (self.page==1) {
                //下拉刷新
                
                self.allOrderArr = [orderArr mutableCopy];
            }else{
                //上拉加载
                if (orderArr.count==0||orderArr==nil) {
                    self.page=self.page-1;
                }
                [self.allOrderArr addObjectsFromArray:orderArr];
            }
            
            [self.tableView reloadData];
            self.delegate.myscroll.scrollEnabled=YES;
            for (UIButton *bt in self.delegate.topBtnArr) {
                bt.userInteractionEnabled=YES;
            }
            if (self.allOrderArr.count==0) {
                NoOrderView *noV = [[[NSBundle mainBundle]loadNibNamed:@"NoOrderView" owner:self options:0]firstObject];
                noV.frame=self.frame;
                noV.delegate = self.delegate;
                self.delegate.myscroll.scrollEnabled=YES;
                [self.delegate.myscroll addSubview:noV];
            }
            MBProgressHUD *hud = [MBProgressHUD HUDForView:self];
            [hud removeFromSuperview];

        }
            break;
        case JHCANCELORDER:
        {
            NSDictionary *dic = object;
            
            NSString *status = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
            if ([status isEqualToString:@"10000"]) {
                //取消成功
                NSDictionary *dic =@{@"page":@"1"};
                [_manager getALLOrderWithPageParams:dic];
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
                hud.labelText =@"加载中...";
            }
            
        }
            break;
        case JHPAYPARAMS:
        {
            if (_payWayFlag == WXPAY) {
                [self sendWXPay:object];
            }else
            {
                [self sendALPay:object];
            }
        }
            break;
            
        default:
            break;
    }
    
}
-(void)requestFailure:(id)failReson withRequestType:(RequestType)requestType{
    switch (requestType) {
        case JHGETALLORDER:
        {
            [self.header endRefreshing];
            [self.footer endRefreshing];
            if (self.page!=1) {
                self.page = self.page-1;
            }
            self.delegate.myscroll.scrollEnabled=YES;
            for (UIButton *bt in self.delegate.topBtnArr) {
                bt.userInteractionEnabled=YES;
            }
            if (!failReson) {
                failReson = @"加载失败";
            }
            MBProgressHUD *hud = [MBProgressHUD HUDForView:self];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = failReson;
            [hud showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [hud removeFromSuperview];
                
            }];
        }
            break;
        case JHCANCELORDER:
        {
            if (!failReson) {
                failReson = @"加载失败";
            }
            MBProgressHUD *hud = [MBProgressHUD HUDForView:self];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = failReson;
            [hud showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [hud removeFromSuperview];
                
            }];
        }
            break;
        case JHPAYPARAMS:
        {
            if (!failReson) {
                failReson = @"加载失败";
            }
            MBProgressHUD *hud = [MBProgressHUD HUDForView:self];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = failReson;
            [hud showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [hud removeFromSuperview];
                
            }];
        }
            break;
            
        default:
            break;
    }
    
   
}
//制作headerview
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]
                    initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8.5)];
    view.backgroundColor = HEADERVIEW_COLOR;
    UIView *topline =[[UIView alloc]initWithFrame:CGRectMake(0, 0.2, SCREEN_WIDTH, 0.5)];
    topline.backgroundColor = SEPARATELINE_COLOR;
    [view addSubview:topline];
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.allOrderArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    MyOrderModel *model = self.allOrderArr[indexPath.section];
    if ([model.status isEqualToString:@"未付款"]||[model.status isEqualToString:@"已送达"]||([model.status isEqualToString:@"未取货"]&&[model.pay_type isEqualToString:@"货到付款"])) {
        return 176;
    }else{
        return 136;
    }
   
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{
        return 8.5;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyOrderModel *model = self.allOrderArr[indexPath.section];
    
    if ([model.status isEqualToString:@"未付款"]||([model.status isEqualToString:@"未取货"]&&[model.pay_type isEqualToString:@"货到付款"])) {
        WaitForPayTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"WaitForPayTableViewCell" owner:self options:0]firstObject];
       // }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = model;
        return cell;
    }
    else if ([model.status isEqualToString:@"已送达"]){
        OrderCommentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderCommentTableViewCell" owner:self options:0]firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model=model;
        return cell;
    }
    else{
        CanceledFinishedOrderTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
       if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"CanceledFinishedOrderTableViewCell" owner:self options:0]firstObject];
        }
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    
    
    
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"cancelTheOrder" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"orderDetrailPageCanceled" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"payTheOrder" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"orderDetrailPagePaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"orderDetailPageBack" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"commentTheOrder" object:nil];
    [self.header free];
    [self.footer free];
 
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderDetailViewController *vc = [[OrderDetailViewController alloc]init];
    vc.model =self.allOrderArr[indexPath.section];
    [self.delegate.navigationController pushViewController:vc animated:YES];
}

-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        self.tableView.separatorColor = SEPARATELINE_COLOR;
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
     [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        self.tableView.separatorColor = SEPARATELINE_COLOR;
    }
    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
@end
