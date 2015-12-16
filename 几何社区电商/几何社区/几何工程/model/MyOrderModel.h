//
//  MyOrderModel.h
//  几何社区
//
//  Created by KMING on 15/9/21.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOrderModel : NSObject
@property (nonatomic,copy)NSString *userName;
@property (nonatomic,copy)NSString *userPhone;
@property (nonatomic,copy)NSString *userAddress;

@property (nonatomic,copy)NSString *amount;
@property (nonatomic,copy)NSString *buyer;
@property (nonatomic,copy)NSString *coupon;
@property (nonatomic,copy)NSString *created;
@property (nonatomic,copy)NSString *deliver_time;
@property (nonatomic,copy)NSString *deliverer;
@property (nonatomic,copy)NSString *iid;
@property (nonatomic,copy)NSString *message;
@property (nonatomic,copy)NSString *number;
@property (nonatomic,copy)NSString *pay_type;
@property (nonatomic,copy)NSArray *products;//装着商品，商品为字典
@property (nonatomic,copy)NSString *shipping;
@property (nonatomic,copy)NSString *status;
@property (nonatomic,copy)NSString *status_alias;
@property (nonatomic,copy)NSString *wechat_openid;
@property (nonatomic,copy)NSString *wechat_pay_id;
@property (nonatomic,copy)NSString *wechat_pay_result;
@property (nonatomic,copy)NSString *wechat_pay_status;
@property (nonatomic,copy)NSString *wechat_prepay_id;


+ (NSMutableArray*)listFromJsonDictionnary:(NSDictionary *)dic;
@end
