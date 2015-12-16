//
//  JHDataManager.h
//  几何社区
//
//  Created by 颜 on 15/9/2.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IndicatorTool.h"
#import "AFNetworking.h"
typedef enum{
    JHAPPVERSION        = 0,    //获取app版本
    JHGETGOODLIST       = 1,    //获取商品分类/列表
    JHSEARCHGOOD        = 2,    //获取搜索商品
    JHGETGOODDETAIL     = 3,    //获取商品详情
    JHGETVERIFYCODE     = 4,    //获取手机验证码
    JHLOGIN             = 5,    //手机登陆
    JHGETHOMEACTIVITY   = 6,    //获取首页活动
    JHUPDATEGOODCAR     = 7,    //跟新购物车
    JHGETGOODCAR        = 8,    //获取购物车
    JHADDADDRESS        = 9,    //新增收货地址
    JHEDITADDRESS       = 10,    //修改收货地址
    JHDELETEADDRESS     = 11,    //删除收货地址
    JHGETADDRESS        = 12,    //获取收货地址
    JHGETALLORDER       = 13,    //获取全部订单
    JHGETWAITPAYORDER   = 14,    //获取待支付订单
    JHGETPROCESSORDER   = 15,    //获取取货中订单
    JHGETTRANSPORTORDER = 16,    //获取配送中订单
    JHGETFINISHEDORDER  = 17,    //获取已完成订单
    JHGETCOUPON         = 18,    //获取全部优惠券
    JHCREATORDER        = 19,    //创建订单
    JHPAYPARAMS         = 20,    //获取支付参数
    JHADDCOUPON         = 21,    //添加优惠券
    JHGETREGIONID       = 22,    //获取区域id
    JHCHECKOUT          = 23,    //获取优惠、活动信息
    JHCHECKOUTFASTBUY   = 24,    //活动商品获取活动信息
    JHCANCELORDER       = 25,    //取消订单
    JHGETUSEDCOUPON     = 26,    //获取已使用的优惠券
    JHUSECOUPON         = 27,    //使用优惠券
    JHGETSHARE          = 28,    //分享相关
    JHGETSHOPINFO       = 29,    //点击跳转到商品
    JHGETSHOPFOOD       = 30,    //餐饮料理店点击显示商品
    JHGETHOMENEWBANNER  = 31,    //首页新增的广告位
    JHGETMIAOSHALIST    = 32,    //秒杀商品列表接口
    JHMIAOSHA           = 33,    //秒杀资格及中奖结果校验
    JHMIAOSHADETAIL     = 34,    //秒杀商品详情页
    JHMIAOSHAXIADAN     = 35,    //秒杀抢购下单校验
    JHMIAOSHAJIESUAN    = 36,    //秒杀抢购结算
    JHHOMEMIAOSHATIME   = 37,    //首页秒杀时间
    JHGETVOICECODE      = 38,    //获取语音验证码
    JHHOTWORLD          = 39,    //热门搜索词
    
} RequestType;
@protocol JHDataMagerDelegate <NSObject>


@optional
- (void)requestSuccess:(id)object withRequestType:(RequestType)requestType;
- (void)requestFailure:(id)failReson withRequestType:(RequestType)requestType;


@end

@interface JHDataManager : NSObject
@property (nonatomic , weak) id <JHDataMagerDelegate>delegate;
@property (nonatomic , strong)AFHTTPRequestOperationManager *httpManager;
@property (nonatomic , strong)IndicatorTool *hud;
@property (nonatomic, strong) id resultDic;

- (BOOL)isRunning;
- (void)start;
- (void)pause;
- (void)resume;
- (void)cancel;
+ (JHDataManager *)getInstance;

- (void)getAppVersion;                                      //获取app的版本
- (void)getGoodListWithParams:(NSString *)name;             //获取商品分类/列表
- (void)getSearchGoodWithKeyWord:(NSString *)key classify:(NSString *)classify area_id:(NSString *)area_id sort:(NSString *)sort page:(NSInteger)page;                              //搜索商品  sort1－> 0/1  sort2->0/1
- (void)getShopWithKeyWord:(NSString *)key classify:(NSString *)classify area_id:(NSString *)area_id sort:(NSString *)sort page:(NSInteger)page;//跳转到商店

- (void)getGoodDetailWithID:(NSString *)goodId;             //获取商品详情
- (void)getVerificationCodeWithParams:(NSDictionary*)params;//获取验证码
- (void)loginWithParams:(NSDictionary*)params;              //手机登陆
- (void)getHomeActivitywithRegionId:(NSString*)regionId;    //获取首页活动
- (void)updateGoodCar:(NSDictionary *)params;               //跟新购物车
- (void)getGoodCar;                                         //获取购物车
- (void)createOrderWithAddress:(NSString *)address time:(NSString *)time area_id:(NSString *)area_id  message:(NSString *)message pay_type:(NSString *)pay_type goodParams:(NSArray *)params;                        //创建订单  message可以为空
-(void)addAddressWithParams:(NSDictionary*)params;
-(void)editAddressWithParams:(NSDictionary*)params;
-(void)deleteAddressWithParams:(NSDictionary*)params;
-(void)getAddressWithParams:(NSDictionary*)dic;
//获取各种order
-(void)getALLOrderWithPageParams:(NSDictionary*)params;
-(void)getWaitForPayOrderWithPageParams:(NSDictionary*)params;
-(void)getProcessingOrderWithPageParams:(NSDictionary*)params;
-(void)getTransportOrderWithPageParams:(NSDictionary*)params;
-(void)getFinishedOrderWithPageParams:(NSDictionary*)params;
//获取优惠券
-(void)getAllCoupon;
-(void)addCouponWithParams:(NSDictionary*)params;
-(void)getUsedCoupon;
//获取区域ID
-(void)getRegionIDWithLatitude:(CGFloat)latitude andlongitude:(CGFloat)longitude;
- (void)getPaywayMessage:(NSInteger)payType withOrderID:(NSString *)orderID;   //获取支付参数
- (void)getCheckoutParams:(NSArray *)params;            /*商品信息*/            //获取活动信息
- (void)getCheckoutFastbuyParams:(NSArray *)params;     /*商品信息*/            //秒杀、抢购活动支付接口
- (void)cancelOrderWithParams:(NSDictionary*)params;
- (void)useCouponWithCoupon:(NSString*)coupon;
//使用优惠券   后台存了cookie

-(void)getShareInfo;
-(void)getShopFoodWithShopid:(NSString*)shopid andAreaid:(NSString*)areaid;
//首页新增广告位数据
-(void)getHomeNewBannerInfoWithurl:(NSString *)url;
-(void)getMiaoshaListWithAreaId:(NSDictionary *)params;
-(void)miaoShaCheckActionWithParams:(NSDictionary*)params;
-(void)getMiaoshaDetailWithMid:(NSString *)mid;
-(void)miaoSHaXiaDanCheckWithparams:(NSDictionary *)params;
-(void)miaoShaJieSuanWithParams:(NSDictionary *)params;
-(void)getHomeMiaoShaTime;
-(void)getVoiceCodeWithPhone:(NSString*)phone;
-(void)getHotWords;
@end
