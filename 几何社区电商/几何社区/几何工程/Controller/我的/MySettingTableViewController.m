//
//  MySettingTableViewController.m
//  几何社区
//
//  Created by 李明翰 on 15/8/21.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "MySettingTableViewController.h"
#import "SettingCellModel.h"
#import "Define.h"
#import "SettingFirstTableViewCell.h"
#import "MyOrderViewController.h"
#import "ChooseAddressTableViewController.h"
#import "MyCouponsViewController.h"
#import "SettingLoginTableViewCell.h"
#import "LoginViewController.h"
#import "SettingViewController.h"
#import "CouponModel.h"
#import "ShareTableViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ShareModel.h"
@interface MySettingTableViewController ()<JHDataMagerDelegate>
@property (nonatomic,strong)NSMutableArray *datalist;
@property (nonatomic,copy)NSString *logState;//登录状态，从nsuserdefualt获取
@property (nonatomic,strong)NSMutableArray *usableCoupons;//可用优惠券，主要用来显示数量
@property (nonatomic,strong)UILabel *usableCouponNumLbl;//cell上面可用优惠券个数
@property (nonatomic,strong)UILabel *kefuphone;//cell上客服电话
@property (nonatomic,strong)ShareModel *model;
@property (nonatomic,strong)UIView *centerLine;//section0中间的线
@property (nonatomic,strong)UIView *downLine;
@end

@implementation MySettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor  = HEADERVIEW_COLOR;
    self.tableView.tableFooterView = [[UIView alloc]init];
    //如果自定义了navigationItem的leftBarButtonItem，那么这个手势就会失效。解决:
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    _manager = [JHDataManager getInstance];
    
    
    
}

