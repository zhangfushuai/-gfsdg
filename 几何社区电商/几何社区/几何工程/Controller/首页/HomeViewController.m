//
//  HomeViewController.m
//  几何社区
//
//  Created by KMING on 15/9/9.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "HomeViewController.h"
#import "MapViewController.h"
#import "HomeYaoyiyaoTableViewCell.h"
#import "HomeOtherTableViewCell.h"
#import "PlaceSearchResultModel.h"
#import "HomeActivityModel.h"
#import "HomeClickActvityViewController.h"
#import "SearchGoodViewController.h"
#import "CategoryDetailViewController.h"
#import "ProductDetailViewController.h"
#import "BestSellerView.h"
#import "ShopListViewController.h"
#import "ProductDetailViewController.h"
#import "HomeNewSeveralViewController.h"
#import "MiaoShaListTableViewController.h"
#import "HomeMiaoShaTableViewCell.h"
@interface HomeViewController ()
{
    AMapSearchAPI *_search;
}
/**MJRfresh*/
@property (nonatomic,strong)MJRefreshHeaderView *header;

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)MKMapView *MapView;
@property (nonatomic,strong)HWTitleButton *titleBtn;//navigationbar上的titlebview
//@property (nonatomic,strong)MKMapView *MapView;//有个小的mapview，设置为hidden，这样可以使用mapview的定位，防止gps偏移，更准确
@property (nonatomic,strong)CLGeocoder *geocoder;
@property(nonatomic,strong)CLLocationManager *locMgr;
//@property (nonatomic,copy)NSString *cutPlace;
@property (nonatomic,strong)MKUserLocation *userLocation;//用来记录定位到的userlocation，跳转到地图页是可以直接传给地图，让地图加载这个位置
@property (nonatomic,strong)NSArray* activities;//数据源
@property (nonatomic,strong)PlaceSearchResultModel *placeModel;

@property (nonatomic,copy)NSString *activity_title;//用来记录点击活动如果为2类型时点击活动的标题，传给下一页
@property (nonatomic,copy)NSString *classify;//用来记录点击活动如果为2类型时点击活动的cid，传给下一页

@property (nonatomic,strong)HomeActivityModel *homeModel;

@property (nonatomic,strong)UIView *footerV;

//首页秒杀时间
@property (nonatomic,copy)NSString *flag;//1为正在抢，0为还未开始
@property (nonatomic,copy)NSString *flag_time;//截止时间
@property (nonatomic,copy)NSString *time;//当前服务器时间
@property (nonatomic,copy)NSString *miaoshaImgUrl;
@end

@implementation HomeViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"HomeViewController"];
    _manager.delegate = self;
    //获取首页秒杀时间
   
    if (self.activities) {
        
    }else{
        if (self.userLocation) {
            //获取区域id
           // NSLog(@"%f---%f",self.userLocation.location.coordinate.latitude,self.userLocation.location.coordinate.longitude);
            [_manager getRegionIDWithLatitude:self.userLocation.location.coordinate.latitude andlongitude:self.userLocation.location.coordinate.longitude];
        }else{
            
        }
    }
     [_manager getHomeMiaoShaTime];
    
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"HomeViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //配置用户Key
    [AMapSearchServices sharedServices].apiKey = AMAPKEY;
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    self.placeModel = [[PlaceSearchResultModel alloc]init];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+47,SCREEN_WIDTH, SCREEN_HEIGHT-64-47-49)];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
        //self.tableView.backgroundColor =[UIColor colorWithWhite:0.976 alpha:1.000];
    [self makeMapView];
    _manager = [JHDataManager getInstance];
    
    //如果自定义了navigationItem的leftBarButtonItem，那么这个手势就会失效。解决:
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nextPageMapAddressConfirmed:) name:@"addressConfirmToHome" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(homeYaoyiyaoClicked:) name:@"homeYaoyiyaoClicked" object:nil];
    
     [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkLocateState:) userInfo:nil repeats:YES];
    
    [self initialHeaderViewAndFooterView];
    
    self.header = [MJRefreshHeaderView header];
    self.header.scrollView = self.tableView;
    self.header.delegate = self;

    }
#pragma mark - MJRefresh
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    NSString *areaId = [[NSUserDefaults standardUserDefaults]objectForKey:@"regionId"];
    [_manager getHomeActivitywithRegionId:areaId];
    [_manager getHomeMiaoShaTime];
}

