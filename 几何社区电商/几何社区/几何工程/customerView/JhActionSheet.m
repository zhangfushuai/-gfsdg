//
//  JhActionSheet.m
//  几何社区
//
//  Created by 颜 on 15/9/23.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "JhActionSheet.h"
#import "OrderAddressCell.h"
#import "MyAddressModel.h"
@implementation JhActionSheet 

-(id)initWithConfirmTitle:(NSString *)confirmTitle delegate:(id)delegate addTitle:(NSString *)addTitle arrList:(NSArray *)List
{
    self=[super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.backgroundColor = RGBCOLOR(0, 0, 0, 0.6);
        self.delegate = delegate;
        self.datasourse = List;
        
        UITableView *tableView = [[UITableView alloc] init];
        tableView.translatesAutoresizingMaskIntoConstraints = NO;
        tableView.layer.cornerRadius = 10.0f;
        tableView.delegate = self;
        tableView.dataSource = self;
//        tableView.tableFooterView = [[UIView alloc] init];
        [self addSubview:tableView];
        
        UIButton *btnCancel = [[UIButton alloc] init];
        btnCancel.translatesAutoresizingMaskIntoConstraints = NO;
        [btnCancel setTitle:confirmTitle forState:UIControlStateNormal];
        [btnCancel setBackgroundColor:[UIColor whiteColor]];
        [btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btnCancel.layer.cornerRadius = 10.0f;
        [btnCancel addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnCancel];
        
        CGFloat height ;
        if (List.count >= 3) {
            height = 3 * 74+40;
        }else{
            height = List.count *74 +40;
        }
        tableView.contentSize = CGSizeMake(tableView.frame.size.width, List.count*74+40);
//        [UIView animateKeyframesWithDuration:10 delay:0 options:UIViewKeyframeAnimationOptionBeginFromCurrentState animations:^{
//            NSString *format = [NSString stringWithFormat:@"V:[tableView(%f)]-(10)-[btnCancel(40)]-(%f)-|",height,(height+10+40+10)];
//            NSDictionary *views = NSDictionaryOfVariableBindings(self,tableView,btnCancel);
//            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views]];
//
//        } completion:^(BOOL finished) {
//            NSString *format = [NSString stringWithFormat:@"V:[tableView(%f)]-(10)-[btnCancel(40)]-(10)-|",height];
//            NSDictionary *views = NSDictionaryOfVariableBindings(self,tableView,btnCancel);
//            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views]];
//
//        }];
        NSString *format = [NSString stringWithFormat:@"V:[tableView(%f)]-(10)-[btnCancel(40)]-(10)-|",height];
        NSDictionary *views = NSDictionaryOfVariableBindings(self,tableView,btnCancel);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views]];
        
        NSDictionary *views1 = NSDictionaryOfVariableBindings(self,tableView);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[tableView]-(10)-|" options:0 metrics:nil views:views1]];
        NSDictionary *views2 = NSDictionaryOfVariableBindings(self,btnCancel);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(10)-[btnCancel]-(10)-|" options:0 metrics:nil views:views2]];

    }
    return self;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderAddressCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderAddressCell" owner:self options:nil] lastObject];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 73.5, SCREEN_WIDTH, 0.5)];
        line.backgroundColor = SEPARATELINE_COLOR;
        [cell.contentView addSubview:line];
    }
    [cell layoutIfNeeded];
    MyAddressModel *model = [_datasourse objectAtIndex:indexPath.row];
    cell.lblNoneAddress.hidden = YES;
    cell.lblName.text = model.name;
    cell.lblPhone.text = model.phonenum;
    cell.lblAddress.text = model.address;
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasourse.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [_delegate actionSheet:self clickedButtonAtIndex:indexPath.row];
    }
    [self removeFromSuperview];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    footerView.backgroundColor = [UIColor whiteColor];;
    UIButton *btnAdd = [[UIButton alloc] initWithFrame:footerView.bounds];
    [btnAdd setTitle:@"新增收货地址" forState:UIControlStateNormal];
    [btnAdd setTitleColor:NAVIGATIONBAR_COLOR forState:UIControlStateNormal];
    [btnAdd addTarget:self action:@selector(addAddress) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:btnAdd];
    return footerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40.f;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    scrollView.bounces = NO;
}

- (void)addAddress
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [_delegate actionSheet:self clickedButtonAtIndex:-2];
    }
    [self removeFromSuperview];
}
-(void)cancel
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(actionSheet:clickedButtonAtIndex:)]) {
        [_delegate actionSheet:self clickedButtonAtIndex:-1];
    }
    [self removeFromSuperview];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
