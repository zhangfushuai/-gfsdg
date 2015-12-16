//
//  SearchStreetViewController.m
//  几何社区
//
//  Created by KMING on 15/8/29.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "SearchStreetViewController.h"
#import "Define.h"
#import "PlaceSearchResultModel.h"
#import "SearchResultTableViewCell.h"
#import "ClickOneAddressToMapViewController.h"
@interface SearchStreetViewController ()<UITextFieldDelegate,AMapSearchDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{
    AMapSearchAPI *_search;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *searchResults;//数据源，搜索结果
@property (nonatomic,strong)UITextField *searchtf;
@property (nonatomic,strong)UIImageView *borderiv;
@end

@implementation SearchStreetViewController
-(void)viewWillAppear:(BOOL)animated{
//    [self setNavColor:[UIColor whiteColor]];
    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden = YES;
     // 此处记得不用的时候需要置nil，否则影响内存的释放
     [MobClick beginLogPageView:@"SearchStreetViewController"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"SearchStreetViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self makeNavigation];
    self.borderiv = [[UIImageView alloc]initWithFrame:CGRectMake(11, 75, SCREEN_WIDTH-22, SCREEN_HEIGHT-64-22)];
    self.borderiv.image = [UIImage imageNamed:@"add_bg"];
    [self.view addSubview:self.borderiv];
    self.borderiv.hidden=YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //配置用户Key
    [AMapSearchServices sharedServices].apiKey = AMAPKEY;
    //初始化检索对象
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(12, 76, SCREEN_WIDTH-24, SCREEN_HEIGHT-64-24)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    [self.searchtf becomeFirstResponder];
    
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.searchtf resignFirstResponder];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.searchtf resignFirstResponder];
}
#pragma mark - tableview相关
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchResults.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchResultTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"SearchResultTableViewCell" owner:self options:0]firstObject];
    }
    PlaceSearchResultModel *model = self.searchResults[indexPath.row];
    
    NSString *namestring = model.name;
    NSRange range = [namestring rangeOfString:self.searchtf.text];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:namestring];
    [attribute addAttributes: @{NSForegroundColorAttributeName: [UIColor colorWithRed:0.231 green:0.486 blue:0.996 alpha:1.000]} range: range];
    
 
    cell.namelabel.text = namestring;
   
    cell.namelabel.textColor = Color242424;
     [cell.namelabel setAttributedText:attribute];
    cell.placeLabel.textColor = Color757575;
    cell.placeLabel.text = model.address;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.isHomePush) {
        ClickOneAddressToMapViewController *vc = [[ClickOneAddressToMapViewController alloc]initWithNibName:@"ClickOneAddressToMapViewController" bundle:nil];
        PlaceSearchResultModel *model =self.searchResults[indexPath.row];
        vc.latitude = model.latitude;
        vc.longitude=model.longitude;
        [self.searchtf resignFirstResponder];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        PlaceSearchResultModel *model = self.searchResults[indexPath.row];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"choosestreet" object:@{@"model":model}];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    
}
-(void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    if(response.pois.count == 0)
    {
        return;
    }
    
    //通过AMapPlaceSearchResponse对象处理搜索结果
    //NSString *strCount = [NSString stringWithFormat:@"count: %ld",response.count];
    //    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
    
    NSMutableArray *placeArr = [NSMutableArray array];
    for (AMapPOI *p in response.pois) {
        //过滤掉没有address的
        if (p.address) {
            
            PlaceSearchResultModel *model = [[PlaceSearchResultModel alloc]init];
            model.name = p.name;
            model.city = p.city;
            model.district = p.district;
            model.address = p.address;
            model.latitude = p.location.latitude;
            model.longitude = p.location.longitude;
            [placeArr addObject:model];
            
        }
    }
    self.searchResults = placeArr;
    [self.tableView reloadData];
}


-(void)textFieldValueChanged:(UITextField*)tf{

    self.borderiv.hidden=NO;
    //高德
    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc]init];
    request.keywords = tf.text;
    request.city=self.searchCity;
    request.types = @"商务住宅|体育休闲服务|医疗保健服务|政府机构及社会团体|科教文化服务|风景名胜|地名地址信息";
     request.sortrule = 0;
      request.requireExtension = YES;
    [_search AMapPOIKeywordsSearch:request];
    
    }
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)makeNavigation{
    [self setLeftNavButtonWithType:BACK];
    UIView *topview = [[UIView alloc]initWithFrame:CGRectMake(50, 0,200 , 30)];
    if (SCREEN_WIDTH==414) {
        topview.frame = CGRectMake(50, 0, 235, 30);
    }else if (SCREEN_WIDTH==375){
        topview.frame = CGRectMake(50, 0, 230, 30);
    }
    UIImageView *topimgview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 250, 30)];
    topimgview.image = [UIImage imageNamed:@"add_bg"];
    [topview addSubview:topimgview];
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(2.5, 2.5, 25, 25)];
    [searchBtn setImage:[UIImage imageNamed:@"seach"] forState:UIControlStateNormal];
    [topview addSubview:searchBtn];
    
    self.searchtf = [[UITextField alloc]initWithFrame:CGRectMake(27.5, 0, 220, 30)];
    self.searchtf.returnKeyType = UIReturnKeyDone;
    self.searchtf.borderStyle = UITextBorderStyleNone;
    self.searchtf.placeholder = @"请输入小区、街道或大厦 ";
    self.searchtf.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.searchtf addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    self.searchtf.delegate = self;
    [topview addSubview:self.searchtf];
    
    self.navigationItem.titleView = topview;
    
//    self.searchtf = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 220, 30)];
//    self.searchtf.font = [UIFont systemFontOfSize:13];
//    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(7, 7, 16, 16)];
//    imgV.image = [UIImage imageNamed:@"seach"];
//    [leftView addSubview:imgV];
//    self.searchtf.leftView = leftView;
//    self.searchtf.leftViewMode = UITextFieldViewModeAlways;
//    [self.searchtf addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
//    self.searchtf.delegate = self;
//    self.searchtf.placeholder = @"请输入小区、街道或大厦                ";
//    self.searchtf.layer.borderWidth = 0.3;
//    self.searchtf.layer.cornerRadius = 5;
//    self.searchtf.clearButtonMode = UITextFieldViewModeWhileEditing;
//    
//    self.navigationItem.titleView = self.searchtf;
    

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