-(void)initialHeaderViewAndFooterView{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*137/320)];
    self.tableView.tableHeaderView = headerView;
    
    
    self.footerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 31)];
    self.footerV.backgroundColor = HEADERVIEW_COLOR;
    UILabel *bestsellLbl = [[UILabel alloc]initWithFrame:CGRectMake(12, 8, 60, 15)];
    bestsellLbl.textColor = Color757575;
    bestsellLbl.font = [UIFont systemFontOfSize:15];
    bestsellLbl.text = @"热销产品";
    [self.footerV addSubview:bestsellLbl];
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    topLine.backgroundColor = SEPARATELINE_COLOR;
    [self.footerV addSubview:topLine];
    self.tableView.tableFooterView = self.footerV;
}
-(void)homeYaoyiyaoClicked:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification object];
    NSString *tag = [nameDictionary objectForKey:@"tag"];
    NSInteger tagint = [tag integerValue];
    switch (tagint) {
        case 0:
        {
            NSString *areaId = [[NSUserDefaults standardUserDefaults]objectForKey:@"regionId"];
            self.activity_title = @"酒水";
            self.classify = @"A";
            [_manager getSearchGoodWithKeyWord:nil classify:self.classify area_id:areaId sort:nil page:1];
        }
            break;
        case 1:
        {
            
            NSString *areaId = [[NSUserDefaults standardUserDefaults]objectForKey:@"regionId"];
            NSString *did = [self.activities lastObject];
            if ([did isEqualToString:@""]||[areaId isEqualToString:@"422594"]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"该区域暂无代购";
                [hud showAnimated:YES whileExecutingBlock:^{
                    sleep(1);
                } completionBlock:^{
                    [hud removeFromSuperview];
                }];
            }else{
                [_manager getGoodDetailWithID:did];
            }
        }
            break;
        case 2:
        {
            NSString *areaId = [[NSUserDefaults standardUserDefaults]objectForKey:@"regionId"];
            self.activity_title = @"粮油";
            self.classify = @"D";
            [_manager getSearchGoodWithKeyWord:nil classify:self.classify area_id:areaId sort:nil page:1];
        }
            break;
        case 3:
        {
            NSString *areaId = [[NSUserDefaults standardUserDefaults]objectForKey:@"regionId"];
            self.activity_title = @"日化";
            self.classify = @"H";
            [_manager getSearchGoodWithKeyWord:nil classify:self.classify area_id:areaId sort:nil page:1];
        }
            break;
        case 4:
        {
//            self.activity_title = @"餐饮料理";
//            self.classify = @"B";
//            [_manager getShopWithKeyWord:nil classify:self.classify area_id:nil sort:nil];
            
            NSString *areaId = [[NSUserDefaults standardUserDefaults]objectForKey:@"regionId"];
            [_manager getShopWithKeyWord:nil classify:@"B" area_id:areaId sort:nil page:1];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.labelText =@"加载中...";
            
        }
            break;
        case 5:
        {
            NSString *areaId = [[NSUserDefaults standardUserDefaults]objectForKey:@"regionId"];
            self.activity_title = @"水果";
            self.classify = @"C";
            [_manager getSearchGoodWithKeyWord:nil classify:self.classify area_id:areaId sort:nil page:1];
        }
            break;
        
        
        case 6:
        {
            NSString *areaId = [[NSUserDefaults standardUserDefaults]objectForKey:@"regionId"];
            self.activity_title = @"下午茶";
            self.classify = @"E";
            [_manager getSearchGoodWithKeyWord:nil classify:self.classify area_id:areaId sort:nil page:1];
        }
            break;
        case 7:
        {
            NSString *areaId = [[NSUserDefaults standardUserDefaults]objectForKey:@"regionId"];
            self.activity_title = @"休闲零食";
            self.classify = @"F";
            [_manager getSearchGoodWithKeyWord:nil classify:self.classify area_id:areaId sort:nil page:1];
                    }
            break;
        
            
        default:
            break;
    }

}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1)//关闭主界面的右滑返回
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark - 监听到下一页的地址选好了
-(void)nextPageMapAddressConfirmed:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification object];
    PlaceSearchResultModel *model = [nameDictionary objectForKey:@"model"];
    [self.titleBtn setTitle:[NSString stringWithFormat:@"送至:%@",model.name] forState:UIControlStateNormal];
    [_manager getRegionIDWithLatitude:model.latitude andlongitude:model.longitude];
    NSString *placeModelPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"placeModel"];
    [NSKeyedArchiver archiveRootObject:model toFile:placeModelPath];
    
    
}

