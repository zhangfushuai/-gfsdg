//
//  HomeNewHotSellView.h
//  几何社区
//
//  Created by KMING on 15/10/8.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HotSellModel.h"

@interface HomeNewHotSellView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;

@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (nonatomic,strong)HotSellModel *model;
@end
