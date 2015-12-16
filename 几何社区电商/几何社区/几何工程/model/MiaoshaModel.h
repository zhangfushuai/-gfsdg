//
//  MiaoshaModel.h
//  几何社区
//
//  Created by KMING on 15/10/13.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MiaoshaModel : NSObject
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *type;
@property (nonatomic,copy)NSString *discount_price;
@property (nonatomic,copy)NSString *imgsrc;
@property (nonatomic,copy)NSString *limit_amount;
@property (nonatomic,copy)NSString *mid;
@property (nonatomic,copy)NSString *original_price;
@property (nonatomic,copy)NSString *pid;
@property (nonatomic,copy)NSString *remain_amount;

+ (NSMutableArray*)listFromJsonDictionnary:(NSDictionary *)dic;


@end
