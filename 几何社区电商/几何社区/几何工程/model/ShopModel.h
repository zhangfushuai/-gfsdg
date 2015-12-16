//
//  ShopModel.h
//  几何社区
//
//  Created by KMING on 15/10/6.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopModel : NSObject
@property (nonatomic,copy)NSString *iid;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *imgsrc;
@property (nonatomic,copy)NSString *address;

+ (NSMutableArray*)listFromJsonDictionnary:(NSDictionary *)dic;

@end
