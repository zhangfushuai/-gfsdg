//
//  BestSellerView.h
//  几何社区
//
//  Created by KMING on 15/9/10.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeActivityModel.h"
@interface BestSellerView : UIView
@property (nonatomic,strong)HomeActivityModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (strong, nonatomic)UILabel *nameLbl;
@property (strong, nonatomic)UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *buyCountLbl;
@property (weak, nonatomic) IBOutlet UIButton *clearbtn;
@property (weak, nonatomic) IBOutlet UIView *downV;
@property (nonatomic,strong)UIView *line;
@end
