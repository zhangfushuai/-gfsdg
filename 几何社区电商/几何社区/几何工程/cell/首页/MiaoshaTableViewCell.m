//
//  MiaoshaTableViewCell.m
//  几何社区
//
//  Created by KMING on 15/10/12.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "MiaoshaTableViewCell.h"
#import "UIImageView+AFNetworking.h"
@implementation MiaoshaTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.downImg.layer.masksToBounds = YES;
    self.downImg.layer.cornerRadius = 4;
    self.nameLbl.textColor = Color242424;
    self.yuanjia.textColor = Color757575;
    self.priceLbl.textColor = NAVIGATIONBAR_COLOR;
    self.qiangBtn.layer.masksToBounds = YES;
    self.qiangBtn.layer.cornerRadius = 3;
    self.downImg.layer.masksToBounds = YES;
    self.downImg.layer.cornerRadius = 5;
    self.topImg.layer.masksToBounds = YES;
    self.topImg.layer.cornerRadius = 5;
    

}
- (IBAction)qiangAction:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"miaoShaQiangGouBtn" object:@{@"model":self.model}];
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.downImg setImageWithURL:[NSURL URLWithString:self.model.imgsrc] placeholderImage:[UIImage imageNamed:@"产品默认图"]];
    if ([self.model.type isEqualToString:@"0"]) {
        self.topImg.image = [UIImage imageNamed:@"列表秒杀标签"];
    }else{
        self.topImg.image = [UIImage imageNamed:@"列表抢购标签"];
    }
    
    self.nameLbl.text = self.model.title;
    self.yuanjia.text = [NSString stringWithFormat:@"原价：￥%@",self.model.original_price];
    self.priceLbl.text = [NSString stringWithFormat:@"￥%@",self.model.discount_price];
    if ([self.flag isEqualToString:@"0"]) {
        self.qiangBtn.backgroundColor = Color757575;
        [self.qiangBtn setTitle:@"请等待" forState:UIControlStateNormal];
        self.qiangBtn.enabled = NO;
    }else{
        if ([self.model.remain_amount isEqualToString:@"0"]||self.model.remain_amount==nil) {
            self.qiangBtn.backgroundColor = Color757575;
            [self.qiangBtn setTitle:@"抢光了" forState:UIControlStateNormal];
            self.qiangBtn.enabled = NO;
        }else{
            self.qiangBtn.backgroundColor = NAVIGATIONBAR_COLOR;
            [self.qiangBtn setTitle:@"马上抢" forState:UIControlStateNormal];
            self.qiangBtn.enabled = YES;

        }
    }
    
    
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
