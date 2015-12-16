//
//  HomeOtherTableViewCell.m
//  几何社区
//
//  Created by KMING on 15/8/23.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "HomeOtherTableViewCell.h"
#import "UIImageView+AFNetworking.h"
@implementation HomeOtherTableViewCell

- (void)awakeFromNib {
    // Initialization code
  

  
    }
-(void)layoutSubviews{
    [super layoutSubviews];
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*105/320+8);
        UIView *seperateV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
        seperateV.backgroundColor = HEADERVIEW_COLOR;
        UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        topLine.backgroundColor = SEPARATELINE_COLOR;
        [seperateV addSubview:topLine];
        UIView *downLine = [[UIView alloc]initWithFrame:CGRectMake(0, 7.5, SCREEN_WIDTH, 0.5)];
        downLine.backgroundColor = SEPARATELINE_COLOR;
        [seperateV addSubview:downLine];
        [self.contentView addSubview:seperateV];
    self.img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 8, self.frame.size.width, self.frame.size.height-8)];
    [self.img setImageWithURL:[NSURL URLWithString:self.model.imgsrc] placeholderImage:[UIImage imageNamed:@"首页banner默认图"]];
    [self.contentView addSubview:self.img];
    
   }
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
