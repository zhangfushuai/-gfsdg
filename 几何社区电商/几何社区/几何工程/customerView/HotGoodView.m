//
//  HotGoodView.m
//  几何社区
//
//  Created by 颜 on 15/9/6.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "HotGoodView.h"

@implementation HotGoodView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (id)init
{
        if (self = [super init]){
    }
    return self;
}
- (void)addButtons:(NSArray *)array
{

    UILabel *lebal = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, SCREEN_WIDTH, 40)];
    lebal.text = @"热门搜索";
    lebal.font = [UIFont systemFontOfSize:15];
    [self addSubview:lebal];
    float spaceX = 14;
    float spaceY = 10;


    CGFloat btnWidth = (SCREEN_WIDTH - 5*spaceX)/4;
    CGFloat btnHeight =  30;
    CGFloat startY = 30;
    CGFloat height;
    if (array.count % 4 >0) {
       height = (array.count/4 +1) *btnHeight +startY +(array.count/4 + 2) * spaceY;
    }else{
        height = (array.count/4) *btnHeight +startY +(array.count/4 + 1) * spaceY;
    }
    self.frame = CGRectMake(0, 64+10, SCREEN_WIDTH, height);
    
    UIView *upLine =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    upLine.backgroundColor = SEPARATELINE_COLOR;
    [self addSubview:upLine];
    UIView *downLine =[[UIView alloc] initWithFrame:CGRectMake(0, height-1, SCREEN_WIDTH, 0.5)];
    downLine.backgroundColor = SEPARATELINE_COLOR;
    [self addSubview:downLine];

    
    for (int i = 0 ; i < array.count; i++) {
        int remaid = i % 4;         //第几列
        int interger =(int) i / 4;  //第几行
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(remaid *btnWidth + (remaid +1)*spaceX, startY +interger*btnHeight + spaceY * (interger+1), btnWidth, btnHeight)];
        btn.titleLabel.font =[UIFont systemFontOfSize:25];
        btn.tag = i + 100;
        [btn addTarget:self action:@selector(clickOnButton:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 15.0f;
        btn.layer.borderWidth = 1.f;
        btn.layer.borderColor = NAVIGATIONBAR_COLOR.CGColor;
        [btn setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:NAVIGATIONBAR_COLOR forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:btn];
    }
    self.backgroundColor = [UIColor whiteColor];

}
- (void)clickOnButton:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(didSellectGood:)]) {
        [_delegate didSellectGood:(long)((UIButton *)sender).tag];
    }
    NSLog(@"%ld",(long)((UIButton *)sender).tag);
}
@end
