//
//  JHDataManager.m
//  几何社区
//
//  Created by 颜 on 15/9/2.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "JHDataManager.h"
#import "GoodData.h"
#import "SearchGoodData.h"
#import "GoodDetailBase.h"
#import "HomeActivityModel.h"
#import "CarGoodBase.h"
#import "MyAddressModel.h"
#import "MyOrderModel.h"
#import "CouponModel.h"
#import "ShareModel.h"
#import "WGS84TOGCJ02.h"
#import "ShopModel.h"
#import "HomeNewBannerModel.h"
#import "MiaoshaDetailModel.h"
static JHDataManager *instance = nil;
@implementation JHDataManager

- (id)init
{
    if ((self = [super init])) {
        self.httpManager = [AFHTTPRequestOperationManager manager];
//        self.httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
//        self.httpManager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];    //
        self.httpManager.responseSerializer = [AFHTTPResponseSerializer serializer];  //指定返回数据为data
        _hud = [IndicatorTool getInstance];

     }
    return self;
}
+ (JHDataManager *)getInstance
{
    @synchronized(self) {
        if (instance == nil) {
            instance = [[JHDataManager alloc] init];
        }
    }
    
    return instance;
}

- (BOOL)isRunning
{
    return ![[_httpManager operationQueue] isSuspended];
}

- (void)start
{
    if ([[_httpManager operationQueue] isSuspended]) {
        [[_httpManager operationQueue] setSuspended:NO];
    }
}

- (void)pause
{
    [[_httpManager operationQueue] setSuspended:YES];
}

- (void)resume
{
    [[_httpManager operationQueue] setSuspended:NO];
}

- (void)cancel
{
    [[_httpManager operationQueue] cancelAllOperations];
}

#pragma mark -HTTP Getmethod
- (void)getWithUrl:(NSString *)urlStr andParams:(id)params reqType:(RequestType)reqType
{

    [[_httpManager requestSerializer] setTimeoutInterval:5];
    [_httpManager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"APP"];

    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"cookie_key"];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
        [_httpManager.requestSerializer setValue:[headers objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
    }
    _httpManager.requestSerializer.HTTPShouldHandleCookies = YES;
    [_httpManager GET:urlStr parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:urlStr]];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"cookie_key"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSError *error = nil;
        if (reqType == JHAPPVERSION) {
            self.resultDic = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        }else{
            self.resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        }

        if (reqType==JHGETVERIFYCODE||reqType == JHMIAOSHA ||reqType==JHGETMIAOSHALIST ||reqType==JHGETVOICECODE) {
            if (!error) {
                if([[_resultDic objectForKey:@"status"] integerValue] == 10000)
                {
                    [self requestSuccess:_resultDic withRequestType:reqType];
                }else{
                    [self requestFailure:_resultDic withRequestType:reqType];
                }
            }else{
                if (!responseObject)
                    [self requestFailure:@"网络繁忙,请稍后再试" withRequestType:reqType ];
                else
                    [self requestFailure:_resultDic withRequestType:reqType]; //返回字典
            }
        }else{
            if (!error) {
                [self requestSuccess:_resultDic withRequestType:reqType];
            }
            else{
                if (!responseObject)
                    [self requestFailure:@"网络繁忙,请稍后再试" withRequestType:reqType ];
                else
                    [self requestFailure:_resultDic withRequestType:reqType]; //返回字典
            }
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        NSString *errorMsg = @"网络繁忙,请稍后再试";
        [self requestFailure:errorMsg withRequestType:reqType ];
    }];
}

