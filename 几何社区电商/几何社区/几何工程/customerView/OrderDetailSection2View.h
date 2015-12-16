//
//  OrderDetailSection2View.h
//  几何社区
//
//  Created by KMING on 15/8/28.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailSection2View : UIView
@property (nonatomic,strong)UIButton *imgbtn;
@property (nonatomic,copy)NSString* imgurl;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,strong)UILabel *productnumLabel;//产品数量

@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *quantity;


@end
