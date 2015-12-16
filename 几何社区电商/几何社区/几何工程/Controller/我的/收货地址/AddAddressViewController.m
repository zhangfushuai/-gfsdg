//
//  AddAddressViewController.m
//  几何社区
//
//  Created by KMING on 15/8/29.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "AddAddressViewController.h"
#import "SearchStreetViewController.h"
#import "Define.h"
#import "MBProgressHUD.h"
#import "IQKeyboardReturnKeyHandler.h"
#import "IQKeyboardManager.h"
#import "MyAddressModel.h"
#import "Utils.h"
#import "PlaceSearchResultModel.h"
#import "WGS84TOGCJ02.h"
@interface AddAddressViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,JHDataMagerDelegate>
{
    NSString *newDistrict;
}
@property (nonatomic, strong) IQKeyboardReturnKeyHandler    *returnKeyHandler;
@property (nonatomic,strong)IQKeyboardManager *iManager;
@property (nonatomic,strong)UIView *downbackview;
@property (nonatomic,strong)UIPickerView *pickview;
//pickview数据源
@property (nonatomic,strong)NSArray *provinces;//装着省，每个省都是字典
@property (nonatomic,strong)NSArray *cities;//装着市，每个市都是字典
@property (nonatomic,strong)NSArray *areas;//装着区，每个区都是字符串
@property (nonatomic,copy)NSString *selected1;//pickerview的第一个，省的名字，直辖市特殊
@property (nonatomic,copy)NSString *selected2;//pickerview的第二个，市的名字，直辖市特殊
@property (nonatomic,strong)NSMutableArray* addressArrs;//存放地址模型的属性，归档反归档

@end

@implementation AddAddressViewController

-(void)viewWillAppear:(BOOL)animated{
//    [self setNavColor:[UIColor whiteColor]];
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"AddAddressViewController"];
    _manager.delegate = self;
    self.iManager.enable=YES;
    
    if (!self.myaddressM) {
        self.title = @"新增收货地址";
    }else{
        self.title = @"编辑收货地址";
    }
    [self setNavTitleColor:[UIColor blackColor]];
    
    [self setLeftNavButtonWithType:BACK];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _manager = [JHDataManager getInstance];
    
    //self.editIndex = -1;//初始化产值序号，用来判断是新增地址还是编辑旧地址
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self defendKeyboardHide];//防止键盘遮挡，用三方框架
    [self makeView];
    
    
    //监听下下个地图页选择完地址的确定按钮
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AlreadyChooseAddress:) name:@"chooseAddress" object:nil];
    
    //从plist加载城市数据源
    
    self.provinces = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.plist" ofType:nil]];
    self.cities = [[self.provinces objectAtIndex:0]objectForKey:@"cities"];
    self.areas = [[self.cities objectAtIndex:0]objectForKey:@"areas"];
    
    //登录后存到了userdefault，读取显示
    [self setDefaultText];
    //如果是编辑
    if (self.myaddressM) {
        self.nameTf.text = self.myaddressM.name;
        self.phoneTf.text = self.myaddressM.phonenum;
        self.districtLabel.text = @"";
        self.shouhuoAddressLabel.text = @"";
    }
    

    }

