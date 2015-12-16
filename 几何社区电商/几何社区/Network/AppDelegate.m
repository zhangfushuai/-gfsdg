//
//  AppDelegate.m
//  几何社区
//
//  Created by KMING on 15/8/14.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import "WeiboSDK.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <QZoneConnection/ISSQZoneApp.h>
#import <MapKit/MapKit.h>
#import <AlipaySDK/AlipaySDK.h>
#import "GuideViewController.h"
#import "MobClick.h"
#import "JHDataManager.h"
@interface AppDelegate () <JHDataMagerDelegate>
@property(nonatomic,strong)CLLocationManager *locMgr;
@end

@implementation AppDelegate

+(AppDelegate*)shareAppDelegate
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //  友盟的方法本身是异步执行，所以不需要再异步调用
    [self umengTrack];
    
    //1.初始化ShareSDK应用,字符串"5559f92aa230"换成http://www.mob.com/后台申请的ShareSDK应用的Appkey
    [ShareSDK registerApp:@"a5671318d7a3"];  //如果需要看下广告效果，可以把Appkey换成"737dfd5147db"
    
    //2. 初始化社交平台
    //2.1 代码初始化社交平台的方法
    [self initializePlat];
    //开启QQ空间网页授权开关(optional)
    id<ISSQZoneApp> app =(id<ISSQZoneApp>)[ShareSDK getClientWithType:ShareTypeQQSpace];
    [app setIsAllowWebAuthorize:YES];
    
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    //先取出原来保存的运行次数
    BOOL isRun = [ud boolForKey:@"isRun"];
//    int runCount = [ud integerForKey:@"runCount"];
//    
//    //让原来的运行次数+1再保存回去
//    [ud setInteger:++runCount forKey:@"runCount"];
//    //    切记！！！保存完数据之后 需要同步一下
//    [ud synchronize];
    
    // 1.创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    if (!isRun) {
        GuideViewController *gvc = [[GuideViewController alloc]initWithNibName:@"GuideViewController" bundle:nil];
        self.window.rootViewController = gvc;
    }else{
        self.tabBarControllder = [[LmhTabBarController alloc]init];
        self.window.rootViewController = self.tabBarControllder;
    }
    [self.window makeKeyAndVisible];
    
    JHDataManager *manager = [JHDataManager getInstance];
    manager.delegate = self;
    [manager getAppVersion];
    return YES;
}
#pragma mark - 友盟统计
- (void)umengTrack {
    //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    [MobClick setLogEnabled:NO];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:BATCH channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    [MobClick updateOnlineConfig];  //在线参数配置
    
    //    1.6.8之前的初始化方法
    //    [MobClick setDelegate:self reportPolicy:REALTIME];  //建议使用新方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
}
- (void)onlineConfigCallBack:(NSNotification *)note {
    
    //NSLog(@"online config has fininshed and note = %@", note.userInfo);
}
#pragma mark - shareSdk
- (void)initializePlat

{
    /**
     连接微信应用以使用相关功能，此应用需要引用WeChatConnection.framework和微信官方SDK
     http://open.weixin.qq.com上注册应用，并将相关信息填写以下字段
     **/
    //    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885" wechatCls:[WXApi class]];
    [ShareSDK connectWeChatWithAppId:@"wxdddcf1c64c55d157"
                           appSecret:@"fb0bd7b8a94025681685a70fb420b387"
                           wechatCls:[WXApi class]];
    
    
    /**
     连接QQ空间应用以使用相关功能，此应用需要引用QZoneConnection.framework
     http://connect.qq.com/intro/login/上申请加入QQ登录，并将相关信息填写到以下字段
     
     如果需要实现SSO，需要导入TencentOpenAPI.framework,并引入QQApiInterface.h和TencentOAuth.h，将QQApiInterface和TencentOAuth的类型传入接口
     **/
    [ShareSDK connectQZoneWithAppKey:@"1104869988"
                           appSecret:@"9x8Cr78qihNZ183a"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    /**
     连接QQ应用以使用相关功能，此应用需要引用QQConnection.framework和QQApi.framework库
     http://mobile.qq.com/api/上注册应用，并将相关信息填写到以下字段
     **/
    //旧版中申请的AppId（如：QQxxxxxx类型），可以通过下面方法进行初始化
    //    [ShareSDK connectQQWithAppId:@"QQ075BCD15" qqApiCls:[QQApi class]];
    [ShareSDK connectQQWithQZoneAppKey:@"1104869988"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    //链接到微博
    [ShareSDK connectSinaWeiboWithAppKey:@"4175912510"
                               appSecret:@"66e77b18641cc1e57c5876564f41cab7"
                             redirectUri:@"https://api.weibo.com/oauth2/default.html"
                             weiboSDKCls:[WeiboSDK class]];
    
    
    
    
    
    
    
}
#pragma mark - 如果使用SSO（可以简单理解成客户端授权），以下方法是必要的

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

//iOS 4.2+
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if([[url scheme] isEqualToString:@"JhAlipay"])//从支付钱包
    {
        [[AlipaySDK defaultService]
         processOrderWithPaymentResult:url
         standbyCallback:^(NSDictionary *resultDic) {}];
        return YES;
    }else{
        return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
    }
}

#pragma mark - WXApiDelegate(optional)
-(void) onReq:(BaseReq*)req
{
}

-(void) onResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:[PayResp class]]) {
        //支付回调
        if (_mainDelegate && [_mainDelegate respondsToSelector:@selector(WXPay:)]){
            [_mainDelegate WXPay:resp];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//- (void)requestSuccess:(id)object withRequestType:(RequestType)requestType
//{
//    if (requestType == JHAPPVERSION) {
//        NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
//        NSString *currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
//        NSLog(@"服务器：%@  目前: %@",object,currentVersion);
//        if ([currentVersion isEqualToString:object]) {
//            NSString *msg = [NSString stringWithFormat:@"你当前的版本是V%@，发现新版本V%@，是否下载新版本？",object,currentVersion];
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"升级提示!" message:msg delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"现在升级", nil];
//
//            [alert show];
//        }
//    }
//}
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    //软件需要更新提醒
//    if (buttonIndex == 1) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://192.168.1.126:8088/ucab.html"]];
//    }
//}
@end
