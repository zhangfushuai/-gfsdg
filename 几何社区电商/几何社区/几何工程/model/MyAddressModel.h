//
//  MyAddressModel.h
//  几何社区
//
//  Created by KMING on 15/9/2.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyAddressModel : NSObject<NSCopying>
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *phonenum;
@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *area_id;
@property (nonatomic,copy)NSString *latitude;
@property (nonatomic,copy)NSString *longtitude;
//@property (nonatomic) BOOL isDefaultAddress;
+ (id)listFromJsonDictionnary:(NSDictionary *)root;
@end
