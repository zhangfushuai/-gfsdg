//
//  MyAddressTableVIewCell.h
//  几何社区
//
//  Created by KMING on 15/9/5.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "SWTableViewCell.h"

@interface MyAddressTableVIewCell : SWTableViewCell
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *addressLabel;

@property (nonatomic,strong) UIImageView *iconimg;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end
