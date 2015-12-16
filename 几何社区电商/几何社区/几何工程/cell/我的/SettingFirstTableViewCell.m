//
//  SettingFirstTableViewCell.m
//  几何社区
//
//  Created by KMING on 15/8/22.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "SettingFirstTableViewCell.h"

@implementation SettingFirstTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.nickname.textColor = Color242424;
    self.phonenum.textColor = Color757575;
    UIView *view = [[UIView alloc]
                    initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12)];
    view.backgroundColor = HEADERVIEW_COLOR;
    UIView *downline = [[UIView alloc]initWithFrame:CGRectMake(0, 11.5, SCREEN_WIDTH, 0.5)];
    downline.backgroundColor = SEPARATELINE_COLOR;
    [view addSubview:downline];
    [self.contentView addSubview:view];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
