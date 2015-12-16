//
//  ProductSortControl.h
//  几何社区
//
//  Created by 颜 on 15/9/9.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductSortControlDelegate <NSObject>
@optional
- (void)sortUpToDown:(BOOL)sort;
- (void)removeControl;

@end
@interface ProductSortControl : UIControl <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSArray *datasourse;
@property (nonatomic ,assign)id <ProductSortControlDelegate>delegate;
- (void)reloadtableViewWithFlag:(NSInteger)flag;
- (void)originView;
@end
