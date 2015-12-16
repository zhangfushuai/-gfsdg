//
//  CarGoodBase.h
//  几何社区
//
//  Created by 颜 on 15/9/16.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CarGoodDetail;
@class CarCountBase;
@interface CarGoodBase : NSObject  //购物车商品数据
@property (nonatomic , strong)CarCountBase *countBase;
@property (nonatomic , strong)NSArray *carGoodList;
+ (id)listFromJsonDictionnary:(NSDictionary *)root;
@end

@interface CarCountBase :NSObject
@property (nonatomic ,strong)NSString *amount;  //总价格
@property (nonatomic ,strong)NSString *number;  //总个数
+ (id)listFromJsonDictionnary:(NSDictionary *)root;
@end

@interface CarGoodDetail : NSObject
@property (nonatomic ,strong)NSString *num; //
@property (nonatomic ,strong)NSString *imgsrc; //
@property (nonatomic ,strong)NSString *mid; // 商品不同价格可以是同个mid
@property (nonatomic ,strong)NSString *pid; // 商品的唯一标识 价格
@property (nonatomic ,strong)NSString *price; //
@property (nonatomic ,strong)NSString *promo; //
@property (nonatomic ,strong)NSString *stock; //
@property (nonatomic ,strong)NSString *title; //
@property (nonatomic ,strong)NSString *shop;
+ (id)listFromJsonDictionnary:(NSDictionary *)root;
@end