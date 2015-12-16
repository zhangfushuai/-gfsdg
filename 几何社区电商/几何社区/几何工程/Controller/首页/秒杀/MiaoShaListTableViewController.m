//
//  MiaoShaListTableViewController.m
//  几何社区
//
//  Created by KMING on 15/10/12.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "MiaoShaListTableViewController.h"
#import "MiaoshaTableViewCell.h"
#import "MiaoshaModel.h"
#import "MZTimerLabel.h"
#import "ProductDetailViewController.h"
#import "MiaoshaDetailModel.h"
#import "MiaoshaDetailViewController.h"
#import "LoginViewController.h"
#import "MiaoshaRuleViewController.h"
@interface MiaoShaListTableViewController ()<JHDataMagerDelegate,MZTimerLabelDelegate,MJRefreshBaseViewDelegate,UIAlertViewDelegate>
{
    MZTimerLabel *timerExample3;
}
@property (nonatomic,strong)NSArray *products;
@property (nonatomic,copy)NSString *flag_time;
@property (nonatomic,copy)NSString *time;
@property (nonatomic,copy)NSString *flag;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,copy)NSString *mid;
@property (nonatomic,copy)NSString* logState;
@property (nonatomic)BOOL miaoshaEndAlertIsShow;
@property (nonatomic,strong)UIAlertView *alert;
#import "MiaoshaModel.h"
@end

@implementation MiaoShaListTableViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.logState=[[NSUserDefaults standardUserDefaults]objectForKey:@"logState"];//读取登录状态
    if (!self.logState) {
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"未登录用户不能参与秒杀" message:@"请先登录再秒杀" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去登录", nil];
        
        
            [alertV show];
        
        
        
        
    }
    [self setLeftNavButtonWithType:BACK];
    [self setNavColor:[UIColor whiteColor]];
    [self setNavTitleColor:[UIColor blackColor]];
    self.title = @"秒杀抢购活动";
    NSDictionary *ard;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"regionId"]) {
         ard= @{@"area_id":[[NSUserDefaults standardUserDefaults]objectForKey:@"regionId"]};
    }
    _manager.delegate = self;
    [_manager getMiaoshaListWithAreaId:ard];
    self.timer=[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkTime) userInfo:nil repeats:YES];
}
- (IBAction)huodongRUle:(id)sender {
    
    UIStoryboard *miaoSB = [UIStoryboard storyboardWithName:@"MiaoSha" bundle:nil];
    MiaoshaRuleViewController *vc = [miaoSB instantiateViewControllerWithIdentifier:@"m2"];
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
   
    

    self.headV.frame = CGRectMake(0, 0, 64, SCREEN_WIDTH/320*100);
    self.tableView.tableFooterView = [[UIView alloc]init];
    _manager = [JHDataManager getInstance];
    _manager.delegate = self;
    self.header = [MJRefreshHeaderView header];
    self.header.scrollView = self.tableView;
    self.header.tag = 0;
    self.header.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(miaoShaQiangGouBtn:) name:@"miaoShaQiangGouBtn" object:nil];
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (alertView.tag==5) {
//        [self.navigationController popViewControllerAnimated:YES];
//    }else{
        if (buttonIndex==1) {
            LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            [self presentViewController:vc animated:YES completion:nil];
        }
    //}
    
}
-(void)leftButtonOnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [_header free];
}

