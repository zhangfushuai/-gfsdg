//
//  GoodDetailBottomCell.h
//  几何社区
//
//  Created by 颜 on 15/9/11.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodDetailBottomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineBotomHeight;

@property (weak, nonatomic) IBOutlet UIView *lineTop;
@property (weak, nonatomic) IBOutlet UIView *lineButtom;

@end
