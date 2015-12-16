//
//  OrderDetailViewController.h
//  几何社区
//
//  Created by KMING on 15/8/28.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderModel.h"
@interface OrderDetailViewController : JHBasicViewController
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)MyOrderModel *model;


@property (nonatomic,strong)NSMutableArray *section2contents;
@property (nonatomic,strong)NSMutableArray *section3contents;
@property (nonatomic,strong)UIView *cancelOrPayV;//下面的取消支付

@property (nonatomic,assign)NSInteger payWayFlag;
@end
