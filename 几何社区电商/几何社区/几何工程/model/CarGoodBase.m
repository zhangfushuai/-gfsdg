//
//  CarGoodBase.m
//  几何社区
//
//  Created by 颜 on 15/9/16.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "CarGoodBase.h"

@implementation CarGoodBase
+ (id)listFromJsonDictionnary:(NSDictionary *)root
{
    CarGoodBase *base = [[CarGoodBase alloc] init];
    base.countBase = [CarCountBase listFromJsonDictionnary:[root objectForKey:@"count"]];
    base.carGoodList = [CarGoodDetail listFromJsonDictionnary:root];
    return base;
}
@end
@implementation CarCountBase
+ (id)listFromJsonDictionnary:(NSDictionary *)root
{
    if ([root isKindOfClass:[NSNull class]]) {
        return nil;
    }
    CarCountBase *base = [[CarCountBase alloc] init];
    base.amount = [NSString stringWithFormat:@"%@",[root objectForKey:@"amount"]];
    base.number = [NSString stringWithFormat:@"%@",[root objectForKey:@"number"]];
    return base;
}
@end
@implementation CarGoodDetail
+ (id)listFromJsonDictionnary:(NSDictionary *)root
{
    NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:0];
    if ([[root objectForKey:@"data"]isKindOfClass:[NSNull class]]) {
        return nil;
    }else{
        NSArray *arr = [root objectForKey:@"data"];
        for (int i = 0 ; i < arr.count ; i ++) {
            CarGoodDetail *base = [[CarGoodDetail alloc] init];
            NSDictionary *dict = [arr objectAtIndex:i];
            base.imgsrc = [NSString stringWithFormat:@"%@",[dict objectForKey:@"imgsrc"]];
            base.mid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"mid"]];
            base.num = [NSString stringWithFormat:@"%@",[dict objectForKey:@"num"]];
            base.pid = [NSString stringWithFormat:@"%@",[dict objectForKey:@"pid"]];
            base.price = [NSString stringWithFormat:@"%@",[dict objectForKey:@"price"]];
            base.promo = [NSString stringWithFormat:@"%@",[dict objectForKey:@"promo"]];
            base.shop = [NSString stringWithFormat:@"%@",[dict objectForKey:@"shop"]];
            base.stock = [NSString stringWithFormat:@"%@",[dict objectForKey:@"stock"]];
            base.title = [NSString stringWithFormat:@"%@",[dict objectForKey:@"title"]];
            [list addObject:base];
        }
        return list;
    }
}
@end
