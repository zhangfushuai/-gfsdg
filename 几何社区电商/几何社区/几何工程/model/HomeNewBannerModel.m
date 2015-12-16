//
//  HomeNewBannerModel.m
//  几何社区
//
//  Created by KMING on 15/10/8.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "HomeNewBannerModel.h"

@implementation HomeNewBannerModel
+(HomeNewBannerModel*)modelFromParams:(NSDictionary*)dic{
    HomeNewBannerModel *model = [[HomeNewBannerModel alloc]init];
    model.title = [dic objectForKey:@"title"];
    model.thumb = [dic objectForKey:@"thumb"];
    if ([[dic  objectForKey:@"data"]isKindOfClass:[NSNull class]]) {
        model.dataArr=[NSArray array];
    }else{
        model.dataArr = [dic objectForKey:@"data"];
    }
    
    return model;
}
@end
