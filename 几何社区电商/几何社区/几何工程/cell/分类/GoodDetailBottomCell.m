//
//  GoodDetailBottomCell.m
//  几何社区
//
//  Created by 颜 on 15/9/11.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "GoodDetailBottomCell.h"

@implementation GoodDetailBottomCell

- (void)awakeFromNib {
    // Initialization code
    _lineViewHeight.constant = 0.5;
    _lineBotomHeight.constant = 0.5;
    _lineTop.backgroundColor  = SEPARATELINE_COLOR;
    _lineButtom.backgroundColor = SEPARATELINE_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
