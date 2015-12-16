//
//  HomeOtherTableViewCell.h
//  几何社区
//
//  Created by KMING on 15/8/23.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotSellModel.h"
@interface HomeOtherTableViewCell : UITableViewCell
@property (nonatomic,strong)UIImageView *img;
@property (nonatomic,strong)HotSellModel *model;//数据源
@end
