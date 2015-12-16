//
//  BestSellerView.m
//  几何社区
//
//  Created by KMING on 15/9/10.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "BestSellerView.h"
#import "UIImageView+AFNetworking.h"
@implementation BestSellerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)layoutSubviews{
    [super layoutSubviews];
    CGFloat vW = (SCREEN_WIDTH-12*3)/2;
    CGFloat vH = (vW-2)*135/140+1+57+22;
    self.bounds =CGRectMake(0, 0, vW, vH);
    
    if (!self.nameLbl) {
        self.nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(4, 6, self.frame.size.width-8, 36)];
        self.nameLbl.textColor = Color242424;
        self.nameLbl.numberOfLines = 2;
        self.nameLbl.font = [UIFont systemFontOfSize:15];
        [self.downV addSubview:self.nameLbl];
    }
    if (!self.priceLbl) {
        self.priceLbl = [[UILabel alloc]initWithFrame:CGRectMake(4, 54, self.frame.size.width-8, 17)];
        self.priceLbl.textColor = [UIColor orangeColor];
        self.priceLbl.numberOfLines = 1;
        self.priceLbl.font = [UIFont systemFontOfSize:17];
        [self.downV addSubview:self.priceLbl];
    }
    
    
    
    //self.imgV.frame = CGRectMake(1, 1, vW-2, vW-2);
    //self.imgV.center = CGPointMake(self.bounds.size.width/2, 8+self.imgV.frame.size.height/2);
    [self.imgV setImageWithURL:[NSURL URLWithString:self.model.imgsrc] placeholderImage:nil];
        self.imgV.layer.masksToBounds = YES;
    self.imgV.layer.cornerRadius = 3;
    self.nameLbl.text = self.model.title;
    self.nameLbl.textColor = Color242424;
    self.priceLbl.text = [NSString stringWithFormat:@"¥%.2f",[self.model.price floatValue]];
    if (!self.line) {
        self.line = [[UIView alloc]initWithFrame:CGRectMake(self.priceLbl.frame.origin.x, self.priceLbl.frame.origin.y-6.5, self.frame.size.width-2*self.priceLbl.frame.origin.x, 0.5)];
        self.line.backgroundColor = SEPARATELINE_COLOR;
        [self.downV addSubview:self.line];
    }
   
    
}
@end
