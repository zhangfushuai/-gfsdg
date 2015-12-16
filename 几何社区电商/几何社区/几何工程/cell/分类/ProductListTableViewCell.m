//
//  ProductListTableViewCell.m
//  几何社区
//
//  Created by KMING on 15/8/24.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "ProductListTableViewCell.h"
#import "Define.h"
#import "UIImageView+AFNetworking.h"

@implementation ProductListTableViewCell

- (void)awakeFromNib {
//    // Initialization code                                                                                                                                                                         
}
#pragma mark - 点击加号
- (void)startAnimation
{
    
    CGRect rec = [self convertRect:self.imgVproduct.frame toView:[UIApplication sharedApplication].keyWindow];//从cell的坐标转到window的坐标
    UIImageView *jumpimg = [[UIImageView alloc]initWithFrame:rec];
    jumpimg.image = self.imgVproduct.image;
    [[UIApplication sharedApplication].keyWindow addSubview:jumpimg];
    [UIView animateWithDuration:0.6 animations:^{
        jumpimg.frame = CGRectMake(SCREEN_WIDTH-33, 40, 5, 5);
    } completion:^(BOOL finished) {
        [jumpimg removeFromSuperview];
    }];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