-(void)setDefaultText{
    //登录后存到了userdefault，读取显示
    self.nameTf.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"name"];
    self.phoneTf.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"phone"];
    //地址默认显示定位地址,反归档
    NSString *placeModelPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"placeModel"];
    PlaceSearchResultModel *model = [NSKeyedUnarchiver unarchiveObjectWithFile:placeModelPath];
    if (!model) {
        self.districtLabel.text = @"";
        self.shouhuoAddressLabel.text = @"";
        self.selectCity = @"";
    }else{
        //显示
        [self modelParserWithModel:model];
    }
}
//model解析显示
-(void)modelParserWithModel:(PlaceSearchResultModel*)model{
    NSString *province = model.province;
    NSString *city = model.city;
    NSString *district = model.district;
    NSString *name = model.name;
    NSString *street = @"";
    if ([model.street isEqualToString:@""]||model.street==nil) {
        street = model.address;
    }else{
        street= model.street;
    }
    self.latitude=model.latitude;
    self.longtitude = model.longitude;
    if ([province isEqualToString:@"北京市"]||[province isEqualToString:@"上海市"]||[province isEqualToString:@"天津市"]||[province isEqualToString:@"重庆市"]||[province isEqualToString:@"香港特别行政区"]||[province isEqualToString:@"澳门特别行政区"]) {
        self.districtLabel.text = [NSString stringWithFormat:@"%@-%@",province,district];
        self.shouhuoAddressLabel.text = street;
        self.selectCity = province;
    }else{
        self.districtLabel.text = [NSString stringWithFormat:@"%@-%@-%@",province,city,district];
        self.selectCity = city;
        self.shouhuoAddressLabel.text = street;
    }

}
#pragma mark - 防止键盘遮挡，用三方框架
-(void)defendKeyboardHide{
    //用三方框架防止键盘遮挡，但是有个前提，必须view是scrollview，否则虽然也会上移，但是navigationbar也上移，为了防止navigationbar上移，在xib中删除view，添加scrollview，然后让file owner指向scrollview，然后再scrollview上添加其他view
    self.iManager = [IQKeyboardManager sharedManager];
    self.iManager.enable = YES;
    self.iManager.shouldResignOnTouchOutside = YES;
    self.iManager.shouldToolbarUsesTextFieldTintColor = YES;
    self.iManager.enableAutoToolbar = YES;
    
    self.returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
    self.returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyDone;
    self.returnKeyHandler.toolbarManageBehaviour = IQAutoToolbarBySubviews;
}
#pragma mark - 接收到通知后，地图选择完点了确定后
-(void)AlreadyChooseAddress:(NSNotification*)notification{
    //NSLog(@"选择城市");
    NSDictionary *nameDictionary = [notification object];
    PlaceSearchResultModel *model = [nameDictionary objectForKey:@"model"];
    //解析显示
    [self modelParserWithModel:model];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.returnKeyHandler = nil;
    self.downbackview.hidden=YES;
    self.iManager.enable = NO;//关闭键盘管理，否则下一页搜索地址点击第一项他收键盘，并不是点cell效果
    
    [MobClick endLogPageView:@"AddAddressViewController"];
}

- (void)dealloc
{
    self.returnKeyHandler = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"chooseAddress" object:nil];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
