//
//  GoodData.m
//  几何社区
//
//  Created by 颜 on 15/9/2.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "GoodData.h"

@implementation GoodData
+ (id)listFromJsonArray:(NSArray *)root //递归调用
{
    if (root && root.count >0) {
        NSMutableArray *dataList = [[NSMutableArray alloc] init];
        for (int i = 0 ; i < [root count]; i++) {
            GoodData *dataModel = [[GoodData alloc] init];
            dataModel.goodID = [[root objectAtIndex:i] objectForKey:@"id"];
            dataModel.tid = [[root objectAtIndex:i] objectForKey:@"tid"];
            dataModel.name = [[root objectAtIndex:i] objectForKey:@"name"];
            dataModel.imgsrc = [[root objectAtIndex:i] objectForKey:@"imgsrc"];
            dataModel.goodID = [[root objectAtIndex:i] objectForKey:@"id"];
            NSArray *arr = [[root objectAtIndex:i] objectForKey:@"child"];
            dataModel.child = [GoodData listFromJsonArray:arr];
            [dataList addObject:dataModel];
        }
        return dataList;
    }else{
        return nil;
    }
   }
@end
