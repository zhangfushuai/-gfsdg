//
//  OrderResultViewController.m
//  几何社区
//
//  Created by 颜 on 15/9/25.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "OrderResultViewController.h"
#import "WXApiObject.h"
#import <AlipaySDK/AlipaySDK.h>

@interface OrderResultViewController ()<MainDelegate>

@end

@implementation OrderResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"支付提示";
    [self setNavTitleColor:[UIColor blackColor]];
    [self setLeftNavButtonWithType:BACK];
    [self reloadResultView];
    
    _manager = [JHDataManager getInstance];
    _manager.delegate = self;
}
- (void)reloadResultView
{
    if (_orderSuccess) {
        _imgVHeader.image = [UIImage imageNamed:@"Success"];
        _lblMessage.text = @"支付成功";
        [_btnReturn setTitle:@"返回首页" forState:UIControlStateNormal];
    }else{
        _imgVHeader.image = [UIImage imageNamed:@"Failure"];
        _lblMessage.text = @"支付失败";
        [_btnReturn setTitle:@"重新支付" forState:UIControlStateNormal];
    }
    _lblMessage.textColor = [UIColor lightGrayColor];
    _btnReturn.layer.cornerRadius = 6;
    _btnReturn.layer.borderWidth = 0.5;
    _btnReturn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [_btnReturn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    JHGlobalApp.tabBarControllder.shopcar.tabBarItem.badgeValue = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"number"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftButtonOnClick:(id)sender
{
    //跳回首页
    [self.navigationController popToRootViewControllerAnimated:NO];
    JHGlobalApp.tabBarControllder.selectedIndex = 0;
}
- (IBAction)btnClick:(id)sender {
    if(_orderSuccess){
        //跳回首页
        [self.navigationController popToRootViewControllerAnimated:NO];
        JHGlobalApp.tabBarControllder.selectedIndex = 0;
    }else{
        //重新支付
        [_manager getPaywayMessage:_payWayFlag withOrderID:_orderID];
    }
}
- (void)requestSuccess:(id)object withRequestType:(RequestType)requestType
{
    switch (requestType) {
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

- (void)sendALPay:(NSDictionary *)params
{
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"JhAlipay";
    //将商品信息拼接成字符串
    NSString *orderSpec = [params objectForKey:@"data"];
    [[AlipaySDK defaultService] payOrder:orderSpec fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        if([[resultDic objectForKey:@"resultStatus"] integerValue] == 9000){
            self.orderSuccess = YES;
            [self reloadResultView];
        }else{
            self.orderSuccess = NO;
            [self reloadResultView];
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
- (void)WXPay:(BaseResp *)resp
{
    if (resp.errCode == WXSuccess)
    {
        self.orderSuccess = YES;
        [self reloadResultView];
    }else{
        self.orderSuccess = NO;
        [self reloadResultView];
    }
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
