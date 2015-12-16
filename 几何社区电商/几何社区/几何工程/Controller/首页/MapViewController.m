//
//  MapViewController.m
//  几何社区
//
//  Created by KMING on 15/8/17.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "MapViewController.h"
#import "Define.h"
#import "MBProgressHUD.h"
#import "ChooseProvinceView.h"
#import "UIView+Extension.h"
#import "SearchStreetViewController.h"
#import "PlaceSearchResultModel.h"
#import "HomeMapAddressTableViewCell.h"
#import "MyAddressModel.h"
#import "WGS84TOGCJ02.h"
@interface MapViewController ()
{
    AMapSearchAPI *_search;
}
@property (nonatomic, strong) CLLocationManager *mgr;
@property (nonatomic,copy)NSString *screenCenterPlace;//地图屏幕中央的位置
@property (nonatomic,strong)UIImageView *annoimageview;//中间红色不动的大头针
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)UILabel *addLbl;//上面地址label

@property (nonatomic,copy)NSString *City;
@property (nonatomic,copy)NSString *SubLocality;
@property (nonatomic,copy)NSString *Street;
@property (nonatomic,copy)NSString *state;
@property (nonatomic,strong)PlaceSearchResultModel *placeModel;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *addressArr;//

@property (nonatomic,strong)UIImageView *addbg;
@property (nonatomic,strong)UILabel *usuallyAdd;
@property (nonatomic,strong)UIButton *shouqiBtn;
@property (nonatomic,strong)UIButton *locateAgaionBtn;
@end

@implementation MapViewController

-(void)viewWillAppear:(BOOL)animated{
    [self makeNavigation];
    [super viewWillAppear:animated];
    _manager.delegate = self;
    
    [MobClick beginLogPageView:@"MapViewController"];
}
#pragma mark - 监听到点击城市之后的函数,切换地图到该位置
-(void)AlreadyChooseCity:(NSNotification*)notification{
    //NSLog(@"选择城市");
    [self.mgr stopUpdatingLocation];
    
    NSDictionary *nameDictionary = [notification object];
    NSString *address = [nameDictionary objectForKey:@"name"];
    NSString *address2 = [address stringByAppendingString:@"市"];
    self.locatecity = address;
    [self.rightBtn setTitle:address forState:UIControlStateNormal];//右上角城市名字更改
    /**
     *  重新切换地图位置到该城市
     *
     */
    [self.geocoder geocodeAddressString:address2 completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *mymark = [placemarks firstObject];
        
        
        if ([address isEqualToString:@"深圳"]) {
            CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(22.55, 114.04);
            MKCoordinateSpan span = MKCoordinateSpanMake(0.2,0.2);
            MKCoordinateRegion region = MKCoordinateRegionMake(loc, span);
            [self.myMapView setRegion:region animated:YES];
        }
        else{
            CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(mymark.location.coordinate.latitude, mymark.location.coordinate.longitude);
            
            MKCoordinateSpan span = MKCoordinateSpanMake(0.2,0.2);
            MKCoordinateRegion region = MKCoordinateRegionMake(loc, span);
            [self.myMapView setRegion:region animated:YES];
        }
    }];

}
#pragma mark - 监听到街道搜索的cell点击
-(void)AlreadyChooseStreet:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification object];
    PlaceSearchResultModel *model = [nameDictionary objectForKey:@"model"];
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(model.latitude, model.longitude);
    // 指定经纬度的跨度
    MKCoordinateSpan span = MKCoordinateSpanMake(0.009310,0.007812);
    // 将用户当前的位置作为显示区域的中心点, 并且指定需要显示的跨度范围
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    
    // 设置显示区域
    [self.myMapView setRegion:region animated:YES];
    
    self.addLbl.text = model.name;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    _manager = [JHDataManager getInstance];
    _manager.delegate = self;
    //配置用户Key
    [AMapSearchServices sharedServices].apiKey = AMAPKEY;
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    self.geocoder = [[CLGeocoder alloc]init];
    self.placeModel = [[PlaceSearchResultModel alloc]init];
    /**
     *  监听选择城市的点击事件
     *
     */
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AlreadyChooseCity:) name:@"choosecity" object:nil];
    /****监听poi搜索页面的cell点击***/
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AlreadyChooseStreet:) name:@"choosestreet" object:nil];
    
    [self makeMapView];
