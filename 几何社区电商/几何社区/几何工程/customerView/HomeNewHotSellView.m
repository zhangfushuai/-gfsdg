//
//  HomeNewHotSellView.m
//  几何社区
//
//  Created by KMING on 15/10/8.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "HomeNewHotSellView.h"
#import "UIImageView+AFNetworking.h"
@implementation HomeNewHotSellView

-(void)awakeFromNib{
    self.titleLbl.textColor = Color242424;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.imgV setImageWithURL:[NSURL URLWithString:self.model.imgsrc] placeholderImage:[UIImage imageNamed:@"产品默认图"]];
    self.titleLbl.text = self.model.title;
    self.priceLbl.text = [NSString stringWithFormat:@"￥%.2f",[self.model.price floatValue]];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)seeProductDetail:(id)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hotFoodAdd" object:@{@"pid":self.model.pid}];
    
    
    
}
- (IBAction)buyAction:(id)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"hotFoodBuyToShopCar" object:@{@"model":self.model,@"index":[NSString stringWithFormat:@"%ld",self.addBtn.tag]}];
}


@end
