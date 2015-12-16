//
//  OrderDetailViewController.m
//  几何社区
//
//  Created by KMING on 15/8/28.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "Define.h"
#import "OrderDetailFirstCellTableViewCell.h"
#import "OrderDetailSection2TableViewCell.h"
#import "OrderDetailDownSectionSingleTableViewCell.h"

#import "WXApiObject.h"
#import <AlipaySDK/AlipaySDK.h>
@interface OrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,JHDataMagerDelegate,MainDelegate>

@end

@implementation OrderDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [self makeNavigation];
    [super viewWillAppear:animated];
    _manager.delegate =self;
    [MobClick beginLogPageView:@"OrderDetailViewController"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"OrderDetailViewController"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"orderDetailPageBack" object:nil];
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _manager = [JHDataManager getInstance];
    self.section2contents = [NSMutableArray array];
    [self.section2contents addObject:self.model.number];
    [self.section2contents addObject:self.model.created];
    [self.section2contents addObject:self.model.status];
    self.section3contents = [NSMutableArray array];
    [self.section3contents addObject:self.model.pay_type];
    if ([self.model.coupon isEqualToString:@""]||self.model.coupon==nil) {
        self.model.coupon=@"0";
    }
    [self.section3contents addObject:[NSString stringWithFormat:@"￥%@",self.model.coupon]];
    [self.section3contents addObject:[NSString stringWithFormat:@"￥%@",self.model.shipping]];
    [self.section3contents addObject:[NSString stringWithFormat:@"￥%@",self.model.amount]];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if ([self.model.status isEqualToString:@"未付款"]||[self.model.status isEqualToString:@"未取货"]) {
         self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,SCREEN_WIDTH , SCREEN_HEIGHT-64-44)];
        self.cancelOrPayV = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-44, SCREEN_WIDTH, 44)];
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 44)];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cancelBtn.backgroundColor = NAVIGATIONBAR_COLOR;
        [cancelBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [cancelBtn addTarget:self action:@selector(cancelTheOrder) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelOrPayV addSubview:cancelBtn];
        
        UIButton *payBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 44)];
        payBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        payBtn.backgroundColor = [UIColor orangeColor];
        if ([self.model.pay_type isEqualToString:@"货到付款"]&&[self.model.status isEqualToString:@"未取货"]) {
            [payBtn setTitle:@"货到付款" forState:UIControlStateNormal];
            payBtn.enabled = NO;
        }else{
            [payBtn setTitle:@"去支付" forState:UIControlStateNormal];
            payBtn.enabled=YES;
        }
        [payBtn addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelOrPayV addSubview:payBtn];
        [self.view addSubview:self.cancelOrPayV];
        
    }else{
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64,SCREEN_WIDTH , SCREEN_HEIGHT-64)];
    }
   
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = HEADERVIEW_COLOR;
    
   
    
}
#pragma mark - 支付订单
-(void)payAction{

    NSString *payType=self.model.pay_type;
    if ([payType isEqualToString:@"微信支付"]) {
        _payWayFlag = WXPAY;
        [_manager getPaywayMessage:WXPAY withOrderID:self.model.iid];
    }else if([payType isEqualToString:@"支付宝支付"]){
        _payWayFlag =ALPAY;
        [_manager getPaywayMessage:ALPAY withOrderID:self.model.iid];
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
            self.tableView.frame =CGRectMake(0, 64,SCREEN_WIDTH , SCREEN_HEIGHT-64);
            NSString *status = [self.section2contents lastObject];
            status = @"已支付";
            [self.section2contents replaceObjectAtIndex:2 withObject:status];
            [self.tableView reloadData];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"orderDetrailPagePaySuccess" object:nil];
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
        self.tableView.frame =CGRectMake(0, 64,SCREEN_WIDTH , SCREEN_HEIGHT-64);
        NSString *status = [self.section2contents lastObject];
        status = @"已支付";
        [self.section2contents replaceObjectAtIndex:2 withObject:status];
        [self.tableView reloadData];
       [[NSNotificationCenter defaultCenter]postNotificationName:@"orderDetrailPagePaySuccess" object:nil];
        
        
    }else{//
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"支付失败" message:@"请重新尝试" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}



