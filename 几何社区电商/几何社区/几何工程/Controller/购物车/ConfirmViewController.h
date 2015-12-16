//
//  ConfirmViewController.h
//  几何社区
//
//  Created by 颜 on 15/9/17.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "JHBasicViewController.h"
#import "MyAddressModel.h"

@interface ConfirmViewController : JHBasicViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;

@property (nonatomic , strong)NSArray *dataSourse;      //商品列表数据
@property (nonatomic , strong)NSMutableArray *addressList;     //地址列表
@property (nonatomic , strong)MyAddressModel *addressModel; //收获地址
@property (nonatomic , strong)NSArray *couponList;      //优惠券列表
@property (nonatomic , strong)NSString *totalPrice;     //总价格
@property (nonatomic , strong)NSString *shipping;       //配送费
@property (nonatomic , strong)NSString *coupon_num;       //是否有优惠券
@property (nonatomic , copy)NSString *coupon_name;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomDistance;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeight;


@end
