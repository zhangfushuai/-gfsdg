//
//  MiaoshaTableViewCell.h
//  几何社区
//
//  Created by KMING on 15/10/12.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiaoshaModel.h"
@interface MiaoshaTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *downImg;
@property (weak, nonatomic) IBOutlet UIImageView *topImg;
@property (nonatomic,strong)MiaoshaModel *model;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *yuanjia;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UIButton *qiangBtn;
@property (nonatomic,copy)NSString *flag;
@end