#pragma mark -取消订单
-(void)cancelTheOrder{
    UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"是否确定取消此订单" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [as showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        
    }else{
        
        //queding
        NSDictionary *params = @{@"id":self.model.iid};
        [_manager cancelOrderWithParams:params];
        
    }
    NSLog(@"%ld",buttonIndex);
}
-(void)requestSuccess:(id)object withRequestType:(RequestType)requestType{
    switch (requestType) {
        case JHCANCELORDER:
        {
            NSDictionary *dic = object;
            
            NSString *status = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
            if ([status isEqualToString:@"10000"]) {
                //取消成功
                [self.cancelOrPayV removeFromSuperview];
                self.tableView.frame =CGRectMake(0, 64,SCREEN_WIDTH , SCREEN_HEIGHT-64);
                NSString *status = [self.section2contents lastObject];
                status = @"已取消";
                [self.section2contents replaceObjectAtIndex:2 withObject:status];
                [self.tableView reloadData];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"orderDetrailPageCanceled" object:nil];
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

-(void)makeNavigation{
    
    self.title = @"订单详情";
    [self setLeftNavButtonWithType:BACK];
//    [self setNavColor:[UIColor whiteColor]];
    [self setNavTitleColor:[UIColor blackColor]];
  }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0||section==1) {
        return 1;
    }
    else if (section==2){
        return 3;
    }else{
        return 4;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 65;
    }else if (indexPath.section==1){
        return 72+66*self.model.products.count;
    }else{
        return 44;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyOrderModel *model = self.model;
    if (indexPath.section ==0) {
        OrderDetailFirstCellTableViewCell  *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell =[[[NSBundle mainBundle]loadNibNamed:@"OrderDetailFirstCellTableViewCell" owner:self options:0]firstObject];
        }
        
        cell.nameLabel.text = model.userName;
        cell.phoneLabel.text = model.userPhone;
        cell.addressLabel.text = model.userAddress;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
                return cell;
    }else if (indexPath.section==1){
        OrderDetailSection2TableViewCell *cell =[tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell =[[[NSBundle mainBundle]loadNibNamed:@"OrderDetailSection2TableViewCell" owner:self options:0]firstObject];
        }
        cell.products =self.model.products;
        cell.msg = self.model.message;
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.section==2){
        NSArray *titleArr = @[@"订单编号",@"下单时间",@"订单状态"];
        OrderDetailDownSectionSingleTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailDownSectionSingleTableViewCell" owner:self options:0]firstObject];
            
        }
        cell.name = titleArr[indexPath.row];
        cell.content = self.section2contents[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        NSArray *titleArr = @[@"支付方式",@"优惠",@"配送费",@"实际付费"];
        OrderDetailDownSectionSingleTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"OrderDetailDownSectionSingleTableViewCell" owner:self options:0]firstObject];
            
        }
        cell.name = titleArr[indexPath.row];
        cell.content = self.section3contents[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}
//制作headerview
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return nil;
    }
    else{
        UIView *view = [[UIView alloc]
                        initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8.5)];
        view.backgroundColor = HEADERVIEW_COLOR;
        UIView *topline =[[UIView alloc]initWithFrame:CGRectMake(0, 0.5, SCREEN_WIDTH, 0.5)];
        topline.backgroundColor = SEPARATELINE_COLOR;
        [view addSubview:topline];
        UIView *downline =[[UIView alloc]initWithFrame:CGRectMake(0, 7.5, SCREEN_WIDTH, 0.5)];
        downline.backgroundColor = SEPARATELINE_COLOR;
        [view addSubview:downline];
        return view;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{
        return 8.5;
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
