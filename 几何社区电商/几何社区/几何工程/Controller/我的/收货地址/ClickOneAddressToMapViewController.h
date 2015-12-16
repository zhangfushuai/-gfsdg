//
//  ClickOneAddressToMapViewController.h
//  几何社区
//
//  Created by KMING on 15/9/1.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
@interface ClickOneAddressToMapViewController : JHBasicViewController<MKMapViewDelegate,AMapSearchDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *myMapView;
@property (nonatomic)CGFloat latitude;
@property (nonatomic)CGFloat longitude;
@end
