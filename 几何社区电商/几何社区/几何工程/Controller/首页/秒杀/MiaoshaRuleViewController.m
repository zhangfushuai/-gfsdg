//
//  MiaoshaRuleViewController.m
//  几何社区
//
//  Created by KMING on 15/10/13.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "MiaoshaRuleViewController.h"

@interface MiaoshaRuleViewController ()

@end

@implementation MiaoshaRuleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    UIView *centerLine = [[UIView alloc]initWithFrame:CGRectMake(14, 48, SCREEN_WIDTH-24, 0.5)];
//    centerLine.backgroundColor = SEPARATELINE_COLOR;
//    [self.backV addSubview:centerLine];
//    for (UILabel *lb in self.labls) {
//        lb.textColor = Color242424;
//    }
    
    UIScrollView *myscroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    myscroll.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH*2078/640);
    UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*2078/640)];
    imgV.image = [UIImage imageNamed:@"秒杀规则"];
    [myscroll addSubview:imgV];
    [self.view addSubview:myscroll];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setLeftNavButtonWithType:BACK];
    [self setNavTitleColor:[UIColor blackColor]];
    self.title = @"活动规则";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
