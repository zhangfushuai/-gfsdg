//
//  LmhTabBarController.m
//  几何社区
//
//  Created by KMING on 15/8/20.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "LmhTabBarController.h"
//#import "HomeTableViewController.h"
#import "HomeViewController.h"
#import "CategoryViewController.h"
#import "MySettingTableViewController.h"
@interface LmhTabBarController ()
@end

@implementation LmhTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBar.barTintColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    // 1.初始化子控制器
    HomeViewController *home = [[HomeViewController alloc] init];
    [self addChildVc:home title:@"首页" image:@"home_d" selectedImage:@"home_p"];
    
    CategoryViewController *category = [[CategoryViewController alloc] init];
    [self addChildVc:category title:@"分类" image:@"class_d" selectedImage:@"class_p"];
    
    self.shopcar = [[ShopCarViewController alloc] init];
    _shopcar.fromFlag = 1000; //首页进去
    [self addChildVc:self.shopcar title:@"购物车" image:@"cart_d" selectedImage:@"cart_p"];
    
    MySettingTableViewController *myset = [[MySettingTableViewController alloc]init];
    [self addChildVc:myset title:@"我的" image:@"my_d" selectedImage:@"my_p"];
}
/**
 *  添加一个子控制器
 *
 *  @param childVc       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [[UIImage imageNamed:image]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor colorWithWhite:0.443 alpha:1.000];
    textAttrs[NSFontAttributeName]= [UIFont systemFontOfSize:13];
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.937 green:0.000 blue:0.000 alpha:1.000];
    selectTextAttrs[NSFontAttributeName]= [UIFont systemFontOfSize:13];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    //[UITabBarItem appearance]
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
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
