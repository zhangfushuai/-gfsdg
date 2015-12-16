//
//  GoodDetailCell.m
//  几何社区
//
//  Created by 颜 on 15/9/2.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "GoodDetailTopCell.h"
#import "UIImageView+AFNetworking.h"

@implementation GoodDetailTopCell

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}
+(instancetype)originViewTableView:(UITableView *)tableView
{
    static NSString *identifier = @"GoodDetailTopCell";
 // 1.缓存中取
     GoodDetailTopCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
     // 2.创建
    if (cell == nil) {
        cell = [[GoodDetailTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
- (void)goodDetail:(GoodDetailBase *)goodDetail andAddBtnHidden:(BOOL)hidden
{
    _goodDetail = goodDetail;
    _hidden = hidden;
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 260);
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    [self addSubview:sv];
    NSArray *arrayImg = _goodDetail.imgscr;
    for (int i =0; i<arrayImg.count; i++) {
        UIImageView *productimg = [[UIImageView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
        [productimg setImageWithURL:[NSURL URLWithString:[arrayImg objectAtIndex:i]]];
        [sv addSubview:productimg];
    }
    sv.delegate = self;
    sv.contentSize = CGSizeMake(arrayImg.count * SCREEN_WIDTH, 0);
    sv.pagingEnabled = YES;
    sv.showsHorizontalScrollIndicator = NO;
    self.indexlabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-12-28, SCREEN_WIDTH-23-15, 28, 28)];
    self.indexlabel.layer.masksToBounds=YES;
    self.indexlabel.layer.cornerRadius=14;
    self.indexlabel.backgroundColor = RGBCOLOR(0, 0, 0, 0.12);
    self.indexlabel.font = [UIFont systemFontOfSize:14];
    self.indexlabel.textAlignment = NSTextAlignmentCenter;
    self.indexlabel.textColor = [UIColor whiteColor];
    [self addSubview:self.indexlabel];
    self.indexlabel.text = [NSString stringWithFormat:@"1/%ld",(unsigned long)arrayImg.count];
    
    /******************商品名字和价格****/
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = SEPARATELINE_COLOR;
    [self addSubview:line];
    UILabel *productname = [[UILabel alloc]initWithFrame:CGRectMake(12, SCREEN_WIDTH+10, SCREEN_WIDTH-24, 30)];
    productname.font = [UIFont systemFontOfSize:17];
    productname.text = _goodDetail.title;
    [self addSubview:productname];
    
    if (!_hidden) {
        if(!self.btnAdd){
            self.btnAdd    = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30 - 10, SCREEN_WIDTH +36, 30, 30)];
            [self.btnAdd setImage:[UIImage imageNamed:@"Add to"] forState:UIControlStateNormal];
            self.lblGoodCount = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -32 -30-10, SCREEN_WIDTH +36, 32, 30)];
            self.lblGoodCount.textAlignment = NSTextAlignmentCenter;
            self.btnReduce       = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -32 -30 -30 -10, SCREEN_WIDTH +36, 30, 30)];
            [self.btnReduce setImage:[UIImage imageNamed:@"Reduce"] forState:UIControlStateNormal];
            [self addSubview:_btnAdd];
            [self addSubview:_btnReduce];
            [self addSubview:_lblGoodCount];
        }
    }
    
    
    UILabel *pricelabel = [[UILabel alloc]initWithFrame:CGRectMake(12, SCREEN_WIDTH +40, 200, 30)];
    pricelabel.textColor = [UIColor colorWithRed:255.0/255.0 green:138.0/255.0 blue:0 alpha:1];
    pricelabel.font =[UIFont systemFontOfSize:17];
    pricelabel.text = [NSString stringWithFormat:@"¥ %.2f",[_goodDetail.price floatValue]];
    [self addSubview:pricelabel];
    
    UIView *downline1 = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH +69.5, SCREEN_WIDTH, 0.5)];
    downline1.backgroundColor = SEPARATELINE_COLOR;
    [self addSubview:downline1];

}
#pragma mark - 秒杀
- (void)miaoShagoodDetail:(MiaoshaDetailModel *)model
{
//    _goodDetail = goodDetail;
   
    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 260);
    UIScrollView *sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    [self addSubview:sv];
    NSArray *arrayImg = [NSArray arrayWithObject:model.imgsrc];
    for (int i =0; i<arrayImg.count; i++) {
        UIImageView *productimg = [[UIImageView alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
        [productimg setImageWithURL:[NSURL URLWithString:[arrayImg objectAtIndex:i]]];
        [sv addSubview:productimg];
    }
    sv.delegate = self;
    sv.contentSize = CGSizeMake(arrayImg.count * SCREEN_WIDTH, 0);
    sv.pagingEnabled = YES;
    sv.showsHorizontalScrollIndicator = NO;
    self.indexlabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-12-28, SCREEN_WIDTH-23-15, 28, 28)];
    self.indexlabel.layer.masksToBounds=YES;
    self.indexlabel.layer.cornerRadius=14;
    self.indexlabel.backgroundColor = RGBCOLOR(0, 0, 0, 0.12);
    self.indexlabel.font = [UIFont systemFontOfSize:14];
    self.indexlabel.textAlignment = NSTextAlignmentCenter;
    self.indexlabel.textColor = [UIColor whiteColor];
    [self addSubview:self.indexlabel];
    self.indexlabel.text = [NSString stringWithFormat:@"1/%ld",(unsigned long)arrayImg.count];
    
    /******************商品名字和价格****/
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_WIDTH, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = SEPARATELINE_COLOR;
    [self addSubview:line];
    UILabel *productname = [[UILabel alloc]initWithFrame:CGRectMake(12, SCREEN_WIDTH+10, SCREEN_WIDTH-24, 30)];
    productname.font = [UIFont systemFontOfSize:17];
    productname.text = model.title;
    [self addSubview:productname];
    
//    if (!_hidden) {
//        if(!self.btnAdd){
//            self.btnAdd    = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 30 - 10, SCREEN_WIDTH +36, 30, 30)];
//            [self.btnAdd setImage:[UIImage imageNamed:@"Add to"] forState:UIControlStateNormal];
//            self.lblGoodCount = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -32 -30-10, SCREEN_WIDTH +36, 32, 30)];
//            self.lblGoodCount.textAlignment = NSTextAlignmentCenter;
//            self.btnReduce       = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -32 -30 -30 -10, SCREEN_WIDTH +36, 30, 30)];
//            [self.btnReduce setImage:[UIImage imageNamed:@"Reduce"] forState:UIControlStateNormal];
//            [self addSubview:_btnAdd];
//            [self addSubview:_btnReduce];
//            [self addSubview:_lblGoodCount];
//        }
//    }
    
    
    UILabel *pricelabel = [[UILabel alloc]initWithFrame:CGRectMake(12, SCREEN_WIDTH +40, 200, 30)];
    pricelabel.textColor = [UIColor colorWithRed:255.0/255.0 green:138.0/255.0 blue:0 alpha:1];
    pricelabel.font =[UIFont systemFontOfSize:17];
    pricelabel.text = [NSString stringWithFormat:@"¥ %.2f",[model.discount_price floatValue]];
    [self addSubview:pricelabel];
    
    UIView *downline1 = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH +69.5, SCREEN_WIDTH, 0.5)];
    downline1.backgroundColor = SEPARATELINE_COLOR;
    [self addSubview:downline1];
    
}



-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int a = scrollView.contentOffset.x/SCREEN_WIDTH;
    self.indexlabel.text = [NSString stringWithFormat:@"%d/%ld",a+1,_goodDetail.imgscr.count];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
