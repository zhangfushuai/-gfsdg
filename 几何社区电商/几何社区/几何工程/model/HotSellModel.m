//
//  HotSellModel.m
//  几何社区
//
//  Created by KMING on 15/10/8.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "HotSellModel.h"

@implementation HotSellModel
+(HotSellModel*)modelFromParams:(NSDictionary *)dic{
    HotSellModel *model = [[HotSellModel alloc]init];
    model.title = [dic objectForKey:@"title"];
    model.pid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"pid"]];
    model.mid = [NSString stringWithFormat:@"%@",[dic objectForKey:@"mid"]];
    model.price = [NSString stringWithFormat:@"%@",[dic objectForKey:@"price"]];
    model.url = [dic objectForKey:@"url"];
    model.imgsrc = [dic objectForKey:@"imgsrc"];
    return model;
}
@end
