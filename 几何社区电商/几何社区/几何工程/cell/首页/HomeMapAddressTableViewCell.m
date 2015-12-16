//
//  HomeMapAddressTableViewCell.m
//  几何社区
//
//  Created by KMING on 15/10/5.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "HomeMapAddressTableViewCell.h"

@implementation HomeMapAddressTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.label.textColor = Color242424;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
