//
//  OrderDetailSection2TableViewCell.m
//  几何社区
//
//  Created by KMING on 15/8/28.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "OrderDetailSection2TableViewCell.h"
#import "Define.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+AFNetworking.h"
#import "OrderDetailSection2View.h"
#import "MyorderProductModel.h"
@implementation OrderDetailSection2TableViewCell
-(void)layoutSubviews{
    [super layoutSubviews];
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 32+40+66*self.products.count);
    //产品清单
    
    UILabel *productListLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 15)];
    productListLabel.center = CGPointMake(12+30, 16);
    productListLabel.text = @"产品清单";
    productListLabel.font = [UIFont systemFontOfSize:15];
    productListLabel.textColor = Color242424;
    [self addSubview:productListLabel];
    UIView *downline1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 31.5, SCREEN_WIDTH, 0.5)];
    downline1.backgroundColor = SEPARATELINE_COLOR;
    [self addSubview:downline1];
    //产品种类，显示几行
    for (int i=0; i<self.products.count; i++) {
        MyorderProductModel *model = self.products[i];
        OrderDetailSection2View *orderview = [[OrderDetailSection2View alloc]initWithFrame:CGRectMake(0, 32+66*i, SCREEN_WIDTH, 66)];
        orderview.imgurl =model.pic_url;
        orderview.name = model.title;
        orderview.price = [NSString stringWithFormat:@"%.2f",[model.price floatValue]];
        orderview.quantity = model.quantity;
        
        
        [self addSubview:orderview];
    }
    //备注那一行
    UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, 32+66*self.products.count, SCREEN_WIDTH, 0.5)];
    topline.backgroundColor = SEPARATELINE_COLOR;
    [self addSubview:topline];
    //由于给view加了中间的线，所以最后的备注上的那条线会左右不均匀，所以 给右边加上白色线，盖上不均匀 部位，你可以尝试注释掉看看效果.
    UIView *toprightline = [[UIView alloc]initWithFrame:CGRectMake(12+50+18, 32+66*self.products.count-0.5, SCREEN_WIDTH-12-50-18, 0.5)];
    toprightline.backgroundColor = [UIColor whiteColor];
    [self addSubview:toprightline];
    
    UILabel *beizhuLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 15)];
    beizhuLabel.font = [UIFont systemFontOfSize:15];
    beizhuLabel.textColor =Color242424;
    beizhuLabel.text = @"备注";
    beizhuLabel.center = CGPointMake(12+15, 20+32+66*self.products.count);
    [self addSubview:beizhuLabel];
    UILabel *msgLbl = [[UILabel alloc]initWithFrame:CGRectMake(beizhuLabel.frame.origin.x+beizhuLabel.frame.size.width+12, beizhuLabel.frame.origin.y, SCREEN_WIDTH-(beizhuLabel.frame.origin.x+beizhuLabel.frame.size.width+12)-12, 15)];
    msgLbl.font = [UIFont systemFontOfSize:15];
    msgLbl.textAlignment = NSTextAlignmentRight;
    msgLbl.textColor = Color757575;
    msgLbl.text = self.msg;
    [self addSubview:msgLbl];
    
}
- (void)awakeFromNib {
    // Initialization code
   
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
