//
//  JHBasicViewController.h
//  几何社区
//
//  Created by 颜 on 15/9/6.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHDataManager.h"
#import "Toast+UIView.h"
typedef enum
{
    BACK        = 1001,
    SEARCH      = 1002,
    ADD         = 1003,
    SHARE       = 1004,
    DELETE_W    = 1005,
    DELETE_R    = 1006,
    NONE        = 1007,
}NAV_BUTTON_TYPE;

typedef enum {

    NOFOUND      = 100,
}NON_VIEW_TYPE;
@interface JHBasicViewController : UIViewController <JHDataMagerDelegate>
{
    JHDataManager *_manager;  //网络数据请求
}
@property (nonatomic , assign)BOOL nothingViewHidden;  //默认为hidden  无数据显示

- (void)setNothingviewWithType:(NON_VIEW_TYPE)type;

- (void)setLeftNavButtonWithType:(NAV_BUTTON_TYPE)type;
- (void)setRightNavButtonWithType:(NAV_BUTTON_TYPE)type;

//-(void)setNavColor:(UIColor *)color;
-(void)setNavTitleColor:(UIColor*)color;
-(void)leftButtonOnClick:(id) sender;
-(void)rightButtonOnClick:(id)sender;

-(void)setNavColor:(UIColor *)color;
@end
