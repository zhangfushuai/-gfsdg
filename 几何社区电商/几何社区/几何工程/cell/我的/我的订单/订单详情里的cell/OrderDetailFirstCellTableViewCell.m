//
//  OrderDetailFirstCellTableViewCell.m
//  几何社区
//
//  Created by KMING on 15/8/28.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "OrderDetailFirstCellTableViewCell.h"

@implementation OrderDetailFirstCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 65);
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,0, 100, 15)];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.center = CGPointMake(12+50,14+7.5);
    self.nameLabel.textColor =RGBCOLOR(36.0, 36.0, 36.0,1);
    //self.nameLabel.text = @"李明翰";
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.nameLabel];
    
    self.phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
    self.phoneLabel.center = CGPointMake(SCREEN_WIDTH-12-100, self.nameLabel.center.y);
    self.phoneLabel.textAlignment = NSTextAlignmentRight;
    //self.phoneLabel.text = @"18888888888";
    self.phoneLabel.font = [UIFont systemFontOfSize:15];
    self.phoneLabel.textColor =RGBCOLOR(36.0, 36.0, 36.0,1);
    [self addSubview:self.phoneLabel];
    
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 12)];
    self.addressLabel.center = CGPointMake(12+150, 45);
    self.addressLabel.font = [UIFont systemFontOfSize:12];
    self.addressLabel.textColor = RGBCOLOR(117.0, 117.0, 117.0,1);
    self.addressLabel.textAlignment = NSTextAlignmentLeft;
    //self.addressLabel.text = @"广东省深圳市罗湖区哈哈哈哈";
    [self addSubview:self.addressLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
