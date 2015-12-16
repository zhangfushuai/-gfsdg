//
//  SettingLoginTableViewCell.h
//  几何社区
//
//  Created by KMING on 15/9/7.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySettingTableViewController.h"
@interface SettingLoginTableViewCell : UITableViewCell
@property (nonatomic,weak)MySettingTableViewController *delegate;//反向调用
@end
