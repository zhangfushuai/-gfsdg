//
//  PlaceSearchResultModel.h
//  几何社区
//
//  Created by KMING on 15/9/1.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface PlaceSearchResultModel : NSObject<NSCopying>
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *province;
@property (nonatomic,copy)NSString *city;
@property (nonatomic,copy)NSString *district;
@property (nonatomic,copy)NSString *address;//poi返回的不准确，只有在搜索提示那个页面用
@property (nonatomic,copy)NSString *street;//反地理编码的街道地址，好用
@property (nonatomic)CGFloat latitude;
@property (nonatomic)CGFloat longitude;
@end
