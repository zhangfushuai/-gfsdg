
//
//  ProductDetailViewController.h
//  几何社区
//
//  Created by 颜 on 15/9/8.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodDetailBase.h"


@interface ProductDetailViewController : JHBasicViewController
@property (nonatomic, strong) GoodDetailBase *goodDetail;
@property (nonatomic , assign)NSInteger fromFlag;   // 1000购买书籍

@property (weak, nonatomic) IBOutlet UILabel *lblTotalMoney;
@property (weak, nonatomic) IBOutlet UILabel *lblGoodCount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblMoneyWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblCountWidth;
@property (weak, nonatomic) IBOutlet UIButton *btnBuyNow;  //立即购买书籍
@property (weak, nonatomic) IBOutlet UIView *btnBuyNormal;  //普通商品购买
@property (weak, nonatomic) IBOutlet UIButton *btnBuy;

@end