-(void)requestSuccess:(id)object withRequestType:(RequestType)requestType{
    switch (requestType) {
        case JHGETCOUPON:{
            NSArray* myCoupons=object;
            self.usableCoupons = [NSMutableArray array];
            for (CouponModel *model in myCoupons) {
                if ([model.code_status isEqualToString:@"可用"]) {
                    [self.usableCoupons addObject:model];
                }
            }
            [self.tableView reloadData];
        }
           
            break;
        case JHGETSHARE:
        {
            
             self.model = object;
            [self.tableView reloadData];
            
        }
            break;
            
        default:
            break;
    }
}
-(void)requestFailure:(id)failReson withRequestType:(RequestType)requestType{
    switch (requestType) {
        case JHGETCOUPON:
            NSLog(@"获取优惠券失败");
            break;
        case JHGETSHARE:
        {
            NSLog(@"获取分享信息失败");
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
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor = NAVIGATIONBAR_COLOR;
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"MySettingTableViewController"];
    
    self.logState=[[NSUserDefaults standardUserDefaults]objectForKey:@"logState"];//读取登录状态
    [self.tableView reloadData];
    
    UILabel *wode = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    wode.text = @"我的";
    wode.textAlignment = NSTextAlignmentCenter;
    wode.font = [UIFont boldSystemFontOfSize:18];
    wode.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = wode;
    _manager.delegate = self;
    [_manager getAllCoupon];
    [_manager getShareInfo];
    //self.logState = @"1";
    
//    if (!self.logState) {
//        UIButton *logBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 36, 16)];
//        [logBtn addTarget:self action:@selector(logAction) forControlEvents:UIControlEventTouchUpInside];
//        [logBtn setTitle:@"登录" forState:UIControlStateNormal];
//        UIBarButtonItem *rightbbt = [[UIBarButtonItem alloc]initWithCustomView:logBtn];
//        self.navigationItem.rightBarButtonItem = rightbbt;
//    }else{
//        self.navigationItem.rightBarButtonItem = nil;
//    }

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    
    [MobClick endLogPageView:@"MySettingTableViewController"];
    
    

}
-(void)logAction{
    LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    [self presentViewController:vc animated:YES completion:nil];
}
/**
 *  懒加载，初始化数据原数组
 */
-(NSMutableArray *)datalist{
    if (!_datalist) {
        _datalist =[NSMutableArray array];
        SettingCellModel *section11 = [[SettingCellModel alloc]init];
        section11.image = [UIImage imageNamed:@"tx"];
        section11.content =@"点击登录";
        NSArray *sec1arr = [NSArray arrayWithObject:section11];
        
        SettingCellModel *section21 = [[SettingCellModel alloc]init];
        section21.image = [UIImage imageNamed:@"icon01"];
        section21.content =@"邀请好友送优惠券";
        
        SettingCellModel *section22 = [[SettingCellModel alloc]init];
        section22.image = [UIImage imageNamed:@"icon03"];
        section22.content =@"优惠券";
        NSArray *sec2arr = @[section21,section22];
        
        SettingCellModel *section31 = [[SettingCellModel alloc]init];
        section31.image = [UIImage imageNamed:@"icon04"];
        section31.content =@"我的订单";
        NSArray *sec3arr = [NSArray arrayWithObject:section31];
        SettingCellModel *section41 = [[SettingCellModel alloc]init];
        section41.image = [UIImage imageNamed:@"icon05"];
        section41.content =@"收货地址";
        NSArray *sec4arr = [NSArray arrayWithObject:section41];
        
//        SettingCellModel *section51 = [[SettingCellModel alloc]init];
//        section51.image = [UIImage imageNamed:@"sz"];
//        section51.content =@"设置";
//        NSArray *sec5arr = [NSArray arrayWithObject:section41];
        
        SettingCellModel *section51 = [[SettingCellModel alloc]init];
        section51.image = [UIImage imageNamed:@"icon06"];
        section51.content =@"客服电话";

        
        NSArray *sec5arr = [NSArray arrayWithObject:section51];
        [self.datalist addObject:sec1arr];
        [self.datalist addObject:sec2arr];
        [self.datalist addObject:sec3arr];
        [self.datalist addObject:sec4arr];
        [self.datalist addObject:sec5arr];
        //[self.datalist addObject:sec5arr];
    }
    return _datalist;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
//        UIView *view = [[UIView alloc]
//                        initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12)];
//        view.backgroundColor = HEADERVIEW_COLOR;
//        UIView *downline = [[UIView alloc]initWithFrame:CGRectMake(0, 11.5, SCREEN_WIDTH, 0.5)];
//        downline.backgroundColor = SEPARATELINE_COLOR;
//        [view addSubview:downline];
//        
//        return view;
        return nil;
    }else if (section==1){
        UIView *view = [[UIView alloc]
                        initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 12)];
        view.backgroundColor = HEADERVIEW_COLOR;
        UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        topline.backgroundColor = SEPARATELINE_COLOR;
        [view addSubview:topline];
        UIView *downline = [[UIView alloc]initWithFrame:CGRectMake(0, 11.5, SCREEN_WIDTH, 0.5)];
        downline.backgroundColor = SEPARATELINE_COLOR;
        [view addSubview:downline];
        return view;
    }
    else{
        UIView *view = [[UIView alloc]
                        initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
        view.backgroundColor = HEADERVIEW_COLOR;
        UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        topline.backgroundColor = SEPARATELINE_COLOR;
        [view addSubview:topline];
        UIView *downline = [[UIView alloc]initWithFrame:CGRectMake(0, 7.5, SCREEN_WIDTH, 0.5)];
        downline.backgroundColor = SEPARATELINE_COLOR;
        [view addSubview:downline];
        return view;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.datalist[section];
    return arr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //return 5;
    return self.datalist.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        return 80;
    }else{
        return 44;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        return 0;
    }else if (section==1){
        return 12;
    }
    else{
        return 8;
    }
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//去除分隔线
    if (indexPath.section==0) {
        SettingFirstTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"SettingFirstTableViewCell" owner:self options:0]firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!self.logState) {
            cell.nickname.text = @"尊敬的用户";
            cell.phonenum.text = @"登录后获得更多特权";
        }else{
            if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"name"]isEqualToString:@""]||[[NSUserDefaults standardUserDefaults]objectForKey:@"name"]==nil) {
                cell.nickname.text = @"尊敬的用户";
            }else{
                cell.nickname.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"name"];
            }
            
            cell.phonenum.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"phone"];
        }
        UIImageView *right = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
        cell.accessoryView = right;
        if (self.logState) {
            [cell.touxiang setImageWithURL:[NSURL URLWithString:self.model.headimgurl] placeholderImage:[UIImage imageNamed:@"tx"]];
            cell.touxiang.layer.masksToBounds = YES;
            cell.touxiang.layer.cornerRadius = 24;
        }else{
            cell.touxiang.image = [UIImage imageNamed:@"tx"];
        }
        
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"mycell"];
        }
        NSArray *arr = self.datalist[indexPath.section];
        SettingCellModel *mod = arr[indexPath.row];
        cell.imageView.image = mod.image;
        cell.textLabel.text = mod.content;
        cell.textLabel.textColor =Color242424;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        UIImageView *right = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow"]];
        cell.accessoryView = right;
        if (indexPath.section==1) {
            if (indexPath.row==0) {
                if (!self.centerLine) {
                    self.centerLine = [[UIView alloc]initWithFrame:CGRectMake(54, 43.5, SCREEN_WIDTH, 0.5)];
                    self.centerLine.backgroundColor = SEPARATELINE_COLOR;
                    [cell.contentView addSubview:self.centerLine];
                }
            }
            else{
                
                //如果登录了，显示有几张优惠券可用
                if (self.logState) {
                    //如果有文字了，就不再重复addsubview了
                    if (self.usableCouponNumLbl) {
                        self.usableCouponNumLbl.text = [NSString stringWithFormat:@"%lu张可用",(unsigned long)self.usableCoupons.count];
                    }else{
                        self.usableCouponNumLbl = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
                        self.usableCouponNumLbl.textAlignment = NSTextAlignmentRight;
                        self.usableCouponNumLbl.center = CGPointMake(SCREEN_WIDTH-27-80, 22);
                        self.usableCouponNumLbl.text = [NSString stringWithFormat:@"%lu张可用",(unsigned long)self.usableCoupons.count];
                        self.usableCouponNumLbl.font = [UIFont systemFontOfSize:12];
                        self.usableCouponNumLbl.textColor =[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1];
                        
                        [cell.contentView addSubview:self.usableCouponNumLbl];
                    }
                    
                }
                //没登陆隐藏
                else{
                    self.usableCouponNumLbl.text = @"";
                }
            }
        }
        //添加客服电话
        if (indexPath.section==4) {
            if (indexPath.row==0) {
                if (!self.kefuphone) {
                    self.kefuphone = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 20)];
                    self.kefuphone.textAlignment = NSTextAlignmentRight;
                    self.kefuphone.center = CGPointMake(SCREEN_WIDTH-27-80, 22);
                    self.kefuphone.text = @"400-022-2900";
                    self.kefuphone.font = [UIFont systemFontOfSize:12];
                    self.kefuphone.textColor =[UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1];
                    [cell.contentView addSubview:self.kefuphone];
                    
                    if (!self.downLine) {
                        self.downLine = [[UIView alloc]initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5)];
                        self.downLine.backgroundColor = SEPARATELINE_COLOR;
                        [cell.contentView addSubview:self.downLine];
                    }
                    
                }
                
                
            }
        }
        
        //self.tableView.showsVerticalScrollIndicator = NO;//垂直的滚动条消失，4s需要滚到
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;

    }
    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        if (!self.logState) {
            LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            [self presentViewController:vc animated:YES completion:nil];
        }else{
            SettingViewController *vc = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (indexPath.section == 1) {
        /* 没有登录就去登录*/
        if (!self.logState) {
            LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            [self presentViewController:vc animated:YES completion:nil];
        }else{
            if (indexPath.row == 0) {
                ShareTableViewController *vc = [[ShareTableViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
                
            }else if(indexPath.row == 1){
                MyCouponsViewController *vc = [[MyCouponsViewController alloc]initWithNibName:@"MyCouponsViewController" bundle:nil];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }else if (indexPath.section==2) {
        /* 没有登录就去登录*/
        if (!self.logState) {
            LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            [self presentViewController:vc animated:YES completion:nil];
        }else{
            MyOrderViewController *vc = [[MyOrderViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }else if (indexPath.section==3){
        /* 没有登录就去登录*/
        if (!self.logState) {
            LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
            [self presentViewController:vc animated:YES completion:nil];
        }else{
            ChooseAddressTableViewController *vc = [[ChooseAddressTableViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
    //    else if (indexPath.section==3){
    //        SettingViewController *vc = [[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
    //        [self.navigationController pushViewController:vc animated:YES];
    //    }
    else if (indexPath.section==4){
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4000222900"];
        //            NSLog(@"str======%@",str);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
    
    
}





@end
