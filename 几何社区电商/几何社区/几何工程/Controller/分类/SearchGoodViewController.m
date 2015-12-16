//
//  SearchGoodViewController.m
//  几何社区
//
//  Created by 颜 on 15/9/6.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "SearchGoodViewController.h"
#import "HotGoodView.h"
#import "ProductSortView.h"
#import "CategoryDetailViewController.h"
#import "ProductListTableViewCell.h"
#import "SearchGoodData.h"
#import "UIImageView+AFNetworking.h"
#import "ProductSortControl.h"
#import "ProductDetailViewController.h"

@interface SearchGoodViewController ()<HotGoodDelegate,UITextFieldDelegate,ProductSortViewDelegate,UITableViewDelegate,UITableViewDataSource,ProductSortControlDelegate,MJRefreshBaseViewDelegate>
@property (nonatomic , strong) HotGoodView *hotView;
@property (nonatomic , strong) UITextField *tfSearch;
@property (nonatomic , assign) NSInteger selectFlag;
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSMutableArray *datasourse;
@property (nonatomic , strong) ProductSortControl *control;
@property (nonatomic , strong) ProductSortView *topview;

@property (nonatomic , strong) NSString*keyWord;
@property (nonatomic , strong)NSString *sortStr;

@property (nonatomic , strong)MJRefreshFooterView *footerView;
@property (nonatomic , strong)MJRefreshHeaderView *headerView;
@property (nonatomic , assign)NSInteger page;
@end

@implementation SearchGoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = HEADERVIEW_COLOR;
    _hotView = [[HotGoodView alloc] init];
    [_hotView addButtons: _hotSearchList];
    _hotView.delegate = self;
    [self.view addSubview:_hotView];
    
    _manager = [JHDataManager getInstance];
    _manager.delegate = self;
    self.hotView.hidden = NO;
    [self setnavSearch];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _manager.delegate = self;
}
- (void)dealloc
{
    [_footerView free];
    [_headerView free];
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
- (void)setnavSearch
{
    [self setLeftNavButtonWithType:BACK];
    _tfSearch = [[UITextField alloc] initWithFrame:CGRectMake(40, 0, 150, 30)];
    _tfSearch.font = [UIFont systemFontOfSize:13];
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 16, 16)];
    imgV.image = [UIImage imageNamed:@"seach"];
    [leftView addSubview:imgV];
    _tfSearch.leftView = leftView;
    _tfSearch.leftViewMode = UITextFieldViewModeAlways;
    _tfSearch.delegate = self;
    _tfSearch.placeholder = @"寻找你喜欢的宝贝或商品               ";
    _tfSearch.font = [UIFont systemFontOfSize:15];
    _tfSearch.layer.borderColor = RGBCOLOR(0, 0, 0, 0.26).CGColor;
    _tfSearch.layer.borderWidth = 0.5;
    _tfSearch.layer.cornerRadius = 5;
    _tfSearch.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    self.navigationItem.titleView = _tfSearch;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 48, 30)];
    [rightButton setBackgroundColor:NAVIGATIONBAR_COLOR];
    [rightButton setTitle:@"搜索" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton addTarget:self action:@selector(searchGoods) forControlEvents:UIControlEventTouchUpInside];
    rightButton.layer.cornerRadius = 5;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = item;
}
- (void)createInitView:(BOOL)hidden
{
    /**
     上面的那行：“默认折扣”，@“默认价格”，@“默认销量”
     */
    if (hidden) {
        _topview.hidden = YES;
        _tableView.hidden = YES;
    }else{
        if (!_topview) {
            _topview = [[[NSBundle mainBundle] loadNibNamed:@"ProductSortView" owner:self options:nil] firstObject];
            [_topview originView];
            _topview.frame  = CGRectMake(0, 64, SCREEN_WIDTH, 40);
            _topview.delegate = self;
            [self.view addSubview:_topview];
        }
        if (!_tableView) {
            self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT-104)];
            self.tableView.dataSource = self;
            self.tableView.delegate = self;
            self.tableView.tableFooterView = [[UIView alloc] init];
            [self.view addSubview:self.tableView];
            
            _headerView = [MJRefreshHeaderView header];
            self.headerView.scrollView = self.tableView;
            _headerView.delegate = self;
            self.headerView = _headerView;
            _headerView.tag = 0;
            
            _footerView = [MJRefreshFooterView footer];
            self.footerView.scrollView = self.tableView;
            _footerView.delegate = self;
            _footerView.tag = 1;
            
        }else{
            [self.tableView reloadData];
        }
        _topview.hidden = NO;
        _tableView.hidden = NO;
    }
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
        [_manager getSearchGoodWithKeyWord:_keyWord classify:nil area_id:[[NSUserDefaults standardUserDefaults] objectForKey:@"regionId"] sort:_sortStr page:_page];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)didSellectGood:(NSInteger)tag   //热门搜素
{
    [_tfSearch resignFirstResponder];
    _keyWord = [_hotSearchList objectAtIndex:tag - 100];
    [_manager getSearchGoodWithKeyWord:[_hotSearchList objectAtIndex:tag - 100] classify:nil area_id:[[NSUserDefaults standardUserDefaults] objectForKey:@"regionId"] sort:nil page:1];
}

