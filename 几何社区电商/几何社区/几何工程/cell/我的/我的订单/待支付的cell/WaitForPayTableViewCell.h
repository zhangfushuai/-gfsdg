//
//  WaitForPayTableViewCell.h
//  几何社区
//
//  Created by KMING on 15/8/27.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderModel.h"
//@protocol WQZShopGroupCellDelegate <NSObject>
//
//@optional
//-(void)reloadDataRowOfClickedAtIndex:(NSInteger)index;
//@end
@interface WaitForPayTableViewCell : UITableViewCell
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UILabel *introlabel;
@property (nonatomic,strong)UILabel *payStateLabel;
@property (nonatomic,strong)MyOrderModel *model;
@end
