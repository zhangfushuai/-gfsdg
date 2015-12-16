//
//  CanceledFinishedOrderTableViewCell.m
//  几何社区
//
//  Created by KMING on 15/8/28.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "CanceledFinishedOrderTableViewCell.h"
#import "Define.h"
#import "UIImageView+AFNetworking.h"
#import "MyorderProductModel.h"
@implementation CanceledFinishedOrderTableViewCell

- (void)awakeFromNib {
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    // Initialization code
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 136);
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
    self.timeLabel.center = CGPointMake(112, 15);
    self.timeLabel.font = [UIFont systemFontOfSize:12];
    self.timeLabel.textColor = RGBCOLOR(36.0, 36.0,36.0,1);
    self.timeLabel.text = self.model.created;
    [self addSubview:self.timeLabel];
    //中间的背景view
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, 76)];
    centerView.backgroundColor = HEADERVIEW_COLOR;
    [self addSubview:centerView];
    if (self.model.products.count<=4) {
        for (int i=0; i<self.model.products.count; i++) {
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(i*(SCREEN_WIDTH-60)/4+12, 30, 76, 76)];
            MyorderProductModel *pModel = self.model.products[i];
            
            [img setImageWithURL:[NSURL URLWithString:pModel.pic_url] placeholderImage:[UIImage imageNamed:@"产品默认图"]];
            
            [self addSubview:img];
        }
    }else{
        for (int i=0; i<4; i++) {
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(i*(SCREEN_WIDTH-60)/4+12, 30, 76, 76)];
            MyorderProductModel *pModel = self.model.products[i];
            [img setImageWithURL:[NSURL URLWithString:pModel.pic_url] placeholderImage:[UIImage imageNamed:@"产品默认图"]];
            [self addSubview:img];
        }
    }
    //中间的文字
    self.introlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 20)];
    self.introlabel.textAlignment = NSTextAlignmentRight;
    self.introlabel.center = CGPointMake(SCREEN_WIDTH-150-12, 106+15);
    self.introlabel.textColor = RGBCOLOR(117.0, 117.0, 117.0,1);
    self.introlabel.font = [UIFont systemFontOfSize:12];
    self.introlabel.text = [NSString stringWithFormat:@"共%lu件商品 合计:￥%@元(含运费:%@)",(unsigned long)self.model.products.count,self.model.amount,self.model.shipping];
    [self addSubview:self.introlabel];
    
    //红色的支付状态label
    self.payStateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    self.payStateLabel.center = CGPointMake(SCREEN_WIDTH-12-50, 15);
    self.payStateLabel.font = [UIFont systemFontOfSize:12];
    self.payStateLabel.textColor = [UIColor redColor];
    self.payStateLabel.textAlignment = NSTextAlignmentRight;
    self.payStateLabel.text = self.model.status;
    [self addSubview:self.payStateLabel];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
