//
//  ChooseAddressTableViewController.m
//  几何社区
//
//  Created by KMING on 15/8/29.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "ChooseAddressTableViewController.h"
#import "AddAddressViewController.h"
#import "MyAddressModel.h"
#import "MyAddressTableVIewCell.h"
#import "MBProgressHUD.h"
@interface ChooseAddressTableViewController ()<SWTableViewCellDelegate,UIActionSheetDelegate,JHDataMagerDelegate,MJRefreshBaseViewDelegate>

@property (nonatomic,strong)NSIndexPath *cellIndexPath;//要删除的indexpath
@end

@implementation ChooseAddressTableViewController

-(void)viewWillAppear:(BOOL)animated{
    [self setNavColor:[UIColor whiteColor]];
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"ChooseAddressTableViewController"];
    
    
    self.title = @"选择收货地址";
    [self setNavTitleColor:[UIColor blackColor]];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
//    // hud.mode = MBProgressHUDModeText;
//    hud.labelText = @"加载地址中...";
    
    
    
    

    [self.tableView setTableFooterView:[[UIView alloc]init]];
    _manager.delegate = self;
     NSDictionary *dic =@{@"page":@"1"};
    [_manager getAddressWithParams:dic];
    [self.tableView reloadData];
}
#pragma mark - MJREfresh
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if (refreshView.tag==0) {
        NSDictionary *dic =@{@"page":@"1"};
        [_manager getAddressWithParams:dic];
    }
//    else{
//        self.page = self.page+1;
//        NSDictionary *dic = @{@"page":[NSString stringWithFormat:@"%d",self.page]};
//        [_manager getAddressWithParams:dic];
//    }
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ChooseAddressTableViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.addressArr = [NSMutableArray array];
    self.view.backgroundColor = HEADERVIEW_COLOR;
    _manager = [JHDataManager getInstance];
    _manager.delegate = self;
    self.title = @"选择收货地址";
    [self setLeftNavButtonWithType:BACK];
    [self setRightNavButtonWithType:ADD];
    self.page = 1;
    self.header = [MJRefreshHeaderView header];
    self.header.scrollView = self.tableView;
    self.header.tag = 0;
    self.header.delegate = self;
//    self.footer = [MJRefreshFooterView footer];
//    self.footer.scrollView = self.tableView;
//    self.footer.delegate = self;
//    self.footer.tag = 1;
    
}
#pragma mark 改变分割线从左开始
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

#pragma mark - 跳回页面
-(void)goBackPage{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.addressArr.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]
                    initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    
    UIView *downLine = [[UIView alloc]initWithFrame:CGRectMake(0, 7.5, SCREEN_WIDTH, 0.5)];
    downLine.backgroundColor = SEPARATELINE_COLOR;
    [view addSubview:downLine];
    
    view.backgroundColor = HEADERVIEW_COLOR;
    return view;

}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyAddressTableVIewCell *cell =[[[NSBundle mainBundle]loadNibNamed:@"MyAddressTableVIewCell" owner:self options:0]firstObject];
    
    
    //cell继承与三方框架，有侧滑功能，需要delegate;
    MyAddressModel *model = self.addressArr[indexPath.row];
    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:72.0f];
    cell.delegate = self;
    cell.addressLabel.text = model.address;

    cell.nameLabel.text = model.name;
    cell.phoneLabel.text = model.phonenum;
    cell.selectionStyle = UITableViewCellStyleDefault;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}


- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.733 green:0.729 blue:0.757 alpha:1.000]
                                                title:@"编辑"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     RGBCOLOR(251, 78, 71, 1)
                                                title:@"删除"];
    
    return rightUtilityButtons;
}
#pragma mark - SWTableViewDelegate
- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
           // NSLog(@"编辑");
            [cell hideUtilityButtonsAnimated:YES];
            AddAddressViewController *vc = [[AddAddressViewController alloc]initWithNibName:@"AddAddressViewController" bundle:nil];
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
            MyAddressModel *model = self.addressArr[cellIndexPath.row];
            vc.myaddressM = model;//传给下一页编辑
            vc.selectIndex=cellIndexPath.row;
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case 1:
        {
            // Delete button was pressed
             self.cellIndexPath = [self.tableView indexPathForCell:cell];
            UIActionSheet *as = [[UIActionSheet alloc]initWithTitle:@"确认删除收货地址？此操作不可逆" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [as showInView:self.view];
            
            break;
        }
        default:
            break;
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        NSNumber *myNumber = [NSNumber numberWithInteger:self.cellIndexPath.row];
        NSDictionary *params = @{@"id":myNumber};
        [_manager deleteAddressWithParams:params];
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"删除中";
//        [hud showAnimated:YES whileExecutingBlock:^{
//            sleep(10);
//        } completionBlock:^{
//            [hud removeFromSuperview];
//            
//        }];

        

        
        
    }
}
-(void)requestSuccess:(id)object withRequestType:(RequestType)requestType{
    switch (requestType) {
        case JHGETADDRESS:
        {
//            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.tableView];
           
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = @"加载成功";
//            [hud showAnimated:YES whileExecutingBlock:^{
//                sleep(1);
//            } completionBlock:^{
//                [hud removeFromSuperview];
//                
//            }];
            [self.header endRefreshing];
            [self.footer endRefreshing];
            NSArray *orderArr = object;
            if (self.page==1) {
                //下拉刷新
                self.addressArr = [orderArr mutableCopy];
            }else{
                //上拉加载
                [self.addressArr addObjectsFromArray:orderArr];
            }
            [self.tableView reloadData];
        }
            break;
        case JHDELETEADDRESS:
        {
            NSDictionary *dic = object;
            NSString *status = [NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]];
            if ([status isEqualToString:@"10000"]) {
//                MBProgressHUD *hud =  [MBProgressHUD HUDForView:self.tableView];
//                hud.mode = MBProgressHUDModeText;
//                hud.labelText = @"删除成功";
//                [hud showAnimated:YES whileExecutingBlock:^{
//                    sleep(1);
//                } completionBlock:^{
//                    [hud removeFromSuperview];
//                    [_manager getAddress];
//                    
//                }];
                NSDictionary *dic =@{@"page":@"1"};
                [_manager getAddressWithParams:dic];
            }
            
        }
            break;
            
        default:
            break;
    }

}
-(void)requestFailure:(id)failReson withRequestType:(RequestType)requestType{
    [self.header endRefreshing];
    [self.footer endRefreshing];
    if (self.page!=1) {
        self.page = self.page-1;
    }
    NSLog(@"%@",failReson);
    if (!failReson) {
        failReson=@"加载失败";
    }
//    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.tableView];
//    hud.mode = MBProgressHUDModeText;
//    hud.labelText = failReson;
//    [hud showAnimated:YES whileExecutingBlock:^{
//        sleep(1);
//    } completionBlock:^{
//        [hud removeFromSuperview];
//        
//    }];
    
}
-(void)dealloc{
    [self.header free];
    [self.footer free];
}
@end