-(void)makeMapView{
    
    //self.view.backgroundColor  = [UIColor colorWithWhite:0.961 alpha:1.000];
    
    UIView *searchV = [self makeSearchView];
    searchV.frame = CGRectMake(0, 64, SCREEN_WIDTH, 47);
    [self.view addSubview:searchV];
    [self makeNavigation];
    self.locatecity = @"选择城市";//传给下一页的位置，初始化
    
    

    self.MapView = [[MKMapView alloc]initWithFrame:CGRectMake(-100, 100, 50, 50)];//一个地图放到屏幕外面，用来定位
    self.MapView.delegate = self;
    [self.view addSubview:self.MapView];
    [self.MapView setShowsUserLocation:YES];
    self.MapView.rotateEnabled = NO;
    
}
-(void)checkLocateState:(NSTimer*)timer{
    if (([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)||![CLLocationManager locationServicesEnabled]){
        UIAlertView *alertv = [[UIAlertView alloc]initWithTitle:@"提示" message:@"定位功能关闭，请开启定位或手动选择地址" delegate:self cancelButtonTitle:@"点击选择地址" otherButtonTitles:nil, nil];
        alertv.delegate=self;
        [alertv show];
        
        [self.titleBtn setTitle:@"定位失败，点击手动选择地址" forState:UIControlStateNormal];
        NSLog(@"禁止");
        [timer invalidate];
        
        
    }else if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken,^{
            if (IS_IOS8_OR_LATER) {
                self.locMgr = [[CLLocationManager alloc]init];
                [self.locMgr requestWhenInUseAuthorization];
                self.locMgr.desiredAccuracy = kCLLocationAccuracyBest;
                 NSLog(@"未决定");
            }

        });
        
    }
    else{
        NSLog(@"允许");
        [self.titleBtn setTitle:@"定位中，请稍后..." forState:UIControlStateNormal];
        [timer invalidate];
        
    }
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==5) {
        if (buttonIndex==0) {
            NSLog(@"%ld",(long)buttonIndex);
            NSString *regionId =@"422594";
//            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//            [ud setObject:regionId forKey:@"regionId"];
//            [ud synchronize];
            [_manager getHomeActivitywithRegionId:regionId];
        }
    }
    else if (alertView.tag==8) {
        if (buttonIndex==1) {
            //软件需要更新提醒
            if (buttonIndex == 1) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.hey900.com/ucab1.html"]];
            }
        }
    }
    else{
        if (buttonIndex==0) {
            MapViewController *mapview = [[MapViewController alloc]init];
            mapview.locatecity = self.locatecity;
            //mapview.userLocation = self.userLocation;
            [self.navigationController pushViewController:mapview animated:YES];
        }
    }
}

