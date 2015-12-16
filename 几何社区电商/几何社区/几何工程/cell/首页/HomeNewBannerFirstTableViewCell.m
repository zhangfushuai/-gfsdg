//
//  HomeNewBannerFirstTableViewCell.m
//  几何社区
//
//  Created by KMING on 15/10/10.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "HomeNewBannerFirstTableViewCell.h"

@implementation HomeNewBannerFirstTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*105/320) ;
    self.imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*105/320)];
    [self.contentView addSubview:self.imgV];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
