//
//  OrderDetailDownSectionSingleTableViewCell.m
//  几何社区
//
//  Created by KMING on 15/8/28.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "OrderDetailDownSectionSingleTableViewCell.h"

@implementation OrderDetailDownSectionSingleTableViewCell

- (void)awakeFromNib {
    // Initialization code
//    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44);
//    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 15)];
//    self.nameLabel.font = [UIFont systemFontOfSize:15];
//    self.nameLabel.textColor = RGBCOLOR(37.0, 37.0, 37.0);
//    self.nameLabel.center = CGPointMake(42, 22);
//    [self addSubview:self.nameLabel];
//    self.nameLabel.text = @"订单编号";
//    
//    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 160, 15)];
//    self.contentLabel.font = [UIFont systemFontOfSize:15];
//    self.contentLabel.textColor = RGBCOLOR(117.0, 117.0, 117.0);
////    self.contentLabel.center = CGPointMake(<#CGFloat x#>, <#CGFloat y#>)
    self.nameLabel.textColor = RGBCOLOR(37.0, 37.0, 37.0,1);
    self.introLabel.textColor = RGBCOLOR(117.0, 117.0, 117.0,1);
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.nameLabel.text = self.name;
    self.introLabel.text = self.content;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
