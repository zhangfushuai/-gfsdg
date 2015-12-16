//
//  GoodCategaryCell.m
//  几何社区
//
//  Created by 颜 on 15/9/2.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "GoodCategaryCell.h"

@implementation GoodCategaryCell

- (void)awakeFromNib {
    // Initialization code
    _downLine.backgroundColor = RGBCOLOR(224, 224, 224, 1);
    _rightLine.backgroundColor = RGBCOLOR(224, 224, 224, 1);
    _redLine.backgroundColor = NAVIGATIONBAR_COLOR;
    _lblText.tintColor = RGBCOLOR(101, 101, 101, 1);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
