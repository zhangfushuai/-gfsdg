//
//  ProductDetailViewController.h
//  几何社区
//
//  Created by 颜 on 15/9/8.
//  Copyright (c) 2015年 lmh. All rights reserved.
//


#import "ProductDetailViewController.h"
#import "GoodDetailTopCell.h"
#import "GoodDetailBottomCell.h"
#import "Utils.h"
#import "ShopCarViewController.h"
#import "LoginViewController.h"
#import "ConfirmDirectViewController.h"
#import "IndicatorTool.h"

#import "CarGoodBase.h"
#import <ShareSDK/ShareSDK.h>


@interface ProductDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)CarGoodBase *carGoodBase;
@property (nonatomic,strong)CarCountBase *carCountBase;

@property (nonatomic,assign)NSInteger goodCount; //用于直接购买接口
@property (nonatomic,assign)CGFloat webHeight;
@property (nonatomic,strong)UIWebView *webview;
@end

@implementation ProductDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webHeight = 0.0f;
    _goodCount = 1;
    if (_fromFlag == 1000) {    //直接购买接口
        self.btnBuyNow.hidden = NO;
        self.btnBuyNormal.hidden = YES;
        [self.btnBuyNow setBackgroundColor:NAVIGATIONBAR_COLOR];
    }else{                      //普通购买接口
        self.btnBuyNow.hidden = YES;
        self.btnBuyNormal.hidden = NO;
        [self.btnBuy setBackgroundColor:NAVIGATIONBAR_COLOR];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-44)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor =[UIColor colorWithWhite:0.961 alpha:1.000];
    [self.view addSubview:self.tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;//避免scrollview偏移
    UIView *footerview  = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footerview;
    
    _lblTotalMoney.backgroundColor = [UIColor whiteColor];
    _lblTotalMoney.layer.cornerRadius = 7;
    _lblTotalMoney.clipsToBounds = YES;
    
    _lblGoodCount.backgroundColor = [UIColor whiteColor];
    _lblGoodCount.layer.cornerRadius = 7;
    _lblGoodCount.clipsToBounds = YES;
    _manager = [JHDataManager getInstance];
    _manager.delegate = self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _manager.delegate = self;
    _lblTotalMoney.hidden = YES;
    _lblGoodCount.hidden = YES;
    [self getGoodCar];
    
    self.title = @"商品详情";
    [self setLeftNavButtonWithType:BACK];
    [self setNavTitleColor:[UIColor blackColor]];
    
    [self setRightNavButtonWithType:SHARE];
}
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        self.tableView.separatorColor = [UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
       [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        self.tableView.separatorColor = [UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(_goodDetail.content && _goodDetail.content.length > 0){
        return 3;
    }else{
        return 2;
    }

}
//制作headerview
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]
                    initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    view.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else if(section == 1){
        return 8;
    }else if  (section == 2)
    {
        return 8;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        return SCREEN_WIDTH +70;
    }else if (indexPath.section==1){
        return 48;
    }else{
        return _webHeight;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }
    else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        GoodDetailTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodDetailTopCell" ];
        if (!cell) {
            cell = [GoodDetailTopCell originViewTableView:tableView];
            if (_fromFlag == 1000) {
                [cell goodDetail:_goodDetail andAddBtnHidden:NO];
            }else{
                [cell goodDetail:_goodDetail andAddBtnHidden:YES];
            }
        }
        [cell.btnAdd addTarget:self action:@selector(addGood) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnReduce addTarget:self action:@selector(reduceGood) forControlEvents:UIControlEventTouchUpInside];
        if (_goodCount <= 1) {
            cell.btnReduce.enabled = NO;
        }
        cell.lblGoodCount.text  = [NSString stringWithFormat:@"%ld",(long)_goodCount];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.section == 1){
        GoodDetailBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodDetailBottomCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"GoodDetailBottomCell" owner:self options:0]firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lblTitle.text = [NSString stringWithFormat:@"商品规格：%@",_goodDetail.capacity];
        return cell;
    }
    else{
        UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycell"];
            if (_goodDetail.content && _goodDetail.content.length > 0)
            {
                if (!_webview) {
                    _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _webHeight)];
                    [_webview loadHTMLString:_goodDetail.content baseURL:nil];
                    _webview.delegate = self;
                    _webview.scrollView.scrollEnabled = NO;
                }
                _webview.frame = CGRectMake(0, 0, SCREEN_WIDTH, _webHeight);
                [cell.contentView addSubview:_webview];
            }
        }
        return cell;
    }
}
-(NSString *)filterHTML:(NSString *)html
{
    html =[html stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    html =[html stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    html = [html stringByReplacingOccurrencesOfString:@"nbsp;" withString:@"&nbsp;"];
    html = [html stringByReplacingOccurrencesOfString:@"&amp;" withString:@""];
    return html;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"];
    _webHeight = 0.55*[height_str floatValue];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark 活动支付接口
- (void)addGood
{
    GoodDetailTopCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.btnReduce.enabled = YES;
    _goodCount ++;
    cell.lblGoodCount.text  = [NSString stringWithFormat:@"%ld",(long)_goodCount];
}
-(void)reduceGood
{
    GoodDetailTopCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    _goodCount --;
    cell.lblGoodCount.text  = [NSString stringWithFormat:@"%ld",(long)_goodCount];
    if (_goodCount > 1) {
        cell.btnReduce.enabled = YES;
    }else{
        cell.btnReduce.enabled = NO;
    }
}
- (IBAction)buyNow:(id)sender
{
    NSString *logState=[[NSUserDefaults standardUserDefaults]objectForKey:@"logState"];//读取登录状态
    if (!logState) {
        LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
    }else{
        NSString *str = [NSString stringWithFormat:@"%ld",_goodCount];
        NSDictionary *dict = @{@"pid":_goodDetail.pid,@"mid":_goodDetail.mid,@"num":str};
        NSArray *arr = [NSArray arrayWithObject:dict];
        [_manager getCheckoutFastbuyParams:arr];
    }
}
- (void)getGoodCar
{
    [_manager getGoodCar];
}
- (IBAction)addToCar:(id)sender { //加入购物车
        NSDictionary *dic4 = @{@"pid":_goodDetail.pid,@"mid":_goodDetail.mid,@"num":@"1"};
        NSArray *arr = [NSArray arrayWithObject:dic4];
        NSData *data = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsstr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *dict = @{@"cart":jsstr};
        [_manager updateGoodCar:dict];
}
- (IBAction)goToCar:(id)sender { //进入购物车
    ShopCarViewController *vc = [[ShopCarViewController alloc] initWithNibName:@"ShopCarViewController" bundle:nil];
    vc.fromFlag = 1001;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)rightButtonOnClick:(id)sender
{
    /* 邀请好友送优惠券*/
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"120-120" ofType:@"png"];
    //1、构造分享内容
    NSString *urlStr = [NSString stringWithFormat:@"http://m.jh920.com/product/%@",_goodDetail.pid];
    id<ISSContent> publishContent = [ShareSDK content:@"指尖轻触,美味零食/水果/外卖/下午茶等秒速配送到家门口,让您躺在家里悠然逛超市!"
                                       defaultContent:@"指尖轻触,美味零食/水果/外卖/下午茶等秒速配送到家门口,让您躺在家里悠然逛超市!"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:_goodDetail.title
                                                  url:urlStr
                                          description:@"指尖轻触,美味零食/水果/外卖/下午茶等秒速配送到家门口,让您躺在家里悠然逛超市!"
                                            mediaType:SSPublishContentMediaTypeNews];
    //1+创建弹出菜单容器（iPad必要）
    id<ISSContainer> container = [ShareSDK container];
    //2、弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                //可以根据回调提示用户。
                                if (state == SSResponseStateSuccess)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                    message:nil
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                    message:[NSString stringWithFormat:@"失败描述：%@",[error errorDescription]]
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                            }];
}
-(void)requestSuccess:(id)object withRequestType:(RequestType)requestType
{
    switch (requestType) {
        case JHGETGOODCAR:
        {
            _carGoodBase = object;
            if ([_carGoodBase.countBase.number intValue]>0) {
                _lblTotalMoney.hidden = NO;
                _lblGoodCount.hidden = NO;
                _lblGoodCount.text = _carGoodBase.countBase.number;
                _lblTotalMoney.text = [Utils floatStringFromString:_carGoodBase.countBase.amount];
                _lblMoneyWidth.constant = [Utils sizeFromString:[Utils floatStringFromString:_carGoodBase.countBase.amount] withFont:13.f].width+15;
                _lblCountWidth.constant = [Utils sizeFromString:_carGoodBase.countBase.number withFont:13.f].width+15;

            }else{
                _lblTotalMoney.hidden = YES;
                _lblGoodCount.hidden = YES;
            }
        }
            break;
        case JHUPDATEGOODCAR:
        {
//            MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self.view];
//            [self.view addSubview:hud];
//            hud.mode = MBProgressHUDModeCustomView;
//            UIView *view = [[UIView alloc] init];
//            view.backgroundColor = [UIColor redColor];
////            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Success"]];
//            hud.labelText = @"添加成功";
//            [hud showAnimated:YES whileExecutingBlock:^{
//                sleep(1);
//            } completionBlock:^{
//                [hud removeFromSuperview];
//            }];
            _carCountBase = object;
            if ([_carCountBase.number intValue]>0) {
                [[NSUserDefaults standardUserDefaults] setObject:_carCountBase.number forKey:@"number"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                JHGlobalApp.tabBarControllder.shopcar.tabBarItem.badgeValue =_carCountBase.number;

                _lblTotalMoney.hidden = NO;
                _lblGoodCount.hidden = NO;
                _lblGoodCount.text = _carCountBase.number;
                _lblTotalMoney.text = [Utils floatStringFromString:_carCountBase.amount];
                _lblMoneyWidth.constant = [Utils sizeFromString:[Utils floatStringFromString:_carCountBase.amount] withFont:13.f].width+15;
                _lblCountWidth.constant = [Utils sizeFromString:_carCountBase.number withFont:13.f].width+15;
            }else{
                _lblTotalMoney.hidden = YES;
                _lblGoodCount.hidden = YES;
            }
        }
            break;
        case JHCHECKOUTFASTBUY:
        {
            ConfirmDirectViewController *vc = [[ConfirmDirectViewController alloc] initWithNibName:@"ConfirmDirectViewController" bundle:nil];
            NSDictionary *dict = @{@"data":[object objectForKey:@"products"]};
            vc.dataSourse   = [CarGoodDetail listFromJsonDictionnary:dict];
            vc.addressList  = [MyAddressModel listFromJsonDictionnary:@{@"data":[object objectForKey:@"address"]}];
            vc.addressModel = [[MyAddressModel listFromJsonDictionnary:@{@"data":[object objectForKey:@"address"]}] firstObject];
            vc.totalPrice   = [NSString stringWithFormat:@"%@",[object objectForKey:@"amount"]];
            vc.shipping     = [NSString stringWithFormat:@"%@",[object objectForKey:@"shipping"]];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}


#pragma mark - 秒杀




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
