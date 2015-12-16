//
//  CarGoodCell.m
//  几何社区
//
//  Created by 颜 on 15/9/16.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "CarGoodCell.h"

@implementation CarGoodCell

- (void)awakeFromNib {
    // Initialization code
    _longLineHeight.constant = 0.5;
    _shortLineHeight.constant = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
