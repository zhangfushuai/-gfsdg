//
//  CouponCell.h
//  几何社区
//
//  Created by 颜 on 15/9/1.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouponCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgVbackGroud;
@property (weak, nonatomic) IBOutlet UILabel *lblMonney;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblPassword;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeOut;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIImageView *imgVused;

@end