#pragma mark - 初始化导航栏
-(void)makeNavigation{
    
    //修正偏移
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -3.5;
    

    
    self.titleBtn = [[HWTitleButton alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];//生命成属性保证只有一个titleBtn
    [self.titleBtn setTitle:@"定位中，请稍后..." forState:UIControlStateNormal];
    self.titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    self.titleBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    //self.titleBtn.frame = CGRectMake(0, 0, 10, 30);
    [self.titleBtn setImage:[UIImage imageNamed:@"xl2"] forState:UIControlStateNormal];
    [self.titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.titleBtn addTarget:self action:@selector(pushToMap) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *titleBBt = [[UIBarButtonItem alloc]initWithCustomView:self.titleBtn];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer,titleBBt, nil];
    
    self.navigationItem.titleView = [[UIView alloc]init];//隐藏标题
    
    
//    UIBarButtonItem *rig = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushToMiaosha)];
//    self.navigationItem.rightBarButtonItem = rig;
    
}
//-(void)pushToMiaosha{
//    UIStoryboard *miaoSB = [UIStoryboard storyboardWithName:@"MiaoSha" bundle:nil];
//    MiaoShaListTableViewController *vc = [miaoSB instantiateViewControllerWithIdentifier:@"m1"];
//    [self.navigationController pushViewController:vc animated:YES];
//}
#pragma mark - 返回搜索view
-(UIView*)makeSearchView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 47)];
    view.backgroundColor = [UIColor whiteColor];
    UIView *searchBackV = [[UIView alloc]initWithFrame:CGRectMake(12, 8, SCREEN_WIDTH-24, 31)];
    searchBackV.backgroundColor = [UIColor colorWithWhite:0.851 alpha:0.54];
    searchBackV.layer.masksToBounds = YES;
    searchBackV.layer.cornerRadius = 3;
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, 7, 17, 17)];
    [searchBtn setImage:[UIImage imageNamed:@"seach"] forState:UIControlStateNormal];
    [searchBackV addSubview:searchBtn];
    UITextField *searchTf = [[UITextField alloc]initWithFrame:CGRectMake(37, 8, searchBackV.frame.size.width-37, 15)];
    searchTf.font = [UIFont systemFontOfSize:15];
    searchTf.textColor = RGBCOLOR(166, 166, 166, 1);
    searchTf.textAlignment = NSTextAlignmentLeft;
    searchTf.placeholder = @"请输入搜索关键字";
    searchTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchTf.returnKeyType = UIReturnKeySearch;
    [searchBackV addSubview:searchTf];
    [view addSubview:searchBackV];
    UIView *downLine = [[UIView alloc]initWithFrame:CGRectMake(0,47-0.5, SCREEN_WIDTH, 0.5)];
    downLine.backgroundColor = SEPARATELINE_COLOR;
    [view addSubview:downLine];
    
    UIButton *searchClearBt = [[UIButton alloc]initWithFrame:searchBackV.bounds];
    [searchClearBt addTarget:self action:@selector(goToSearch) forControlEvents:UIControlEventTouchUpInside];
    [searchBackV addSubview:searchClearBt];
    return view;
}
-(void)goToSearch{
    [_manager getHotWords];
}
#pragma mark 点击地址调到地图
-(void)pushToMap{
    //[self performSegueWithIdentifier:@"HomeToMap" sender:nil];
    MapViewController *mapview = [[MapViewController alloc]init];
    mapview.locatecity = self.locatecity;
    mapview.userLocation = self.userLocation;
    [self.navigationController pushViewController:mapview animated:YES];
}
#pragma mark - 制作footerview热销商品
-(void)makeFooterView{
    NSArray *bestSellerArr = self.activities[3];
    if (bestSellerArr.count==0||bestSellerArr==nil) {
        self.tableView.tableFooterView = [[UIView alloc]init];
    }else{
        self.footerV=nil;
        
        self.footerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 31)];
        self.footerV.backgroundColor = HEADERVIEW_COLOR;
        UILabel *bestsellLbl = [[UILabel alloc]initWithFrame:CGRectMake(12, 8, 60, 15)];
        bestsellLbl.textColor = Color757575;
        bestsellLbl.font = [UIFont systemFontOfSize:15];
        bestsellLbl.text = @"热销产品";
        [self.footerV addSubview:bestsellLbl];
        UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        topLine.backgroundColor = SEPARATELINE_COLOR;
        [self.footerV addSubview:topLine];
        
        
        
        CGFloat vW = (SCREEN_WIDTH-12*3)/2;
        CGFloat vH = (vW-2)*135/140+1+57+22;
        
        self.footerV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 31+(bestSellerArr.count+1)/2*(vH+12));
        
        
        for (int i=0; i<bestSellerArr.count; i++) {
            BestSellerView *bestSellerV = [[[NSBundle mainBundle]loadNibNamed:@"BestSellerView" owner:self options:0]firstObject];
            bestSellerV.layer.masksToBounds = YES;
            bestSellerV.layer.cornerRadius = 5;
            bestSellerV.model = bestSellerArr[i];//防止多次加载
            bestSellerV.frame= CGRectMake(0, 0, vW, vH);
            bestSellerV.center = CGPointMake(i%2*(12+vW)+12+vW/2,i/2*(vH+12)+31+vH/2);
            [bestSellerV.clearbtn addTarget:self action:@selector(pushToDetail:) forControlEvents:UIControlEventTouchUpInside];
            bestSellerV.clearbtn.tag=i;
            [self.footerV addSubview:bestSellerV];
        }
        self.tableView.tableFooterView = self.footerV;
    }
    
}
#pragma mark - 下面的商品点击
-(void)pushToDetail:(UIButton*)btn{
    
    
    
    HomeActivityModel *model = self.activities[3][btn.tag];
    
  
    [_manager getGoodDetailWithID:model.pid];
    
}
#pragma mark -网络请求协议
-(void)requestSuccess:(id)object withRequestType:(RequestType)requestType{
    switch (requestType) {
        case JHGETHOMEACTIVITY:
        {
            self.activities = object;
            [self.tableView reloadData];
            [self.header endRefreshing];
            
            NSMutableArray *imagesURLStrings = [NSMutableArray array];
            for (HomeActivityModel *model in self.activities[0]) {
                [imagesURLStrings addObject:model.imgsrc];
            }
            SDCycleScrollView* cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*137/320) imageURLStringsGroup:imagesURLStrings];
            cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
            cycleScrollView.pageControlDotSize = CGSizeMake(5, 5);
            cycleScrollView.dotColor = [UIColor redColor];
            cycleScrollView.delegate = self;
            cycleScrollView.autoScrollTimeInterval = 4.0;
            cycleScrollView.placeholderImage = [UIImage imageNamed:@"首页顶部banner默认图"];
            [self.tableView.tableHeaderView addSubview:cycleScrollView];
            
            [self makeFooterView];
            
            
        }
            break;
        case JHGETREGIONID:
        {
            NSDictionary *dic = object;
            NSString *status = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
            if ([status isEqualToString:@"10000"]) {
                NSString *regionId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]];
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud setObject:regionId forKey:@"regionId"];
                [ud synchronize];
                [_manager getHomeActivitywithRegionId:regionId];
                
                
                
            }else if ([status isEqualToString:@"10001"]){
                NSString *regionId =[NSString stringWithFormat:@"%@",[dic objectForKey:@"data"]];
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud setObject:regionId forKey:@"regionId"];
                [ud synchronize];
                
                NSString *msg = [dic objectForKey:@"msg"];
                UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:nil message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                alertV.tag = 5;
                [alertV show];
                
                
                
            }
        }
            break;
        case JHSEARCHGOOD:
        {
            if (object==nil||((NSArray*)object).count==0) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"该区域暂未开通服务";
                [hud showAnimated:YES whileExecutingBlock:^{
                    sleep(1);
                } completionBlock:^{
                    [hud removeFromSuperview];
                    
                }];
            }else{
                
                CategoryDetailViewController *vc = [[CategoryDetailViewController alloc]init];
                vc.title = self.activity_title;
                vc.classifyId = self.classify;
                vc.datasourse = object;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case JHGETGOODDETAIL:
        {
            if ([_homeModel.redirect_type integerValue] == 4) {
                ProductDetailViewController *vc = [[ProductDetailViewController alloc] init];
                vc.fromFlag = 1000;
                vc.goodDetail   = object;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else{
                ProductDetailViewController *vc = [[ProductDetailViewController alloc] init];
                vc.goodDetail   = object;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
            
        case JHAPPVERSION:
        {
            NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
            if (![currentVersion isEqualToString:object]) {
                NSString *msg = [NSString stringWithFormat:@"你当前的版本是V%@，发现新版本V%@，是否下载新版本？",currentVersion,object];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"升级提示!" message:msg delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"现在升级", nil];
                alert.tag = 8;
                [alert show];
            }
        }
            break;
        case JHHOMEMIAOSHATIME:
        {
            NSDictionary *dic = object;
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            self.flag = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"flag"]];
            self.time =[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"time"]];
            self.flag_time =[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"flag_time"]];
            self.miaoshaImgUrl =[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"url"]];
            [self.tableView reloadData];
        }
            break;
        case JHGETSHOPINFO:
        {
            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
            [hud removeFromSuperview];
            NSArray *orderArr = object;
            
            if (orderArr==nil||orderArr.count==0) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"该区域暂未开通服务";
                [hud showAnimated:YES whileExecutingBlock:^{
                    sleep(1);
                } completionBlock:^{
                    [hud removeFromSuperview];
                    
                }];
            }else{
                ShopListViewController *vc = [[ShopListViewController alloc]initWithNibName:@"ShopListViewController" bundle:nil];
                vc.titleText = @"餐饮料理";
                vc.classify= @"B";
                vc.arr = orderArr;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
        }
            break;
        case  JHHOTWORLD:
        {
            SearchGoodViewController *vc = [[SearchGoodViewController alloc] init];
            vc.hotSearchList = [object objectForKey:@"data"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}
-(void)requestFailure:(id)failReson withRequestType:(RequestType)requestType{
    switch (requestType) {
        case JHGETREGIONID:
        {
            NSLog(@"%@",failReson);
        }
            
            break;
        case JHGETHOMEACTIVITY:
        {
            [self.header endRefreshing];
            //NSDictionary *dic = failReson;
            NSLog(@"获取首页失败");
        }
            
            break;
        case JHGETGOODDETAIL:
        {
            NSLog(@"%@",failReson);
            //NSDictionary *dic = failReson;
            NSLog(@"获取商品详情失败");
            
        }
            break;
        case JHSEARCHGOOD:{
            NSLog(@"%@",failReson);
            //NSDictionary *dic = failReson;
            NSLog(@"获取商品详情失败");
        }
            break;
        case JHGETSHOPINFO:{
            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
            [hud removeFromSuperview];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    //NSLog(@"---点击了第%ld张图片",index);
    _homeModel= self.activities[0][index];
    
    NSDictionary *dict = @{@"url" : _homeModel.url};
    [MobClick event:@"homeBannerClick" attributes:dict];
    
    
    if (_homeModel.redirect_type==nil||[_homeModel.redirect_type isKindOfClass:[NSNull class]]) {
        HomeClickActvityViewController *vc = [[HomeClickActvityViewController alloc]init];
        vc.url = _homeModel.url;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        if ([_homeModel.redirect_type integerValue] == 4) {
            [_manager getGoodDetailWithID:_homeModel.pid];
        }else if ([_homeModel.redirect_type integerValue] == 1){
            HomeClickActvityViewController *vc = [[HomeClickActvityViewController alloc]init];
            vc.url = _homeModel.url;
            [self.navigationController pushViewController:vc animated:YES];
        }else if ([_homeModel.redirect_type integerValue] == 2){
            self.activity_title = _homeModel.activity_title;
            self.classify = _homeModel.cid;
            [_manager getSearchGoodWithKeyWord:nil classify:_homeModel.cid area_id:nil sort:nil page:1];
        }else if ([_homeModel.redirect_type integerValue] == 3){
            [_manager getGoodDetailWithID:_homeModel.pid];
        }
        else if ([_homeModel.redirect_type integerValue] == 5){
            HomeNewSeveralViewController *vc = [[HomeNewSeveralViewController alloc]init];
            vc.url = _homeModel.url;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            HomeClickActvityViewController *vc = [[HomeClickActvityViewController alloc]init];
            vc.url = _homeModel.url;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
    
    
}
#pragma mark - 定位到位置之后
/**
 *  mapView协议，当update到位置时调用
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation

{

    
    self.userLocation = userLocation;//记录地址，传给下一页用
    self.geocoder = [[CLGeocoder alloc]init];
    
    //启动高德地图的poi周边搜索，传入坐标，找推荐地，如金湖山庄
    
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest*request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude];
    
    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
    // POI的类型共分为20种大类别，分别为：
    // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
    // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
    // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
    request.types = @"商务住宅|体育休闲服务|医疗保健服务|政府机构及社会团体|科教文化服务|地名地址信息|住宿服务|餐饮服务";
    request.sortrule = 0;
    request.requireExtension = YES;
    
    //发起周边搜索
    [_search AMapPOIAroundSearch: request];
    
    
    self.placeModel.latitude = userLocation.location.coordinate.latitude;
    self.placeModel.longitude = userLocation.location.coordinate.longitude;
    
    
    //获取区域id
    [_manager getRegionIDWithLatitude:userLocation.location.coordinate.latitude andlongitude:userLocation.location.coordinate.longitude];
    
    
}

-(void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    [self.locMgr stopUpdatingLocation];
    
    [self.MapView setShowsUserLocation:NO];
    [self.MapView removeFromSuperview];
    //NSLog(@"%@",response);
    if(response.pois.count == 0)
    {   [self.titleBtn setTitle:@"此区域暂未开通服务，请手动选择地址" forState:UIControlStateNormal];
        return;
    }
    
    NSMutableArray *placeArr = [NSMutableArray array];
    for (AMapPOI *p in response.pois) {
        //过滤掉没有address的
        if (p.address) {
            [placeArr addObject:p];
        }
    }
    if (placeArr.count>0) {
       // NSArray *plarr = placeArr;
        AMapPOI *p1 = placeArr[0];
        //NSLog(@"%@",p1.name);
        self.placeModel.name =p1.name;
        self.placeModel.province = p1.province;
        self.placeModel.city = p1.city;
        self.placeModel.district = p1.district;
        self.placeModel.address = p1.address;
        
        [self.titleBtn setTitle:[NSString stringWithFormat:@"送至:%@",p1.name] forState:UIControlStateNormal];
        //构造AMapReGeocodeSearchRequest对象
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
       
        regeo.location = [AMapGeoPoint locationWithLatitude:self.placeModel.latitude longitude:self.placeModel.longitude];
        regeo.radius = 10000;
        regeo.requireExtension = YES;
        
        //发起逆地理编码
        [_search AMapReGoecodeSearch: regeo];

        
    }else{
        [self.titleBtn setTitle:@"定位失败，点击手动选择地址" forState:UIControlStateNormal];
    }

}
-(void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    AMapReGeocode *code = response.regeocode;
    if (code.addressComponent) {
        AMapAddressComponent *addressComponent=code.addressComponent;
        if (addressComponent.streetNumber) {
            AMapStreetNumber *streetNumber=addressComponent.streetNumber;
            NSString *street = [NSString stringWithFormat:@"%@%@号",streetNumber.street,streetNumber.number];
            self.placeModel.street = street;
            NSString *placeModelPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"placeModel"];
            [NSKeyedArchiver archiveRootObject:self.placeModel toFile:placeModelPath];
        }
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - Table view data source
////制作headerview
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
////    if (section==2||section==0) {
////        return nil;
////    }else{
//        UIView *view = [[UIView alloc]
//                        initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
//        UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
//        topLine.backgroundColor = SEPARATELINE_COLOR;
//        [view addSubview:topLine];
//        UIView *downLine = [[UIView alloc]initWithFrame:CGRectMake(0, 7.5, SCREEN_WIDTH, 0.5)];
//        downLine.backgroundColor = SEPARATELINE_COLOR;
//        [view addSubview:downLine];
//    
//        view.backgroundColor = HEADERVIEW_COLOR;
//        return view;
//   // }
//
//}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.miaoshaImgUrl isEqualToString:BasicUrl]||[self.miaoshaImgUrl isEqualToString:@""]||self.miaoshaImgUrl==nil) {
        return 3;
    }else{
        return 4;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.miaoshaImgUrl isEqualToString:BasicUrl]||[self.miaoshaImgUrl isEqualToString:@""]||self.miaoshaImgUrl==nil){
        if (section==1) {
            NSArray *model30002arr = self.activities[1];
            return model30002arr.count;
        }else if (section==2){
            NSArray *model30004arr = self.activities[2];
            return model30004arr.count;
        }else{
            return 1;
        }
    }else{
        if (section==2) {
            NSArray *model30002arr = self.activities[1];
            return model30002arr.count;
        }else if (section==3){
            NSArray *model30004arr = self.activities[2];
            return model30004arr.count;
        }else{
            return 1;
        }
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 160;
    }
    else{
        return SCREEN_WIDTH*105/320+8;
    }
//    else{
//        NSArray *bestSellerarr= self.activities[2];
//        CGFloat vW = (SCREEN_WIDTH-12*3)/2;
//        CGFloat vH = (vW-2)*135/140+1+42;
//        return (40+bestSellerarr.count/2*(vH+12));
//       
//    }
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
////    if ([self.miaoshaImgUrl isEqualToString:BasicUrl]||[self.miaoshaImgUrl isEqualToString:@""]||self.miaoshaImgUrl==nil){
////        if (section==2) {
////            return 0;
////        }else{
////             return 8;
////        }
////       
////    }else{
////        if (section==3) {
////            return 0;
////        }else{
////            return 8;
////        }
////        
////    }
//   
//        if (section==0) {
//            return 8;
//        }else{
//            return 0;
//        }
//    
//   
//}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    if (section==0) {
//        return nil;
//    }else if (section==1){
//        return @" ";
//    }else if (section==2){
//        return @" ";
//    }else if (section==3){
//        return @" ";
//    }else{
//        return @" ";
//    }
//    
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去除分隔线
//    if (indexPath.section==0) {
//        HomeFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell0"];
//        if (!cell) {
//             cell=[[[NSBundle mainBundle]loadNibNamed:@"HomeFirstTableViewCell" owner:self options:0]firstObject];
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        cell.modelArray = self.activities[0];
//        cell.delegate = self;
//        return cell;
//        
//    }
    
    if ([self.miaoshaImgUrl isEqualToString:BasicUrl]||[self.miaoshaImgUrl isEqualToString:@""]||self.miaoshaImgUrl==nil){
        if (indexPath.section==0){
            HomeYaoyiyaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
            if (!cell) {
                cell= [[[NSBundle mainBundle]loadNibNamed:@"HomeYaoyiyaoTableViewCell" owner:self options:0]firstObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        
        else if (indexPath.section==1){
            HomeOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell1"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"HomeOtherTableViewCell" owner:self options:0]firstObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray *model30002arr = self.activities[1];
            cell.model = model30002arr[indexPath.row];
            return cell;
        }
        else{
            HomeOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell1"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"HomeOtherTableViewCell" owner:self options:0]firstObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray *model30004arr = self.activities[2];
            cell.model = model30004arr[indexPath.row];
            return cell;
        }
        //     else{
        //        HomeBestSellerTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"HomeBestSellerTableViewCell" owner:self options:0]firstObject];
        ////        if (!cell) {
        ////            cell = [[[NSBundle mainBundle]loadNibNamed:@"HomeBestSellerTableViewCell" owner:self options:0]firstObject];
        ////       }
        //        cell.delegate = self;
        //        cell.bestSellerArr = self.activities[2];
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        return cell;
        //    }
    }else{
        if (indexPath.section==0){
            HomeYaoyiyaoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
            if (!cell) {
                cell= [[[NSBundle mainBundle]loadNibNamed:@"HomeYaoyiyaoTableViewCell" owner:self options:0]firstObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.section==1){
            //秒杀
            HomeMiaoShaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"miao"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"HomeMiaoShaTableViewCell" owner:self options:0]firstObject];
            }
            cell.flag = self.flag;
            cell.flag_time = self.flag_time;
            cell.time = self.time;
            cell.imgUrl = self.miaoshaImgUrl;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if (indexPath.section==2){
            HomeOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell1"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"HomeOtherTableViewCell" owner:self options:0]firstObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray *model30002arr = self.activities[1];
            cell.model = model30002arr[indexPath.row];
            return cell;
        }
        else{
            HomeOtherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell1"];
            if (!cell) {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"HomeOtherTableViewCell" owner:self options:0]firstObject];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray *model30004arr = self.activities[2];
            cell.model = model30004arr[indexPath.row];
            return cell;
        }
        //     else{
        //        HomeBestSellerTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"HomeBestSellerTableViewCell" owner:self options:0]firstObject];
        ////        if (!cell) {
        ////            cell = [[[NSBundle mainBundle]loadNibNamed:@"HomeBestSellerTableViewCell" owner:self options:0]firstObject];
        ////       }
        //        cell.delegate = self;
        //        cell.bestSellerArr = self.activities[2];
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        return cell;
        //    }

    }
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.miaoshaImgUrl isEqualToString:BasicUrl]||[self.miaoshaImgUrl isEqualToString:@""]||self.miaoshaImgUrl==nil){
        if (indexPath.section==1) {
            NSArray *model30002arr = self.activities[1];
            HomeActivityModel *model = model30002arr[indexPath.row];
            
            NSDictionary *dict = @{@"url" : model.url};
            [MobClick event:@"homeBannerClick" attributes:dict];
            
            
            if (model.redirect_type==nil||[model.redirect_type isKindOfClass:[NSNull class]]) {
                HomeClickActvityViewController *vc =[[HomeClickActvityViewController alloc]init];
                vc.url = model.url;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                NSInteger i = [model.redirect_type integerValue];
                switch (i) {
                    case 1:
                    {
                        HomeClickActvityViewController *vc = [[HomeClickActvityViewController alloc]init];
                        vc.url = model.url;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case 2:
                    {
                        self.activity_title = model.activity_title;
                        self.classify = model.cid;
                        [_manager getSearchGoodWithKeyWord:nil classify:model.cid area_id:nil sort:nil page:1];
                    }
                        break;
                        
                    case 3:
                    {
                        [_manager getGoodDetailWithID:_homeModel.pid];
                    }
                        break;
                    case 4:
                    {
                        HomeClickActvityViewController *vc = [[HomeClickActvityViewController alloc]init];
                        vc.url = _homeModel.url;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case 5:
                    {
                        
                        HomeNewSeveralViewController *vc = [[HomeNewSeveralViewController alloc]init];
                        vc.url = model.url;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                        
                    }
                    default:
                        break;
                }
            }
            
        }
        else if (indexPath.section==2) {
            NSArray *model30004arr = self.activities[2 ];
            HomeActivityModel *model = model30004arr[indexPath.row];
            
            NSDictionary *dict = @{@"url" : model.url};
            [MobClick event:@"homeBannerClick" attributes:dict];
            
            
            if (model.redirect_type==nil||[model.redirect_type isKindOfClass:[NSNull class]]) {
                HomeClickActvityViewController *vc =[[HomeClickActvityViewController alloc]init];
                vc.url = model.url;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                NSInteger i = [model.redirect_type integerValue];
                switch (i) {
                    case 1:
                    {
                        HomeClickActvityViewController *vc = [[HomeClickActvityViewController alloc]init];
                        vc.url = model.url;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case 2:
                    {
                        self.activity_title = model.activity_title;
                        self.classify = model.cid;
                        [_manager getSearchGoodWithKeyWord:nil classify:model.cid area_id:nil sort:nil page:1];
                    }
                        break;
                        
                    case 3:
                    {
                        [_manager getGoodDetailWithID:_homeModel.pid];
                    }
                        break;
                    case 4:
                    {
                        HomeClickActvityViewController *vc = [[HomeClickActvityViewController alloc]init];
                        vc.url = _homeModel.url;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case 5:
                    {
                        //[_manager getHomeNewBannerInfoWithurl:model.url];
                        HomeNewSeveralViewController *vc = [[HomeNewSeveralViewController alloc]init];
                        vc.url = model.url;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }
                    default:
                        break;
                }
            }
            
        }

    }else{
        if (indexPath.section==1) {
            UIStoryboard *miaoSB = [UIStoryboard storyboardWithName:@"MiaoSha" bundle:nil];
            MiaoShaListTableViewController *vc = [miaoSB instantiateViewControllerWithIdentifier:@"m1"];
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.section==2) {
            NSArray *model30002arr = self.activities[1];
            HomeActivityModel *model = model30002arr[indexPath.row];
            
            NSDictionary *dict = @{@"url" : model.url};
            [MobClick event:@"homeBannerClick" attributes:dict];
            
            
            if (model.redirect_type==nil||[model.redirect_type isKindOfClass:[NSNull class]]) {
                HomeClickActvityViewController *vc =[[HomeClickActvityViewController alloc]init];
                vc.url = model.url;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                NSInteger i = [model.redirect_type integerValue];
                switch (i) {
                    case 1:
                    {
                        HomeClickActvityViewController *vc = [[HomeClickActvityViewController alloc]init];
                        vc.url = model.url;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case 2:
                    {
                        self.activity_title = model.activity_title;
                        self.classify = model.cid;
                        [_manager getSearchGoodWithKeyWord:nil classify:model.cid area_id:nil sort:nil page:1];
                    }
                        break;
                        
                    case 3:
                    {
                        [_manager getGoodDetailWithID:_homeModel.pid];
                    }
                        break;
                    case 4:
                    {
                        HomeClickActvityViewController *vc = [[HomeClickActvityViewController alloc]init];
                        vc.url = _homeModel.url;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case 5:
                    {
                        
                        HomeNewSeveralViewController *vc = [[HomeNewSeveralViewController alloc]init];
                        vc.url = model.url;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                        
                    }
                    default:
                        break;
                }
            }
            
        }
        else if (indexPath.section==3) {
            NSArray *model30004arr = self.activities[2 ];
            HomeActivityModel *model = model30004arr[indexPath.row];
            
            NSDictionary *dict = @{@"url" : model.url};
            [MobClick event:@"homeBannerClick" attributes:dict];
            
            
            if (model.redirect_type==nil||[model.redirect_type isKindOfClass:[NSNull class]]) {
                HomeClickActvityViewController *vc =[[HomeClickActvityViewController alloc]init];
                vc.url = model.url;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                NSInteger i = [model.redirect_type integerValue];
                switch (i) {
                    case 1:
                    {
                        HomeClickActvityViewController *vc = [[HomeClickActvityViewController alloc]init];
                        vc.url = model.url;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case 2:
                    {
                        self.activity_title = model.activity_title;
                        self.classify = model.cid;
                        [_manager getSearchGoodWithKeyWord:nil classify:model.cid area_id:nil sort:nil page:1];
                    }
                        break;
                        
                    case 3:
                    {
                        [_manager getGoodDetailWithID:_homeModel.pid];
                    }
                        break;
                    case 4:
                    {
                        HomeClickActvityViewController *vc = [[HomeClickActvityViewController alloc]init];
                        vc.url = _homeModel.url;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                        break;
                    case 5:
                    {
                        //[_manager getHomeNewBannerInfoWithurl:model.url];
                        HomeNewSeveralViewController *vc = [[HomeNewSeveralViewController alloc]init];
                        vc.url = model.url;
                        [self.navigationController pushViewController:vc animated:YES];
                        
                    }
                    default:
                        break;
                }
            }
            
        }

    }
    
}
-(void)dealloc{
   
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"addressConfirmToHome" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"homeYaoyiyaoClicked" object:nil];
   [self.header free];
    
}
@end
