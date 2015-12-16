//
//  TransportOrderView.m
//  几何社区
//
//  Created by KMING on 15/9/21.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "TransportOrderView.h"
#import "WaitForPayTableViewCell.h"
#import "CanceledFinishedOrderTableViewCell.h"
#import "OrderDetailViewController.h"
#import "NoOrderView.h"
@implementation TransportOrderView

-(void)layoutSubviews{
    [super layoutSubviews];
    _manager.delegate =self;
    NSDictionary *dic =@{@"page":@"1"};
    [_manager getTransportOrderWithPageParams:dic];
    self.delegate.myscroll.scrollEnabled=NO;
    for (UIButton *bt in self.delegate.topBtnArr) {
        bt.userInteractionEnabled=NO;
    }
}
- (id)initWithFrame:(CGRect)frame
{
    if (self =[super initWithFrame:frame]) {
        // 初始化代码
        //self.backgroundColor = [UIColor blueColor];
        
        self.tableView = [[UITableView alloc]initWithFrame:self.bounds];
        [self addSubview:self.tableView];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.backgroundColor = HEADERVIEW_COLOR;
        [self.tableView setTableFooterView:[[UIView alloc]init]];
        _manager = [JHDataManager getInstance];
        _manager.delegate =self;
        
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
//        hud.labelText =@"加载中...";
        self.allOrderArr  =[NSMutableArray array];
        self.page = 1;
        self.header = [MJRefreshHeaderView header];
        self.header.scrollView = self.tableView;
        self.header.tag = 0;
        self.header.delegate = self;
        self.footer = [MJRefreshFooterView footer];
        self.footer.scrollView = self.tableView;
        self.footer.delegate = self;
        self.footer.tag = 1;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(orderDetailPageBack) name:@"orderDetailPageBack" object:nil];//详情页后退需要充值——manager
    }
    return self;
}
-(void)orderDetailPageBack{
    _manager.delegate = self;
}
#pragma mark - MJREfresh
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if (refreshView.tag==0) {
        self.page=1;
        NSDictionary *dic =@{@"page":@"1"};
        [_manager getTransportOrderWithPageParams:dic];
    }
    else{
        if(self.allOrderArr.count!=0){
            self.page = self.page+1;
        }
        NSDictionary *dic = @{@"page":[NSString stringWithFormat:@"%d",self.page]};
        [_manager getTransportOrderWithPageParams:dic];
    }
    
}

-(void)requestSuccess:(id)object withRequestType:(RequestType)requestType{
    [self.header endRefreshing];
    [self.footer endRefreshing];
    NSArray *orderArr = object;
    if (self.page==1) {
        //下拉刷新
        self.allOrderArr = [orderArr mutableCopy];
    }else{
        //上拉加载
        if (orderArr.count==0||orderArr==nil) {
            self.page=self.page-1;
        }
        [self.allOrderArr addObjectsFromArray:orderArr];
    }
    [self.tableView reloadData];
    self.delegate.myscroll.scrollEnabled=YES;
    for (UIButton *bt in self.delegate.topBtnArr) {
        bt.userInteractionEnabled=YES;
    }
    if (self.allOrderArr.count==0) {
        NoOrderView *noV = [[[NSBundle mainBundle]loadNibNamed:@"NoOrderView" owner:self options:0]firstObject];
        noV.frame=self.frame;
         noV.delegate = self.delegate;
        self.delegate.myscroll.scrollEnabled=YES;
        [self.delegate.myscroll addSubview:noV];
    }
//    MBProgressHUD *hud = [MBProgressHUD HUDForView:self];
//    hud.mode = MBProgressHUDModeText;
//    hud.labelText = @"加载成功";
//    [hud showAnimated:YES whileExecutingBlock:^{
//        sleep(1);
//    } completionBlock:^{
//        [hud removeFromSuperview];
//        
//    }];
    
}
-(void)requestFailure:(id)failReson withRequestType:(RequestType)requestType{
    [self.header endRefreshing];
    [self.footer endRefreshing];
    if (self.page!=1) {
        self.page = self.page-1;
    }
    self.delegate.myscroll.scrollEnabled=YES;
    for (UIButton *bt in self.delegate.topBtnArr) {
        bt.userInteractionEnabled=YES;
    }
    if (!failReson) {
        failReson = @"加载失败";
    }
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = failReson;
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [hud removeFromSuperview];
        
    }];
    
}
//制作headerview
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]
                    initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8.5)];
    view.backgroundColor = HEADERVIEW_COLOR;
    UIView *topline =[[UIView alloc]initWithFrame:CGRectMake(0, 0.2, SCREEN_WIDTH, 0.5)];
    topline.backgroundColor = SEPARATELINE_COLOR;
    [view addSubview:topline];
    return view;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.allOrderArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (indexPath.section==0) {
    //        return 176;
    //    }else{
    //        return 136;
    //    }
    MyOrderModel *model = self.allOrderArr[indexPath.section];
    if ([model.status isEqualToString:@"未付款"]||([model.status isEqualToString:@"未取货"]&&[model.pay_type isEqualToString:@"货到付款"])) {
        return 176;
    }else{
        return 136;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{
        return 8.5;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyOrderModel *model = self.allOrderArr[indexPath.section];

        CanceledFinishedOrderTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"CanceledFinishedOrderTableViewCell" owner:self options:0]firstObject];
 
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    
    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderDetailViewController *vc = [[OrderDetailViewController alloc]init];
    vc.model =self.allOrderArr[indexPath.section];
    [self.delegate.navigationController pushViewController:vc animated:YES];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"orderDetailPageBack" object:nil];
    [self.header free];
    [self.footer free];
}


-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        self.tableView.separatorColor = SEPARATELINE_COLOR;
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        self.tableView.separatorColor = SEPARATELINE_COLOR;
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
@end