#pragma mark -HTTP postmethod
- (void)postWithUrl:(NSString *)urlStr jsonStr:(id)params reqType:(RequestType)reqType
{
    [[_httpManager requestSerializer] setTimeoutInterval:10];
    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"cookie_key"];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSDictionary *headers = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
        [_httpManager.requestSerializer setValue:[headers objectForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
    }
    [_httpManager.requestSerializer setValue:@"ios" forHTTPHeaderField:@"APP"];
    [_httpManager POST:urlStr parameters:params  success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:urlStr]];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"cookie_key"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSError *error = nil;
        self.resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
        if (reqType==JHADDADDRESS || reqType==JHEDITADDRESS || reqType==JHDELETEADDRESS || reqType==JHADDCOUPON || reqType==JHCANCELORDER ) {
            if (!error) {
                [self requestSuccess:_resultDic withRequestType:reqType];
            }
            else{
                if (!responseObject)
                    [self requestFailure:@"网络繁忙,请稍后再试" withRequestType:reqType ];
                else
                    [self requestFailure:_resultDic withRequestType:reqType]; //返回字典
            }

        }else{
            if (!error) {
                if([[_resultDic objectForKey:@"status"] integerValue] == 10000)
                {
                    [self requestSuccess:_resultDic withRequestType:reqType];
                }else{
                    [self requestFailure:_resultDic withRequestType:reqType];
                }
            }else{
                if (!responseObject)
                    [self requestFailure:@"网络繁忙,请稍后再试" withRequestType:reqType ];
                else
                    [self requestFailure:_resultDic withRequestType:reqType]; //返回字典
            }

        }
