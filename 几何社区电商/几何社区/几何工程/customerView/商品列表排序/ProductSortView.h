//
//  ProductSortView.h
//  几何社区
//
//  Created by 颜 on 15/9/9.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWTitleButton.h"

@protocol ProductSortViewDelegate <NSObject>

- (void)clickWithFlag:(NSInteger)flag;

@end

@interface ProductSortView : UIView

@property (weak, nonatomic) IBOutlet HWTitleButton *btnOne;

@property (weak, nonatomic) IBOutlet HWTitleButton *btnTwo;

@property (weak, nonatomic) IBOutlet HWTitleButton *btnThree;

@property (assign ,nonatomic)id <ProductSortViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttomLine;

- (void)originView;

@end