- (void)setNotFoundView:(BOOL)hidden
{
    if (hidden == YES) {
        _hotView.hidden = YES;
        self.nothingViewHidden = NO;
        [self setNothingviewWithType:NOFOUND];
    }else{
        _hotView.hidden = NO;
        self.nothingViewHidden = YES;
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self setNotFoundView:NO];
    [self createInitView:YES];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField              // called when 'return' key pressed. return NO to ignore.
{
    [self searchGoods];
    return YES;
}
- (void)searchGoods
{
    [_tfSearch resignFirstResponder];
    if (_tfSearch.text && _tfSearch.text.length >0 ) {
        _keyWord = _tfSearch.text;
        [_manager getSearchGoodWithKeyWord:_tfSearch.text classify:nil area_id:[[NSUserDefaults standardUserDefaults] objectForKey:@"regionId"] sort:nil page:1];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_tfSearch resignFirstResponder];
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
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
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
    [_topview layoutSubviews];
}
- (void)sortUpToDown:(BOOL)sort
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
    [_manager getSearchGoodWithKeyWord:_keyWord classify:nil area_id:[[NSUserDefaults standardUserDefaults] objectForKey:@"regionId"] sort:_sortStr page:_page];
}


- (void)requestSuccess:(id)object withRequestType:(RequestType)requestType
{
    [_headerView endRefreshing];
    [_footerView endRefreshing];
    if (requestType == JHSEARCHGOOD) {
        if (!object || [(NSArray *)object count]<=0) {
            if (_page<=1) {
                _page = 1;
            }else{
                _page--;
            }
        }
        if (_page == 1) {
            NSArray *arr = object;
            if (!_datasourse) {
                _datasourse = [[NSMutableArray alloc] initWithCapacity:0];
            }
            if (arr && arr.count > 0 ) {
                self.datasourse = object;
                [self createInitView:NO];
            }else{
                [self setNotFoundView:YES];
                [self createInitView:YES];
            }
        }else{
            NSArray *arr = object;
            if (!_datasourse) {
                _datasourse = [[NSMutableArray alloc] initWithCapacity:0];
            }
            if (arr && arr.count > 0 ) {
                [_datasourse addObjectsFromArray:object];
                if (_datasourse &&_datasourse.count > 0 ) {
                    [self createInitView:NO];
                    [_tableView reloadData];
                }else{
                    [self setNotFoundView:YES];
                    [self createInitView:YES];
                }
            }
        }
    } if (requestType == JHGETGOODDETAIL)
    {
        ProductDetailViewController *vc = [[ProductDetailViewController alloc] init];
        vc.goodDetail   = object;
        
        [self.navigationController pushViewController:vc animated:YES];
    }

}
-(void)requestFailure:(id)failReson withRequestType:(RequestType)requestType
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
