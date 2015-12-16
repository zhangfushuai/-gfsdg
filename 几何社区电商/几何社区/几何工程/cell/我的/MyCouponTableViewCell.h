//
//  MyCouponTableViewCell.h
//  几何社区
//
//  Created by KMING on 15/9/23.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"
@interface MyCouponTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *priceLeftLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *couponType;
@property (weak, nonatomic) IBOutlet UILabel *codeLbl;
@property (weak, nonatomic) IBOutlet UILabel *moneyFrom;
@property (weak, nonatomic) IBOutlet UILabel *wechatOrApp;
@property (weak, nonatomic) IBOutlet UILabel *toLbl;

@property (weak, nonatomic) IBOutlet UILabel *usable;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *backimg;

@property (nonatomic,strong)CouponModel *model;
@end
