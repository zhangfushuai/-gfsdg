//
//  MyCouponsViewController.h
//  几何社区
//
//  Created by KMING on 15/9/22.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CouponDelegate <NSObject>
@optional
- (void)reloadCheckOut;
@end
@interface MyCouponsViewController : JHBasicViewController<JHDataMagerDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *myTf;

@property (nonatomic ,assign)NSInteger fromFlag;  //1000 购物车
@property (nonatomic ,assign)id <CouponDelegate>delegate;
@end
