//
//  MyAddressModel.m
//  几何社区
//
//  Created by KMING on 15/9/2.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "MyAddressModel.h"

@implementation MyAddressModel
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.phonenum = [aDecoder decodeObjectForKey:@"phonenum"];
        self.address = [aDecoder decodeObjectForKey:@"address"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.phonenum forKey:@"phonenum"];
    [aCoder encodeObject:self.address forKey:@"address"];
}
+ (id)listFromJsonDictionnary:(NSDictionary *)root
{
    NSMutableArray *addressArr = [[NSMutableArray alloc] initWithCapacity:0];
    NSArray *dataArr = [root objectForKey:@"data"];
    for (NSDictionary *addressDic in dataArr) {
        MyAddressModel *model = [[MyAddressModel alloc] init];
        model.name = [addressDic objectForKey:@"name"];
        model.phonenum =[addressDic objectForKey:@"phone"];
        model.address = [addressDic objectForKey:@"address"];
        model.area_id = [addressDic objectForKey:@"area_id"];
        NSString *latlng = [addressDic objectForKey:@"latlng"];
        NSArray *latlngarr = [latlng componentsSeparatedByString:@","];
        if (![latlng isEqualToString:@""]) {
            model.latitude = latlngarr[0];
            model.longtitude = latlngarr[1];
        }
        [addressArr addObject:model];
    }
    return addressArr;
}

@end
