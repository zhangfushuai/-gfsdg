//
//  AboutUsViewController.m
//  几何社区
//
//  Created by KMING on 15/9/14.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController
-(void)viewWillAppear:(BOOL)animated{
//    [self setNavColor:[UIColor whiteColor]];
    [super viewWillAppear:animated];
    [self setLeftNavButtonWithType:BACK];
    self.title = @"关于我们";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.lbl1.textColor = Color757575;
    self.lbl2.textColor = Color757575;
    self.lbl3.textColor = Color757575;
    
    self.view.backgroundColor = HEADERVIEW_COLOR;
    CGFloat width = SCREEN_WIDTH/3.5;
    UIImageView *jeheV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, width)];
    jeheV.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-50);
    jeheV.image = [UIImage imageNamed:@"120-120"];
    [self.view addSubview:jeheV];
    
    UILabel *jiheLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 20)];
    jiheLbl.textAlignment = NSTextAlignmentCenter;
    jiheLbl.textColor = [UIColor blackColor];
    jiheLbl.font = [UIFont systemFontOfSize:15];
    jiheLbl.center = CGPointMake(jeheV.center.x, jeheV.center.y+width/2+30);
    jiheLbl.text =@"几何社区";
    [self.view addSubview:jiheLbl];
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
