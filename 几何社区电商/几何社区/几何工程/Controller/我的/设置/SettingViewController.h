//
//  SettingViewController.h
//  几何社区
//
//  Created by KMING on 15/9/14.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : JHBasicViewController
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *cellVs;

@property (weak, nonatomic) IBOutlet UIView *logoutV;
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end
