//
//  ChooseProvinceView.m
//  几何社区
//
//  Created by KMING on 15/8/18.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "ChooseProvinceView.h"
#import "Define.h"
#import "ChooseCityView.h"

@implementation ChooseProvinceView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.arrs = [NSMutableArray array];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil]];
    [self.tableview reloadData];
}
- (IBAction)CancelBtnClick:(UIButton *)sender {
    [UIView animateWithDuration:0.4 animations:^{
        self.frame = CGRectMake(SCREEN_WIDTH, 0, self.frame.size.width, self.frame.size.height);
        self.delegate.backAlphaView.alpha = 0;

    } completion:^(BOOL finished) {
        [self.delegate.backAlphaView removeFromSuperview];
        [self removeFromSuperview];
    }];
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.provinces.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
//    UITableViewCell *cell= [tableView cellForRowAtIndexPath:indexPath];//关掉重用机制试过了，滑动时对号会消失，只能用判断省份名字方法实现
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycell"];
    }
    NSString *provin =[[self.provinces objectAtIndex:indexPath.row] objectForKey:@"state"];
    cell.textLabel.text = provin;
    /**
     *  重要，经过判断，看现在的cell的名字和选中的cell的省份是否一样，因为下面reloaddata了，所以self.provi有值，如果一样，则添加对号（不加会消失，不知道为什么），如果不一样，就把对号删除
     */
    if (![cell.textLabel.text isEqualToString:self.provi]) {
        for (UIView *vi in cell.contentView.subviews) {
            if ([vi isKindOfClass:[UIImageView class]]) {
                [vi removeFromSuperview];
            }
        }
    }else{
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width-30, (cell.contentView.frame.size.height-20.5)/2, 20.5, 20.5)];
        img.image = [UIImage imageNamed:@"Selected"];
        [cell.contentView addSubview:img];
    }
    
    
        return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [self.tableview cellForRowAtIndexPath:indexPath];
    NSString *province = [[self.provinces objectAtIndex:indexPath.row] objectForKey:@"state"];//点击的省名字
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width-30, (cell.contentView.frame.size.height-20.5)/2, 20.5, 20.5)];
    img.image = [UIImage imageNamed:@"Selected"];
    img.tag = indexPath.row;
    [self.arrs addObject:img];
    [cell.contentView addSubview:img];
    self.provi = province;//self.provi,记录点击的省份名字，用来判断所有的cell哪个是点击的那个，防止tableview重用机制重复显示
    [self.tableview reloadData];//reloaddata，上一个方法就可以判断了
    /**
     *  设置整个tableview的对号只有一个
     */
    for (UIImageView *im in self.arrs) {
        if (im.tag!=indexPath.row) {
            [im removeFromSuperview];
        }
    }
    

    /**
     *  选择城市,把view添加到当前view上，并且传值过去
     *
     */
    ChooseCityView *cityview = [[[NSBundle mainBundle]loadNibNamed:@"ChooseCityView" owner:self options:0]firstObject];
    cityview.delegate =self;
     NSArray* cities = [[self.provinces objectAtIndex:indexPath.row] objectForKey:@"cities"];
    cityview.citys = cities;//传值过去
    cityview.province = province;//传值过去，下一页标题
    cityview.frame= CGRectMake(self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:cityview];
    [UIView animateWithDuration:0.4 animations:^{
        cityview.frame= CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }];
    

    
    
    
}

//-(void)viewDidLayoutSubviews {
//    
//    if ([self.tableview respondsToSelector:@selector(setSeparatorInset:)]) {
//        [self.tableview setSeparatorInset:UIEdgeInsetsZero];
//        self.tableview.separatorColor = SEPARATELINE_COLOR;
//        
//    }
//    if ([self.tableview respondsToSelector:@selector(setLayoutMargins:)])  {
//        [self.tableview setLayoutMargins:UIEdgeInsetsZero];
//        self.tableview.separatorColor = SEPARATELINE_COLOR;
//    }
//    
//}
-(void)layoutSubviews{
    [super layoutSubviews];
    if ([self.tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableview setSeparatorInset:UIEdgeInsetsZero];
        self.tableview.separatorColor = SEPARATELINE_COLOR;
        
    }
    if ([self.tableview respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableview setLayoutMargins:UIEdgeInsetsZero];
        self.tableview.separatorColor = SEPARATELINE_COLOR;
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
