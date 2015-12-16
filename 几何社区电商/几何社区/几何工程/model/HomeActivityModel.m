//
//  HomeActivityModel.m
//  几何社区
//
//  Created by KMING on 15/9/8.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "HomeActivityModel.h"

@implementation HomeActivityModel
+(NSMutableArray*)listFromJsonDictionary:(NSDictionary*)dic{
    NSMutableArray *activities = [NSMutableArray array];//数组装着数组(30001,30002,30003..)
    if ([[dic  objectForKey:@"data"]isKindOfClass:[NSNull class]]) {
        return nil;
    }
    NSDictionary *data = [dic objectForKey:@"data"];
    NSMutableArray *model30001Arr = [NSMutableArray array];
    NSArray *arr30001 = [data objectForKey:@"30001"];
    for (NSDictionary *dic30001 in arr30001) {
       
        HomeActivityModel *model = [[HomeActivityModel alloc]init];
        if ([[dic30001 allKeys]containsObject:@"redirect_type"]) {
            model.redirect_type = [dic30001 objectForKey:@"redirect_type"];
        }
        if ([[dic30001 allKeys]containsObject:@"cid"]) {
            model.cid = [dic30001 objectForKey:@"cid"];
        }
        if ([[dic30001 allKeys]containsObject:@"activity_title"]) {
            model.activity_title = [dic30001 objectForKey:@"activity_title"];
        }
        model.end_time = [dic30001 objectForKey:@"end_time"];
        model.imgsrc =[dic30001 objectForKey:@"imgsrc"];
        model.start_time =[dic30001 objectForKey:@"start_time"];
        model.url =[dic30001 objectForKey:@"url"];
        model.pid = [dic30001 objectForKey:@"pid"];
        [model30001Arr addObject:model];
    }
    [activities addObject:model30001Arr];
    NSMutableArray *model30002Arr = [NSMutableArray array];
    NSArray *arr30002 = [data objectForKey:@"30002"];
    for (NSDictionary *dic30002 in arr30002) {
        HomeActivityModel *model30002 = [[HomeActivityModel alloc]init];
        if ([[dic30002 allKeys]containsObject:@"redirect_type"]) {
            model30002.redirect_type = [dic30002 objectForKey:@"redirect_type"];
        }
        if ([[dic30002 allKeys]containsObject:@"cid"]) {
            model30002.cid = [dic30002 objectForKey:@"cid"];
        }
        if ([[dic30002 allKeys]containsObject:@"activity_title"]) {
            model30002.activity_title = [dic30002 objectForKey:@"activity_title"];
        }
        model30002.end_time = [dic30002 objectForKey:@"end_time"];
        model30002.imgsrc =[dic30002 objectForKey:@"imgsrc"];
        model30002.start_time =[dic30002 objectForKey:@"start_time"];
        model30002.url =[dic30002 objectForKey:@"url"];
        [model30002Arr addObject:model30002];
    }
    [activities addObject:model30002Arr];
    
//    NSDictionary *dic30002 = [[data objectForKey:@"30002"]firstObject];
//    HomeActivityModel *model30002 = [[HomeActivityModel alloc]init];
//    model30002.end_time = [dic30002 objectForKey:@"end_time"];
//    model30002.imgsrc =[dic30002 objectForKey:@"imgsrc"];
//    model30002.start_time =[dic30002 objectForKey:@"start_time"];
//    model30002.url =[dic30002 objectForKey:@"url"];
//    [activities addObject:model30002];
    
    if ([[data allKeys]containsObject:@"30004"]) {
        NSMutableArray *model30004Arr = [NSMutableArray array];
        NSArray *arr30004 = [data objectForKey:@"30004"];
        for (NSDictionary *dic30004 in arr30004) {
            HomeActivityModel *model30004 = [[HomeActivityModel alloc]init];
            if ([[dic30004 allKeys]containsObject:@"redirect_type"]) {
                model30004.redirect_type = [dic30004 objectForKey:@"redirect_type"];
            }
            if ([[dic30004 allKeys]containsObject:@"cid"]) {
                model30004.cid = [dic30004 objectForKey:@"cid"];
            }
            if ([[dic30004 allKeys]containsObject:@"activity_title"]) {
                model30004.activity_title = [dic30004 objectForKey:@"activity_title"];
            }
            model30004.end_time = [dic30004 objectForKey:@"end_time"];
            model30004.imgsrc =[dic30004 objectForKey:@"imgsrc"];
            model30004.start_time =[dic30004 objectForKey:@"start_time"];
            model30004.url =[dic30004 objectForKey:@"url"];
            [model30004Arr addObject:model30004];
        }
        [activities addObject:model30004Arr];
    }else{
        NSArray *arra = [NSArray array];
        [activities addObject:arra];
    }
    
    
    
    
    
    
    
    
    NSMutableArray *model30003Arr = [NSMutableArray array];
    NSArray *arr30003 = [data objectForKey:@"30003"];
    for (NSDictionary *dic30003 in arr30003) {
        HomeActivityModel *model30003 = [[HomeActivityModel alloc]init];
        if ([[dic30003 allKeys]containsObject:@"redirect_type"]) {
            model30003.redirect_type = [dic30003 objectForKey:@"redirect_type"];
        }
        if ([[dic30003 allKeys]containsObject:@"cid"]) {
            model30003.cid = [dic30003 objectForKey:@"cid"];
        }
        if ([[dic30003 allKeys]containsObject:@"activity_title"]) {
            model30003.activity_title = [dic30003 objectForKey:@"activity_title"];
        }
        model30003.end_time = [dic30003 objectForKey:@"end_time"];
        model30003.imgsrc =[dic30003 objectForKey:@"imgsrc"];
        model30003.start_time =[dic30003 objectForKey:@"start_time"];
        model30003.url =[dic30003 objectForKey:@"url"];
        model30003.mid = [dic30003 objectForKey:@"mid"];
        model30003.pid =[dic30003 objectForKey:@"pid"];
        model30003.price =[dic30003 objectForKey:@"price"];
        model30003.title =[dic30003 objectForKey:@"title"];
        [model30003Arr addObject:model30003];
    }
    [activities addObject:model30003Arr];
//    for (int i=0; i<data.count-1; i++) {
//        NSArray *arr30000 = [data objectForKey:[NSString stringWithFormat:@"3000%d",i+2]];
//        NSDictionary *dic30000 = [arr30000 firstObject];
//        HomeActivityModel *model = [[HomeActivityModel alloc]init];
//        model.end_time = [dic30000 objectForKey:@"end_time"];
//        model.imgsrc =[dic30000 objectForKey:@"imgsrc"];
//        model.start_time =[dic30000 objectForKey:@"start_time"];
//        model.url =[dic30000 objectForKey:@"url"];
//        //如果里面为空，就不加入数据源
//        if ([dic30000 objectForKey:@"imgsrc"]) {
//            [activities addObject:model];
//        }
//        
//    }
    
    NSString *did = [NSString stringWithFormat:@"%@",[dic objectForKey:@"did"]];
    if ([[dic objectForKey:@"did"]isKindOfClass:[NSNull class]]) {
        //NSLog(@"该区域暂无代购");
        did = @"";
    }
    [activities addObject:did];
    return activities;

}
@end
