//
//  WaitToPayOrderView.h
//  几何社区
//
//  Created by KMING on 15/8/27.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOrderViewController.h"
@interface WaitToPayOrderView : UIView<UITableViewDataSource,UITableViewDelegate,JHDataMagerDelegate,UIActionSheetDelegate,MJRefreshBaseViewDelegate,MainDelegate,UIAlertViewDelegate>
{
    JHDataManager *_manager;  //网络数据请求
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,weak)MyOrderViewController *delegate;//反向调用
@property (nonatomic,strong)NSMutableArray *allOrderArr;
@property (nonatomic,strong)UIView *backV;//取消定订单后面的灰色背景
@property (nonatomic,copy)NSString *iid;//取消订单时用到的订单id

@property (nonatomic,assign)NSInteger payWayFlag;

@property (nonatomic)int page;
@property (nonatomic,strong)MJRefreshHeaderView *header;
@property (nonatomic,strong)MJRefreshFooterView *footer;
@end
