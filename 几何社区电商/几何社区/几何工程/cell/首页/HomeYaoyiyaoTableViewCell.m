//
//  HomeYaoyiyaoTableViewCell.m
//  几何社区
//
//  Created by KMING on 15/8/23.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "HomeYaoyiyaoTableViewCell.h"
#import "Define.h"
@implementation HomeYaoyiyaoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 160);
//    UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
//    topline.backgroundColor = SEPARATELINE_COLOR;
//    [self addSubview:topline];
    
    
    
//    
//    self.yaoyiyao.center =CGPointMake(SCREEN_WIDTH/4/2, self.yaoyiyao.center.y);
//    self.yaoYiYaoLabel.center = CGPointMake(SCREEN_WIDTH/4/2, self.yaoYiYaoLabel.center.y);
//    self.youhuiquan.center = CGPointMake(SCREEN_WIDTH/4+SCREEN_WIDTH/4/2, self.youhuiquan.center.y);
//    self.youHuiQuanLabel.center = CGPointMake(SCREEN_WIDTH/4+SCREEN_WIDTH/4/2, self.youHuiQuanLabel.center.y);
//    self.songyou.center = CGPointMake(SCREEN_WIDTH/2+SCREEN_WIDTH/4/2, self.songyou.center.y);
//    self.songYouLabel.center = CGPointMake(SCREEN_WIDTH/2+SCREEN_WIDTH/4/2, self.songYouLabel.center.y);;
//    self.choujiang.center = CGPointMake(SCREEN_WIDTH/2+SCREEN_WIDTH/4+SCREEN_WIDTH/4/2, self.choujiang.center.y);
//    self.chouJiangLabel.center = CGPointMake(SCREEN_WIDTH/2+SCREEN_WIDTH/4+SCREEN_WIDTH/4/2, self.chouJiangLabel.center.y);
//    
//    UIView *downline = [[UIView alloc]initWithFrame:CGRectMake(0, 159.5, SCREEN_WIDTH, 0.5)];
//    downline.backgroundColor = SEPARATELINE_COLOR;
//    [self addSubview:downline];
    
    NSArray *names = @[@"美美喝",@"生鲜代购",@"粮油",@"日化",@"餐饮料理",@"水果",@"下午茶",@"休闲零食"];
    NSArray *imgNames = @[@"jiushui",@"sx",@"ly",@"rh",@"cy",@"sg",@"xwc",@"xxls"];
    for (int i=0; i<8; i++) {
        UILabel *nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(i%4*SCREEN_WIDTH/4, i/4*(self.frame.size.height/2-5)+55, SCREEN_WIDTH/4, 20)];
        nameLbl.textAlignment = NSTextAlignmentCenter;
        nameLbl.textColor = Color242424;
        nameLbl.font = [UIFont systemFontOfSize:12];
        nameLbl.text = names[i];
        [self addSubview:nameLbl];
        
        UIButton *imgBtn = [[UIButton alloc]initWithFrame:CGRectMake(i%4*SCREEN_WIDTH/4, i/4*(self.frame.size.height/2-5)+8, SCREEN_WIDTH/4, 55)];
        [imgBtn setImage:[UIImage imageNamed:imgNames[i]] forState:UIControlStateNormal];
        imgBtn.tag = i;
        [imgBtn addTarget:self action:@selector(homeYaoyiyaoClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:imgBtn];
    }
    UIView *seperateV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    seperateV.backgroundColor = HEADERVIEW_COLOR;
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    topLine.backgroundColor = SEPARATELINE_COLOR;
    [seperateV addSubview:topLine];
    UIView *downLine = [[UIView alloc]initWithFrame:CGRectMake(0, 7.5, SCREEN_WIDTH, 0.5)];
    downLine.backgroundColor = SEPARATELINE_COLOR;
    [seperateV addSubview:downLine];
    [self.contentView addSubview:seperateV];
    
}
-(void)homeYaoyiyaoClicked:(UIButton*)btn{
    NSString *tag = [NSString stringWithFormat:@"%ld",btn.tag];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"homeYaoyiyaoClicked" object:@{@"tag":tag}];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