//    if (self.userLocation!=nil) {
//            //上一个页面传来的位置，可以直接让地图过来
//            CLLocationCoordinate2D center = self.userLocation.location.coordinate;
//            // 指定经纬度的跨度
//            MKCoordinateSpan span = MKCoordinateSpanMake(0.1,0.1);//MKCoordinateSpanMake(0.009310,0.007812);
//            // 将用户当前的位置作为显示区域的中心点, 并且指定需要显示的跨度范围
//            MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
//            
//            // 设置显示区域
//            [self.myMapView setRegion:region animated:YES];
//        
//    }
   [self makeAnnotation];
   [self makeUsuallyAddress];
}
#pragma mark - 常用地址
-(void)makeUsuallyAddress{
    //常用地址的背景
    self.addbg = [[UIImageView alloc]initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-24, 40)];
    self.addbg.image = [UIImage imageNamed:@"may_bg"];
    //addbg.alpha=0.8;
    self.addbg.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-12-30);
    [self.view addSubview:self.addbg];
    //常用地址文字label
    self.usuallyAdd= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.usuallyAdd.center = CGPointMake(self.addbg.frame.origin.x+10+50, self.addbg.center.y);
    self.usuallyAdd.text= @"常用地址";
    //usuallyAdd.textColor = [UIColor blackColor];
    self.usuallyAdd.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.usuallyAdd];
    //收起的button
    self.shouqiBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    self.shouqiBtn.center = CGPointMake(self.addbg.frame.origin.x+self.addbg.frame.size.width-20, self.addbg.center.y);
    [self.shouqiBtn setTitle:@"弹出" forState:UIControlStateNormal];
    [self.shouqiBtn setTitle:@"收起" forState:UIControlStateSelected];
    [self.shouqiBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.shouqiBtn addTarget:self action:@selector(shouqiAddressBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.shouqiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.shouqiBtn.selected = NO;
    [self.view addSubview:self.shouqiBtn];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(self.addbg.frame.origin.x,SCREEN_HEIGHT-132-20 , self.addbg.frame.size.width, 132)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.layer.cornerRadius = 3;
    self.tableView.bounces = NO;
    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
    NSDictionary *dic =@{@"page":@"1"};
    [_manager getAddressWithParams:dic];
    
    
    self.locateAgaionBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-12-32, 0, 32, 32)];
    self.locateAgaionBtn.center = CGPointMake(SCREEN_WIDTH-12-16, self.addbg.center.y-30-12);
    [self.locateAgaionBtn setImage:[UIImage imageNamed:@"Location"] forState:UIControlStateNormal];
    [self.locateAgaionBtn addTarget:self action:@selector(locateAgaion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.locateAgaionBtn];
}
-(void)shouqiAddressBtn:(UIButton*)btn{
    btn.selected = !btn.selected;
    if (btn.selected ==YES) {
        self.tableView.hidden = NO;
        self.addbg.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-12-30-132);
        self.usuallyAdd.center = CGPointMake(self.addbg.frame.origin.x+10+50, self.addbg.center.y);
        self.shouqiBtn.center = CGPointMake(self.addbg.frame.origin.x+self.addbg.frame.size.width-20, self.addbg.center.y);
        self.locateAgaionBtn.center = CGPointMake(SCREEN_WIDTH-12-16, self.addbg.center.y-30-12);
    }else{
        self.tableView.hidden = YES;
        self.addbg.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-12-30);
        self.usuallyAdd.center = CGPointMake(self.addbg.frame.origin.x+10+50, self.addbg.center.y);
        self.shouqiBtn.center = CGPointMake(self.addbg.frame.origin.x+self.addbg.frame.size.width-20, self.addbg.center.y);
        self.locateAgaionBtn.center = CGPointMake(SCREEN_WIDTH-12-16, self.addbg.center.y-30-12);
    }
}
-(void)requestSuccess:(id)object withRequestType:(RequestType)requestType{
    switch (requestType) {
        case JHGETADDRESS:
        {
            self.addressArr = object;
            [self.tableView reloadData];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark  -tableview相关
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.addressArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyAddressModel *model = self.addressArr[indexPath.row];
    
    HomeMapAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HomeMapAddressTableViewCell" owner:self options:0]firstObject];
    
    }
    cell.label.text = model.address;
    cell.label.textColor = Color757575;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MyAddressModel *model = self.addressArr[indexPath.row];
    
    double latitude = [model.latitude doubleValue];
    double longtitude = [model.longtitude doubleValue];
    CLLocationCoordinate2D coo = CLLocationCoordinate2DMake(latitude, longtitude);
    CLLocationCoordinate2D newcll= [WGS84TOGCJ02 locationMarsFromBaidu:coo];
   CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(newcll.latitude, newcll.longitude);
    MKCoordinateSpan span = MKCoordinateSpanMake(0.009310,0.007812);
    // 将用户当前的位置作为显示区域的中心点, 并且指定需要显示的跨度范围
    MKCoordinateRegion region = MKCoordinateRegionMake(loc, span);
    
    // 设置显示区域
    [self.myMapView setRegion:region animated:YES];
    
    
   
}


#pragma mark - 制作中间大头针和上面的view
-(void)makeAnnotation{
    /**
     添加红色的大头针
     */
    self.annoimageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 16, 37)];
    self.annoimageview.center = CGPointMake(self.myMapView.center.x, self.myMapView.center.y-self.annoimageview.frame.size.height/2);
    self.annoimageview.image = [UIImage imageNamed:@"may副本"];
    [self.view addSubview:self.annoimageview];
    //大头针上面的背景
    UIImageView *annotop = [[UIImageView alloc]initWithFrame:CGRectMake(12, 0, SCREEN_WIDTH-24, 40)];
    annotop.image = [UIImage imageNamed:@"add_bg"];
    //annotop.alpha=0.8;
    annotop.center = CGPointMake(SCREEN_WIDTH/2, 96);
    [self.view addSubview:annotop];
    
    UIImageView *editImgV = [[UIImageView alloc]initWithFrame:CGRectMake(annotop.frame.origin.x+10, 0, 16, 16)];
    editImgV.centerY = annotop.centerY;
    editImgV.image = [UIImage imageNamed:@"bj"];
    [self.view addSubview:editImgV];
    UIView *rigntLine = [[UIView alloc]initWithFrame:CGRectMake(editImgV.x+24, annotop.centerY-6, 0.5, 12)];
    rigntLine.backgroundColor = Color757575;
    //rigntLine.alpha=0.8;
    [self.view addSubview:rigntLine];
    
    self.addLbl = [[UILabel alloc]initWithFrame:CGRectMake(rigntLine.centerX+8, 0, annotop.width-30-45, 15)];
    self.addLbl.font = [UIFont systemFontOfSize:15];
    self.addLbl.alpha=0.8;
    self.addLbl.textColor = Color757575;
    //addLbl.text = @"金湖山庄D1栋";
    self.addLbl.centerY = annotop.centerY;
    [self.view addSubview:self.addLbl];
    
    UIButton *selectAddBtn = [[UIButton alloc]initWithFrame:CGRectMake(annotop.x, annotop.y, annotop.width-45, annotop.height)];
    [selectAddBtn addTarget:self action:@selector(goToSearchView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectAddBtn];
    //右边蓝色确定
    UIImageView *annorightblue =[[UIImageView alloc]initWithFrame:CGRectMake(annotop.frame.origin.x+annotop.frame.size.width-45, annotop.frame.origin.y, 45, 40)];
    annorightblue.image = [UIImage imageNamed:@"may_nl"];
    annorightblue.alpha=0.8;
    [self.view addSubview:annorightblue];
    
    UIButton *annorightbtn = [[UIButton alloc]initWithFrame:CGRectMake(annotop.frame.origin.x+annotop.frame.size.width-45, annotop.frame.origin.y, 45, 40)];
    [annorightbtn setTitle:@"确定" forState:UIControlStateNormal];
    [annorightbtn addTarget:self action:@selector(addressConfirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:annorightbtn];
    
    
    
    
    
}
-(void)locateAgaion{
    if (self.locateLocation) {
        // 获取用户的位置
        CLLocationCoordinate2D center = self.locateLocation.location.coordinate;
        // 指定经纬度的跨度
        MKCoordinateSpan span = MKCoordinateSpanMake(0.009310,0.007812);
        // 将用户当前的位置作为显示区域的中心点, 并且指定需要显示的跨度范围
        MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
        
        // 设置显示区域
        [self.myMapView setRegion:region animated:YES];
    }
}
#pragma mark - 确定地址，跳回上一个页面
-(void)addressConfirmAction{
    if ([self.addLbl.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"地址不能为空";
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(2);
        } completionBlock:^{
            [hud removeFromSuperview];
            
        }];
    }else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"addressConfirmToHome" object:@{@"model":self.placeModel}];
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }
}
#pragma mark - 编辑地址去搜索地址页面
-(void)goToSearchView{
    SearchStreetViewController *vc = [[SearchStreetViewController alloc]initWithNibName:@"SearchStreetViewController" bundle:nil];
    if ([self.locatecity isEqualToString:@"选择城市"]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请先选择城市";
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [hud removeFromSuperview];
        }];
    }else{
        vc.searchCity = self.locatecity;
        vc.isHomePush = @"1";
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}
#pragma mark - 初始化地图，未开启定位默认选择深圳
-(void)makeMapView{
    self.myMapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [self.view addSubview:self.myMapView];
    
    
    
    /**
     *  未打开定位时，默认显示深圳的地图
     *
     */
    
    if ((![CLLocationManager locationServicesEnabled])||([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)) {
        //NSLog(@"定位服务当前可能尚未打开，请设置打开！");
            CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(22.55, 114.04);//深圳某处坐标
            MKCoordinateSpan span = MKCoordinateSpanMake(0.21,0.21);
            MKCoordinateRegion region = MKCoordinateRegionMake(loc, span);
            [self.myMapView setRegion:region animated:YES];
            [self getCenterPlace];
//        self.locatecity = @"深圳";
//        [self.rightBtn setTitle:@"深圳" forState:UIControlStateNormal];
    }
    if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
        // 主动请求权限
        self.mgr = [[CLLocationManager alloc] init];
        
       // [self.mgr requestWhenInUseAuthorization];
    }
    
    // 设置不允许地图旋转
    self.myMapView.rotateEnabled = NO;
    [self.myMapView setShowsUserLocation:YES];
    self.myMapView.delegate = self;
    self.myMapView.userTrackingMode = MKUserTrackingModeFollow;
}
#pragma mark - 初始化导航栏样子
-(void)makeNavigation{
    self.title = @"地图位置确认";
//    [self setNavColor:[UIColor whiteColor]];
    [self setNavTitleColor:[UIColor blackColor]];
    [self setLeftNavButtonWithType:BACK];
    self.rightBtn = [[HWTitleButton alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    [self.rightBtn setTitle:self.locatecity forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor colorWithRed:0.980 green:0.129 blue:0.110 alpha:1.000] forState:UIControlStateNormal];
    
    [self.rightBtn setImage:[UIImage imageNamed:@"downArrow"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(chooseCity) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightbarbutton = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    
//    //修正偏移
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    negativeSpacer.width = 20;
   //self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rightbarbutton,negativeSpacer, nil];
    self.navigationItem.rightBarButtonItem = rightbarbutton;
}
#pragma mark - 选择城市
-(void)chooseCity{
    self.backAlphaView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.backAlphaView.backgroundColor = [UIColor blackColor];
    self.backAlphaView.alpha = 0.7;
    /**
     *  在keywindow上添加，不在self.view上添加,因为会被navigationbar遮挡
     */
    [[UIApplication sharedApplication].keyWindow addSubview:self.backAlphaView];
    ChooseProvinceView *provinceView = [[[NSBundle mainBundle]loadNibNamed:@"ChooseProvinceView" owner:self options:0]firstObject];
    provinceView.delegate = self;
    provinceView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH/7*6, SCREEN_HEIGHT);
    [[UIApplication sharedApplication].keyWindow addSubview:provinceView];
    [UIView animateWithDuration:0.4 animations:^{
        provinceView.frame = CGRectMake(SCREEN_WIDTH/7, 0, SCREEN_WIDTH/7*6, SCREEN_HEIGHT);
    }];
}

#pragma mark - 每次更新到用户位置
/**
 *  每次更新到用户的位置就会调用(调用不频繁, 只有位置改变才会调用)
 *
 *  @param mapView      促发事件的控件
 *  @param userLocation 大头针模型
 */
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
   // [self getCenterPlace];
    /**
     利用反地理编码获取位置之后设置标题
     */
    self.locateLocation = userLocation;
    [self.geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        NSDictionary *adddic = placemark.addressDictionary;//地址的字典
        //NSLog(@"获取地理位置成功 name = %@ locality = %@", placemark.name, placemark.locality);
        NSString *place = [NSString stringWithFormat:@"%@%@%@",[adddic objectForKey:@"City"],[adddic objectForKey:@"SubLocality"],[adddic objectForKey:@"Street"]];
        NSString *locatecity =[adddic objectForKey:@"City"];
        if ([locatecity hasSuffix:@"市"]) {
            
            NSRange range =[locatecity rangeOfString:@"市"];
            locatecity = [locatecity stringByReplacingCharactersInRange:range withString:@""];
            
        }
        //[self.rightBtn setTitle:locatecity forState:UIControlStateNormal];
        if (locatecity==nil||[locatecity isEqualToString:@""]) {
            locatecity = @"选择城市";
        }
        static dispatch_once_t onceToken;//防止多次更改标题，用户选择的和定位的可能不同
        dispatch_once(&onceToken,^{

        [self.rightBtn setTitle:locatecity forState:UIControlStateNormal];
        });
        
        userLocation.title = @"当前定位位置";
        userLocation.subtitle = place;
        
    }];
    
    
    /**
     *  调用下面定义的方法，让程序第一次地图定位时候显示定位的位置（ios7），ios8会自动显示的
     */
    [self firstSetLocateToScreenCenter:userLocation];
    
    /**
     *  停止定位，但是没效果，所以离开页面时候，删除地图，否则苹果右上角一直会有一个定位图标，用户会不喜欢的
     */
    
    [self.mgr stopUpdatingLocation];
    
    
}
#pragma mark -让程序第一次地图定位时候显示定位的位置（ios7）
-(void)firstSetLocateToScreenCenter:(MKUserLocation*)userLocation{
    /**
     *  用dispatch once保证在程序中虽然协议执行多次，但是里面的设置中心只执行第一次，否则拖动地图时地图总是弹回去
     */
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        /**
         *  ios8设置完self.myMapView.userTrackingMode = MKUserTrackingModeFollow后会缩放，但是ios7不行，要加上下面的，让ios7也缩放
         */
        // 移动地图到当前用户所在位置
        // 获取用户当前所在位置的经纬度, 并且设置为地图的中心点
        //[self.myMapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
        
        // 设置地图显示的区域
        // 获取用户的位置
        CLLocationCoordinate2D center = userLocation.location.coordinate;
        // 指定经纬度的跨度
        MKCoordinateSpan span = MKCoordinateSpanMake(0.009310,0.007812);
        // 将用户当前的位置作为显示区域的中心点, 并且指定需要显示的跨度范围
        MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
        
        // 设置显示区域
        [self.myMapView setRegion:region animated:YES];
        
    });
}
#pragma mark -地图的区域改变完成时调用，即拖动地图或者缩放地图

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{   [self.mgr stopUpdatingLocation];
    //NSLog(@"地图的区域改变完成时调用");

        [self getCenterPlace];

    
    
    
}
#pragma mark -获取屏幕中心的地图位置,用timer调用
/**
 *  获取屏幕中心的地图位置,用timer调用，否则会有时不显示，有bug
 */
