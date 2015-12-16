//
//  MapViewController.h
//  几何社区
//
//  Created by KMING on 15/8/17.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "HWTitleButton.h"
#import <AMapSearchKit/AMapSearchKit.h>
@interface MapViewController : JHBasicViewController<MKMapViewDelegate,AMapSearchDelegate,UITableViewDelegate,UITableViewDataSource,JHDataMagerDelegate>
@property (nonatomic,strong)MKMapView *myMapView;
@property (nonatomic,copy)NSString *locatecity;
@property (nonatomic,strong)HWTitleButton *rightBtn;
@property (nonatomic ,strong) CLGeocoder *geocoder;
@property (nonatomic,strong)UIView *backAlphaView;//点击选择城市时 背景半透明的
@property (nonatomic,copy)NSString *cityName;//用来接受选择城市的城市名字
@property (nonatomic,strong)MKUserLocation *userLocation;//上一页传来的位置
@property (nonatomic,strong)MKUserLocation *locateLocation;//定位哦的位置，用来按定位按钮回到定位位置
@end
