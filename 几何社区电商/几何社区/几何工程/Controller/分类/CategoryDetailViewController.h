//
//  CategoryDetailViewController.h
//  几何社区
//
//  Created by KMING on 15/8/25.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryDetailViewController : JHBasicViewController
@property (nonatomic)long buycount;//购物车购买的数量
@property (nonatomic,strong)UILabel *buycountLabel;//购买了多少，在右上角购物车上的label

@property (nonatomic ,strong)NSMutableArray *datasourse; //数据源


@property (nonatomic ,strong)NSString *classifyId;

@end