-(void)checkTime{
    NSArray *timeArr = [self.hideTimeL.text componentsSeparatedByString:@":"];
    NSString *shi = timeArr[0];
    NSString *fen = timeArr[1];
    NSString *miao = timeArr[2];
   // NSLog(@"%@---%@---%@",shi,fen,miao);
    self.shiLbl.text = shi;
    self.fenLbl.text = fen;
    self.miaoLBl.text = miao;
    
    //NSLog(@"%@",self.countTimeLbl.text);
    if ([self.hideTimeL.text isEqualToString:@"00:00:00"]) {
        [self.timer invalidate];
        
//        self.alert = [[UIAlertView alloc]initWithTitle:@"今天的秒杀已结束" message:@"请下次再参与，谢谢！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        self.alert.tag = 5;
//        self.miaoshaEndAlertIsShow =YES;
//        [self.alert show];
        
        
        
        
        NSDictionary *ard = @{@"area_id":[[NSUserDefaults standardUserDefaults]objectForKey:@"regionId"]};
        [_manager getMiaoshaListWithAreaId:ard];
        
    }
    

}
-(void)miaoShaQiangGouBtn:(NSNotification*)notification{
    NSString* logState=[[NSUserDefaults standardUserDefaults]objectForKey:@"logState"];//读取登录状态
    if (logState) {
        NSDictionary *nameDictionary = [notification object];
        MiaoshaModel *model = [nameDictionary objectForKey:@"model"];
        self.mid = model.mid;
        NSDictionary *params = @{@"type":model.type,@"mid":model.mid};
        [_manager miaoShaCheckActionWithParams:params];
    }else{
        LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - MJREfresh
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    NSDictionary *ard = @{@"area_id":[[NSUserDefaults standardUserDefaults]objectForKey:@"regionId"]};
    [_manager getMiaoshaListWithAreaId:ard];
}
-(void)requestSuccess:(id)object withRequestType:(RequestType)requestType{
    switch (requestType) {
        case JHGETMIAOSHALIST:
        {
            [self.header endRefreshing];
            NSDictionary *dic = object;
            self.products = [MiaoshaModel listFromJsonDictionnary:dic];
            if (self.products.count==0||self.products==nil) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"该区域暂时没有秒杀";
                [hud showAnimated:YES whileExecutingBlock:^{
                    sleep(1);
                } completionBlock:^{
                    [hud removeFromSuperview];
                    
                }];
            }
            
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            self.time = [dataDic objectForKey:@"time"];
            self.flag_time = [dataDic objectForKey:@"flag_time"];
            self.flag = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"flag"]];
            if ([self.flag isEqualToString:@"1"]) {
                self.juliLbl.text = @"距离结束";
            }else{
                self.juliLbl.text = @"距离开抢";
            }
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            
            [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
            
            NSDate *date2=[dateFormatter dateFromString:self.flag_time];
            NSDate *date1=[dateFormatter dateFromString:self.time];
            NSTimeInterval timein = [date2 timeIntervalSinceDate:date1];
            
            [timerExample3 removeFromSuperview];
            timerExample3 = [[MZTimerLabel alloc] initWithLabel:self.hideTimeL andTimerType:MZTimerLabelTypeTimer];
            [timerExample3 setCountDownTime:timein]; //** Or you can use [timer3 setCountDownToDate:aDate];
            [timerExample3 start];
            
            
            [self.tableView reloadData];
           
        }
            break;
        case JHMIAOSHADETAIL:
        {
            MiaoshaDetailViewController *vc = [[MiaoshaDetailViewController alloc]initWithNibName:@"MiaoshaDetailViewController" bundle:nil];
            vc.model = [self listFromJsonDictionnary:object];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case JHMIAOSHA:
        {
            //NSLog(@"%@",self.mid);
            NSDictionary *dic = object;
            if ([[dic objectForKey:@"status"]integerValue]==10000) {
                //检测秒杀成功
                [_manager getMiaoshaDetailWithMid:self.mid];
                
            }
        }
        default:
            break;
    }
}

- (MiaoshaDetailModel*)listFromJsonDictionnary:(NSDictionary *)dic{
    NSDictionary *dataDic = [dic objectForKey:@"data"];
    MiaoshaDetailModel *model = [[MiaoshaDetailModel alloc]init];
    model.capacity = [dataDic objectForKey:@"capacity"];
    model.discount_price = [dataDic objectForKey:@"discount_price"];
    model.flag = [dataDic objectForKey:@"flag"];
    model.flag_time = [dataDic objectForKey:@"flag_time"];
    model.imgsrc = [dataDic objectForKey:@"imgsrc"];
    model.limit_amount = [dataDic objectForKey:@"limit_amount"];
    model.mid = [dataDic objectForKey:@"mid"];
    model.pid = [dataDic objectForKey:@"pid"];
    model.remain_amount = [dataDic objectForKey:@"remain_amount"];
    model.title = [dataDic objectForKey:@"title"];
    model.type = [dataDic objectForKey:@"type"];
    model.time = [dataDic objectForKey:@"time"];
    return model;
    
    
    
}

-(void)requestFailure:(id)failReson withRequestType:(RequestType)requestType{
    switch (requestType) {
        case JHGETMIAOSHALIST:
        {
            [self.header endRefreshing];
            if ([failReson isKindOfClass:[NSDictionary class]]) {
                [self.view makeToast:[failReson objectForKey:@"msg"]];
            }else if([failReson isKindOfClass:[NSString class]]){
                [self.view makeToast:failReson];
            }
        }
            break;
        case JHMIAOSHADETAIL:
        {
            if ([failReson isKindOfClass:[NSDictionary class]]) {
                [self.view makeToast:[failReson objectForKey:@"msg"]];
            }else if([failReson isKindOfClass:[NSString class]]){
                [self.view makeToast:failReson];
            }
        }
            break;
        case JHMIAOSHA:
        {
            if ([failReson isKindOfClass:[NSDictionary class]]) {
                [self.view makeToast:[failReson objectForKey:@"msg"]];
            }else if([failReson isKindOfClass:[NSString class]]){
                [self.view makeToast:failReson];
            }
//            NSDictionary *dic = failReson;
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = [dic objectForKey:@"msg"];
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
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"miaoShaQiangGouBtn" object:nil];
    [self.timer invalidate];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 91;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.products.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MiaoshaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    if (!cell) {
        cell = [[MiaoshaTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycell"];
    }
    cell.model = self.products[indexPath.row];
    cell.flag = self.flag;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
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
@end
