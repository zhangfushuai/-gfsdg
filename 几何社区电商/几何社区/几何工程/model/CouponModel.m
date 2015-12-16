//
//  CouponModel.m
//  几何社区
//
//  Created by KMING on 15/9/22.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "CouponModel.h"

@implementation CouponModel
+ (NSMutableArray*)listFromJsonDictionnary:(NSDictionary *)dic{
    NSMutableArray *couponArr = [NSMutableArray array];
    if ([[dic objectForKey:@"data"]isKindOfClass:[NSNull class]]) {
        return nil;
    }else{
        NSArray *dataArr = [dic objectForKey:@"data"];
        for (NSDictionary *coupondic in dataArr) {
            CouponModel *model = [[CouponModel alloc]init];
            model.code = [coupondic objectForKey:@"code"];
            model.code_status = [coupondic objectForKey:@"code_status"];
            model.discount = [NSString stringWithFormat:@"%@",[coupondic objectForKey:@"discount"]];
            model.from = [coupondic objectForKey:@"from"];
            model.money_from =[NSString stringWithFormat:@"%@",[coupondic objectForKey:@"money_from"]];
            model.title = [coupondic objectForKey:@"title"];
            model.type =[NSString stringWithFormat:@"%@",[coupondic objectForKey:@"type"]];
            model.to=[coupondic objectForKey:@"to"];
            [couponArr addObject:model];
        }
        return couponArr;
    }
    
}
@end
