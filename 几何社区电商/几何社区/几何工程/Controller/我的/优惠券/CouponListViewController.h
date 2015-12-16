//
//  CouponListViewController.h
//  几何社区
//
//  Created by 颜 on 15/9/1.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
enum {
    VALID = 1000,
    USED,
    TIMEOUT,
};
@interface CouponListViewController : UIViewController
@property (nonatomic,assign) NSInteger type;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic , strong)NSArray *datasourse; //优惠券数据源
@end
