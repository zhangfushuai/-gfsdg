//
//  CouponListViewController.m
//  几何社区
//
//  Created by 颜 on 15/9/1.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "CouponListViewController.h"
#import "CouponCell.h"

@interface CouponListViewController () <UITableViewDelegate,UITableViewDataSource>
{
    NSInteger selectFlag;
}

@end

@implementation CouponListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    selectFlag = 0;
    if(self.datasourse.count == 0){
        self.tableview.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.datasourse count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CouponCell *cell = [tableView dequeueReusableCellWithIdentifier:@"coupon"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CouponCell" owner:self options:0] firstObject] ;
        if (self.type == VALID) {
            cell.imgVbackGroud.image = [UIImage imageNamed:@"valid"];
            cell.imgVused.hidden = NO;
//            cell.lblMonney.textColor = [UIColor grayColor];
        }else{
            cell.imgVbackGroud.image = [UIImage imageNamed:@"invalid"];
            cell.imgVused.hidden = YES;
            cell.lblMonney.textColor = [UIColor grayColor];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lblPassword.text = [NSString stringWithFormat:@"券密码:%@",@"10000"];

    if (self.type == VALID) {
        cell.lblName.text = @"1";
        cell.lblTimeOut.text = [NSString stringWithFormat:@"有效期:%@",@"10000"];
        cell.lblMessage.text = @"说明";
        if (indexPath.row == selectFlag) {
            cell.imgVused.image = [UIImage imageNamed:@"Selected"];
        }else{
            cell.imgVused.image = [UIImage imageNamed:@"unSelected"];
        }
    }else if(self.type == USED){
        cell.lblName.text = @"1";
        cell.lblTimeOut.text = [NSString stringWithFormat:@"使用期:%@",@"10000"];
        cell.lblMessage.text = @"说明";
    }else if(self.type == TIMEOUT){
        cell.lblName.text = @"1";
        cell.lblTimeOut.text = [NSString stringWithFormat:@"有效期:%@",@"10000"];
        cell.lblMessage.text = @"说明";
    }
   
    cell.lblMonney.text = [NSString stringWithFormat:@"¥%@",@"10"];;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == VALID) {
        /*可使用*/
        if (self.datasourse.count >0) {
            selectFlag = indexPath.row;
            [tableView reloadData];
        }
    }else{
        /*不可使用*/
    }
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
