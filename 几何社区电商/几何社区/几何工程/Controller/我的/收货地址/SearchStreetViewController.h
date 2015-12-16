//
//  SearchStreetViewController.h
//  几何社区
//
//  Created by KMING on 15/8/29.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
@interface SearchStreetViewController : JHBasicViewController
@property (nonatomic,copy)NSString *searchCity;//上个页面选择的城市，传值过来
@property (nonatomic,copy)NSString *isHomePush;//判断是否是从首页地图推送过来的
@end
