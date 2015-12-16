//
//  HomeNewSeveralViewController.m
//  几何社区
//
//  Created by KMING on 15/10/8.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "HomeNewSeveralViewController.h"
#import "UIImageView+AFNetworking.h"
#import "HomeNewHotSellView.h"
#import "HotSellModel.h"
#import "ProductDetailViewController.h"
#import "CarGoodBase.h"
#import "ShopCarViewController.h"
#import "HomeNewBannerFirstTableViewCell.h"

@interface HomeNewSeveralViewController ()<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UILabel *buycountLabel;//购买了多少，在右上角购物车上的label
@property (nonatomic)long buycount;//购物车购买的数量
@property (nonatomic,strong)CarGoodBase *carGoodBase;
@property (nonatomic,strong)CarCountBase *carCountBase;
@property (nonatomic,strong)UIView *allView;
@property (nonatomic)int index;//点击购买的是哪个序号的


@end

@implementation HomeNewSeveralViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setLeftNavButtonWithType:BACK];
    [self setNavTitleColor:[UIColor blackColor]];
    self.title = self.model.title;
    
    _manager.delegate = self;
    
    [self makeRightShopCar];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
#pragma mark - MJREfresh
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if (refreshView.tag==0) {
        [_manager getHomeNewBannerInfoWithurl:self.url];
    }
   
    
}
-(void)makeRightShopCar{
    /**
     导航栏右边的购物车
     */
    UIView *rightview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    rightview.backgroundColor = [UIColor clearColor];
    
    
    UIImageView *shopcarimg = [[UIImageView alloc]initWithFrame:CGRectMake(8, 4, 22, 22)];
    shopcarimg.image = [UIImage imageNamed:@"cart"];
    [rightview addSubview:shopcarimg];
    //购买了多少，在右上角购物车上的label
    self.buycountLabel =[[UILabel alloc]initWithFrame:(CGRect){24,2,12,12 }];
    [_manager getGoodCar];
   
    self.buycountLabel.hidden=YES;
    
    self.buycountLabel.layer.masksToBounds=YES;
    self.buycountLabel.layer.cornerRadius=5.5;
    self.buycountLabel.textAlignment=NSTextAlignmentCenter;
    self.buycountLabel.backgroundColor=[UIColor redColor];
    self.buycountLabel.textColor=[UIColor whiteColor];
    self.buycountLabel.font=[UIFont systemFontOfSize:9];
    [rightview addSubview:self.buycountLabel];
    
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:rightview.frame];
    [rightBtn addTarget:self action:@selector(goToShopCar) forControlEvents:UIControlEventTouchUpInside];
    [rightview addSubview:rightBtn];
    
    UIBarButtonItem *rightbarbutton = [[UIBarButtonItem alloc]initWithCustomView:rightview];
    self.navigationItem.rightBarButtonItem = rightbarbutton;
}
-(void)goToShopCar{
    ShopCarViewController *vc = [[ShopCarViewController alloc] initWithNibName:@"ShopCarViewController" bundle:nil];
    vc.fromFlag = 1001;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hotFoodAddAction:) name:@"hotFoodAdd" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hotFoodBuyToShopCarAction:) name:@"hotFoodBuyToShopCar" object:nil];
    
    _manager = [JHDataManager getInstance];
    _manager.delegate = self;
    [_manager getHomeNewBannerInfoWithurl:self.url];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor= HEADERVIEW_COLOR;
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.header = [MJRefreshHeaderView header];
    self.header.scrollView = self.tableView;
    self.header.tag = 0;
    self.header.delegate = self;

    
    
    
}
//商品详情
-(void)hotFoodAddAction:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification object];
    NSString *pid = [nameDictionary objectForKey:@"pid"];
    [_manager getGoodDetailWithID:pid];


}
//添加购物车
-(void)hotFoodBuyToShopCarAction:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification object];
    HotSellModel *model = [nameDictionary objectForKey:@"model"];
    
    NSDictionary *dic4 = @{@"pid":model.pid,@"mid":model.mid,@"num":@"1"};
    NSArray *arr = [NSArray arrayWithObject:dic4];
    NSData *data = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsstr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *dict = @{@"cart":jsstr};
    [_manager updateGoodCar:dict];
    
    NSString *indexString = [nameDictionary objectForKey:@"index"];
    self.index = [indexString intValue];
    
    
}
-(void)makeFooterView{
    NSMutableArray *hotModelArr = [NSMutableArray array];
    for (NSDictionary *dic in self.model.dataArr) {
        HotSellModel *model= [HotSellModel modelFromParams:dic];
        [hotModelArr addObject:model];
    }
    CGFloat vW = (SCREEN_WIDTH-12*3)/2;
    CGFloat vH = vW+53;
//    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 40+(vH+12)*(self.model.dataArr.count+1)/2);
    [self.allView removeFromSuperview];

    self.allView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40+(vH+12)*((self.model.dataArr.count+1)/2))];
    self.allView.backgroundColor = HEADERVIEW_COLOR;
    
    UIView *leftLine = [[UIView alloc]initWithFrame:CGRectMake(12, 20, 80, 0.5)];
    leftLine.backgroundColor = SEPARATELINE_COLOR;
    [self.allView addSubview:leftLine];
    
    UIView *rightLine = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-12-80, 20, 80, 0.5)];
    rightLine.backgroundColor =SEPARATELINE_COLOR;
    [self.allView addSubview:rightLine];
    
    UILabel *remaiLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 15)];
    remaiLbl.center = CGPointMake(SCREEN_WIDTH/2, 20);
    remaiLbl.font = [UIFont systemFontOfSize:15];
    remaiLbl.textColor = Color757575;
    remaiLbl.text = @"热卖专区";
    [self.allView addSubview:remaiLbl];
    
    for (int i=0; i<self.model.dataArr.count; i++) {
        HomeNewHotSellView *hotV = [[[NSBundle mainBundle]loadNibNamed:@"HomeNewHotSellView" owner:self options:0]firstObject];
        hotV.frame = CGRectMake(0, 0, vW, vH);
        hotV.center = CGPointMake(i%2*(vW+12)+12+vW/2, 40+i/2*(vH+12)+vH/2);
        hotV.model = hotModelArr[i];
        hotV.layer.masksToBounds = YES;
        hotV.layer.cornerRadius = 5;
        hotV.addBtn.tag = i;
        
        [self.allView addSubview:hotV];
    }
    
    self.tableView.tableFooterView=self.allView;
}
-(void)requestSuccess:(id)object withRequestType:(RequestType)requestType{
    switch (requestType) {
        case JHGETGOODDETAIL:
        {
            ProductDetailViewController *vc = [[ProductDetailViewController alloc] init];
            vc.goodDetail   = object;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case JHGETGOODCAR:
        {
            
            _carGoodBase = object;
            self.buycount = [_carGoodBase.countBase.number intValue];
            if (self.buycount==0) {
                self.buycountLabel.hidden = YES;
            }else{
                self.buycountLabel.hidden = NO;
            }
            self.buycountLabel.text = _carGoodBase.countBase.number;
            
            
        }
            break;
        case JHUPDATEGOODCAR:
        {
            NSMutableArray *hotViews = [NSMutableArray array];
            for (UIView *subV in self.allView.subviews) {
                if ([subV isKindOfClass:[HomeNewHotSellView class]]) {
                    [hotViews addObject:subV];
                }
            }
            HomeNewHotSellView *hotV = hotViews[self.index];
            
            CGRect rec = [hotV convertRect:hotV.imgV.frame toView:[UIApplication sharedApplication].keyWindow];//从cell的坐标转到window的坐标
           
            UIImageView *jumpimg = [[UIImageView alloc]initWithFrame:rec];
            jumpimg.image = hotV.imgV.image;
            [[UIApplication sharedApplication].keyWindow addSubview:jumpimg];
            [UIView animateWithDuration:0.6 animations:^{
                jumpimg.frame = CGRectMake(SCREEN_WIDTH-33, 40, 5, 5);
            } completion:^(BOOL finished) {
                [jumpimg removeFromSuperview];
            }];
            
            _carCountBase = object;
            
            
            if ([_carCountBase.number intValue]>0) {
                [[NSUserDefaults standardUserDefaults] setObject:_carCountBase.number forKey:@"number"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                JHGlobalApp.tabBarControllder.shopcar.tabBarItem.badgeValue =_carCountBase.number;
                
                 self.buycountLabel.hidden = NO;
                 self.buycountLabel.text = _carCountBase.number;
                
            }else{
                self.buycountLabel.hidden = YES;
            }

        }
            break;
        case JHGETHOMENEWBANNER:
        {
            [self.header endRefreshing];
            self.model=object;
            [self.tableView reloadData];
            [self makeFooterView];
            self.title = self.model.title;
//            [self.scroll removeFromSuperview];
//            [self makeView];
        }
            break;
            
        default:
            break;
    }
}
-(void)requestFailure:(id)failReson withRequestType:(RequestType)requestType{
    [self.header endRefreshing];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"该区域暂未开通服务";
    [hud showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [hud removeFromSuperview];
        
    }];
    
}
#pragma mark - tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section==0) {
//        return SCREEN_WIDTH, SCREEN_WIDTH*105/320;
//    }else{
//        NSMutableArray *hotModelArr = [NSMutableArray array];
//        for (NSDictionary *dic in self.model.dataArr) {
//            HotSellModel *model= [HotSellModel modelFromParams:dic];
//            [hotModelArr addObject:model];
//        }
//        CGFloat vW = (SCREEN_WIDTH-12*3)/2;
//        CGFloat vH = vW/27*28+58;
//        return 40+(vH+12)*(self.model.dataArr.count+1)/2;
//        
//    }
    return  SCREEN_WIDTH*105/320;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    if (indexPath.section==0) {
        HomeNewBannerFirstTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"HomeNewBannerFirstTableViewCell" owner:self options:0]firstObject];
        [cell.imgV setImageWithURL:[NSURL URLWithString:self.model.thumb] placeholderImage:[UIImage imageNamed:@"首页banner默认图"]];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
//    }else{
//        HomeNewBannerSecondTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"HomeNewBannerSecondTableViewCell" owner:self options:0]firstObject];
//        cell.model = self.model;
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        return cell;
//    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [self.header free];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"hotFoodAdd" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"hotFoodBuyToShopCar" object:nil];
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
