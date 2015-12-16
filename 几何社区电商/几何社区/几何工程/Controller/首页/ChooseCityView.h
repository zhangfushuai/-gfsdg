//
//  ChooseCityView.h
//  几何社区
//
//  Created by KMING on 15/8/19.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseProvinceView.h"
@interface ChooseCityView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong)NSArray *citys;
@property (nonatomic,strong)NSMutableArray *arrs;//用来放对号的图片
@property (nonatomic,copy)NSString *province;//用来接受上个页面的省名字
@property (nonatomic,copy)NSString *cit;//self.cit,记录点击的城市名字，用来判断所有的cell哪个是点击的那个，防止tableview重用机制重复显示，也用来传递到mapview切换地图
@property (nonatomic,weak)ChooseProvinceView *delegate;
@end
