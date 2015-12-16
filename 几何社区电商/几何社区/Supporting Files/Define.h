//
//  Define.h
//  几何社区
//
//  Created by KMING on 15/8/14.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#ifndef _____Define_h
#define _____Define_h
enum{
    WXPAY = 100,
    DFPAY = 101,
    ALPAY = 102,
};

#define JHGlobalApp     [AppDelegate shareAppDelegate]
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define NAVHEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height +
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define IS_IOS8_OR_LATER [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0
#define ISIOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0


#define HEADERVIEW_COLOR [UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1]
#define SEPARATELINE_COLOR [UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1]
#define RGBCOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define NAVIGATIONBAR_COLOR [UIColor colorWithRed:0.980 green:0.200 blue:0.196 alpha:1.000]
#define Color757575 [UIColor colorWithRed:117.0/255.0 green:117.0/255.0 blue:117.0/255.0 alpha:1]
#define Color242424 [UIColor colorWithRed:36.0/255.0 green:36.0/255.0 blue:36.0/255.0 alpha:1]
/*******微信******/
#define WXAPP_ID          @"wxdddcf1c64c55d157"               //APPID
#define APP_SECRET      @"fb0bd7b8a94025681685a70fb420b387" //appsecret
//商户号，填写商户对应参数
//#define MCH_ID          @""
////商户API密钥，填写相应参数
//#define PARTNER_ID      @""
////支付结果回调页面
//#define NOTIFY_URL      @"http://wxpay.weixin.qq.com/pub_v2/pay/notify.v2.php"
////获取服务器端支付数据地址（商户自定义）
#define SP_URL          @"http://wxpay.weixin.qq.com/pub_v2/app/app_pay.php"

/*******阿里支付******/
#define ALIAPP_ID @"2015081500217058"

/*******分享******/
#define ShARESDKKEY @"a5671318d7a3"  //appkey
#define AMAPKEY @"d6ac228caa7d749bd87ef08adb0d1f55"  //高德地图poi搜索key
//#define AMAPKEY @"03aa17b78d677f3ff2bb3ed49ae798ed"    //企业账号 高德

/*******后台服务器******/
//#define BasicUrl @"http://192.168.1.96/"
#define BasicUrl @"http://m.jh920.com/"
//#define BasicUrl @"http://192.168.1.17/"


/*******友盟统计******/
#define UMENG_APPKEY @"561507bf67e58e9566002379"
#endif
