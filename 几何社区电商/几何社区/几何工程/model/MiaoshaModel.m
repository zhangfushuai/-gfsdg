//
//  MiaoshaModel.m
//  几何社区
//
//  Created by KMING on 15/10/13.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "MiaoshaModel.h"

@implementation MiaoshaModel
+ (NSMutableArray*)listFromJsonDictionnary:(NSDictionary *)dic{
    NSMutableArray *products = [NSMutableArray array];
    NSDictionary *dataDic = [dic objectForKey:@"data"];
    
    if ([[dataDic objectForKey:@"product"]isKindOfClass:[NSNull class]]) {
        return nil;
    }else{
        NSArray *proArr = [dataDic objectForKey:@"product"];
        for (NSDictionary *proDic in proArr) {
            MiaoshaModel *model  = [[MiaoshaModel alloc]init];
            model.discount_price = [proDic objectForKey:@"discount_price"];
            model.imgsrc = [proDic objectForKey:@"imgsrc"];
            model.limit_amount = [proDic objectForKey:@"limit_amount"];
            model.mid = [proDic objectForKey:@"mid"];
            model.pid = [proDic objectForKey:@"pid"];
            model.remain_amount = [proDic objectForKey:@"remain_amount"];
            model.title = [proDic objectForKey:@"title"];
            model.type = [NSString stringWithFormat:@"%@",[proDic objectForKey:@"type"]];
            model.original_price = [proDic objectForKey:@"original_price"];
            [products addObject:model];
        }
        return products;
    }
    
}
@end
