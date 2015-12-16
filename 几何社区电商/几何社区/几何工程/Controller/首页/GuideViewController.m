//
//  GuideViewController.m
//  几何社区
//
//  Created by KMING on 15/9/28.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "GuideViewController.h"
#import "LmhTabBarController.h"
@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.myScroll.contentSize = CGSizeMake(SCREEN_WIDTH*4, SCREEN_HEIGHT);
    
    for (int i=0; i<4; i++) {
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        iv.image = [UIImage imageNamed:[NSString stringWithFormat:@"引导页%d.jpg",i+1]];
        [self.myScroll addSubview:iv];
        
    }
    UIButton *goInBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 150, 70)];
    
    [goInBtn addTarget:self action:@selector(goTOHome) forControlEvents:UIControlEventTouchUpInside];
    goInBtn.center = CGPointMake(SCREEN_WIDTH*3+SCREEN_WIDTH/2, SCREEN_HEIGHT-SCREEN_HEIGHT/12);
    
    [self.myScroll addSubview:goInBtn];
}
//去首页
-(void)goTOHome{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [ud setBool:YES forKey:@"isRun"];
    [ud synchronize];
    
    JHGlobalApp.tabBarControllder = [[LmhTabBarController alloc]init];
    [self presentViewController:JHGlobalApp.tabBarControllder animated:YES completion:nil];
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
