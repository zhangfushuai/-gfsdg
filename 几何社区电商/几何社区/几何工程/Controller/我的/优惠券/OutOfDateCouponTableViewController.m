//
//  OutOfDateCouponTableViewController.m
//  几何社区
//
//  Created by KMING on 15/9/29.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "OutOfDateCouponTableViewController.h"
#import "MyCouponTableViewCell.h"
@interface OutOfDateCouponTableViewController ()<JHDataMagerDelegate>
@property (nonatomic,strong)NSArray *coupons;
@end

@implementation OutOfDateCouponTableViewController
-(void)viewWillAppear:(BOOL)animated{
    [self setNavColor:[UIColor whiteColor]];
    [super viewWillAppear:animated];
    [self setLeftNavButtonWithType:BACK];
    [self setNavTitleColor:[UIColor blackColor]];
    self.title = @"优惠券";
    _manager.delegate = self;
    [_manager getUsedCoupon];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _manager = [JHDataManager getInstance];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
     self.tableView.tableFooterView = [[UIView alloc]init];
}
-(void)requestSuccess:(id)object withRequestType:(RequestType)requestType{
    switch (requestType) {
        case JHGETUSEDCOUPON:
        {
            self.coupons = object;
            [self.tableView reloadData];
            
            
        }
            break;
            
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _manager.delegate=nil;
}
#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 136;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.coupons.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    MyCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyCouponTableViewCell" owner:self options:0]firstObject];
    }
    
    cell.model = self.coupons[indexPath.section];
    cell.backimg.image = [UIImage imageNamed:@"invalid"];
    return cell;
    
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0){
        UIView *view = [[UIView alloc]
                        initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
        view.backgroundColor = [UIColor whiteColor];
               UIView *downline = [[UIView alloc]initWithFrame:CGRectMake(0, 7.5, SCREEN_WIDTH, 0.5)];
        downline.backgroundColor = SEPARATELINE_COLOR;
        [view addSubview:downline];
        return view;
    }
    else{
        UIView *view = [[UIView alloc]
                        initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
        view.backgroundColor = [UIColor whiteColor];
        UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        topline.backgroundColor = SEPARATELINE_COLOR;
        [view addSubview:topline];
        UIView *downline = [[UIView alloc]initWithFrame:CGRectMake(0, 7.5, SCREEN_WIDTH, 0.5)];
        downline.backgroundColor = SEPARATELINE_COLOR;
        [view addSubview:downline];
        return view;
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
