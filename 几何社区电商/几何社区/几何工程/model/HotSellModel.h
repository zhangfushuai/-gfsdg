//
//  HotSellModel.h
//  几何社区
//
//  Created by KMING on 15/10/8.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotSellModel : NSObject
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *mid;
@property (nonatomic,copy)NSString *pid;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *url;
@property (nonatomic,copy)NSString *imgsrc;

+(HotSellModel*)modelFromParams:(NSDictionary *)dic;
@end
