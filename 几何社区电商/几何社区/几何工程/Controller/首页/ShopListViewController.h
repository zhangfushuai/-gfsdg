//
//  ShopListViewController.h
//  几何社区
//
//  Created by KMING on 15/10/6.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopModel.h"
@interface ShopListViewController : JHBasicViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,copy)NSString *titleText;
@property (nonatomic,strong)NSMutableArray *shopARR;
@property (nonatomic,copy)NSString *classify;
@property (nonatomic)int page;
@property (nonatomic,strong)MJRefreshHeaderView *header;
@property (nonatomic,strong)MJRefreshFooterView *footer;

@property (nonatomic,strong)NSArray *arr;
@end
