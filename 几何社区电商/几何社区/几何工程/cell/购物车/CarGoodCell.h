//
//  CarGoodCell.h
//  几何社区
//
//  Created by 颜 on 15/9/16.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarGoodCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;
@property (weak, nonatomic) IBOutlet UIImageView *imgVGood;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblMoney;
@property (weak, nonatomic) IBOutlet UIButton *btnReduce;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
@property (weak, nonatomic) IBOutlet UILabel *lblGoodCount;
@property (weak, nonatomic) IBOutlet UIView *VButtomLine;
@property (weak, nonatomic) IBOutlet UIView *buttomLineV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblCountTrailing;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *longLineHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shortLineHeight;

@end
