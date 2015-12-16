//
//  OrderCommentTableViewCell.h
//  几何社区
//
//  Created by KMING on 15/10/20.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderModel.h"
@interface OrderCommentTableViewCell : UITableViewCell
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UILabel *introlabel;
@property (nonatomic,strong)UILabel *payStateLabel;
@property (nonatomic,strong)MyOrderModel *model;
@end
