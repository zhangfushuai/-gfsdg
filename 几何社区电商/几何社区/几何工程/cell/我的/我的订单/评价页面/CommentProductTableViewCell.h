//
//  CommentProductTableViewCell.h
//  几何社区
//
//  Created by KMING on 15/10/20.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyorderProductModel.h"
@interface CommentProductTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *starBtns;
@property (weak, nonatomic) IBOutlet UIView *downV;
@property (weak, nonatomic) IBOutlet UIButton *tijiaoBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (nonatomic,strong)MyorderProductModel *model;

@property (nonatomic,copy)NSString *index;
@property (nonatomic,strong)UIButton *commnetBtn;

@property (nonatomic,copy)NSString *btnSelected;
@end
