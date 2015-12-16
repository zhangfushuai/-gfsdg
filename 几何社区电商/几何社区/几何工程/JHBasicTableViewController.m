//
//  JHBasicTableViewController.m
//  几何社区
//
//  Created by KMING on 15/9/6.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "JHBasicTableViewController.h"
#import "AddAddressViewController.h"
@interface JHBasicTableViewController ()
@property (nonatomic , strong)UIButton *leftButton;
@property (nonatomic , strong)UIButton *rightButton;
@end

@implementation JHBasicTableViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    if ([self.navigationController.navigationBar.barTintColor isEqual:NAVIGATIONBAR_COLOR]) {
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    }else{
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    }
    if(self.navigationController.viewControllers.count > 1){
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        JHGlobalApp.tabBarControllder.tabBar.hidden = YES;
    }else{
        self.navigationController.navigationBar.barTintColor = NAVIGATIONBAR_COLOR;
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        JHGlobalApp.tabBarControllder.tabBar.hidden = NO;
    }

}

//-(UIStatusBarStyle)preferredStatusBarStyle
//{
//    
//    return UIStatusBarStyleLightContent;
//    
////    if ([self.navigationController.navigationBar.barTintColor isEqual:NAVIGATIONBAR_COLOR]) {
////        return UIStatusBarStyleLightContent;
////        
////    }else{
////        return UIStatusBarStyleDefault;
////        
////    }
//    
//    
//    
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = NAVIGATIONBAR_COLOR;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    
    
    _leftButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [_leftButton addTarget:self action:@selector(leftButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [_rightButton addTarget:self action:@selector(rightButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}
- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)setLeftNavButtonWithType:(NAV_BUTTON_TYPE)type
{
    self.leftButton.tag  = type;
    UIImage *leftImage = nil;
    switch (type) {
        case BACK:
        {
            leftImage = [UIImage imageNamed:@"shape-1"];
        }
            break;
            
        case SEARCH:
        {
            leftImage = [UIImage imageNamed:@""];
        }
            break;
        default:
            break;
    }
    [_leftButton setImage:leftImage forState:UIControlStateNormal];
    [_leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_leftButton];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)setRightNavButtonWithType:(NAV_BUTTON_TYPE)type
{
    self.rightButton.tag  = type;
    UIImage *rightImage = nil;
    switch (type) {
        case BACK:
        {
            rightImage = [UIImage imageNamed:@""];
        }
            break;
            
        case SEARCH:
        {
            rightImage = [UIImage imageNamed:@"seach"];
        }
            break;
        case ADD:
        {
            rightImage = [UIImage imageNamed:@"new"];
        }
            break;
            
        default:
            break;
    }
    [_rightButton setImage:rightImage forState:UIControlStateNormal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem = item;
    
}
-(void)setNavColor:(UIColor *)color
{
    self.navigationController.navigationBar.barTintColor = color;
    
}
-(void)setNavTitleColor:(UIColor*)color{
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: color,
                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
}
-(void)leftButtonOnClick:(UIButton*)btn
{
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightButtonOnClick:(UIButton*)btn
{
    
    switch (btn.tag) {
        case ADD:
        {
            AddAddressViewController *vc = [[AddAddressViewController alloc]initWithNibName:@"AddAddressViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
