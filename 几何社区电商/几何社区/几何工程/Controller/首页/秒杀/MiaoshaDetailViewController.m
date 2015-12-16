//
//  MiaoshaDetailViewController.m
//  几何社区
//
//  Created by KMING on 15/10/13.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "MiaoshaDetailViewController.h"
#import "GoodDetailTopCell.h"
#import "GoodDetailBottomCell.h"
#import "MiaoShaDaojishiView.h"
#import "ConfirmDirectViewController.h"
#import "Utils.h"
#import <ShareSDK/ShareSDK.h>
@interface MiaoshaDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,MZTimerLabelDelegate>
{
    MZTimerLabel *timerExample3;
}
@property (nonatomic,assign)NSInteger goodCount; //用于直接购买接口
@property (nonatomic,assign)CGFloat webHeight;
@property (nonatomic,strong)UIWebView *webview;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,copy)NSString *flag_time;
@property (nonatomic,copy)NSString *flag;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)UILabel *myLbl;
@property (nonatomic,strong)UIImageView *miaoshaImg1;
@property (nonatomic,strong)UIImageView *miaoshaImg2;
@property (nonatomic,strong)MiaoShaDaojishiView *headV;
@property (nonatomic,copy)NSString *time;
@end


@implementation MiaoshaDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _webHeight = 0.0f;
    _goodCount = 1;
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-44)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor =[UIColor colorWithWhite:0.961 alpha:1.000];
    [self.view addSubview:self.tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;//避免scrollview偏移
    UIView *footerview  = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footerview;
    _manager = [JHDataManager getInstance];
    _manager.delegate = self;
    //[self makeHeaderView];
    self.myLbl= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.myLbl.text = @"99:99:99";
    [self.view addSubview:self.myLbl];
    
}
-(void)caculateTime{
    self.flag_time = self.model.flag_time;
    self.flag = [NSString stringWithFormat:@"%@",self.model.flag];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    self.time = self.model.time;
    NSDate *date2=[dateFormatter dateFromString:self.flag_time];
    NSDate *date1=[dateFormatter dateFromString:self.time];
    NSTimeInterval timein = [date2 timeIntervalSinceDate:date1];
    
    [timerExample3 removeFromSuperview];
    timerExample3 = [[MZTimerLabel alloc] initWithLabel:self.myLbl andTimerType:MZTimerLabelTypeTimer];
    [timerExample3 setCountDownTime:timein]; //** Or you can use [timer3 setCountDownToDate:aDate];
    [timerExample3 start];
}
-(void)leftButtonOnClick:(id)sender
{
    [timerExample3 pause];
    [timerExample3 removeFromSuperview];
    [self.timer invalidate];
    self.timer = nil;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _manager.delegate = self;
    self.title = @"商品详情";
    [self setLeftNavButtonWithType:BACK];
    [self setNavColor:[UIColor whiteColor]];
    [self setNavTitleColor:[UIColor blackColor]];
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkTime) userInfo:nil repeats:YES];
    [self setRightNavButtonWithType:SHARE];
    [self caculateTime];
}
- (IBAction)mashangQiangAction:(id)sender {
//    NSDictionary *dic = @{@"mid":self.model.mid,@"pid":self.model.pid,@"num":@"1"};
//    [_manager miaoSHaXiaDanCheckWithParams:dic];
   // NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:0];
    NSDictionary *dict = @{@"pid":self.model.pid,@"mid":self.model.mid,@"num":@"1"};
    //[list addObject:dict];
    [_manager miaoSHaXiaDanCheckWithparams:dict];
    
}
-(void)requestSuccess:(id)object withRequestType:(RequestType)requestType{
    switch (requestType) {
        case JHMIAOSHAXIADAN:
        {
            NSDictionary *dic = object;
            if ([[dic objectForKey:@"status"]integerValue]==10000) {
                 NSDictionary *dict = @{@"pid":self.model.pid,@"mid":self.model.mid,@"num":@"1"};
                [_manager miaoShaJieSuanWithParams:dict];
            }
        }
            break;
        case JHMIAOSHAJIESUAN:
        {
            ConfirmDirectViewController *vc = [[ConfirmDirectViewController alloc] initWithNibName:@"ConfirmDirectViewController" bundle:nil];
            vc.fromFlag = 1000;                                    
            NSDictionary *dataDict = [object objectForKey:@"data"];
            NSDictionary *dict = @{@"data":[dataDict objectForKey:@"products"]};
            vc.dataSourse   = [CarGoodDetail listFromJsonDictionnary:dict];
            vc.addressList  = [MyAddressModel listFromJsonDictionnary:@{@"data":[dataDict objectForKey:@"address"]}];
            vc.addressModel = [[MyAddressModel listFromJsonDictionnary:@{@"data":[dataDict objectForKey:@"address"]}] firstObject];
            vc.totalPrice   = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"amount"]];
            vc.shipping     = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"shipping"]];
            [self.navigationController pushViewController:vc animated:YES];
        }
            
        default:
            break;
    }
}
-(void)requestFailure:(id)failReson withRequestType:(RequestType)requestType{
    
    switch (requestType) {
        case JHMIAOSHAJIESUAN:
        {
            if ([failReson isKindOfClass:[NSDictionary class]]) {
                [self.view makeToast:[failReson objectForKey:@"msg"]];
            }else if([failReson isKindOfClass:[NSString class]]){
                [self.view makeToast:failReson];
            }
        }
            break;
        case JHMIAOSHAXIADAN:
            
        {
            if ([failReson isKindOfClass:[NSDictionary class]]) {
                [self.view makeToast:[failReson objectForKey:@"msg"]];
            }else if([failReson isKindOfClass:[NSString class]]){
                [self.view makeToast:failReson];
            }
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = [failReson objectForKey:@"msg"];
//            [hud showAnimated:YES whileExecutingBlock:^{
//                sleep(1);
//            } completionBlock:^{
//                [hud removeFromSuperview];
//                
//            }];
        }
        default:
            break;
    }
}
-(void)checkTime{
    NSArray *timeArr = [self.myLbl.text componentsSeparatedByString:@":"];
    NSString *shi = timeArr[0];
    NSString *fen = timeArr[1];
    NSString *miao = timeArr[2];
    // NSLog(@"%@---%@---%@",shi,fen,miao);
    self.headV.shiLbl.text = shi;
    self.headV.fenLbl.text = fen;
    self.headV.miaoLbl.text = miao;
    
  

    
    
    if ([self.flag isEqualToString:@"1"]) {
        [self.qiangBtn setBackgroundColor:NAVIGATIONBAR_COLOR];
        [self.qiangBtn setTitle:@"马上抢" forState:UIControlStateNormal];
        self.qiangBtn.enabled = YES;
        self.headV.juliLbl.text = @"距离结束";
        if ([self.myLbl.text isEqualToString:@"00:00:00"]) {
            [self.qiangBtn setBackgroundColor:[UIColor colorWithWhite:0.686 alpha:1.000]];
            [self.qiangBtn setTitle:@"时间已过" forState:UIControlStateNormal];
            self.qiangBtn.enabled = NO;
        }
    }else{
        self.headV.juliLbl.text = @"距离开抢";
        [self.qiangBtn setBackgroundColor:[UIColor colorWithWhite:0.686 alpha:1.000]];
        [self.qiangBtn setTitle:@"请等待" forState:UIControlStateNormal];
        self.qiangBtn.enabled = NO;
        if ([self.myLbl.text isEqualToString:@"00:00:00"]) {
            [self.qiangBtn setBackgroundColor:NAVIGATIONBAR_COLOR];
            [self.qiangBtn setTitle:@"马上抢" forState:UIControlStateNormal];
            self.qiangBtn.enabled = YES;
        }
        
    }
    
//    //NSLog(@"%@",self.countTimeLbl.text);
//    if ([self.hideLbl.text isEqualToString:@"00:00:00"]) {
//        [self.timer invalidate];
//        NSDictionary *ard = @{@"area_id":[[NSUserDefaults standardUserDefaults]objectForKey:@"regionId"]};
//        [_manager getMiaoshaListWithAreaId:ard];
//    }
}
- (void)rightButtonOnClick:(id)sender
{
    /* 邀请好友送优惠券*/
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"120-120" ofType:@"png"];
    //1、构造分享内容
    NSString *urlStr = [NSString stringWithFormat:@"http://m.jh920.com/product/%@",self.model.pid];
    id<ISSContent> publishContent = [ShareSDK content:@"指尖轻触,美味零食/水果/外卖/下午茶等秒速配送到家门口,让您躺在家里悠然逛超市!"
                                       defaultContent:@"指尖轻触,美味零食/水果/外卖/下午茶等秒速配送到家门口,让您躺在家里悠然逛超市!"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:self.model.title
                                                  url:urlStr
                                          description:@"指尖轻触,美味零食/水果/外卖/下午茶等秒速配送到家门口,让您躺在家里悠然逛超市!"
                                            mediaType:SSPublishContentMediaTypeNews];
    //1+创建弹出菜单容器（iPad必要）
    id<ISSContainer> container = [ShareSDK container];
    //2、弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                //可以根据回调提示用户。
                                if (state == SSResponseStateSuccess)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                    message:nil
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                                    message:[NSString stringWithFormat:@"失败描述：%@",[error errorDescription]]
                                                                                   delegate:self
                                                                          cancelButtonTitle:@"OK"
                                                                          otherButtonTitles:nil, nil];
                                    [alert show];
                                }
                            }];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    self.headV = [[[NSBundle mainBundle]loadNibNamed:@"MiaoShaDaojishiView" owner:self options:0]firstObject];
    self.headV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    
    return self.headV;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 45;

    }else{
        return 0;
    }
   
}
//-(void)makeHeaderView{
//    UIView *headV = [[[NSBundle mainBundle]loadNibNamed:@"MiaoshaDetailViewController" owner:self options:0]lastObject];
//    headV.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
//    self.tableView.tableHeaderView = headV;
//}
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        self.tableView.separatorColor = [UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        self.tableView.separatorColor = [UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.model.content && self.model.content.length > 0){
        return 3;
    }else{
        return 2;
    }
    
}
////制作headerview
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc]
//                    initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
//    view.backgroundColor = [UIColor colorWithWhite:0.961 alpha:1.000];
//    return view;
//}
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section==0) {
//        return 0;
//    }else if(section == 1){
//        return 8;
//    }else if  (section == 2)
//    {
//        return 8;
//    }
//    return 0;
//}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        return SCREEN_WIDTH +70;
    }else if (indexPath.section==1){
        return 48;
    }else{
        return _webHeight;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }
    else{
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        GoodDetailTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodDetailTopCell" ];
        if (!cell) {
            cell = [GoodDetailTopCell originViewTableView:tableView];
            [cell miaoShagoodDetail:self.model];

        }
        CGSize titleSize = [Utils sizeFromString:self.model.title withFont:17];
        if ([self.model.type isEqualToString:@"0"]) {
            if (!self.miaoshaImg1) {
                self.miaoshaImg1 = [[UIImageView alloc]initWithFrame:CGRectMake(titleSize.width+12+8, SCREEN_WIDTH+14, 35, 20)];
                self.miaoshaImg1.image = [UIImage imageNamed:@"详情页秒杀标签"];
                [cell.contentView addSubview:self.miaoshaImg1];
                UILabel *txtLbl = [[UILabel alloc]initWithFrame:self.miaoshaImg1.frame];
                txtLbl.textColor = [UIColor whiteColor];
                txtLbl.font = [UIFont systemFontOfSize:12];
                txtLbl.textAlignment = NSTextAlignmentCenter;
                txtLbl.text= @"秒杀";
                [cell.contentView addSubview:txtLbl];
            }
            
            
        }else{
            if (!self.miaoshaImg2) {
                self.miaoshaImg2 = [[UIImageView alloc]initWithFrame:CGRectMake(titleSize.width+12+3, SCREEN_WIDTH+14, 35, 20)];
                self.miaoshaImg2.image = [UIImage imageNamed:@"详情页抢购标签"];
                [cell.contentView addSubview:self.miaoshaImg2];
                UILabel *txtLbl = [[UILabel alloc]initWithFrame:self.miaoshaImg2.frame];
                txtLbl.textColor = [UIColor whiteColor];
                txtLbl.font = [UIFont systemFontOfSize:12];
                txtLbl.text= @"抢购";
                txtLbl.textAlignment = NSTextAlignmentCenter;
                [cell.contentView addSubview:txtLbl];
            }
            
        }
       
        
        
//        [cell.btnAdd addTarget:self action:@selector(addGood) forControlEvents:UIControlEventTouchUpInside];
//        [cell.btnReduce addTarget:self action:@selector(reduceGood) forControlEvents:UIControlEventTouchUpInside];
//        if (_goodCount <= 1) {
//            cell.btnReduce.enabled = NO;
//        }
//        cell.lblGoodCount.text  = [NSString stringWithFormat:@"%ld",(long)_goodCount];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.section == 1){
        GoodDetailBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodDetailBottomCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"GoodDetailBottomCell" owner:self options:0]firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lblTitle.text = [NSString stringWithFormat:@"商品规格：%@",self.model.capacity];
        return cell;
    }
    else{
        UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycell"];
            if (self.model.content && self.model.content.length > 0)
            {
                if (!_webview) {
                    _webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, _webHeight)];
                    [_webview loadHTMLString:self.model.content baseURL:nil];
                    _webview.delegate = self;
                    _webview.scrollView.scrollEnabled = NO;
                }
                _webview.frame = CGRectMake(0, 0, SCREEN_WIDTH, _webHeight);
                [cell.contentView addSubview:_webview];
            }
        }
        return cell;
    }
}
-(NSString *)filterHTML:(NSString *)html
{
    html =[html stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    html =[html stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    html = [html stringByReplacingOccurrencesOfString:@"nbsp;" withString:@"&nbsp;"];
    html = [html stringByReplacingOccurrencesOfString:@"&amp;" withString:@""];
    return html;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *height_str= [webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"];
    _webHeight = 0.55*[height_str floatValue];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
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
