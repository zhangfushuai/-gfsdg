//
//  JHBasicViewController.m
//  几何社区
//
//  Created by 颜 on 15/9/6.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "JHBasicViewController.h"
#import "AddAddressViewController.h"
@interface JHBasicViewController ()
@property (nonatomic , strong)UIButton  *leftButton;
@property (nonatomic , strong)UIButton  *rightButton;
@property (nonatomic , strong)UIView    *basicView;
//@property (nonatomic , strong)UIImage   *basicImg;
//@property (nonatomic , strong)NSString  *basicStr;

@end

@implementation JHBasicViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(self.navigationController.viewControllers.count > 1){
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor],
                                                                        NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        JHGlobalApp.tabBarControllder.tabBar.hidden = YES;
    }else{
        self.navigationController.navigationBar.barTintColor = NAVIGATIONBAR_COLOR;
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                        NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        JHGlobalApp.tabBarControllder.tabBar.hidden = NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = NAVIGATIONBAR_COLOR;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
    
    _leftButton =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [_leftButton addTarget:self action:@selector(leftButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [_rightButton addTarget:self action:@selector(rightButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self createBasicView];
}
- (void)createBasicView
{
    _basicView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
//    _basicView.backgroundColor = [UIColor redColor];
    _basicView.hidden = YES;
    [self.view addSubview:_basicView];
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
- (void)setNothingViewHidden:(BOOL)nothingViewHidden
{
    
    if (nothingViewHidden) {
        _basicView.hidden = YES;
    }else{
        _basicView.hidden = NO;
        [self.view bringSubviewToFront:_basicView];
    }
}
- (void)setNothingviewWithType:(NON_VIEW_TYPE)type
{
    if (_basicView.subviews.count>0) {
        [_basicView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(_basicView.frame.size.width/2-32, (_basicView.frame.size.height-32)/2-32, 64, 64)];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, (_basicView.frame.size.height-32)/2+58, SCREEN_WIDTH, 30)];
    lblTitle.textAlignment = NSTextAlignmentCenter;
    lblTitle.textColor= RGBCOLOR(0, 0, 0, 0.26);
    [_basicView addSubview:imgV];
    [_basicView addSubview:lblTitle];
    switch (type) {
        case NOFOUND:
        {
            imgV.image = [UIImage imageNamed:@"seach_big"];
            lblTitle.text = @"没有搜索到结果，请更换关键词";
        }
            break;
            
        default:
            break;
    }
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
            leftImage = [UIImage imageNamed:@"search"];
        }
            break;
        default:
            break;
    }
    [_leftButton setImage:leftImage forState:UIControlStateNormal];
    [_leftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];//向左偏移5
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:_leftButton];
    self.navigationItem.leftBarButtonItem = item;
}

- (void)setRightNavButtonWithType:(NAV_BUTTON_TYPE)type
{
    _rightButton.hidden = NO;
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
            rightImage = [UIImage imageNamed:@"search"];
        }
            break;
        case ADD:
        {
            rightImage = [UIImage imageNamed:@"new"];
        }
            break;
        case SHARE:
        {
            rightImage = [UIImage imageNamed:@"Share"];
        }
            break;
        case DELETE_W:
        {
            [_rightButton setTitle:@"删除" forState:UIControlStateNormal];
            [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
            break;
        case DELETE_R:
        {
            [_rightButton setTitle:@"删除" forState:UIControlStateNormal];
            [_rightButton setTitleColor:NAVIGATIONBAR_COLOR forState:UIControlStateNormal];
        }
            break;
        case NONE:
        {
            _rightButton.hidden = YES;
        }
            break;
        default:
            break;
    }
    [_rightButton setImage:rightImage forState:UIControlStateNormal];
    [_rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
    [_rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
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

- (void)requestFailure:(id)failReson withRequestType:(RequestType)requestType
{
    if ([failReson isKindOfClass:[NSDictionary class]]) {
        [self.view makeToast:[failReson objectForKey:@"msg"]];
    }else if([failReson isKindOfClass:[NSString class]]){
        [self.view makeToast:failReson];
    }
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
