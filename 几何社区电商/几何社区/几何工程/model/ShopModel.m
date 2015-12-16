//
//  ShopModel.m
//  几何社区
//
//  Created by KMING on 15/10/6.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "ShopModel.h"

@implementation ShopModel
+ (NSMutableArray*)listFromJsonDictionnary:(NSDictionary *)root{
    
    NSMutableArray *arrList = [[NSMutableArray alloc] init];
    if ([[root objectForKey:@"data"]isKindOfClass:[NSNull class]]) {
        return nil;
    }else{
        NSArray *dataArr = [root objectForKey:@"data"];
        for (NSDictionary *dataDic in dataArr) {
            ShopModel *model = [[ShopModel alloc]init];
            model.iid = [dataDic objectForKey:@"id"];
            model.address =[dataDic objectForKey:@"address"];
            model.imgsrc =[dataDic objectForKey:@"imgsrc"];
            model.title =[dataDic objectForKey:@"title"];
            [arrList addObject:model];
        }
        return arrList;
    }
    
    
    
}
@end
