
//
//  ShopCarViewController.h
//  几何社区
//
//  Created by 颜 on 15/9/14.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarGoodBase.h"

@interface ShopCarViewController : JHBasicViewController
@property (nonatomic ,assign)NSInteger fromFlag;   //1000 购物车主页入口  1001 商品详情点击购物车
@property (nonatomic , strong)CarGoodBase *carGoodBase;
@property (weak, nonatomic) IBOutlet UILabel *totalMoney;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewButtomSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnButtomSpace;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;

@property (weak, nonatomic) IBOutlet UIView *confirmFooterView;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirm;


@end
