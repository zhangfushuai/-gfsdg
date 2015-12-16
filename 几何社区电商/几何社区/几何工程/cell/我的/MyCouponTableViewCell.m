//
//  MyCouponTableViewCell.m
//  几何社区
//
//  Created by KMING on 15/9/23.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "MyCouponTableViewCell.h"

@implementation MyCouponTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.contentView.backgroundColor = HEADERVIEW_COLOR;
    
    self.usable.textColor = RGBCOLOR(255, 149, 58, 1) ;
    self.priceLbl.text = self.model.discount;
    self.codeLbl.text = [NSString stringWithFormat:@"优惠码:%@",self.model.code];
    self.codeLbl.textColor = Color757575;
    self.moneyFrom.text = [NSString stringWithFormat:@"满%@元可用",self.model.money_from];
    self.titleLbl.text = self.model.title;
    self.moneyFrom.textColor = Color757575;
    self.toLbl.text = [NSString stringWithFormat:@"有效期至:%@",self.model.to];
    self.toLbl.textColor = Color757575;
    self.wechatOrApp.textColor = Color757575;
    self.usable.text = self.model.code_status;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
