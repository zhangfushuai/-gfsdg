//
//  GoodCategaryCell.h
//  几何社区
//
//  Created by 颜 on 15/9/2.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodCategaryCell : UITableViewCell /*商品分类左侧cell*/

@property (weak, nonatomic) IBOutlet UIView *downLine;

@property (weak, nonatomic) IBOutlet UIView *rightLine;
@property (weak , nonatomic) IBOutlet UIView *redLine;
@property (weak, nonatomic) IBOutlet UILabel *lblText;

@end
