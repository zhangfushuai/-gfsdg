//
//  CouponModel.h
//  几何社区
//
//  Created by KMING on 15/9/22.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouponModel : NSObject
@property (nonatomic,copy)NSString *code;//优惠券号码
@property (nonatomic,copy)NSString *code_status;//可用、、、
@property (nonatomic,copy)NSString *discount;//int 5，字典里
@property (nonatomic,copy)NSString *from;//"2015-09-01";
@property (nonatomic,copy)NSString *money_from;//"30.000"，应该是多少钱可用吧
@property (nonatomic,copy)NSString *title;//5元优惠全
@property (nonatomic,copy)NSString *to;//"2016-09-01"
@property (nonatomic,copy)NSString *type;//(int)1;
+ (NSMutableArray*)listFromJsonDictionnary:(NSDictionary *)dic;
@end
