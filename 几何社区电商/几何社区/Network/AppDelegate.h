//
//  AppDelegate.h
//  几何社区
//
//  Created by KMING on 15/8/14.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import "LmhTabBarController.h"


@protocol MainDelegate <NSObject>
@optional
- (void)WXPay:(BaseResp*)resp;
@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (assign, nonatomic)id <MainDelegate>mainDelegate;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSMutableArray *globalCarList;
@property (strong, nonatomic) LmhTabBarController *tabBarControllder;

+(AppDelegate*)shareAppDelegate;
@end

