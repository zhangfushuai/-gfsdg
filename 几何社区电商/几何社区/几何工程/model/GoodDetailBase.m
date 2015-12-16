//
//  GoodDetail.m
//  几何社区
//
//  Created by 颜 on 15/9/10.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "GoodDetailBase.h"

@implementation GoodDetailBase
+ (id)listFromJsonDictionnary:(NSDictionary *)root
{
    NSDictionary *dict = [root objectForKey:@"data"];
    if ([dict isKindOfClass:[NSNull class]]) {
        return nil;
    }else{
        GoodDetailBase *base = [[GoodDetailBase alloc] init];
        base.capacity   = [dict objectForKey:@"capacity"];
        base.imgscr     = [dict objectForKey:@"imgsrc"];
        NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0 ; i < [[dict objectForKey:@"imgsrc"] count]; i ++) {
            NSString *str = [[dict objectForKey:@"imgsrc"] objectAtIndex:i];
            [list addObject:str];
        }
        base.imgscr     = list;
        base.mid        = [dict objectForKey:@"mid"];
        base.pid        = [dict objectForKey:@"pid"];
        base.price      = [dict objectForKey:@"price"];
        base.promo      = [dict objectForKey:@"promo"];
        base.stock      = [dict objectForKey:@"stock"];
        base.title      = [dict objectForKey:@"title"];
        base.content    = [dict objectForKey:@"content"];
        return base;
    }
}
@end

