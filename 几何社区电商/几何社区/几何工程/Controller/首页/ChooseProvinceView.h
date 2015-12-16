//
//  ChooseProvinceView.h
//  几何社区
//
//  Created by KMING on 15/8/18.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapViewController.h"
@interface ChooseProvinceView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSArray *provinces;
@property (nonatomic,strong)NSMutableArray *arrs;//用来放对号的图片
@property (nonatomic,weak)MapViewController *delegate;//反向调用，点击取消时，调用
@property (nonatomic,copy)NSString *provi;//self.provi,记录点击的省份名字，用来判断所有的cell哪个是点击的那个，防止tableview重用机制重复显示
@end
