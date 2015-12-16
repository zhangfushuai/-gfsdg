//
//  OrderDetailDownSectionSingleTableViewCell.h
//  几何社区
//
//  Created by KMING on 15/8/28.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailDownSectionSingleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;

@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *content;
@end
