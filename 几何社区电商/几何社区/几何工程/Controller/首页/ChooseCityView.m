//
//  ChooseCityView.m
//  几何社区
//
//  Created by KMING on 15/8/19.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "ChooseCityView.h"
#import "Define.h"
@implementation ChooseCityView
- (IBAction)ConfirmAction:(UIButton *)sender {
    if ([self.province isEqualToString:@"北京"]||[self.province isEqualToString:@"天津"]||[self.province isEqualToString:@"上海"]||[self.province isEqualToString:@"重庆"]||[self.province isEqualToString:@"香港"]||[self.province isEqualToString:@"澳门"]) {
//       self.delegate.delegate.cityName = self.province;//如果是直辖市，可以直接点确定
//        [self.delegate.delegate.rightBtn setTitle:self.province forState:UIControlStateNormal];
    
        [UIView animateWithDuration:0.4 animations:^{
            self.frame = CGRectMake(SCREEN_WIDTH, 0, self.frame.size.width, self.frame.size.height);
            self.delegate.frame = CGRectMake(SCREEN_WIDTH, 0, self.frame.size.width, self.frame.size.height);
            self.delegate.delegate.backAlphaView.alpha = 0;
        } completion:^(BOOL finished) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"choosecity" object:@{@"name":self.province}];//传通知到地图页面，切换地图
            [self removeFromSuperview];
            [self.delegate.delegate.backAlphaView removeFromSuperview];
            [self.delegate removeFromSuperview];
        }];
    }else{
        if (![self.cit isEqualToString:@"初始"]) {
           // self.delegate.delegate.cityName = self.cit;
//            [self.delegate.delegate.rightBtn setTitle:self.cit forState:UIControlStateNormal];
            [UIView animateWithDuration:0.4 animations:^{
                self.frame = CGRectMake(SCREEN_WIDTH, 0, self.frame.size.width, self.frame.size.height);
                self.delegate.frame = CGRectMake(SCREEN_WIDTH, 0, self.frame.size.width, self.frame.size.height);
                self.delegate.delegate.backAlphaView.alpha = 0;
            } completion:^(BOOL finished) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"choosecity" object:@{@"name":self.cit}];
                [self removeFromSuperview];
                [self.delegate.delegate.backAlphaView removeFromSuperview];
                [self.delegate removeFromSuperview];
            }];
        }
    }
}
- (IBAction)cancelBtnclick:(UIButton *)sender {
    
    [UIView animateWithDuration:0.4 animations:^{
        self.frame = CGRectMake(SCREEN_WIDTH, 0, self.frame.size.width, self.frame.size.height);
        self.delegate.frame = CGRectMake(SCREEN_WIDTH, 0, self.frame.size.width, self.frame.size.height);
        self.delegate.delegate.backAlphaView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self.delegate.delegate.backAlphaView removeFromSuperview];
        [self.delegate removeFromSuperview];
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 43.5;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [NSString stringWithFormat:@"    %@",self.province];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.cit = @"初始";//开始城市叫 初始 用来判断点确定时人们选没选城市
    self.arrs = [NSMutableArray array];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.citys.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycell"];
    }
    cell.textLabel.text = [self.citys objectAtIndex:indexPath.row];
    /**
     *  重要，经过判断，看现在的cell的名字和选中的cell的城市是否一样，因为下面reloaddata了，所以self.provi有值，如果一样，则添加对号（不加会消失，不知道为什么），如果不一样，就把对号删除
     */
    if (![cell.textLabel.text isEqualToString:self.cit]) {
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
    NSString *city = [self.citys objectAtIndex:indexPath.row];//点击的城市名字
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width-30, (cell.contentView.frame.size.height-20.5)/2, 20.5, 20.5)];
    img.image = [UIImage imageNamed:@"Selected"];
    img.tag = indexPath.row;
    [self.arrs addObject:img];
    [cell.contentView addSubview:img];
    self.cit = city;//self.provi,记录点击的城市名字，用来判断所有的cell哪个是点击的那个，防止tableview重用机制重复显示
    [self.tableview reloadData];//reloaddata，上一个方法就可以判断了
    /**
     *  设置整个tableview的对号只有一个
     */
    for (UIImageView *im in self.arrs) {
        if (im.tag!=indexPath.row) {
            [im removeFromSuperview];
        }
    }
    
    
    
    
    
    
    
}

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
