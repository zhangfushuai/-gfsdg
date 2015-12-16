//
//  MyAddressTableVIewCell.m
//  几何社区
//
//  Created by KMING on 15/9/5.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "MyAddressTableVIewCell.h"
#import "Define.h"
@implementation MyAddressTableVIewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib{
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 14, 120, 18)];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.textColor =Color242424;
    self.phoneLabel.textColor = Color242424;
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.nameLabel.center = CGPointMake(self.nameLabel.center.x, self.phoneLabel.center.y);
    if (!self.addressLabel) {
        self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 33, SCREEN_WIDTH-24, 38)];
        self.addressLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.addressLabel];
        self.addressLabel.textColor = Color757575;
        self.addressLabel.numberOfLines = 2;
    }
   
    
    
    
}
@end
