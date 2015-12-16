//
//  GoodData.h
//  几何社区
//
//  Created by 颜 on 15/9/2.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodData : NSObject      //分类列表数据
@property (nonatomic , strong)NSString *goodID;
@property (nonatomic , strong)NSString *tid;
@property (nonatomic , strong)NSString *name;
@property (nonatomic , strong)NSString *imgsrc;
@property (nonatomic , strong)NSMutableArray *child;
+ (id)listFromJsonArray:(NSArray *)root;
@end
