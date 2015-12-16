//
//  MyOrderModel.m
//  几何社区
//
//  Created by KMING on 15/9/21.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "MyOrderModel.h"
#import "MyorderProductModel.h"
@implementation MyOrderModel
+ (NSMutableArray*)listFromJsonDictionnary:(NSDictionary *)dic{

    NSMutableArray *orderArr =[NSMutableArray array];
    if ([[dic  objectForKey:@"data"]isKindOfClass:[NSNull class]]) {
        return nil;
    }
    NSArray *dataArr = [dic objectForKey:@"data"];
    for (NSDictionary *modelDic in dataArr) {
        MyOrderModel *model = [[MyOrderModel alloc]init];
        NSString *address =[NSString stringWithFormat:@"%@",[modelDic objectForKey:@"address"]];
        NSArray *addressArr = [address componentsSeparatedByString:@" "];
        if (addressArr.count==0) {
            model.userName = @"";
            model.userPhone = @"";
            model.userAddress = @"";
        }else if (addressArr.count==1){
            model.userName = addressArr[0];
            model.userPhone = @"";
            model.userAddress = @"";
        }else if (addressArr.count==2){
            model.userName = addressArr[0];
            model.userPhone = addressArr[1];
            model.userAddress = @"";
        }else if (addressArr.count==3){
            model.userName = addressArr[0];
            model.userPhone = addressArr[1];
            model.userAddress = addressArr[2];
        }
                
        
        
        NSString *amount =[NSString stringWithFormat:@"%@",[modelDic objectForKey:@"amount"]];
        NSInteger am = [amount integerValue];
        model.amount = [NSString stringWithFormat:@"%ld",(long)am];
        model.buyer = [NSString stringWithFormat:@"%@",[modelDic objectForKey:@"buyer"]];
        model.coupon = [NSString stringWithFormat:@"%@",[modelDic objectForKey:@"coupon"]];
        model.created = [NSString stringWithFormat:@"%@",[modelDic objectForKey:@"created"]];
        model.deliver_time = [NSString stringWithFormat:@"%@",[modelDic objectForKey:@"deliver_time"]];
        model.deliverer = [NSString stringWithFormat:@"%@",[modelDic objectForKey:@"deliverer"]];
        model.iid = [NSString stringWithFormat:@"%@",[modelDic objectForKey:@"id"]];
         model.message = [NSString stringWithFormat:@"%@",[modelDic objectForKey:@"message"]];
         model.number = [NSString stringWithFormat:@"%@",[modelDic objectForKey:@"number"]];
         model.pay_type = [NSString stringWithFormat:@"%@",[modelDic objectForKey:@"pay_type"]];
         model.shipping = [NSString stringWithFormat:@"%@",[modelDic objectForKey:@"shipping"]];
         model.status_alias = [NSString stringWithFormat:@"%@",[modelDic objectForKey:@"status_alias"]];
        model.status = [NSString stringWithFormat:@"%@",[modelDic objectForKey:@"status"]];
         model.wechat_openid = [NSString stringWithFormat:@"%@",[modelDic objectForKey:@"wechat_openid"]];
         model.wechat_pay_id = [NSString stringWithFormat:@"%@",[modelDic objectForKey:@"wechat_pay_id"]];
         model.wechat_pay_result = [NSString stringWithFormat:@"%@",[modelDic objectForKey:@"wechat_pay_result"]];
         model.wechat_pay_status = [NSString stringWithFormat:@"%@",[modelDic objectForKey:@"wechat_pay_status"]];
         model.wechat_prepay_id = [NSString stringWithFormat:@"%@",[modelDic objectForKey:@"wechat_prepay_id"]];
         NSArray *productsArr = [modelDic objectForKey:@"products"];
        NSMutableArray *products = [NSMutableArray array];
        for (NSDictionary *productDic in productsArr) {
            MyorderProductModel *pModel = [[MyorderProductModel alloc]init];
            pModel.unit = [NSString stringWithFormat:@"%@",[productDic objectForKey:@"unit"]];
            pModel.model_id = [NSString stringWithFormat:@"%@",[productDic objectForKey:@"model_id"]];
            pModel.quantity = [NSString stringWithFormat:@"%@",[productDic objectForKey:@"quantity"]];
            pModel.iid = [NSString stringWithFormat:@"%@",[productDic objectForKey:@"id"]];
            pModel.price = [NSString stringWithFormat:@"%@",[productDic objectForKey:@"price"]];
            pModel.title = [NSString stringWithFormat:@"%@",[productDic objectForKey:@"title"]];
            pModel.tookprice = [NSString stringWithFormat:@"%@",[productDic objectForKey:@"tookprice"]];
            pModel.pic_url = [NSString stringWithFormat:@"%@",[productDic objectForKey:@"pic_url"]];
            pModel.shop_id = [NSString stringWithFormat:@"%@",[productDic objectForKey:@"shop_id"]];
            pModel.pic_url_origin = [NSString stringWithFormat:@"%@",[productDic objectForKey:@"pic_url_origin"]];
            [products addObject:pModel];
        }
        model.products = products;
        [orderArr addObject:model];
    }
    return orderArr;
}
@end
