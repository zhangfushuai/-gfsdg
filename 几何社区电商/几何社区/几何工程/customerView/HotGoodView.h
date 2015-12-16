//
//  HotGoodView.h
//  几何社区
//
//  Created by 颜 on 15/9/6.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotGoodDelegate <NSObject>

- (void)didSellectGood:(NSInteger)tag;

@end
//热门商品推荐
@interface HotGoodView : UIView
@property (nonatomic, assign)id <HotGoodDelegate> delegate;
- (void)addButtons:(NSArray *)array;
@end
