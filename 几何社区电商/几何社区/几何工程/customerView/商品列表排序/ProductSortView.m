//
//  ProductSortView.m
//  几何社区
//
//  Created by 颜 on 15/9/9.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "ProductSortView.h"

@implementation ProductSortView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)originView
{
    _buttomLine.constant = 0.5;
    [_btnOne setTintColor:[UIColor blackColor]];
    [_btnTwo setTintColor:[UIColor blackColor]];
    [_btnThree setTintColor:[UIColor blackColor]];
    
    [_btnOne setTitle:@"默认折扣" forState:UIControlStateNormal];
    [_btnTwo setTitle:@"默认价格" forState:UIControlStateNormal];
    [_btnThree setTitle:@"默认销量" forState:UIControlStateNormal];
    
    [_btnOne setImage:[UIImage imageNamed:@"xla"] forState:UIControlStateNormal];
    [_btnTwo setImage:[UIImage imageNamed:@"xla"] forState:UIControlStateNormal];
    [_btnThree setImage:[UIImage imageNamed:@"xla"] forState:UIControlStateNormal];
    
    [_btnOne setTitleColor:RGBCOLOR(0, 0, 0, 0.54) forState:UIControlStateNormal];
    [_btnTwo setTitleColor:RGBCOLOR(0, 0, 0, 0.54) forState:UIControlStateNormal];
    [_btnThree setTitleColor:RGBCOLOR(0, 0, 0, 0.54) forState:UIControlStateNormal];
    
    _btnOne.tag     = 1000;
    _btnTwo.tag     = 1001;
    _btnThree.tag   = 1002;
    
}
- (IBAction)buttonOnClick:(id)sender {
    [_btnOne setImage:[UIImage imageNamed:@"xla"] forState:UIControlStateNormal];
    [_btnTwo setImage:[UIImage imageNamed:@"xla"] forState:UIControlStateNormal];
    [_btnThree setImage:[UIImage imageNamed:@"xla"] forState:UIControlStateNormal];
    [_btnOne setTintColor:[UIColor blackColor]];
    [_btnTwo setTintColor:[UIColor blackColor]];
    [_btnThree setTintColor:[UIColor blackColor]];
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 1000) {
        [_btnOne setImage:[UIImage imageNamed:@"shang"] forState:UIControlStateNormal];
        [_btnOne setTintColor:[UIColor redColor]];

    }else if (btn.tag == 1001) {
        [_btnTwo setImage:[UIImage imageNamed:@"shang"] forState:UIControlStateNormal];
        [_btnTwo setTintColor:[UIColor redColor]];
    }else if (btn.tag == 1002) {
        [_btnThree setImage:[UIImage imageNamed:@"shang"] forState:UIControlStateNormal];
        [_btnThree setTintColor:[UIColor redColor]];
    }

    if (_delegate && [_delegate respondsToSelector:@selector(clickWithFlag:)])
    {
        [_delegate clickWithFlag:((UIButton *)sender).tag];
    }
}

@end
