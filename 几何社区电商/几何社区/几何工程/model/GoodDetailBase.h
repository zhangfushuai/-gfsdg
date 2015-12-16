//
//  GoodDetail.h
//  几何社区
//
//  Created by 颜 on 15/9/10.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodDetailBase : NSObject       //商品详情数据
@property (nonatomic ,strong)NSString *capacity;    //
@property (nonatomic ,strong)NSArray  *imgscr;      //图片数组
@property (nonatomic ,strong)NSString *mid;         //
@property (nonatomic ,strong)NSString *pid;         //
@property (nonatomic ,strong)NSString *price;       //价格
@property (nonatomic ,strong)NSString *promo;       //
@property (nonatomic ,strong)NSString *stock;       //库存
@property (nonatomic ,strong)NSString *title;       //名称
@property (nonatomic ,strong)NSString *content;     //商品详情介绍   html5
+ (id)listFromJsonDictionnary:(NSDictionary *)root;
@end


