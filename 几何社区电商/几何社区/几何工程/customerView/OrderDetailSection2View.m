//
//  OrderDetailSection2View.m
//  几何社区
//
//  Created by KMING on 15/8/28.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "OrderDetailSection2View.h"
#import "UIButton+AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "Define.h"
@implementation OrderDetailSection2View

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews{
    [super layoutSubviews];
    self.backgroundColor = [UIColor whiteColor];
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 66);
    self.imgbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.imgbtn.center = CGPointMake(12+25, 33);
    [self.imgbtn setImageForState:UIControlStateNormal withURL:[NSURL URLWithString:self.imgurl] placeholderImage:[UIImage imageNamed:@"产品默认图"]];
    [self addSubview:self.imgbtn];
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 250, 15)];
    self.nameLabel.center = CGPointMake(12+50+18+125, 21);
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.nameLabel.textColor = Color242424;
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.text = self.name;
    [self addSubview:self.nameLabel];
    
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 15)];
    self.priceLabel.center = CGPointMake(12+50+18+50, self.nameLabel.center.y+15+9);
    self.priceLabel.font = [UIFont systemFontOfSize:15];
    self.priceLabel.textColor = RGBCOLOR(255.0, 138.0, 0,1);
    self.priceLabel.textAlignment = NSTextAlignmentLeft;
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f",[self.price floatValue]];
    [self addSubview:self.priceLabel];
    
    self.productnumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 15)];
    self.productnumLabel.textAlignment = NSTextAlignmentRight;
    self.productnumLabel.center = CGPointMake(SCREEN_WIDTH-12-30, 66-16-7.5);
    self.productnumLabel.textColor = RGBCOLOR(117.0, 117.0, 117.0,1);
    self.productnumLabel.font = [UIFont systemFontOfSize:15];
    self.productnumLabel.text = [NSString stringWithFormat:@"X%@",self.quantity];
    [self addSubview:self.productnumLabel];
    
    //中间那条线
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(12+50+18, 65.5, SCREEN_WIDTH-12-50-18, 0.5)];
    centerView.backgroundColor = SEPARATELINE_COLOR;
    [self addSubview:centerView];
}
@end
