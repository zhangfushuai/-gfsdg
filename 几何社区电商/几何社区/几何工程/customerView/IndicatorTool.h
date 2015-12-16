//
//  IndicatorTool.h
//  Maizuo3.0
//
//  Created by Steven on 4/15/14.
//  Copyright (c) 2014 Tracy_deng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@class IndicatorTool;

@protocol IndicatorToolDelegate <NSObject>

-(void)CancelIndicatorTool:(IndicatorTool *)indicatorTool;

@end

@interface IndicatorTool : NSObject<MBProgressHUDDelegate>
{
	MBProgressHUD *_hud;
}

@property (nonatomic, retain) MBProgressHUD *hud;
@property (nonatomic, assign) id<IndicatorToolDelegate>delegate;
+ (IndicatorTool *)getInstance;

-(void)setMode:(MBProgressHUDMode)mode;

-(void) hidden;

-(void)showHUDWithSeconds:(NSInteger)second text:(NSString *)text andView:(UIView *)view mode:(MBProgressHUDMode)mode;

-(void)showHUD:(NSString *)text andView:(UIView *)view mode:(MBProgressHUDMode)mode;

-(void)showHUDInView:(UIView *)view;

-(void)customView:(UIView *)custom;

@end
