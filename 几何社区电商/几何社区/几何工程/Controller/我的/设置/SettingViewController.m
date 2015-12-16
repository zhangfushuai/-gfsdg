//
//  SettingViewController.m
//  几何社区
//
//  Created by KMING on 15/9/14.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "SettingViewController.h"
#import "AboutUsViewController.h"
@interface SettingViewController ()<UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong)NSArray *dataSourse;
@property (nonatomic, strong)NSString* logState;

@end

@implementation SettingViewController
-(void)viewWillAppear:(BOOL)animated{
//    [self setNavColor:[UIColor whiteColor]];
    [super viewWillAppear:animated];
    
    [self setLeftNavButtonWithType:BACK];
    [self setNavTitleColor:[UIColor blackColor]];
    self.title = @"设置";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEADERVIEW_COLOR;
    _logState=[[NSUserDefaults standardUserDefaults]objectForKey:@"logState"];//读取登录状态
    if (_logState) {
        _dataSourse = [[NSArray alloc] initWithObjects:@"消息提醒",@"关于我们",@"检测版本",@"退出登录",nil];
    }else{
        _dataSourse = [[NSArray alloc] initWithObjects:@"消息提醒",@"关于我们",@"检测版本",nil];
    }
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = HEADERVIEW_COLOR;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSourse.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
    }
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    line.backgroundColor = SEPARATELINE_COLOR;
    [cell.contentView addSubview:line];
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, SCREEN_WIDTH, 0.5)];
    line1.backgroundColor = SEPARATELINE_COLOR;
    [cell.contentView addSubview:line1];

    if (indexPath.section == _dataSourse.count-1) {
        if (_logState) {
            UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, cell.contentView.frame.size.height)];
            [cell.contentView addSubview:label];
            label.text = _dataSourse.lastObject;
            label.font = [UIFont systemFontOfSize:15];
            label.textAlignment = NSTextAlignmentCenter;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else{
            cell.textLabel.text = [_dataSourse objectAtIndex:indexPath.section];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else{
        cell.textLabel.text = [_dataSourse objectAtIndex:indexPath.section];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 0) {
        UISwitch  *onoff = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 51 - 12, 5, 51, 30)];
        //        [onoff addTarget:self action:@selector(payWaySelect:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:onoff];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {}
            break;
        case 1:
        {
            [self aboutUs];
        }
            break;
        case 2:
        {
            JHDataManager *manager = [JHDataManager getInstance];
            manager.delegate = self;
            [manager getAppVersion];
        }
            break;
        case 3:
        {
            [self logOutAction];
        }
            break;
            
        default:
            break;
    }
}
- (void)logOutAction{
    
    NSDictionary *dict = @{@"phone" : [[NSUserDefaults standardUserDefaults]objectForKey:@"phone"]};
    [MobClick event:@"logoutAction" attributes:dict];
       
    UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"退出后不会删除任何历史数据,下次登录依然可以使用本账号" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登录" otherButtonTitles:nil, nil];
    
    [as showInView:self.view];
    
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
   // NSLog(@"%ld",buttonIndex);
    if (buttonIndex==0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud removeObjectForKey:@"logState"];//删除登录状态
        [ud removeObjectForKey:@"phone"];
        [ud removeObjectForKey:@"name"];
        [ud removeObjectForKey:@"number"];
        JHGlobalApp.tabBarControllder.shopcar.tabBarItem.badgeValue = nil;
        [ud synchronize];

        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"cookie_key"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)aboutUs{
    AboutUsViewController *vc = [[AboutUsViewController alloc]initWithNibName:@"AboutUsViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)requestSuccess:(id)object withRequestType:(RequestType)requestType
{
    if (requestType == JHAPPVERSION) {
        {
            NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
            NSString *currentVersion = [infoDict objectForKey:@"CFBundleVersion"];
            if (![currentVersion isEqualToString:object]) {
                NSString *msg = [NSString stringWithFormat:@"你当前的版本是V%@,发现新版本V%@,是否下载新版本？",currentVersion,object];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"升级提示!" message:msg delegate:self cancelButtonTitle:@"下次再说" otherButtonTitles:@"现在升级", nil];
                
                [alert show];
            }else{
                NSString *msg = [NSString stringWithFormat:@"你当前的版本已经是新版本V%@",currentVersion];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"升级提示!" message:msg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                
                [alert show];
            }
        }
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //软件需要更新提醒
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.hey900.com/ucab1.html"]];
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
