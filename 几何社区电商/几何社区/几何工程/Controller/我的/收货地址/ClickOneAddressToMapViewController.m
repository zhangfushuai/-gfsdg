//
//  ClickOneAddressToMapViewController.m
//  几何社区
//
//  Created by KMING on 15/9/1.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "ClickOneAddressToMapViewController.h"
#import "Define.h"
#import "AddAddressViewController.h"
#import "PlaceSearchResultModel.h"

@interface ClickOneAddressToMapViewController ()
{
    AMapSearchAPI *_search;
}
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic ,strong) CLGeocoder *geocoder;
@property (nonatomic,copy)NSString *screenCenterPlace;//地图屏幕中央的位置
@property (nonatomic,strong)UIImageView *annoimageview;//中间红色不动的大头针
@property (nonatomic,strong)UILabel *downtitle;//推荐地址
@property (nonatomic,copy)NSString *City;
@property (nonatomic,copy)NSString *SubLocality;
@property (nonatomic,copy)NSString *Street;
@property (nonatomic,copy)NSString *state;
@property (nonatomic,strong)PlaceSearchResultModel *placeModel;
@end

@implementation ClickOneAddressToMapViewController
-(void)viewWillAppear:(BOOL)animated{
    [self makeNavigation];
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ClickOneAddressToMapViewController"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
     [MobClick endLogPageView:@"ClickOneAddressToMapViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.placeModel = [[PlaceSearchResultModel alloc]init];
    //配置用户Key
    [AMapSearchServices sharedServices].apiKey = AMAPKEY;
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    self.geocoder = [[CLGeocoder alloc]init];//初始化反地理编码控件
    
    [self makeMapView];
    [self makeAnnotation];
    
}

#pragma mark - 初始化导航栏样子
-(void)makeNavigation{
    self.title = @"地图位置确认";
    [self setLeftNavButtonWithType:BACK];
    [self setNavTitleColor:[UIColor blackColor]];
//    [self setNavColor:[UIColor whiteColor]];
}

#pragma mark -地图的区域改变完成时调用，即拖动地图或者缩放地图

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
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
-(void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    if(response.pois.count == 0)
    {   self.downtitle.text = [NSString stringWithFormat:@"推荐地址:%@",@""];
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
        AMapPOI *p1 = placeArr[0];
        //NSLog(@"%@",p1.name);
        self.placeModel.name =p1.name;
        self.placeModel.province = p1.province;
        self.placeModel.city = p1.city;
        self.placeModel.district = p1.district;
        self.placeModel.address = p1.address;
        
        //构造AMapReGeocodeSearchRequest对象
        AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
        
        regeo.location = [AMapGeoPoint locationWithLatitude:self.placeModel.latitude longitude:self.placeModel.longitude];
        regeo.radius = 10000;
        regeo.requireExtension = YES;
        
        //发起逆地理编码
        [_search AMapReGoecodeSearch: regeo];
        
    }else{
        self.downtitle.text = [NSString stringWithFormat:@"推荐地址:%@",@""];
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
            self.downtitle.text = [NSString stringWithFormat:@"推荐地址:%@",self.placeModel.name];
        }
    }
    
}


#pragma mark - 初始化地图，显示上一个页面poi搜索的那个地址
-(void)makeMapView{
    
    
        CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(self.latitude, self.longitude);//上个页面选择地址的坐标
        MKCoordinateSpan span = MKCoordinateSpanMake(0.009310,0.007812);
        MKCoordinateRegion region = MKCoordinateRegionMake(loc, span);
        [self.myMapView setRegion:region animated:YES];
        self.myMapView.delegate = self;
        self.myMapView.rotateEnabled = NO;
}

#pragma mark - 大头针和上面的view
-(void)makeAnnotation{
    /**
     添加红色的大头针
     */
    self.annoimageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 22, 32)];
    self.annoimageview.center = CGPointMake(SCREEN_WIDTH/2, (SCREEN_HEIGHT-64)/2);
    self.annoimageview.image = [UIImage imageNamed:@"icon"];
    [self.view addSubview:self.annoimageview];
    //大头针上面的背景
    UIImageView *annotop = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/10*9, 60)];
    annotop.image = [UIImage imageNamed:@"may"];
    annotop.alpha=0.8;
    annotop.center = CGPointMake(self.annoimageview.center.x, self.annoimageview.center.y-50);
    [self.view addSubview:annotop];
    
    UILabel *toptitle = [[UILabel alloc]initWithFrame:CGRectMake(annotop.frame.origin.x+10, annotop.frame.origin.y+5, SCREEN_WIDTH/10*9-10-60, 20)];
    if (SCREEN_HEIGHT==568||SCREEN_HEIGHT==480) {
        toptitle.font = [UIFont systemFontOfSize:11];
    }else if (SCREEN_HEIGHT==667){
        toptitle.font = [UIFont systemFontOfSize:13];
    }else if (SCREEN_HEIGHT==736){
        toptitle.font = [UIFont systemFontOfSize:14];
    }
    
    toptitle.text = @"我们将送货至地图上的位置，可拖动调整";
    [self.view addSubview:toptitle];
    
    //地址title
    self.downtitle = [[UILabel alloc]initWithFrame:CGRectMake(annotop.frame.origin.x+10, toptitle.frame.origin.y+toptitle.frame.size.height, SCREEN_WIDTH/10*9-10-60, 20)];
    if (SCREEN_HEIGHT==568||SCREEN_HEIGHT==480) {
        self.downtitle.font = [UIFont systemFontOfSize:11];
    }else if (SCREEN_HEIGHT==667){
        self.downtitle.font = [UIFont systemFontOfSize:13];
    }else if (SCREEN_HEIGHT==736){
        self.downtitle.font = [UIFont systemFontOfSize:14];
    }
    
    //self.downtitle.font = [UIFont systemFontOfSize:12];
    self.downtitle.textColor = [UIColor darkGrayColor];
    [self.view addSubview:self.downtitle];
    
    //右边蓝色确定
    UIImageView *annorightblue =[[UIImageView alloc]initWithFrame:CGRectMake(annotop.frame.origin.x+annotop.frame.size.width-46, annotop.frame.origin.y, 46, 46)];
    annorightblue.image = [UIImage imageNamed:@"may_nl"];
    annorightblue.alpha=0.8;
    [self.view addSubview:annorightblue];
    
    UIButton *annorightbtn = [[UIButton alloc]initWithFrame:CGRectMake(annotop.frame.origin.x+annotop.frame.size.width-46, annotop.frame.origin.y, 46, 46)];
    [annorightbtn addTarget:self action:@selector(confirmAddress) forControlEvents:UIControlEventTouchUpInside];
    [annorightbtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.view addSubview:annorightbtn];
    
}
#pragma mark - 点击确定按钮
-(void)confirmAddress{

   // NSLog(@"%@",self.City);
    if ([self.placeModel.city isEqualToString:@""]||self.placeModel.city==nil) {
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂未定位到地址，请稍等(⊙_⊙)" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertview show];
    }
    else{
        [[NSNotificationCenter defaultCenter]postNotificationName:@"chooseAddress" object:@{@"model":self.placeModel}];//传通知到地图页面，切换地图
        for (UIViewController *vcHome in self.navigationController.viewControllers) {
            if ([vcHome isKindOfClass:[AddAddressViewController class]]) {
                [self.navigationController popToViewController:vcHome animated:YES];
            }
        }
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
