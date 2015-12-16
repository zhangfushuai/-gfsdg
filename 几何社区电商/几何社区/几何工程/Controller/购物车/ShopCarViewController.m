//
//  ShopCarViewController.h
//  几何社区
//
//  Created by 颜 on 15/9/14.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

enum{
    ADDGOOD     = 100,
    REDUCGOOD   = 101,
    DELETEGOOD  = 102,
};
#import "ShopCarViewController.h"
#import "CarGoodCell.h"
#import "UIImageView+AFNetworking.h"
#import "ConfirmViewController.h"
#import "LoginViewController.h"
#import "CouponModel.h"
#import "ProductDetailViewController.h"
@interface ShopCarViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , strong)UITableView *tableView;
@property (nonatomic , strong)NSArray *datasourse;
@property (nonatomic , strong)NSMutableDictionary *selectDict;
@property (nonatomic , strong)NSMutableArray      *selectArr;
@property (nonatomic , strong)NSMutableDictionary *changeCountDict;
//@property (nonatomic , strong)NSMutableDictionary *changeLocalCountDict;
@property (nonatomic , assign)NSInteger changeCountFlag;  //记录改变第几个商品
@property (nonatomic , assign)NSInteger changeType;

@property (nonatomic , strong)UIView *nonThingView;
@end