#pragma mark - 点击确定保存
-(void)confirmAction{

    if ((self.phoneTf.text.length==11)&&[Utils isPureInt:self.phoneTf.text]&&(![self.nameTf.text isEqualToString:@""])&&(![self.menpaihaoTf.text isEqualToString:@""])&&(![self.shouhuoAddressLabel.text isEqualToString:@""])&&(![self.districtLabel.text isEqualToString:@""])) {
 
//        MyAddressModel *model = [[MyAddressModel alloc]init];
//        model.name = self.nameTf.text;
//        model.phonenum = self.phoneTf.text;
//        model.suozaiquyu = self.districtLabel.text;
//        model.shouhuodizhi = self.shouhuoAddressLabel.text;
//        model.menpaihaoma = self.menpaihaoTf.text;
//        model.address = [NSString stringWithFormat:@"%@%@",self.shouhuoAddressLabel.text,self.menpaihaoTf.text];
        NSString *district = self.districtLabel.text;
        NSArray *districtArr = [district componentsSeparatedByString:@"-"];
        newDistrict = @"";
        for (NSString *text in districtArr) {
            newDistrict = [newDistrict stringByAppendingString:text];
        }
        
        //如果是编辑
        if (self.myaddressM) {
            CLLocationCoordinate2D coo = CLLocationCoordinate2DMake(self.latitude, self.longtitude);
            CLLocationCoordinate2D newcll= [WGS84TOGCJ02 locationBaiduFromMars:coo];
            NSNumber *myNumber = [NSNumber numberWithInteger:self.selectIndex];
            NSString *menpaihao = self.menpaihaoTf.text;
            menpaihao = [menpaihao stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *name1 =self.nameTf.text;
            name1 = [name1 stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            NSDictionary *params = @{@"name":name1,@"phone":self.phoneTf.text,@"province":newDistrict,@"street":self.shouhuoAddressLabel.text,@"address":menpaihao,@"id":myNumber,@"latlng":[NSString stringWithFormat:@"%f,%f",newcll.latitude,newcll.longitude]};
            
            [_manager editAddressWithParams:params];
        }else{
            CLLocationCoordinate2D coo = CLLocationCoordinate2DMake(self.latitude, self.longtitude);
            CLLocationCoordinate2D newcll= [WGS84TOGCJ02 locationBaiduFromMars:coo];
            NSString *menpaihao = self.menpaihaoTf.text;
            menpaihao = [menpaihao stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSString *name1 =self.nameTf.text;
            name1 = [name1 stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSDictionary *params = @{@"name":name1,@"phone":self.phoneTf.text,@"province":newDistrict,@"street":self.shouhuoAddressLabel.text,@"address":menpaihao,@"latlng":[NSString stringWithFormat:@"%f,%f",newcll.latitude,newcll.longitude]};
            [_manager addAddressWithParams:params];
        }
        }else if ([self.menpaihaoTf.text isEqualToString:@""]||[self.menpaihaoTf.text isEqualToString:@""]||[self.shouhuoAddressLabel.text isEqualToString:@""]||[self.districtLabel.text isEqualToString:@""]){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入完整信息";
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [hud removeFromSuperview];
        }];
    }else if (((self.phoneTf.text.length!=11)|| ![Utils isPureInt:self.phoneTf.text] )&&(![self.nameTf.text isEqualToString:@""])&&(![self.menpaihaoTf.text isEqualToString:@""])&&(![self.shouhuoAddressLabel.text isEqualToString:@""])&&(![self.districtLabel.text isEqualToString:@""])){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入正确手机号";
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [hud removeFromSuperview];
        }];
    }
        
    

    
}
#pragma mark - 点击所在区域
-(void)editRegion{
    [self.nameTf resignFirstResponder];
    [self.phoneTf resignFirstResponder];
    //当下面的pickview未显示时候加载
    if (self.downbackview.hidden==YES) {
        self.downbackview.hidden=NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.downbackview.frame = CGRectMake(0, SCREEN_HEIGHT-200, SCREEN_WIDTH, 200);
        }];
        
        
    }
    
    
}
#pragma mark - 移除pickerview，确定pickerview
-(void)removePickview{
    [UIView animateWithDuration:0.2 animations:^{
        self.downbackview.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200);
    } completion:^(BOOL finished) {
        self.downbackview.hidden=YES;
    }];
    
}
#pragma mark - 确定pickerview选择的城市
-(void)quedingPickview{
    NSInteger row1 = [self.pickview selectedRowInComponent:0];
    NSInteger row2 = [self.pickview selectedRowInComponent:1];
    NSInteger row3 = [self.pickview selectedRowInComponent:2];
    self.selected1 = [[self.provinces objectAtIndex:row1]objectForKey:@"state"];
    self.selected2 = [[self.cities objectAtIndex:row2]objectForKey:@"city"];
    NSString *selected3 = @"";
    if (self.areas.count>0) {
        selected3 = [self.areas objectAtIndex:row3];
    }
   //记录选择的城市
    if ([self.selected1 isEqualToString:@"北京"]||[self.selected1 isEqualToString:@"上海"]||[self.selected1 isEqualToString:@"天津"]||[self.selected1 isEqualToString:@"重庆"]||[self.selected1 isEqualToString:@"香港"]||[self.selected1 isEqualToString:@"澳门"]) {
        self.selectCity = self.selected1;
        self.districtLabel.text = [NSString stringWithFormat:@"%@-%@",self.selected1,self.selected2];
    }else{
        self.selectCity = self.selected2;
        self.districtLabel.text = [NSString stringWithFormat:@"%@-%@-%@",self.selected1,self.selected2,selected3];
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.downbackview.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200);
    } completion:^(BOOL finished) {
        self.downbackview.hidden = YES;
        
        
    }];
}
#pragma mark 实现协议UIPickerViewDataSource方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {//省份个数
        return self.provinces.count;
    } else if(component==1){
        return self.cities.count;
    }else{
        return self.areas.count;
    }
    
}

