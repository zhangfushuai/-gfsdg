//
//  ChooseAddressTableViewController.h
//  几何社区
//
//  Created by KMING on 15/8/29.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseAddressTableViewController : JHBasicTableViewController
@property (nonatomic)int page;
@property (nonatomic,strong)MJRefreshHeaderView *header;
@property (nonatomic,strong)MJRefreshFooterView *footer;
@property (nonatomic,strong)NSMutableArray *addressArr;//数据源，可以反归档得到
@end
