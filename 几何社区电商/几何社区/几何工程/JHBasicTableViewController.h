//
//  JHBasicTableViewController.h
//  几何社区
//
//  Created by KMING on 15/9/6.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHBasicTableViewController : UITableViewController
{
    JHDataManager *_manager;  //网络数据请求
}

- (void)setLeftNavButtonWithType:(NAV_BUTTON_TYPE)type;
- (void)setRightNavButtonWithType:(NAV_BUTTON_TYPE)type;

-(void)setNavColor:(UIColor *)color;
-(void)setNavTitleColor:(UIColor*)color;
-(void)leftButtonOnClick:(id) sender;
-(void)rightButtonOnClick:(id)sender;

@end
