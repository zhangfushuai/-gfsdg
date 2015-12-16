//
//  SearchGoodData.m
//  几何社区
//
//  Created by 颜 on 15/9/7.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "SearchGoodData.h"

@implementation SearchGoodData
+ (id)listFromJsonDictionnary:(NSDictionary *)root
{
    
    
    NSMutableArray *arrList = [[NSMutableArray alloc] init];
    
    NSArray *arr = [root objectForKey:@"data"];
    if ([[root objectForKey:@"data"]isKindOfClass:[NSNull class]]) {
        return nil;
    }else{
        for (int i = 0 ; i < arr.count; i ++) {
            SearchGoodData *base = [[SearchGoodData alloc] init];
            base.classify   = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"classify"]];
            base.imgsrc     = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"imgsrc"]];
            base.mid        = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"mid"]];
            base.pid        = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"pid"]];
            base.price      = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"price"]];
            base.promo      = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"promo"]];
            base.sid        = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"sid"]];
            base.stock      = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"stock"]];
            base.title      = [NSString stringWithFormat:@"%@",[[arr objectAtIndex:i] objectForKey:@"title"]];
            [arrList addObject:base];
        }
        return arrList;
    }
}
@end
