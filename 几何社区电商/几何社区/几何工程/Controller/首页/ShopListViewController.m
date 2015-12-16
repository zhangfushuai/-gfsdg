//
//  ShopListViewController.m
//  几何社区
//
//  Created by KMING on 15/10/6.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "ShopListViewController.h"
#import "ShopListTableViewCell.h"
#import "CategoryDetailViewController.h"
#import "ProductListTableViewCell.h"
#import "ShopModel.h"
#import "UIImageView+AFNetworking.h"
@interface ShopListViewController ()<UITableViewDelegate,UITableViewDataSource,JHDataMagerDelegate,MJRefreshBaseViewDelegate>
@property (nonatomic,copy)NSString *titleString;
@end

@implementation ShopListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate=self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView =[[UIView alloc]init];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _manager = [JHDataManager getInstance];
    self.shopARR = [NSMutableArray array];
    self.shopARR = [self.arr mutableCopy];
    self.page = 1;
    self.header = [MJRefreshHeaderView header];
    self.header.scrollView = self.tableView;
    self.header.tag = 0;
    self.header.delegate = self;
    self.footer = [MJRefreshFooterView footer];
    self.footer.scrollView = self.tableView;
    self.footer.delegate = self;
    self.footer.tag = 1;
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

#pragma mark - MJREfresh
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if (refreshView.tag==0) {
        self.page=1;
        [_manager getShopWithKeyWord:nil classify:self.classify area_id:nil sort:nil page:1];
    }
    else{
        if(self.shopARR.count!=0) {
            self.page = self.page+1;
        }
      
       [_manager getShopWithKeyWord:nil classify:self.classify area_id:nil sort:nil page:self.page];
        
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.shopARR.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    ShopListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
//    if (!cell) {
//        cell = [[[NSBundle mainBundle]loadNibNamed:@"ShopListTableViewCell" owner:self options:0]firstObject];
//    }
//    cell.model = self.shopARR[indexPath.row];
//    
//    
//    return cell;
    ShopModel *model = self.shopARR[indexPath.row];
    
    ProductListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell" ];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ProductListTableViewCell" owner:self options:0]firstObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    [cell.imgVproduct setImageWithURL:[NSURL URLWithString:model.imgsrc] placeholderImage:[UIImage imageNamed:@"产品默认图"]];
    cell.lblProductName.text = model.title;
    cell.lblprice.text = model.address;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ShopModel *model = self.shopARR[indexPath.row];
    self.titleString = model.title;
    NSString *areaId = [[NSUserDefaults standardUserDefaults]objectForKey:@"regionId"];
    
    [_manager getShopFoodWithShopid:model.iid andAreaid:areaId];
    
}
-(void)requestSuccess:(id)object withRequestType:(RequestType)requestType{
    switch (requestType) {
        case JHGETSHOPFOOD:
        {
            
            CategoryDetailViewController *vc = [[CategoryDetailViewController alloc] init];
            vc.datasourse = object;
            vc.title = self.titleString;
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
            break;
        case JHGETSHOPINFO:
        {
            [self.header endRefreshing];
            [self.footer endRefreshing];
            NSArray *orderArr = object;
            if (self.page==1) {
                if (orderArr==nil||orderArr.count==0) {
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"该区域暂未开通服务";
                    [hud showAnimated:YES whileExecutingBlock:^{
                        sleep(1);
                    } completionBlock:^{
                        [hud removeFromSuperview];
                        
                    }];
                }

            }else{
                if (orderArr==nil||orderArr.count==0) {
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    hud.mode = MBProgressHUDModeText;
                    hud.labelText = @"没有更多了";
                    [hud showAnimated:YES whileExecutingBlock:^{
                        sleep(1);
                    } completionBlock:^{
                        [hud removeFromSuperview];
                        
                    }];
                }
            }
            
            if (self.page==1) {
                //下拉刷新
                
                self.shopARR = [orderArr mutableCopy];
            }else{
                //上拉加载
                if (orderArr.count==0||orderArr==nil) {
                    self.page=self.page-1;
                }
                [self.shopARR addObjectsFromArray:orderArr];
            }
            
            [self.tableView reloadData];
            
        }
            break;
            
        default:
            break;
    }
}
-(void)requestFailure:(id)failReson withRequestType:(RequestType)requestType{
    switch (requestType) {
        case JHGETSHOPINFO:
        {
            [self.header endRefreshing];
            [self.footer endRefreshing];
        }
            break;
            
        default:
            break;
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setLeftNavButtonWithType:BACK];
    [self setNavTitleColor:[UIColor blackColor]];
    self.title = self.titleText;
    _manager.delegate =self;
   
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    
    [self.header free];
    [self.footer free];
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
