//
//  SearchGoodData.h
//  几何社区
//
//  Created by 颜 on 15/9/7.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchGoodData : NSObject  //搜索获取列表数据
@property (nonatomic , strong)NSString *classify;
@property (nonatomic , strong)NSString *imgsrc;
@property (nonatomic , strong)NSString *mid;
@property (nonatomic , strong)NSString *pid;
@property (nonatomic , strong)NSString *price;
@property (nonatomic , strong)NSString *promo;
@property (nonatomic , strong)NSString *sid;
@property (nonatomic , strong)NSString *stock;
@property (nonatomic , strong)NSString *title;

@property (nonatomic , strong)NSString *count;
+ (id)listFromJsonDictionnary:(NSDictionary *)root;
@end
