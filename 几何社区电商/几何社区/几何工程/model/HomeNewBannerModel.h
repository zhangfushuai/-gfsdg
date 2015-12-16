//
//  HomeNewBannerModel.h
//  几何社区
//
//  Created by KMING on 15/10/8.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeNewBannerModel : NSObject
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *thumb;
@property (nonatomic,strong)NSArray *dataArr;
//里面放着字典，字典的key为：imgsrc
//mid = 167787;
//pid = 170306;
//price = 19;
//title = "\U7edd\U5473\U62db\U724c\U9e2d\U8116250G";
//url = "/product/170306";

+(HomeNewBannerModel*)modelFromParams:(NSDictionary*)dic;
@end
