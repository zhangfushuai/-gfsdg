//
//  ShareModel.m
//  几何社区
//
//  Created by KMING on 15/9/29.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "ShareModel.h"

@implementation ShareModel
+ (ShareModel*)modelFromJsonDictionnary:(NSDictionary *)dic{
    ShareModel *model = [[ShareModel alloc]init];
    model.name = [dic objectForKey:@"name"];
    model.headimgurl =[dic objectForKey:@"headimgurl"];
    model.url = [dic objectForKey:@"url"];
    NSDictionary *datadic = [dic objectForKey:@"data"];
    if ([[dic objectForKey:@"data"]isKindOfClass:[NSDictionary class]]) {
        model.share_num = [datadic objectForKey:@"share_num"];
        model.share_total = [datadic objectForKey:@"share_total"];
    }else{
        model.share_num = @"0";
        model.share_total = @"0";
    }
    
    
    model.sharelist = [NSMutableArray array];
    NSArray *list = [dic objectForKey:@"list"];
    for (NSDictionary *listdic in list) {
        [model.sharelist addObject:listdic];
    }
    
    
    
    return model;
    
   
}
@end
