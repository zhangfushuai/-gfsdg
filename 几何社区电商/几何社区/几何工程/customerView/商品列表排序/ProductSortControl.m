//
//  ProductSortControl.m
//  几何社区
//
//  Created by 颜 on 15/9/9.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "ProductSortControl.h"

@implementation ProductSortControl  

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)reloadtableViewWithFlag:(NSInteger)flag
{
    if(flag == 1000){
        _datasourse = @[@"默认折扣",@"由高至低",@"有低至高"];
    }
    if(flag == 1001){
        _datasourse = @[@"默认价格",@"由高至低",@"有低至高"];
    }
    if(flag == 1002){
        _datasourse = @[@"默认销量",@"由高至低",@"有低至高"];
    }
    [_tableView reloadData];
}
- (void)originView
{
    self.backgroundColor = RGBCOLOR(0, 0, 0, 0.6);
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44*3)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollEnabled = NO;
    [self addSubview:_tableView];    
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
-(void)layoutSubviews {
    [super layoutSubviews];
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        _tableView.separatorColor = SEPARATELINE_COLOR;
        
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
        _tableView.separatorColor = SEPARATELINE_COLOR;
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycell"];
    }
    cell.textLabel.text = [_datasourse objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.textLabel.textColor = RGBCOLOR(0, 0, 0, 0.54);
    if ( indexPath.row == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.userInteractionEnabled = NO;
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.userInteractionEnabled = YES;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self removeCarControl];
    
    if (indexPath.row == 1) {
        if ( _delegate && [_delegate respondsToSelector:@selector(sortUpToDown:)]) {
            [_delegate sortUpToDown:YES];
        }
    }else if (indexPath.row == 2){
        if ( _delegate && [_delegate respondsToSelector:@selector(sortUpToDown:)]) {
            [_delegate sortUpToDown:NO];
        }
    }
    
}

- (void)removeCarControl
{
    if ( _delegate && [_delegate respondsToSelector:@selector(removeControl)]) {
        [_delegate removeControl];
    }
    [self removeFromSuperview];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self removeCarControl];
}
@end