//        if (!error) {
//            if([[_resultDic objectForKey:@"status"] integerValue] == 10000)
//            {
//                [self requestSuccess:_resultDic withRequestType:reqType];
//            }else{
//                [self requestFailure:_resultDic withRequestType:reqType];
//            }
//        }else{
//            if (!responseObject)
//                [self requestFailure:@"网络繁忙,请稍后再试" withRequestType:reqType ];
//            else
//                [self requestFailure:_resultDic withRequestType:reqType]; //返回字典
//        }

            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *errorMsg = @"网络繁忙,请稍后再试";
        [self requestFailure:errorMsg withRequestType:reqType];
    }];
}
- (void)requestSuccess:(id)object withRequestType:(RequestType)requestType
{
    if ([[_httpManager operationQueue] operationCount]==0) {
        [_hud hidden];
    }
    switch (requestType) {
        case JHAPPVERSION:
        {
            NSString *str = object;
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:str withRequestType:requestType];
            }
        }
            break;
        case JHGETGOODLIST:{
            NSArray *arrList = [GoodData listFromJsonArray:object];
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:arrList withRequestType:requestType];
              }
        }
            break;
        case JHSEARCHGOOD:
        {
            NSArray *arrList = [SearchGoodData listFromJsonDictionnary:object];
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:arrList withRequestType:requestType];
            }
            
        }
            break;
        case JHGETGOODDETAIL:
        {
            GoodDetailBase *base = [GoodDetailBase listFromJsonDictionnary:object];
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:base withRequestType:requestType];
            }
        }
            break;
        case JHGETVERIFYCODE:{
            NSDictionary *dic = object;
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:dic withRequestType:requestType];
            }
        }
        case JHLOGIN:{
            NSDictionary *dic = object;
            
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:dic withRequestType:requestType];
            }
        }
            break;


        case JHGETHOMEACTIVITY:{
            NSArray *activities =[HomeActivityModel listFromJsonDictionary:object];
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:activities withRequestType:requestType];
            }
        }
            break;

        case JHUPDATEGOODCAR:
        {
            CarCountBase *base = [CarCountBase listFromJsonDictionnary:[object objectForKey:@"data"]];
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:base withRequestType:requestType];
            }
        }
            break;
        case JHGETGOODCAR:
        {
            if (![[object objectForKey:@"data"] isKindOfClass:[NSNull class]]) {
                CarGoodBase *base = [CarGoodBase listFromJsonDictionnary:object];
                if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                    [_delegate requestSuccess:base withRequestType:requestType];
                }
            }else{
                if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                    [_delegate requestSuccess:nil withRequestType:requestType];
                }
            }
        }
            break;
        case JHADDADDRESS:{
            NSDictionary *dic = object;
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:dic withRequestType:requestType];
            }
        }
            break;
        case JHGETADDRESS:{
            NSArray *list = [MyAddressModel listFromJsonDictionnary:[object objectForKey:@"data"]];
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:list withRequestType:requestType];
            }
        }
            break;
        case JHEDITADDRESS:{
            NSDictionary *dic = object;
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:dic withRequestType:requestType];
            }
        }
            break;
        case JHDELETEADDRESS:{
            NSDictionary *dic = object;
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:dic withRequestType:requestType];
            }
        }
            break;
        case JHGETALLORDER:{
            NSArray *orders = [MyOrderModel listFromJsonDictionnary:object];
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:orders withRequestType:requestType];
            }
        }
            break;
        case JHGETWAITPAYORDER:{
            NSArray *orders = [MyOrderModel listFromJsonDictionnary:object];
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:orders withRequestType:requestType];
            }
        }
            break;
        case JHGETPROCESSORDER:{
            NSArray *orders = [MyOrderModel listFromJsonDictionnary:object];
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:orders withRequestType:requestType];
            }
        }
            break;
        case JHGETTRANSPORTORDER:{
            NSArray *orders = [MyOrderModel listFromJsonDictionnary:object];
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:orders withRequestType:requestType];
            }
        }
            break;
        case JHGETFINISHEDORDER:{
            NSArray *orders = [MyOrderModel listFromJsonDictionnary:object];
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:orders withRequestType:requestType];
            }
        }
            break;
        case JHGETCOUPON:{
            NSArray *coupons =[CouponModel listFromJsonDictionnary:object];
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:coupons withRequestType:requestType];
            }
        }
            break;
        case JHGETUSEDCOUPON:{
            NSArray *coupons =[CouponModel listFromJsonDictionnary:object];
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:coupons withRequestType:requestType];
            }
        }
            break;
        case JHCREATORDER:
        {
            NSDictionary *dic = [object objectForKey:@"data"];
            NSString *orderID = [dic objectForKey:@"id"];
            if(_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)])
            {
                [_delegate requestSuccess:orderID withRequestType:requestType];
            }
        }
            break;
        case JHPAYPARAMS:
        {
            if(_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)])
            {
                [_delegate requestSuccess:object withRequestType:requestType];
            }
        }
            break;
        case JHADDCOUPON:{
            NSDictionary *dic = object;
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:dic withRequestType:requestType];
            }
        }
            break;
        case JHGETREGIONID:{
            NSDictionary *dic = object;
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:dic withRequestType:requestType];
            }
        }
            break;
        case JHCHECKOUT:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:[object objectForKey:@"data"] withRequestType:requestType];
            }
        }
            break;
        case JHCHECKOUTFASTBUY:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:[object objectForKey:@"data"] withRequestType:requestType];
            }
        }
            break;
        case JHCANCELORDER:{
            NSDictionary *dic = object;
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:dic withRequestType:requestType];
            }
        }
            break;
        case JHUSECOUPON:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:object withRequestType:requestType];
            }
        }
            break;
        case JHGETSHARE:{
            ShareModel *model = [ShareModel modelFromJsonDictionnary:object];
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:model withRequestType:requestType];
            }
        }
            break;
        case JHGETSHOPINFO:{
            NSArray *shopArr = [ShopModel listFromJsonDictionnary:object];
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:shopArr withRequestType:requestType];
            }
        }
            break;
        case JHGETSHOPFOOD:{
            NSArray *arrList = [SearchGoodData listFromJsonDictionnary:object];
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:arrList withRequestType:requestType];
            }
        }
            break;
        case JHGETHOMENEWBANNER:
        {
            HomeNewBannerModel *model = [HomeNewBannerModel modelFromParams:object];
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:model withRequestType:requestType];
            }
        }
            break;
        case JHGETMIAOSHALIST:
        {
            NSDictionary *dic = object;
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:dic withRequestType:requestType];
            }
        }
            break;
        case JHMIAOSHA:
        {
            NSDictionary *dic = object;
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:dic withRequestType:requestType];
            }
        }
            break;
        case JHMIAOSHADETAIL:
        {
            NSDictionary *dic = object;
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:dic withRequestType:requestType];
            }
        }
            break;
        case JHMIAOSHAXIADAN:
        {
            NSDictionary *dic = object;
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:dic withRequestType:requestType];
            }
        }
            break;
        case JHMIAOSHAJIESUAN:
        {
            NSDictionary *dic = object;
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:dic withRequestType:requestType];
            }
        }
            break;
        case JHHOMEMIAOSHATIME:
        {
            NSDictionary *dic = object;
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:dic withRequestType:requestType];
            }
        }
            break;
        case JHGETVOICECODE:
        {
            NSDictionary *dic = object;
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:dic withRequestType:requestType];
            }
        }
            break;
        case JHHOTWORLD:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(requestSuccess:withRequestType:)]) {
                [_delegate requestSuccess:object withRequestType:requestType];
            }
        }
            break;
            default:
            
            break;
    }
}
- (void)requestFailure:(id)failReson withRequestType:(RequestType)requestType
{
    if ([[_httpManager operationQueue] operationCount]==0) {
        [_hud hidden];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(requestFailure:withRequestType:)]) {
        [_delegate requestFailure:failReson withRequestType:requestType];
    }
    
}
- (NSString *)combineUrlWithString:(NSString *)str
{
    NSString *urlStr =[BasicUrl stringByAppendingString:str];
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return urlStr;
}
- (void)getAppVersion
{
    [self getWithUrl:@"https://www.hey900.com/ios/versions.txt" andParams:nil reqType:JHAPPVERSION];
}
- (void)getSearchGoodWithKeyWord:(NSString *)key classify:(NSString *)classify area_id:(NSString *)area_id sort:(NSString *)sort page:(NSInteger)page
{
    [_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    NSString  *str = [self combineUrlWithString:@"ajax/product/search"];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (key) {
        [params setObject:key forKey:@"keyword"];
    }
    if (classify) {
        [params setObject:classify forKey:@"classify"];
    }
    if (area_id) {
        [params setObject:area_id forKey:@"area_id"];
    }
    if (sort) {
        [params setObject:sort forKey:@"sort"];
    }
    if (page) {
        [params setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    }
    [self getWithUrl:str andParams:params reqType:JHSEARCHGOOD];
}
- (void)getShopWithKeyWord:(NSString *)key classify:(NSString *)classify area_id:(NSString *)area_id sort:(NSString *)sort page:(NSInteger)page
{
    //[_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    NSString  *str = [self combineUrlWithString:@"ajax/product/search"];
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:0];
    if (key) {
        [params setObject:key forKey:@"keyword"];
    }
    if (classify) {
        [params setObject:classify forKey:@"classify"];
    }
    if (area_id) {
        [params setObject:area_id forKey:@"area_id"];
    }
    if (sort) {
        [params setObject:sort forKey:@"sort"];
    }
    if (page) {
        [params setObject:[NSString stringWithFormat:@"%ld",(long)page] forKey:@"page"];
    }
    [self getWithUrl:str andParams:params reqType:JHGETSHOPINFO];
}

- (void)getGoodDetailWithID:(NSString *)goodId
{
    [_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    NSString  *str = [NSString stringWithFormat:@"ajax/product/%@",goodId];
    str = [self combineUrlWithString:str];
    [self getWithUrl:str andParams:nil reqType:JHGETGOODDETAIL];
}
- (void)getGoodListWithParams:(NSString *)name
{
    [_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    [self getWithUrl:[self combineUrlWithString:@"ajax/model_category"] andParams:nil reqType:JHGETGOODLIST];
}
#pragma mark - 获取验证码
- (void)getVerificationCodeWithParams:(NSDictionary*)params{
   // [_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    [self postWithUrl:[self combineUrlWithString:@"ajax/sent_sms"] jsonStr:params reqType:JHGETVERIFYCODE];
}
#pragma mark - 登录
-(void)loginWithParams:(NSDictionary*)params{
   //[_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    [self postWithUrl:[self combineUrlWithString:@"ajax/login"] jsonStr:params reqType:JHLOGIN];
}

#pragma mark - 获取首页活动
- (void)getHomeActivitywithRegionId:(NSString*)regionId{
    // [_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
     [self getWithUrl:[self combineUrlWithString:[NSString stringWithFormat:@"ajax/activity/%@",regionId]] andParams:nil reqType:JHGETHOMEACTIVITY];
}
- (void)updateGoodCar:(NSDictionary *)params
{
    [_hud showHUD:nil andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    NSString  *str = [self combineUrlWithString:@"ajax/cart_update"];
    [self postWithUrl:str jsonStr:params reqType:JHUPDATEGOODCAR];
}
- (void)getGoodCar
{
    [_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    NSString  * str = [self combineUrlWithString:@"ajax/cart"];
    [self getWithUrl:str andParams:nil reqType:JHGETGOODCAR];

}
#pragma mark - 增删改查地址
-(void)addAddressWithParams:(NSDictionary*)params{
    [_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    [self postWithUrl:[self combineUrlWithString:@"ajax/u/address/add"] jsonStr:params reqType:JHADDADDRESS];
}
-(void)getAddressWithParams:(NSDictionary*)dic{
    [_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    [self getWithUrl:[self combineUrlWithString:@"ajax/u/address"] andParams:dic reqType:JHGETADDRESS];
}
-(void)editAddressWithParams:(NSDictionary*)params{
    [_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    [self postWithUrl:[self combineUrlWithString:@"ajax/u/address/edit"] jsonStr:params reqType:JHEDITADDRESS];
}
-(void)deleteAddressWithParams:(NSDictionary*)params{
    [_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    [self postWithUrl:[self combineUrlWithString:@"ajax/u/address/delete"] jsonStr:params reqType:JHDELETEADDRESS];
}
-(void)getALLOrderWithPageParams:(NSDictionary*)params{
    
    NSString *url =[self combineUrlWithString:@"ajax/u/order/0"];
    [self getWithUrl:url andParams:params reqType:JHGETALLORDER];
}
-(void)getWaitForPayOrderWithPageParams:(NSDictionary*)params{
   // [_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    NSString *url =[self combineUrlWithString:@"ajax/u/order/未付款"];
    [self getWithUrl:url andParams:params reqType:JHGETWAITPAYORDER];
}
-(void)getProcessingOrderWithPageParams:(NSDictionary*)params{
   // [_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    NSString *url =[self combineUrlWithString:@"ajax/u/order/未取货"];
    [self getWithUrl:url andParams:params reqType:JHGETPROCESSORDER];
}
-(void)getTransportOrderWithPageParams:(NSDictionary*)params{
   // [_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    NSString *url =[self combineUrlWithString:@"ajax/u/order/已取货"];
    [self getWithUrl:url andParams:params reqType:JHGETTRANSPORTORDER];
}
-(void)getFinishedOrderWithPageParams:(NSDictionary*)params{
    //[_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    NSString *url =[self combineUrlWithString:@"ajax/u/order/已送达"];
    [self getWithUrl:url andParams:params reqType:JHGETFINISHEDORDER];
}
-(void)getAllCoupon{
    
   
    NSString *url = [self combineUrlWithString:@"u/coupon_list/all"];
    [self getWithUrl:url andParams:nil reqType:JHGETCOUPON];
}
-(void)getUsedCoupon{
    [_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    NSString *url = [self combineUrlWithString:@"u/coupon_list/past"];
    [self getWithUrl:url andParams:nil reqType:JHGETUSEDCOUPON];
}
//获取区域ID
-(void)getRegionIDWithLatitude:(CGFloat)latitude andlongitude:(CGFloat)longitude{
    CLLocationCoordinate2D coo = CLLocationCoordinate2DMake(latitude, longitude);
    CLLocationCoordinate2D newcll= [WGS84TOGCJ02 locationBaiduFromMars:coo];
    [self getWithUrl:[self combineUrlWithString:[NSString stringWithFormat:@"ajax/abs_nearest_shop/%f,%f",newcll.latitude,newcll.longitude]] andParams:nil reqType:JHGETREGIONID];
}
- (void)createOrderWithAddress:(NSString *)address time:(NSString *)time area_id:(NSString *)area_id  message:(NSString *)message pay_type:(NSString *)pay_type goodParams:(NSArray *)params
{
    [_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    if (address) {
        [dict setObject:address forKey:@"address"];
    }
    if (time) {
        [dict setObject:time forKey:@"deliver_time"];
    }
    if (area_id) {
        [dict setObject:area_id forKey:@"area_id"];
    }
    if (message) {
        [dict setObject:message forKey:@"message"];
    }
    if (pay_type) {
        [dict setObject:pay_type forKey:@"pay_type"];
    }
    if (jsonStr) {
        [dict setObject:jsonStr forKey:@"cart"];
    }
    if (dict) {
        NSString *url =[self combineUrlWithString:@"ajax/order/create"];
        [self postWithUrl:url jsonStr:dict reqType:JHCREATORDER];
    }
}

- (void)getPaywayMessage:(NSInteger)payType withOrderID:(NSString *)orderID
{
    [_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    if (payType == WXPAY) {  //微信
        NSString *url = [self combineUrlWithString:[NSString stringWithFormat:@"android_pay/%@",orderID]];
        [self getWithUrl:url andParams:nil reqType:JHPAYPARAMS];
    }else{  //102   支付宝
        NSString *url = [self combineUrlWithString:[NSString stringWithFormat:@"alipay/android/%@",orderID]];
        [self getWithUrl:url andParams:nil reqType:JHPAYPARAMS];
    }
}
- (void)getCheckoutParams:(NSArray *)params
{
    [_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    NSString *url =[self combineUrlWithString:@"checkout"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self postWithUrl:url jsonStr:@{@"cart":jsonStr} reqType:JHCHECKOUT];
}
- (void)getCheckoutFastbuyParams:(NSArray *)params
{
    [_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    NSString *url =[self combineUrlWithString:@"fastbuy"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self postWithUrl:url jsonStr:@{@"cart":jsonStr} reqType:JHCHECKOUTFASTBUY];
}
-(void)addCouponWithParams:(NSDictionary*)params{
    
    [self postWithUrl:[self combineUrlWithString:@"/u/coupon_add/ios"] jsonStr:params reqType:JHADDCOUPON];
}
- (void)useCouponWithCoupon:(NSString*)coupon
{
    [_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    NSString *url =[self combineUrlWithString:[NSString stringWithFormat:@"ajax/coupon_apply/add"]];
    [self postWithUrl:url jsonStr:@{@"coupon":coupon} reqType:JHUSECOUPON];
}
-(void)cancelOrderWithParams:(NSDictionary*)params{
    //[_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    [self postWithUrl:[self combineUrlWithString:@"ajax/u/change_status/已取消"] jsonStr:params reqType:JHCANCELORDER];
}

-(void)getShareInfo{
    [self getWithUrl:[self combineUrlWithString:@"u/share"] andParams:nil reqType:JHGETSHARE];
}
-(void)getShopFoodWithShopid:(NSString*)shopid andAreaid:(NSString*)areaid{
    [_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    [self getWithUrl:[self combineUrlWithString:[NSString stringWithFormat:@"ajax/product/search?shop_id=%@&area_id=%@",shopid,areaid]] andParams:nil reqType:JHGETSHOPFOOD];
}
-(void)getHomeNewBannerInfoWithurl:(NSString *)url{
    // [_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    [self getWithUrl:[NSString stringWithFormat:@"http://m.jh920.com%@",url] andParams:nil reqType:JHGETHOMENEWBANNER];
}
-(void)getMiaoshaListWithAreaId:(NSDictionary *)params{
     [_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    [self postWithUrl:[self combineUrlWithString:@"rushbuy"] jsonStr:params reqType:JHGETMIAOSHALIST];
   
}
-(void)miaoShaCheckActionWithParams:(NSDictionary*)params{
    [_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    [self postWithUrl:[self combineUrlWithString:@"rushbuy/check"] jsonStr:params reqType:JHMIAOSHA];
}
-(void)getMiaoshaDetailWithMid:(NSString *)mid{
    [_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    [self getWithUrl:[self combineUrlWithString:[NSString stringWithFormat:@"rushbuy/product/%@",mid]] andParams:nil reqType:JHMIAOSHADETAIL];
   
}
-(void)miaoSHaXiaDanCheckWithparams:(NSDictionary *)params{
    [_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self postWithUrl:[self combineUrlWithString:@"rushbuy/checkout/confirm"] jsonStr:@{@"cart":jsonStr} reqType:JHMIAOSHAXIADAN];
}
-(void)miaoShaJieSuanWithParams:(NSDictionary *)params{
    [_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self postWithUrl:[self combineUrlWithString:@"rushbuy/checkout"] jsonStr:@{@"cart":jsonStr} reqType:JHMIAOSHAJIESUAN];
}
-(void)getHomeMiaoShaTime{
    [self getWithUrl:[self combineUrlWithString:@"rushbuy/time"] andParams:nil reqType:JHHOMEMIAOSHATIME];
}
-(void)getVoiceCodeWithPhone:(NSString*)phone{
    [self getWithUrl:[self combineUrlWithString:[NSString stringWithFormat:@"ajax/message/voice?phone=%@",phone]] andParams:nil reqType:JHGETVOICECODE];
}
-(void)getHotWords
{
    [_hud showHUD:@"加载中..." andView:[[UIApplication sharedApplication] keyWindow] mode:MBProgressHUDModeIndeterminate];
    NSString *url =[self combineUrlWithString:[NSString stringWithFormat:@"ajax/search/hotwords"]];
    [self getWithUrl:url andParams:nil reqType:JHHOTWORLD];
}
@end
