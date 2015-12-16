//
//  CommentProductTableViewCell.m
//  几何社区
//
//  Created by KMING on 15/10/20.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "CommentProductTableViewCell.h"
#import "UIImageView+AFNetworking.h"
@implementation CommentProductTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.titleLbl.textColor = Color242424;
    self.priceLbl.textColor = [UIColor orangeColor];
    self.tijiaoBtn.layer.masksToBounds = YES;
    self.tijiaoBtn.layer.cornerRadius = 3;
    
    //评价按钮
    self.commnetBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 22)];
    self.commnetBtn.center = CGPointMake(SCREEN_WIDTH-12-30, self.priceLbl.center.y);
    [self.commnetBtn setBackgroundImage:[UIImage imageNamed:@"pay"] forState:UIControlStateNormal];
    self.commnetBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    
    [self.commnetBtn setTitle:@"评价" forState:UIControlStateNormal];
    [self.commnetBtn setTitle:@"收起评价" forState:UIControlStateSelected];
    
    [self.commnetBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.commnetBtn addTarget:self action:@selector(commentAction) forControlEvents:UIControlEventTouchUpInside];
    self.commnetBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.commnetBtn];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.commnetBtn.selected = [self.btnSelected boolValue];
    [self.imgV setImageWithURL:[NSURL URLWithString:self.model.pic_url] placeholderImage:[UIImage imageNamed:@"产品默认图"]];
    self.titleLbl.text = self.model.title;
    self.priceLbl.text = [NSString stringWithFormat:@"￥%@",self.model.price];
}
-(void)commentAction{
    self.commnetBtn.selected = !self.commnetBtn.selected;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"commentTheProduct" object:@{@"selected":[NSString stringWithFormat:@"%d",self.commnetBtn.selected],@"index":self.index}];
}
- (IBAction)starComment:(UIButton*)btn {
    for (UIButton *starBtn in self.starBtns) {
        if (starBtn.tag<=btn.tag) {
           starBtn.selected = YES;
        }
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
