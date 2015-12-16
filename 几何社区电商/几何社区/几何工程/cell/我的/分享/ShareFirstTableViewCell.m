//
//  ShareFirstTableViewCell.m
//  几何社区
//
//  Created by KMING on 15/9/25.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "ShareFirstTableViewCell.h"
#import "UIView+Extension.h"
@implementation ShareFirstTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/2+20);
    UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    topline.backgroundColor = SEPARATELINE_COLOR;
    [self addSubview:topline];
    
    UIView *centerHengL = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height/4*3, SCREEN_WIDTH, 0.5)];
    centerHengL.backgroundColor = SEPARATELINE_COLOR;
    [self addSubview:centerHengL];
    
        UIView *centerShuL = [[UIView alloc]initWithFrame:CGRectMake(0, centerHengL.frame.origin.y+0.5, 0.5, self.bounds.size.height/4)];
    centerShuL.centerX = SCREEN_WIDTH/2;
    centerShuL.backgroundColor = SEPARATELINE_COLOR;
    [self addSubview:centerShuL];
    self.touxiang = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 96, 96)];
    self.touxiang.layer.masksToBounds = YES;
    self.touxiang.layer.cornerRadius = 48;
    //self.touxiang.image = [UIImage imageNamed:@"tx"];
    self.touxiang.center = CGPointMake(SCREEN_WIDTH/2, 12+48);
    [self addSubview:self.touxiang];
    
    self.phoneLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 160, 15)];
    self.phoneLbl.textColor = Color757575;
    self.phoneLbl.textAlignment = NSTextAlignmentCenter;
    self.phoneLbl.center = CGPointMake(SCREEN_WIDTH/2, (self.touxiang.frame.origin.y+self.touxiang.frame.size.height+centerHengL.frame.origin.y)/2);
    //self.phoneLbl.text = @"18210878176";
    [self addSubview:self.phoneLbl];
    
    self.yaoqingNumLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 12)];
    self.yaoqingNumLbl.textAlignment =NSTextAlignmentCenter;
    self.yaoqingNumLbl.textColor = RGBCOLOR(0, 0, 0, 1);
    self.yaoqingNumLbl.font = [UIFont systemFontOfSize:12];
    //self.yaoqingNumLbl.text = @"12";
    self.yaoqingNumLbl.center = CGPointMake(SCREEN_WIDTH/4, self.bounds.size.height-self.bounds.size.height/8-8);
    [self addSubview:self.yaoqingNumLbl];
    
    UILabel *yaoqingLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 12)];
    yaoqingLbl.textAlignment = NSTextAlignmentCenter;
    yaoqingLbl.textColor = Color757575;
    yaoqingLbl.font = [UIFont systemFontOfSize:12];
    yaoqingLbl.text = @"成功邀请";
    yaoqingLbl.center= CGPointMake(self.yaoqingNumLbl.center.x, self.bounds.size.height-self.bounds.size.height/8+8);
    [self addSubview:yaoqingLbl];
    
    self.priceNumLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 12)];
    self.priceNumLbl.font = [UIFont systemFontOfSize:12];
    self.priceNumLbl.textColor = RGBCOLOR(0, 0, 0, 1);
    self.priceNumLbl.center = CGPointMake(SCREEN_WIDTH/4*3, self.bounds.size.height-self.bounds.size.height/8-8);
    self.priceNumLbl.textAlignment = NSTextAlignmentCenter;
    //priceNumLbl.text = @"￥60";
    [self addSubview:self.priceNumLbl];
    
    UILabel *priceLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 12)];
    priceLbl.font = [UIFont systemFontOfSize:12];
    priceLbl.textColor = Color757575;
    priceLbl.center = CGPointMake(SCREEN_WIDTH/4*3, self.bounds.size.height-self.bounds.size.height/8+8);
    priceLbl.textAlignment = NSTextAlignmentCenter;
    priceLbl.text = @"总金额";
    [self addSubview:priceLbl];
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
