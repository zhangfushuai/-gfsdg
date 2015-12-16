//
//  CategoryDetailViewController.m
//  几何社区
//
//  Created by KMING on 15/8/25.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "CategoryDetailViewController.h"
#import "ProductListTableViewCell.h"
#import "ProductDetailViewController.h"

#import "ProductSortView.h"
#import "ProductSortControl.h"
#import "UIImageView+AFNetworking.h"
#import "MJRefresh.h"

#import "SearchGoodData.h"
@interface CategoryDetailViewController ()<UITableViewDataSource,UITableViewDelegate,ProductSortViewDelegate,ProductSortControlDelegate,MJRefreshBaseViewDelegate>
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)ProductSortControl *control;
@property (nonatomic , assign)NSInteger selectFlag; //1000 折扣 1001 价格 1002 销量
@property (nonatomic , strong)ProductSortView *topview;

@property (nonatomic , strong)NSString *sortStr;

@property (nonatomic , strong)MJRefreshFooterView *footerView;
@property (nonatomic , strong)MJRefreshHeaderView *headerView;
@property (nonatomic , assign)NSInteger page;
@end

@implementation CategoryDetailViewController
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _manager.delegate = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self makeleftnavigation];
    /**
     导航栏右边的购物车
     */
}
- (void)dealloc
{
    [self.headerView free];
    [self.footerView free];
}
#pragma mark - 导航栏左边和中间
-(void)makeleftnavigation{
    [self setLeftNavButtonWithType:BACK];
    [self setNavTitleColor:[UIColor blackColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _page = 1;
    _manager = [JHDataManager getInstance];
    _manager.delegate = self;
    /**
     上面的那行：“默认折扣”，@“默认价格”，@“默认销量”
     */
    _topview = [[[NSBundle mainBundle] loadNibNamed:@"ProductSortView" owner:self options:nil] firstObject];
    [_topview originView];
    _topview.frame  = CGRectMake(0, 64, SCREEN_WIDTH, 40);
    _topview.delegate = self;
    [self.view addSubview:_topview];

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT-104)];
    
    _headerView = [MJRefreshHeaderView header];
    self.headerView.scrollView = self.tableView;
    _headerView.delegate = self;
    self.headerView = _headerView;
    _headerView.tag = 0;
    
    _footerView = [MJRefreshFooterView footer];
    self.footerView.scrollView = self.tableView;
    _footerView.delegate = self;
    _footerView.tag = 1;
    
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
}
// 开始进入刷新状态就会调用
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if (refreshView.tag == 0) {
        _page = 1;
    }else if(refreshView.tag == 1)
    {
        if (_datasourse && _datasourse.count > 0) {
            _page ++;
        }
    }
    if (_classifyId) {
        [_manager getSearchGoodWithKeyWord:nil classify:_classifyId area_id:[[NSUserDefaults standardUserDefaults] objectForKey:@"regionId"] sort:_sortStr page:_page];
    }else{
        [_manager getSearchGoodWithKeyWord:self.title classify:nil area_id:[[NSUserDefaults standardUserDefaults] objectForKey:@"regionId"] sort:_sortStr page:_page];
    }
}
#pragma mark  -tabbleview相关
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datasourse.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        ProductListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell" ];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ProductListTableViewCell" owner:self options:0]firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    SearchGoodData *base = [_datasourse objectAtIndex:indexPath.row];
    [cell.imgVproduct setImageWithURL:[NSURL URLWithString:base.imgsrc] placeholderImage:[UIImage imageNamed:@"产品默认图"]];
    cell.lblProductName.text = base.title;
    cell.lblprice.text = [NSString stringWithFormat:@"¥%.2f",[base.price floatValue]];
    return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchGoodData *base = [_datasourse objectAtIndex:indexPath.row];
    [_manager getGoodDetailWithID:base.pid];
}
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].backgroundColor = HEADERVIEW_COLOR;
}
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].backgroundColor = [UIColor clearColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
#pragma mark -productSortView Delegate
- (void)clickWithFlag:(NSInteger)flag  //1000 折扣 1001 价格 1002 销量
{
    _page = 1;
    _selectFlag = flag;
    if (!_control) {
        _control = [[ProductSortControl alloc] initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT-104)];
        [_control originView];
        _control.delegate = self;
        [self.view addSubview:_control];
    }
    if (![self.view.subviews containsObject:_control]) {
        [self.view addSubview:_control];
    }
    [_control reloadtableViewWithFlag:flag];
    
}
#pragma mark -productSortControl Delegate
- (void)removeControl
{
    [_topview originView];
}
- (void)sortUpToDown:(BOOL)sort    //yes 上往下
{
    if(_selectFlag == 1000) {
        if (sort) {
            _sortStr = @"d1";
        }else{
            _sortStr = @"d0";
        }
    }else if  (_selectFlag == 1001)
    {
        if (sort) {
            _sortStr = @"p1";
        }else{
            _sortStr = @"p0";
        }
    }else if (_selectFlag == 1002){
        if (sort) {
            _sortStr = @"v1";
        }else{
            _sortStr = @"v0";
        }
    }
    if (_classifyId) {
        [_manager getSearchGoodWithKeyWord:nil classify:_classifyId area_id:[[NSUserDefaults standardUserDefaults] objectForKey:@"regionId"] sort:_sortStr page:_page];
    }else{
        [_manager getSearchGoodWithKeyWord:self.title classify:nil area_id:[[NSUserDefaults standardUserDefaults] objectForKey:@"regionId"] sort:_sortStr page:_page];
    }

}

#pragma mark - dataManager delegate
- (void)requestSuccess:(id)object withRequestType:(RequestType)requestType
{
    switch (requestType) {
        case JHSEARCHGOOD:
        {
            [_headerView endRefreshing];
            [_footerView endRefreshing];
            if (!object || [(NSArray *)object count]<=0) {
                _page--;
            }
            if ([(NSArray *)object count]>0){
                if (_page > 1) {
                    [_datasourse addObjectsFromArray:object];
                }else{
                    _datasourse = object;
                }
                
                [_tableView reloadData];
            }else{
                IndicatorTool *tool = [[IndicatorTool alloc] init];
                [tool showHUDWithSeconds:1 text:@"没有更多了" andView:self.view mode:MBProgressHUDModeText];
            }
        }
            break;
        case JHGETGOODDETAIL:
        {
            ProductDetailViewController *vc = [[ProductDetailViewController alloc] init];
            vc.goodDetail   = object;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }

}
- (void)requestFailure:(id)failReson withRequestType:(RequestType)requestType
{
    if (_page>1) {
        _page--;
    }
    [_headerView endRefreshing];
    [_footerView endRefreshing];
    if ([failReson isKindOfClass:[NSDictionary class]]) {
        [self.view makeToast:[failReson objectForKey:@"msg"]];
    }else if([failReson isKindOfClass:[NSString class]]){
        [self.view makeToast:failReson];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
