//
//  GoodDetailCell.h
//  几何社区
//
//  Created by 颜 on 15/9/2.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodDetailBase.h"
#import "MiaoshaDetailModel.h"
@interface GoodDetailTopCell : UITableViewCell <UIScrollViewDelegate>/*商品分类 右侧cell*/
@property (nonatomic,strong)UILabel *indexlabel;
@property (nonatomic,strong)UIButton *btnReduce;
@property (nonatomic,strong)UIButton *btnAdd;
@property (nonatomic,strong)UILabel  *lblGoodCount;
@property (nonatomic,strong)GoodDetailBase *goodDetail;
@property (nonatomic,assign)BOOL hidden;
+(instancetype)originViewTableView:(UITableView *)tableView;   //商品加减的按钮
- (void)goodDetail:(GoodDetailBase *)goodDetail andAddBtnHidden:(BOOL)hidden;
- (void)miaoShagoodDetail:(MiaoshaDetailModel *)model;
@end
