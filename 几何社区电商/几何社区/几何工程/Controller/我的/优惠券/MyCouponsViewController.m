//
//  MyCouponsViewController.m
//  几何社区
//
//  Created by KMING on 15/9/22.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "MyCouponsViewController.h"
#import "MyCouponTableViewCell.h"
#import "OutOfDateCouponTableViewController.h"
@interface MyCouponsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MJRefreshBaseViewDelegate>
@property (nonatomic,strong)NSArray *myCoupons;
@property (nonatomic,strong)CouponModel *useCoupon;
@property (nonatomic,strong)MJRefreshHeaderView *header;
@end

@implementation MyCouponsViewController
-(void)viewWillAppear:(BOOL)animated{
//    [self setNavColor:[UIColor whiteColor]];
    [super viewWillAppear:animated];
    [self setLeftNavButtonWithType:BACK];
    
    [self setNavTitleColor:[UIColor blackColor]];
    self.title = @"优惠券";
    _manager.delegate = self;
    
    [MobClick beginLogPageView:@"MyCouponsViewController"];
    
}

- (IBAction)addAction:(UIButton *)sender {
    [self.myTf resignFirstResponder];
    NSDictionary *params = @{@"code":self.myTf.text};
    [_manager addCouponWithParams:params];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (_fromFlag != 1000) {
        NSMutableArray *usableCoupons = [NSMutableArray array];
        for (CouponModel *model in self.myCoupons) {
            if ([model.code_status isEqualToString:@"可用"]) {
                [usableCoupons addObject:model];
            }
        }
        if (section==usableCoupons.count-1) {
            return 50;
        }
        else{
            return 8;
        }
    
    }else{
        return 8;
    }
   
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    NSMutableArray *usableCoupons = [NSMutableArray array];
    for (CouponModel *model in self.myCoupons) {
        if ([model.code_status isEqualToString:@"可用"]) {
            [usableCoupons addObject:model];
        }
    }
    return usableCoupons.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 136;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *usableCoupons = [NSMutableArray array];
    for (CouponModel *model in self.myCoupons) {
        if ([model.code_status isEqualToString:@"可用"]) {
            [usableCoupons addObject:model];
        }
    }
    MyCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyCouponTableViewCell" owner:self options:0]firstObject];
    }
    cell.model = usableCoupons[indexPath.section];
    
    return cell;
}
-(void)makeFooterV{
    UIView *foov = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    
    UILabel *youhuiqLbl = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-12-52, 30, 56, 13)];
    youhuiqLbl.text = @"优惠券>>";
    youhuiqLbl.textColor = Color242424;
    youhuiqLbl.textAlignment = NSTextAlignmentCenter;
    youhuiqLbl.font = [UIFont systemFontOfSize:13];
    [foov addSubview:youhuiqLbl];
    UILabel *yishiyongLbl = [[UILabel alloc]initWithFrame:CGRectMake(youhuiqLbl.frame.origin.x-7*13, 30, 7*13, 13)];
    yishiyongLbl.text = @"已过期或已使用";
    
    yishiyongLbl.textAlignment = NSTextAlignmentCenter;
    yishiyongLbl.font = [UIFont systemFontOfSize:13];
    yishiyongLbl.textColor = [UIColor colorWithRed:0.408 green:0.804 blue:0.729 alpha:1.000];
    [foov addSubview:yishiyongLbl];
    
    UILabel *chakanLbl = [[UILabel alloc]initWithFrame:CGRectMake(yishiyongLbl.frame.origin.x-13*2, 30, 26, 13)];
    chakanLbl.text = @"查看";
    chakanLbl.textColor = Color242424;
    chakanLbl.textAlignment = NSTextAlignmentCenter;
    chakanLbl.font = [UIFont systemFontOfSize:13];
    [foov addSubview:chakanLbl];
    
    UIButton*guoqiBtn = [[UIButton alloc]initWithFrame:CGRectMake(chakanLbl.frame.origin.x-20, 25, SCREEN_WIDTH-chakanLbl.frame.origin.x+20,25 )];
    [guoqiBtn addTarget:self action:@selector(seeOutOfDateCoupon) forControlEvents:UIControlEventTouchUpInside];
    [foov addSubview:guoqiBtn];
    
    self.tableView.tableFooterView = foov;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
        if (_fromFlag != 1000) {
            NSMutableArray *usableCoupons = [NSMutableArray array];
            for (CouponModel *model in self.myCoupons) {
                if ([model.code_status isEqualToString:@"可用"]) {
                    [usableCoupons addObject:model];
                }
            }
            
            if (section==usableCoupons.count-1) {
                UIView *foov = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
                
                UILabel *youhuiqLbl = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-12-52, 30, 56, 13)];
                youhuiqLbl.text = @"优惠券>>";
                youhuiqLbl.textColor = Color242424;
                youhuiqLbl.textAlignment = NSTextAlignmentCenter;
                youhuiqLbl.font = [UIFont systemFontOfSize:13];
                [foov addSubview:youhuiqLbl];
                UILabel *yishiyongLbl = [[UILabel alloc]initWithFrame:CGRectMake(youhuiqLbl.frame.origin.x-7*13, 30, 7*13, 13)];
                yishiyongLbl.text = @"已过期或已使用";
                
                yishiyongLbl.textAlignment = NSTextAlignmentCenter;
                yishiyongLbl.font = [UIFont systemFontOfSize:13];
                yishiyongLbl.textColor = [UIColor colorWithRed:0.408 green:0.804 blue:0.729 alpha:1.000];
                [foov addSubview:yishiyongLbl];
                
                UILabel *chakanLbl = [[UILabel alloc]initWithFrame:CGRectMake(yishiyongLbl.frame.origin.x-13*2, 30, 26, 13)];
                chakanLbl.text = @"查看";
                chakanLbl.textColor = Color242424;
                chakanLbl.textAlignment = NSTextAlignmentCenter;
                chakanLbl.font = [UIFont systemFontOfSize:13];
                [foov addSubview:chakanLbl];
                
                UIButton*guoqiBtn = [[UIButton alloc]initWithFrame:CGRectMake(chakanLbl.frame.origin.x-20, 25, SCREEN_WIDTH-chakanLbl.frame.origin.x+20,25 )];
                [guoqiBtn addTarget:self action:@selector(seeOutOfDateCoupon) forControlEvents:UIControlEventTouchUpInside];
                [foov addSubview:guoqiBtn];
                return foov;
            }else{
                UIView *footv= [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
                footv.backgroundColor = HEADERVIEW_COLOR;
                return footv;
            }

        }else{
            UIView *footv= [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
            footv.backgroundColor = HEADERVIEW_COLOR;
            return footv;
        }
    
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_fromFlag == 1000) {
        NSMutableArray *usableCoupons = [NSMutableArray array];
        for (CouponModel *model in self.myCoupons) {
            if ([model.code_status isEqualToString:@"可用"]) {
                [usableCoupons addObject:model];
            }
        }
        _useCoupon = [usableCoupons objectAtIndex:indexPath.row];
        [_manager useCouponWithCoupon:_useCoupon.code];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = HEADERVIEW_COLOR;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 108, SCREEN_WIDTH, SCREEN_HEIGHT-108)];
    //self.tableView.hidden=YES;
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    _manager = [JHDataManager getInstance];
    _manager.delegate = self;
    [_manager getAllCoupon];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.labelText =@"加载中...";
    
    
    
    self.myTf.delegate = self;
    if (_fromFlag != 1000) {
        [self makeFooterV];
    }
    self.header = [MJRefreshHeaderView header];
    self.header.scrollView = self.tableView;
    self.header.delegate = self;
}
#pragma mark - MJRefresh
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    [_manager getAllCoupon];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)seeOutOfDateCoupon{
    OutOfDateCouponTableViewController *vc =[[OutOfDateCouponTableViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)requestSuccess:(id)object withRequestType:(RequestType)requestType{
    switch (requestType) {
        case JHGETCOUPON:
        {
            
            //self.tableView.hidden = NO;
            [self.header endRefreshing];
            self.myCoupons = object;
            [self.tableView reloadData];
            
            MBProgressHUD *hud = [MBProgressHUD HUDForView:[UIApplication sharedApplication].keyWindow];
            [hud removeFromSuperview];
            if (_fromFlag != 1000) {
                NSMutableArray *usableCoupons = [NSMutableArray array];
                for (CouponModel *model in self.myCoupons) {
                    if ([model.code_status isEqualToString:@"可用"]) {
                        [usableCoupons addObject:model];
                    }
                }
                //如果有可用的，让tableview的footerview为空，但是通过代理显示section的footer
                if (usableCoupons.count!=0) {
                    self.tableView.tableFooterView = [[UIView alloc]init];
                }
            
            }else{
                self.tableView.tableFooterView = [[UIView alloc]init];
            }
            
           
        }
            
            break;
        case JHADDCOUPON:
        {
            NSDictionary *dic = object;
            
            //NSString *status = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"添加成功";
            self.myTf.text = @"";
            [hud showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [hud removeFromSuperview];
                [_manager getAllCoupon];
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                hud.labelText =@"加载中...";
                [self.tableView reloadData];
                
            }];
//            if ([status isEqualToString:@"10001"]) {
//                if ([[dic objectForKey:@"msg"]isEqualToString:@"该券不存在"]) {
//                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//                    hud.mode = MBProgressHUDModeText;
//                    hud.labelText = @"优惠码输入有误";
//                    [hud showAnimated:YES whileExecutingBlock:^{
//                        sleep(1);
//                    } completionBlock:^{
//                        [hud removeFromSuperview];
//                        
//                    }];
//                }else if ([[dic objectForKey:@"msg"]isEqualToString:@"该券已被领取"]){
//                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//                    hud.mode = MBProgressHUDModeText;
//                    hud.labelText = @"该券已被领取";
//                    [hud showAnimated:YES whileExecutingBlock:^{
//                        sleep(1);
//                    } completionBlock:^{
//                        [hud removeFromSuperview];
//                        
//                    }];
//                }
//                
//            }else if ([status isEqualToString:@"10000"]){
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//                hud.mode = MBProgressHUDModeText;
//                hud.labelText = @"添加成功";
//                self.myTf.text = @"";
//                [hud showAnimated:YES whileExecutingBlock:^{
//                    sleep(1);
//                } completionBlock:^{
//                    [hud removeFromSuperview];
//                    [_manager getAllCoupon];
//                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
//                    hud.labelText =@"加载中...";
//                    [self.tableView reloadData];
//                    
//                }];
//            }
        }
            
            break;
        case JHUSECOUPON:
        {
            NSString *status = [NSString stringWithFormat:@"%@",[object objectForKey:@"status"]];
            if ([status isEqualToString:@"10000"]){
                if (_delegate &&[_delegate respondsToSelector:@selector(reloadCheckOut)]) {
                    [_delegate reloadCheckOut];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }else{
                [self.view makeToast:[object objectForKey:@"msg"]];
            }
        }
            break;
            
        default:
            break;
    }
}
-(void)requestFailure:(id)failReson withRequestType:(RequestType)requestType{
    NSLog(@"%@",failReson);
    [self.header endRefreshing];
    MBProgressHUD *hud = [MBProgressHUD HUDForView:[UIApplication sharedApplication].keyWindow];
    [hud removeFromSuperview];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MyCouponsViewController"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [self.header free];
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