-(void)getCenterPlace{
    
    
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(getCenterPlaceName) userInfo:nil repeats:NO];

    
}
#pragma mark -获取屏幕中心的地图位置
-(void)getCenterPlaceName{
    
    //启动高德地图的poi周边搜索，传入坐标，找推荐地，如金湖山庄
    
    //构造AMapPOIAroundSearchRequest对象，设置周边请求参数
    AMapPOIAroundSearchRequest*request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location = [AMapGeoPoint locationWithLatitude:self.myMapView.centerCoordinate.latitude longitude:self.myMapView.centerCoordinate.longitude];
    
    // types属性表示限定搜索POI的类别，默认为：餐饮服务|商务住宅|生活服务
    // POI的类型共分为20种大类别，分别为：
    // 汽车服务|汽车销售|汽车维修|摩托车服务|餐饮服务|购物服务|生活服务|体育休闲服务|
    // 医疗保健服务|住宿服务|风景名胜|商务住宅|政府机构及社会团体|科教文化服务|
    // 交通设施服务|金融保险服务|公司企业|道路附属设施|地名地址信息|公共设施
    request.types = @"商务住宅|体育休闲服务|医疗保健服务|政府机构及社会团体|科教文化服务|风景名胜|地名地址信息";
    request.sortrule = 0;
    request.requireExtension = YES;
    
    //发起周边搜索
    [_search AMapPOIAroundSearch: request];
    
    self.placeModel.latitude = self.myMapView.centerCoordinate.latitude;
    self.placeModel.longitude = self.myMapView.centerCoordinate.longitude;
    
    

}
//实现POI搜索对应的回调函数
-(void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    //NSLog(@"%@",response);
    if(response.pois.count == 0)
    {   self.addLbl.text = @"";
        return;
    }
    
    //通过AMapPlaceSearchResponse对象处理搜索结果
    //NSString *strCount = [NSString stringWithFormat:@"count: %ld",response.count];
    //    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
    NSMutableArray *placeArr = [NSMutableArray array];
    for (AMapPOI *p in response.pois) {
        
        
        //过滤掉没有address的
        if (![p.address isEqualToString:@""] ) {
            [placeArr addObject:p];
        }
    }if (placeArr.count>0) {
        AMapPOI *p1 = placeArr[0];
        //NSLog(@"%@",p1.name);
        self.locatecity = p1.city;
        NSString *city = p1.city;
        if ([city hasSuffix:@"市"]) {
            NSRange range =[city rangeOfString:@"市"];
            city = [city stringByReplacingCharactersInRange:range withString:@""];
        }
        //NSLog(@"%f",self.myMapView.region.span.latitudeDelta);
        if (self.myMapView.region.span.latitudeDelta<25) {
            [self.rightBtn setTitle:city forState:UIControlStateNormal];
        }
        
        self.placeModel.name =p1.name;
        self.placeModel.province = p1.province;
        self.placeModel.city = p1.city;
        self.placeModel.district = p1.district;
        self.placeModel.address = p1.address;
//        CLLocation *location =[[CLLocation alloc]initWithLatitude:self.placeModel.latitude longitude:self.placeModel.longitude];
//        [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
//            CLPlacemark *placemark = [placemarks firstObject];
//            NSDictionary *adddic = placemark.addressDictionary;//反地理编码获取的地址字典
//            
//            NSString* Street =[adddic objectForKey:@"Street"];
//            if ([adddic objectForKey:@"Street"]==NULL) {
//                Street = @"";
//            }
//            self.placeModel.street = Street;
//            if (self.myMapView.region.span.latitudeDelta<25) {
//                self.addLbl.text = p1.name;
//            }else{
//                self.addLbl.text = @"定位中，请稍后...";
//            }
//            
//        }];
        
        //构造AMapReGeocodeSearchRequest对象
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        
        regeo.location = [AMapGeoPoint locationWithLatitude:self.placeModel.latitude longitude:self.placeModel.longitude];
        regeo.radius = 10000;
        regeo.requireExtension = YES;
        
        //发起逆地理编码
        [_search AMapReGoecodeSearch: regeo];
        
        
    }else{
        self.addLbl.text = @"";
    }

}

-(void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    if (self.myMapView.region.span.latitudeDelta<25) {
        self.addLbl.text = self.placeModel.name;
       
    }else{
        
        self.addLbl.text = @"定位中，请稍后...";
    }
    AMapReGeocode *code = response.regeocode;
    if (code.addressComponent) {
        AMapAddressComponent *addressComponent=code.addressComponent;
        if (addressComponent.streetNumber) {
            AMapStreetNumber *streetNumber=addressComponent.streetNumber;
            NSString *street = [NSString stringWithFormat:@"%@%@号",streetNumber.street,streetNumber.number];
            self.placeModel.street = street;
            
        }
    }
    
}

#pragma mark - 页面将要离开
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   [MobClick endLogPageView:@"MapViewController"];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    /**
     *  页面销毁时候，删除地图，否则苹果右上角一直会有一个定位图标，用户会不喜欢的
     */
    [self.myMapView removeFromSuperview];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"choosecity" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"choosestreet" object:nil];
    
    [self.timer invalidate];

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
