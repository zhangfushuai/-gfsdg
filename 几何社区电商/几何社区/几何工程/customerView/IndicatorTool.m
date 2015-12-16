//
//  IndicatorTool.m
//  Maizuo3.0
//
//  Created by Steven on 4/15/14.
//  Copyright (c) 2014 Tracy_deng. All rights reserved.
//

#import "IndicatorTool.h"
#import "JHDataManager.h"


@implementation IndicatorTool
@synthesize hud = _hud;
static IndicatorTool *instance = nil;
-(id)init
{
	self = [super init];
	if (self) {
		_hud =[[MBProgressHUD alloc] init];
//		_hud.dimBackground = YES;//使背景成黑灰色，让MBProgressHUD成高亮显示
		_hud.labelText = @"加载中...";
		_hud.labelFont = [UIFont systemFontOfSize:13.f];
		_hud.mode = MBProgressHUDModeIndeterminate;
		_hud.removeFromSuperViewOnHide = YES;
		_hud.delegate = self;
	}
	return self;
}

- (void)cancelRequest
{
	[[JHDataManager getInstance] cancel];
    if (self.delegate) {
        [self.delegate CancelIndicatorTool:self];
    }
}

+ (IndicatorTool *)getInstance
{
	@synchronized(self) {
		if (instance == nil) {
			instance = [[IndicatorTool alloc] init];
		}
	}
	return instance;
}

-(void)setMode:(MBProgressHUDMode)mode
{
	_hud.mode = mode;
}

-(void) hidden
{
	[_hud hide:YES];
}


-(void)showHUDWithSeconds:(NSInteger)second text:(NSString *)text andView:(UIView *)view mode:(MBProgressHUDMode)mode
{
	[view addSubview:_hud];
	_hud.labelText = text;
	_hud.mode = mode;
	[_hud showAnimated:YES whileExecutingBlock:^{
        sleep((unsigned int)second);
    } completionBlock:^{
        [_hud removeFromSuperview];
    }];
}

-(void)showHUD:(NSString *)text andView:(UIView *)view mode:(MBProgressHUDMode)mode
{
	_hud.labelText = text;
	_hud.mode = mode;
	[view addSubview:_hud];
    [_hud show:YES];
}

-(void)showHUDInView:(UIView *)view
{
	[view addSubview:_hud];
    [_hud show:YES];
}

-(void)customView:(UIView *)custom
{
    _hud.customView = custom;
}

@end
