//
//  NoOrderView.h
//  几何社区
//
//  Created by KMING on 15/9/22.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderViewController.h"
@interface NoOrderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *goHomeBtn;
@property (nonatomic,weak)MyOrderViewController *delegate;
@end
