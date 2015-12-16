//
//  ProductListTableViewCell.h
//  几何社区
//
//  Created by KMING on 15/8/24.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryDetailViewController.h"
@interface ProductListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgVproduct;
@property (weak, nonatomic) IBOutlet UILabel *lblProductName;
@property (weak, nonatomic) IBOutlet UILabel *lblprice;

//@property (weak, nonatomic) IBOutlet UILabel *lblProductCount;
//@property (weak, nonatomic) IBOutlet UIButton *btnReduce;
//@property (weak, nonatomic) IBOutlet UIButton *btnAdd;
//- (void)startAnimation;

@end
