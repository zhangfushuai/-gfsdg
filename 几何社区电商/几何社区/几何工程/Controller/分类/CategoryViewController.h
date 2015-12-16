//
//  CategoryViewController.h
//  几何社区
//
//  Created by KMING on 15/8/20.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBasicViewController.h"
@interface CategoryViewController : JHBasicViewController

@property (nonatomic , strong) UITableView *tbCategary;
@property (nonatomic , strong) UICollectionView *collectionView;
@property (nonatomic , strong) NSArray *datasourse;      //商品数据源


@end
