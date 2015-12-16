//
//  HomeViewController.h
//  几何社区
//
//  Created by KMING on 15/9/9.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "HWTitleButton.h"
#import <AMapSearchKit/AMapSearchKit.h>
#import "SDCycleScrollView.h"
@interface HomeViewController : JHBasicViewController<MKMapViewDelegate,AMapSearchDelegate,UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,UIAlertViewDelegate,SDCycleScrollViewDelegate,MJRefreshBaseViewDelegate>
@property (nonatomic,copy)NSString *locatecity;//传给下一页的位置


@end
