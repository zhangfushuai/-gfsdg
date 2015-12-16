//
//  ConfirmDirectViewController.h
//  几何社区
//
//  Created by 颜 on 15/10/7.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "JHBasicViewController.h"
#import "MyAddressModel.h"


@interface ConfirmDirectViewController : JHBasicViewController   //快递送货  没有优惠无需配送费
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;

@property (nonatomic , strong)NSArray *dataSourse;      //商品列表数据
@property (nonatomic , strong)NSMutableArray *addressList;     //地址列表
@property (nonatomic , strong)MyAddressModel *addressModel; //收获地址
@property (nonatomic , strong)NSString *totalPrice;     //总价格
@property (nonatomic , strong)NSString *shipping;       //配送费
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomDistance;
@property (nonatomic , assign)NSInteger fromFlag;       // 1000 秒杀  否则 远离风口书
@end