@implementation ShopCarViewController
- (id)init
{
    if (self == [super init]) {
        //读取购物车有几个商品
        NSString *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"number"];
        if ([number integerValue]<=0 && number) {
            self.tabBarItem.badgeValue= nil;
        }else{
            self.tabBarItem.badgeValue = number;
        }
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _lineHeight.constant = 0.5;
    self.view.backgroundColor = HEADERVIEW_COLOR;
    if(_fromFlag == 1000){
        [self setNavTitleColor:[UIColor whiteColor]];
        _viewButtomSpace.constant = 49;
        _btnButtomSpace.constant = 49;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49-49)];
    }else if(_fromFlag == 1001){
        [self setNavTitleColor:[UIColor blackColor]];
        _viewButtomSpace.constant = 0;
        _btnButtomSpace.constant = 0;
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-49)];
        [self setLeftNavButtonWithType:BACK];
    }
    _confirmFooterView.hidden = YES;
    _btnConfirm.hidden = YES;
    _tableView.hidden = YES;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = RGBCOLOR(249, 249, 249, 1);
    UIView *footer = [[UIView alloc] init];
    footer.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = footer;
    _datasourse = [[NSArray alloc] init];
    _manager = [JHDataManager getInstance];
    _manager.delegate = self;
    

}
- (void)loadNonView
{
    if (!_nonThingView) {
        _nonThingView = [[UIView alloc] initWithFrame:self.view.frame];
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-32, (SCREEN_HEIGHT)/2-62, 64, 64)];
        imgV.image = [UIImage imageNamed:@"car"];
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, (SCREEN_HEIGHT)/2+18, SCREEN_WIDTH, 30)];
        lblTitle.text = @"亲,您的购物车什么都没有";
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.textColor= RGBCOLOR(0, 0, 0, 0.26);
        UIButton *btnGoHomePage = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-64, (SCREEN_HEIGHT)/2+38+20, 128, 32)];
        btnGoHomePage.titleLabel.font= [UIFont  systemFontOfSize:15];
        [btnGoHomePage setTitle:@"去首页逛逛" forState:UIControlStateNormal];
        btnGoHomePage.layer.cornerRadius = 6;
        btnGoHomePage.layer.borderWidth = 0.5;
        btnGoHomePage.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [btnGoHomePage setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btnGoHomePage addTarget:self action:@selector(goHomePage) forControlEvents:UIControlEventTouchUpInside];
        
        [self.nonThingView addSubview:imgV];
        [self.nonThingView addSubview:lblTitle];
        [self.nonThingView addSubview:btnGoHomePage];
        [self.view addSubview:_nonThingView];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.title = @"购物车";
    //读取购物车有几个商品
    NSString *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"number"];
    if ([number integerValue]<=0 && number) {
        self.tabBarItem.badgeValue= nil;
    }else{
        self.tabBarItem.badgeValue = number;
    }
    _manager.delegate = self;
    [_manager getGoodCar];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasourse.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CarGoodCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CarGoodCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.btnDelete addTarget:self action:@selector(selectGood:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnAdd addTarget:self action:@selector(addGood:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnReduce addTarget:self action:@selector(reduceGood:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.btnDelete.tag  = indexPath.row;
    cell.btnAdd.tag     = indexPath.row;
    cell.btnReduce.tag  = indexPath.row;
    CarGoodDetail *goodBase = [_datasourse objectAtIndex:indexPath.row];
    [cell.imgVGood setImageWithURL:[NSURL URLWithString:goodBase.imgsrc] placeholderImage:[UIImage imageNamed:@"产品默认图"]];
    cell.lblName.text = goodBase.title;
    cell.lblMoney.text = [NSString stringWithFormat:@"¥ %.2f",[goodBase.price floatValue]];
    cell.lblGoodCount.text = [_changeCountDict objectForKey:goodBase.pid];
    cell.btnReduce.enabled = YES;
    if ([[_changeCountDict objectForKey:goodBase.pid] integerValue] == 1) {
        cell.btnReduce.enabled = NO;
        [cell.btnReduce setImage:[UIImage imageNamed:@"Reduce_gray"] forState:UIControlStateNormal];
    }else{
        cell.btnReduce.enabled = YES;
        [cell.btnReduce setImage:[UIImage imageNamed:@"Reduce"] forState:UIControlStateNormal];
    }
    cell.VButtomLine.hidden = YES;  //短线
    cell.buttomLineV.hidden = NO; //长线
    cell.buttomLineV.backgroundColor  = SEPARATELINE_COLOR;
//    if (indexPath.row == _datasourse.count-1) {
//        cell.VButtomLine.hidden = YES;
//        cell.buttomLineV.hidden = NO;
//    }
    if ([[_selectDict objectForKey:goodBase.pid] integerValue] == 1) {
        [cell.btnDelete setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateNormal];
    }else{
        [cell.btnDelete setImage:[UIImage imageNamed:@"unSelected"] forState:UIControlStateNormal];
    }

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 96.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarGoodDetail *base = [_datasourse objectAtIndex:indexPath.row];
    [_manager getGoodDetailWithID:base.pid];
}
#pragma mark jhdatamanaer delegate
- (void)requestSuccess:(id)object withRequestType:(RequestType)requestType
{
    switch (requestType) {
        case JHGETGOODCAR:
        {
            _carGoodBase = object;
            if (!_carGoodBase || _carGoodBase.carGoodList.count == 0) {
                [self setRightNavButtonWithType:NONE];
            }else{
                if(_fromFlag == 1000){
                    [self setRightNavButtonWithType:DELETE_W];
                }else if(_fromFlag == 1001){
                    [self setRightNavButtonWithType:DELETE_R];
                }
            }
            _datasourse = _carGoodBase.carGoodList;
            if (!_datasourse||_datasourse.count <= 0) {
                JHGlobalApp.tabBarControllder.shopcar.tabBarItem.badgeValue = nil;
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"number"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                _confirmFooterView.hidden = YES;
                _btnConfirm.hidden = YES;
                _tableView.hidden = YES;
                [self loadNonView];
            }else{
                _confirmFooterView.hidden = NO;
                _btnConfirm.hidden = NO;
                _tableView.hidden = NO;
                _nonThingView.hidden = YES;
                _totalMoney.text = [NSString stringWithFormat:@"¥%@",_carGoodBase.countBase.amount];
                JHGlobalApp.tabBarControllder.shopcar.tabBarItem.badgeValue = _carGoodBase.countBase.number;
                [[NSUserDefaults standardUserDefaults] setObject:_carGoodBase.countBase.number forKey:@"number"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self reloadSelectDict];
                [self reloadChangeCountDict];
                [_tableView reloadData];
            }

        }
            break;
        case JHUPDATEGOODCAR:
        {
            if (_changeType == ADDGOOD) {
                CarGoodDetail *base =  [_datasourse objectAtIndex:_changeCountFlag];
                NSInteger count = [[_changeCountDict objectForKey:base.pid] integerValue]+1;
                _totalMoney.text = [NSString stringWithFormat:@"¥%@",((CarCountBase *)object).amount];
                
                self.tabBarItem.badgeValue = ((CarCountBase *)object).number;
                [[NSUserDefaults standardUserDefaults] setObject:((CarCountBase *)object).number forKey:@"number"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [_changeCountDict setObject:[NSString stringWithFormat:@"%ld",count] forKey:base.pid];
                NSIndexPath *path = [NSIndexPath indexPathForRow:_changeCountFlag inSection:0];
                CarGoodCell *cell = [_tableView cellForRowAtIndexPath:path];
                cell.lblGoodCount.text = [_changeCountDict objectForKey:base.pid];
                cell.btnReduce.enabled = YES;
                [cell.btnReduce setImage:[UIImage imageNamed:@"Reduce"] forState:UIControlStateNormal];
            }else if(_changeType == REDUCGOOD){
                CarGoodDetail *base =  [_datasourse objectAtIndex:_changeCountFlag];
                NSInteger count = [[_changeCountDict objectForKey:base.pid] integerValue]-1;
                _totalMoney.text = [NSString stringWithFormat:@"¥%@",((CarCountBase *)object).amount];
                
                self.tabBarItem.badgeValue = ((CarCountBase *)object).number;
                [[NSUserDefaults standardUserDefaults] setObject:((CarCountBase *)object).number forKey:@"number"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [_changeCountDict setObject:[NSString stringWithFormat:@"%ld",count] forKey:base.pid];
                NSIndexPath *path = [NSIndexPath indexPathForRow:_changeCountFlag inSection:0];
                CarGoodCell *cell = [_tableView cellForRowAtIndexPath:path];
                cell.lblGoodCount.text = [_changeCountDict objectForKey:base.pid];
                
                if (count <= 1) {
                    cell.btnReduce.enabled = NO;
                    [cell.btnReduce setImage:[UIImage imageNamed:@"Reduce_gray"] forState:UIControlStateNormal];
                }else{
                    cell.btnReduce.enabled = YES;
                    [cell.btnReduce setImage:[UIImage imageNamed:@"Reduce"] forState:UIControlStateNormal];
                }
            }else if(_changeType == DELETEGOOD){
                for (int i = 0 ; i < _selectDict.allKeys.count; i ++) {
                    if ([[_selectDict objectForKey:[_selectDict.allKeys objectAtIndex:i]] integerValue] == 1) {
                        [_selectDict removeObjectForKey:[_selectDict.allKeys objectAtIndex:i]];
                    }
                }
                [_manager getGoodCar];
            }
            
        }
            break;
            case JHCHECKOUT:
        {
            ConfirmViewController *vc = [[ConfirmViewController alloc] initWithNibName:@"ConfirmViewController" bundle:nil];
            NSDictionary *dict = @{@"data":[object objectForKey:@"products"]};
            vc.dataSourse   = [CarGoodDetail listFromJsonDictionnary:dict];
            vc.couponList   = [CouponModel listFromJsonDictionnary:@{@"data":[object objectForKey:@"coupon_p"]}];
            vc.addressList  = [MyAddressModel listFromJsonDictionnary:@{@"data":[object objectForKey:@"address"]}];
            vc.addressModel = [[MyAddressModel listFromJsonDictionnary:@{@"data":[object objectForKey:@"address"]}] firstObject];
            vc.totalPrice   = [NSString stringWithFormat:@"%@",[object objectForKey:@"amount"]];
            vc.shipping     = [NSString stringWithFormat:@"%@",[object objectForKey:@"shipping"]];
            vc.coupon_num   = [NSString stringWithFormat:@"%@",[object objectForKey:@"coupon_num"]];
            vc.coupon_name  = [[[[object objectForKey:@"pmt_o"] objectForKey:@"list"] objectAtIndex:0] objectForKey:@"pmt_describe"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case JHGETGOODDETAIL:
        {
            ProductDetailViewController *vc = [[ProductDetailViewController alloc] init];
            vc.goodDetail   = object;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}
- (void)goHomePage
{
    if (self.navigationController.viewControllers.count>1) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    JHGlobalApp.tabBarControllder.selectedIndex = 0;
}
- (IBAction)confirm:(id)sender {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"logState"]) {
        NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0; i < _selectArr.count; i ++) {
            CarGoodDetail *base = [_selectArr objectAtIndex:i];
            NSDictionary *dict = @{@"pid":base.pid,@"mid":base.mid,@"num":[[self countDict] objectForKey:base.pid]};
            [list addObject:dict];
        }
        if(list && list.count > 0){
            [_manager getCheckoutParams:list];
        }
    }else{
        LoginViewController *vc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self presentViewController:vc animated:YES completion:nil];
    }
}
- (NSDictionary *)countDict  //修改购物车的数量
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    for (int i = 0; i < _selectArr.count; i++) {
        CarGoodDetail *base = [_selectArr objectAtIndex:i];
        [dict setObject:[_changeCountDict objectForKey:base.pid] forKey:base.pid];
    }
    return dict;
}

- (void)rightButtonOnClick:(id)sender  //删除商品
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"你确定删除选定的商品？" delegate:self cancelButtonTitle:@"点错了" otherButtonTitles:@"确定", nil];
    [alertView show];
 }
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        _changeType = DELETEGOOD;
        NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:0];
        for (int i = 0 ; i < _selectArr.count; i ++) {
            CarGoodDetail *goodBase = [_selectArr objectAtIndex:i];
            NSDictionary *dict = @{@"pid":goodBase.pid,@"mid":goodBase.mid,@"num":@"0"};
            [arr addObject:dict];
        }
        if (arr.count >0) {
            NSString *str = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
            [_manager updateGoodCar:@{@"cart":str}];
        }
    }
}
- (void)reloadSelectDict  //选择的商品  1选择 0未选择 pid为键
{
    if (!_selectArr) {
        _selectArr = [[NSMutableArray alloc] initWithCapacity:0];
    }else{
        [_selectArr removeAllObjects];
    }
    [_selectArr addObjectsFromArray:_datasourse];
    if (!_selectDict) {
        _selectDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    for (int i = 0 ; i <_datasourse.count; i ++) {
        CarGoodDetail *goodBase = [_datasourse objectAtIndex:i];
        [_selectDict setObject:@"1" forKey:goodBase.pid];
    }
}
- (void)selectGood:(id)sender
{
    NSInteger tag = ((UIButton *)sender).tag;
    CarGoodDetail *goodBase = [_datasourse objectAtIndex:tag];
    if ([[_selectDict objectForKey:goodBase.pid] integerValue] == 1) {
        [_selectDict setObject:@"0" forKey:goodBase.pid];
        if ([_selectArr containsObject:goodBase]) {
            [_selectArr removeObject:goodBase];
        }
    }else{
        [_selectDict setObject:@"1" forKey:goodBase.pid];
        if (![_selectArr containsObject:goodBase]) {
            [_selectArr addObject:goodBase];
        }
    }
    if (_selectArr && _selectArr.count>0) {
        if(_fromFlag == 1000){
            [self setRightNavButtonWithType:DELETE_W];
        }else if(_fromFlag == 1001){
            [self setRightNavButtonWithType:DELETE_R];
        }
        float price;
        for (int i = 0; i < _selectArr.count; i++) {
            CarGoodDetail *base = [_selectArr objectAtIndex:i];
            price += [base.price floatValue]*[[_changeCountDict objectForKey:base.pid] integerValue];
        }
        _totalMoney.text = [NSString stringWithFormat:@"¥%.2f",price];
    }else{
        [self setRightNavButtonWithType:NONE];
        _totalMoney.text = [NSString stringWithFormat:@"¥%@",@"0"];
    }
    NSIndexPath *path = [NSIndexPath indexPathForRow:tag inSection:0];
    CarGoodCell *cell = [_tableView cellForRowAtIndexPath:path];
    if ([[_selectDict objectForKey:goodBase.pid] integerValue] == 1) {
        [cell.btnDelete setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateNormal];
    }else{
        [cell.btnDelete setImage:[UIImage imageNamed:@"unSelected"] forState:UIControlStateNormal];
    }
}

- (void)reloadChangeCountDict  //减少增加商品 num为值  pid为键
{
    if (!_changeCountDict) {
        _changeCountDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    }else{
        [_changeCountDict removeAllObjects];
    }
    for (int i = 0 ; i <_datasourse.count; i ++) {
        CarGoodDetail *base= [_datasourse objectAtIndex:i];
        [_changeCountDict setObject:base.num forKey:base.pid];
    }
}
- (void)reduceGood:(id)sender
{
    NSInteger tag = ((UIButton *)sender).tag;
    CarGoodDetail *base = [_datasourse objectAtIndex:tag];
    if ([[_changeCountDict objectForKey:base.pid] integerValue] >1) {
        _changeCountFlag = tag;
        _changeType = REDUCGOOD;
        NSDictionary *dict = @{@"pid":base.pid,@"mid":base.mid,@"num":@"-1"};
        NSArray *arr = [NSArray arrayWithObject:dict];
        NSString *str = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        [_manager updateGoodCar:@{@"cart":str}];
    }
}
- (void)addGood:(id)sender
{
    NSInteger tag = ((UIButton *)sender).tag;
    _changeCountFlag = tag;
    _changeType = ADDGOOD;
    CarGoodDetail *base = [_datasourse objectAtIndex:tag];
    NSDictionary *dict = @{@"pid":base.pid,@"mid":base.mid,@"num":@"1"};
    NSArray *arr = [NSArray arrayWithObject:dict];
    NSString *str = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    [_manager updateGoodCar:@{@"cart":str}];
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
