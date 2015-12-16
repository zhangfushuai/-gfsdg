//
//  NoOrderView.m
//  几何社区
//
//  Created by KMING on 15/9/22.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "NoOrderView.h"

@implementation NoOrderView
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.goHomeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    self.backgroundColor = HEADERVIEW_COLOR;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)goToHome:(id)sender {
    if (self.delegate.navigationController.viewControllers.count>1) {
        [self.delegate.navigationController popToRootViewControllerAnimated:NO];
    }
    
    JHGlobalApp.tabBarControllder.selectedIndex = 0;
}

@end