#pragma mark 实现协议UIPickerViewDelegate方法
-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {//选择省份名
        return [[self.provinces objectAtIndex:row]objectForKey:@"state"];
        
    } else if(component==1){//选择市名
        return [[self.cities objectAtIndex:row]objectForKey:@"city"];
     
    }else{
        return [self.areas objectAtIndex:row];
            }
}

- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.cities=[[self.provinces objectAtIndex:row]objectForKey:@"cities"];
        [self.pickview reloadComponent:1];
//        self.areas =[[self.cities objectAtIndex:[self.pickview selectedRowInComponent:<#(NSInteger)#>]objectForKey:@"areas"];
        [self.pickview selectRow:0 inComponent:1 animated:YES];
        self.areas =[[self.cities objectAtIndex:0]objectForKey:@"areas"];
        [self.pickview reloadComponent:2];
    }else if (component==1){
        self.areas =[[self.cities objectAtIndex:row]objectForKey:@"areas"];
        [self.pickview reloadComponent:2];
    }
}

#pragma mark - 点击收货地址
-(void)editAddress{
    if ([self.districtLabel.text isEqualToString:@""]) {
        UIAlertView *alertv = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先选择所在区域" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        [alertv show];
    }else{
        SearchStreetViewController *vc = [[SearchStreetViewController alloc]initWithNibName:@"SearchStreetViewController" bundle:nil];
        vc.searchCity = self.selectCity;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


#pragma mark - 初始化界面
-(void)makeView{
    
    self.view.backgroundColor = HEADERVIEW_COLOR;
    self.downview.backgroundColor = HEADERVIEW_COLOR;
    
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , 0.5)];
    line1.backgroundColor = SEPARATELINE_COLOR;
    [self.view1 addSubview:line1];
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 44,SCREEN_WIDTH , 0.5)];
    line2.backgroundColor = SEPARATELINE_COLOR;
    [self.view1 addSubview:line2];
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 87.5,SCREEN_WIDTH , 0.5)];
    line3.backgroundColor = SEPARATELINE_COLOR;
    [self.view1 addSubview:line3];
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , 0.5)];
    line4.backgroundColor = SEPARATELINE_COLOR;
    [self.view2 addSubview:line4];
    UIView *line5 = [[UIView alloc]initWithFrame:CGRectMake(0, 44,SCREEN_WIDTH , 0.5)];
    line5.backgroundColor = SEPARATELINE_COLOR;
    [self.view2 addSubview:line5];
    UIView *line6 = [[UIView alloc]initWithFrame:CGRectMake(0, 88,SCREEN_WIDTH , 0.5)];
    line6.backgroundColor = SEPARATELINE_COLOR;
    [self.view2 addSubview:line6];
    UIView *line7 = [[UIView alloc]initWithFrame:CGRectMake(0, 131.5,SCREEN_WIDTH , 0.5)];
    line7.backgroundColor = SEPARATELINE_COLOR;
    [self.view2 addSubview:line7];
    self.label1.textColor = Color757575;
    self.label2.textColor = Color757575;
    for (UILabel *label in self.labels) {
        label.textColor = Color242424;
    }
    for (UITextField *tf in self.textfields) {
        tf.textColor = Color242424;
    }
    UIImageView *rightSanjiao =  [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-21, 20, 9, 4.5)];
    rightSanjiao.image = [UIImage imageNamed:@"xla"];
    [self.view2 addSubview:rightSanjiao];
    
    UIButton *editRegionBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    [editRegionBtn addTarget:self action:@selector(editRegion) forControlEvents:UIControlEventTouchUpInside];
    [self.view2 addSubview:editRegionBtn];
    UIButton *editAddressBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 44)];
    [editAddressBtn addTarget:self action:@selector(editAddress) forControlEvents:UIControlEventTouchUpInside];
    [self.view2 addSubview:editAddressBtn];
    
    UIImageView *confirmimg = [[UIImageView alloc]initWithFrame:CGRectMake(12, 380, SCREEN_WIDTH-24, 40)];
    confirmimg.image = [UIImage imageNamed:@"bgr"];
    [self.view addSubview:confirmimg];
    
    UILabel *confirmLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    confirmLabel.text = @"确定";
    confirmLabel.textColor = [UIColor whiteColor];
    confirmLabel.center = confirmimg.center;
    [self.view addSubview:confirmLabel];
    
    UIButton *confirmBtn = [[UIButton alloc]initWithFrame:CGRectMake(12, 380, SCREEN_WIDTH-24, 40)];
    [confirmBtn addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:confirmBtn];
    
    //添加pickview和他的背景view
    self.downbackview = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 200)];
    self.downbackview.hidden = YES;
    self.downbackview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.downbackview];
    UIButton *cancelbtn = [[UIButton alloc]initWithFrame:CGRectMake(5, 0, 50, 30)];
    [cancelbtn setTitleColor:Color757575 forState:UIControlStateNormal];
    [cancelbtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelbtn addTarget:self action:@selector(removePickview) forControlEvents:UIControlEventTouchUpInside];
    cancelbtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    topLine.backgroundColor = SEPARATELINE_COLOR;
    [self.downbackview addSubview:topLine];
    [self.downbackview addSubview:cancelbtn];
    
    UIButton *quedingbtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-5-50, 0, 50, 30)];
    quedingbtn.titleLabel.textAlignment = NSTextAlignmentRight;
    quedingbtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [quedingbtn setTitleColor:Color757575 forState:UIControlStateNormal];
    [quedingbtn setTitle:@"确定" forState:UIControlStateNormal];
    [quedingbtn addTarget:self action:@selector(quedingPickview) forControlEvents:UIControlEventTouchUpInside];
    [self.downbackview addSubview:quedingbtn];
    
    self.pickview = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 30, SCREEN_WIDTH, self.downbackview.frame.size.height-30)];
    self.pickview.delegate = self;
    self.pickview.dataSource = self;
    [self.downbackview addSubview:self.pickview];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)requestSuccess:(id)object withRequestType:(RequestType)requestType{
    switch (requestType) {
        case JHADDADDRESS:
        {
            NSDictionary *dic =object;
            NSString *value = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
            if ([value isEqualToString:@"10000"]) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"保存收货地址成功";
                [hud showAnimated:YES whileExecutingBlock:^{
                    sleep(1);
                } completionBlock:^{
                    [hud removeFromSuperview];
                    [self.navigationController popViewControllerAnimated:YES];
                }];

            }
            [_manager getRegionIDWithLatitude:self.latitude andlongitude:self.longtitude];
        }
            break;
         case JHEDITADDRESS:
        {
            NSDictionary *dic =object;
            NSString *value = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
            if ([value isEqualToString:@"10000"]){
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"修改收货地址成功";
                [hud showAnimated:YES whileExecutingBlock:^{
                    sleep(1);
                } completionBlock:^{
                    [hud removeFromSuperview];
                    [self.navigationController popViewControllerAnimated:YES];
                }];
            }
            [_manager getRegionIDWithLatitude:self.latitude andlongitude:self.longtitude];
                    }
            case JHGETREGIONID:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(chooseAddress:)]) {
                MyAddressModel *model = [[MyAddressModel alloc] init];
                model.name = self.nameTf.text;
                model.phonenum = self.phoneTf.text;
                model.address = [NSString stringWithFormat:@"%@%@%@",newDistrict,self.shouhuoAddressLabel.text,self.menpaihaoTf.text];
                model.area_id = [NSString stringWithFormat:@"%@",[object objectForKey:@"data"]];
                model.latitude = [NSString stringWithFormat:@"%f",self.latitude];
                model.longtitude = [NSString stringWithFormat:@"%f",self.longtitude];
                [_delegate chooseAddress:model];
            }

        }
            break;
        default:
            break;
    }

}
-(void)requestFailure:(id)failReson withRequestType:(RequestType)requestType{
    switch (requestType) {
        case JHADDADDRESS:
            NSLog(@"%@",failReson);
            break;
            
        default:
            break;
    }
    NSLog(@"%@",failReson);
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
