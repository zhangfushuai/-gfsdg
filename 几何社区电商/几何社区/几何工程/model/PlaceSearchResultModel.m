//
//  PlaceSearchResultModel.m
//  几何社区
//
//  Created by KMING on 15/9/1.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "PlaceSearchResultModel.h"

@implementation PlaceSearchResultModel
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.province = [aDecoder decodeObjectForKey:@"province"];
        self.city = [aDecoder decodeObjectForKey:@"city"];
        self.district =[aDecoder decodeObjectForKey:@"district"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
        self.street = [aDecoder decodeObjectForKey:@"street"];
        self.latitude = [aDecoder decodeFloatForKey:@"latitude"];
        self.longitude = [aDecoder decodeFloatForKey:@"longitude"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.province forKey:@"province"];
    [aCoder encodeObject:self.city forKey:@"city"];
    [aCoder encodeObject:self.district forKey:@"district"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.street forKey:@"street"];
    [aCoder encodeFloat:self.latitude forKey:@"latitude"];
    [aCoder encodeFloat:self.longitude forKey:@"longitude"];
}

@end
