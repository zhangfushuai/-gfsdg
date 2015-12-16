//
//  ShopListTableViewCell.m
//  几何社区
//
//  Created by KMING on 15/10/6.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "ShopListTableViewCell.h"
#import "UIImageView+AFNetworking.h"
@implementation ShopListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.img setImageWithURL:[NSURL URLWithString:self.model.imgsrc] placeholderImage:[UIImage imageNamed:@"产品默认图"]];
    self.name.text = self.model.title;
    self.name.textColor = Color242424;
    self.address.text = self.model.address;
    self.address.textColor = Color757575;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
