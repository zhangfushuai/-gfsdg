//
//  ConfirmViewController.m
//  几何社区
//
//  Created by 颜 on 15/9/17.
//  Copyright (c) 2015年 lmh. All rights reserved.
//


#import "ConfirmViewController.h"
#import "OrderAddressCell.h"
#import "CarGoodCell.h"
#import "CarGoodBase.h"
#import "UIImageView+AFNetworking.h"
#import "MyAddressModel.h"
#import "HWTitleButton.h"
#import "ZHPickView.h"
#import "AddAddressViewController.h"
#import "JhActionSheet.h"

#import "OrderResultViewController.h"
#import "MyCouponsViewController.h"
#import "CouponModel.h"

#import "WXApiObject.h"
#import "WXApi.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>

#import <CoreLocation/CLLocation.h>
#import "PlaceSearchResultModel.h"
#import "WGS84TOGCJ02.h"

@interface ConfirmViewController ()<UITableViewDelegate,UITableViewDataSource,JHDataMagerDelegate,UITextFieldDelegate,ZHPickViewDelegate,MainDelegate,AddressDelegate,CouponDelegate>
{
    ZHPickView *JhPickView;
    HWTitleButton *dayButton;
    HWTitleButton *hourButton;
    
    UILabel *label1;
    UILabel *label2;
}
@property (nonatomic , assign)NSInteger dayAndHourFlag; // 0 日期  1 小时

@property (nonatomic , assign)NSInteger payWayFlag;     //支付方式
@property (nonatomic , strong)NSString *time;           //派送时间
@property (nonatomic , strong)NSString *message;        //备注
@property (nonatomic , strong)NSString *address;        //收货地址
@property (nonatomic , strong)NSString *area_id;        //区域id

@property (nonatomic , strong)NSString *orderID;

@end

@implementation ConfirmViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _lineViewHeight.constant = 0.5;
    _lineView.backgroundColor = SEPARATELINE_COLOR;
    
    _payWayFlag = ALPAY;
    self.title = @"确认订单";
    [self setLeftNavButtonWithType:BACK];
    _manager = [JHDataManager getInstance];
    _manager.delegate = self;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = HEADERVIEW_COLOR;
    

    _lblTotal.text = [ NSString stringWithFormat:@"%@元",_totalPrice];
}
- (void)leftButtonOnClick:(id)sender
{
    if (JhPickView) {
        [JhPickView remove];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _manager.delegate = self;
    [self setNavTitleColor:[UIColor blackColor]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark uitableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 2;
        }
            break;
        case 1:
        {
            return _dataSourse.count;
        }
            break;
        case 2:
        {
            return 3;
        }
            break;
        case 3:
        {
            return 3;
        }
            break;
        default:
        {
            return 0;
        }
            break;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                OrderAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderAddressCell"];
                if (!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"OrderAddressCell" owner:self options:nil] lastObject];
                    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, SCREEN_WIDTH, 0.5)];
                    line.backgroundColor = SEPARATELINE_COLOR;
                    [cell.contentView addSubview:line];
                    UIView *line0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
                    line0.backgroundColor = SEPARATELINE_COLOR;
                    [cell.contentView addSubview:line0];
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                if (_addressModel) {
                    cell.lblNoneAddress.hidden = YES;
                    cell.lblAddress.hidden = NO;
                    cell.lblName.hidden = NO;
                    cell.lblPhone.hidden = NO;
                    cell.lblAddress.text = _addressModel.address;
                    cell.lblName.text = _addressModel.name;
                    cell.lblPhone.text = _addressModel.phonenum;
                }else{
                    cell.lblNoneAddress.hidden = NO;
                    cell.lblAddress.hidden = YES;
                    cell.lblName.hidden = YES;
                    cell.lblPhone.hidden = YES;
                }
            
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
                
            }else{
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
                if(!cell){
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycell"];
                    cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
                    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, SCREEN_WIDTH, 0.5)];
                    line.backgroundColor = SEPARATELINE_COLOR;
                    [cell.contentView addSubview:line];
                    dayButton = [[HWTitleButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-170, 15, 60, 20)];
                    [dayButton setTitle:@"今天" forState:UIControlStateNormal];
                    [dayButton setImage:[UIImage imageNamed:@"xla"] forState:UIControlStateNormal];
                    dayButton.titleLabel.font = [UIFont systemFontOfSize:14];
                    
                    hourButton = [[HWTitleButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-110, 15, 100, 20)];
                    [hourButton setTitle:@"一个小时内" forState:UIControlStateNormal];
                    [hourButton setImage:[UIImage imageNamed:@"xla"] forState:UIControlStateNormal];
                    hourButton.titleLabel.font = [UIFont systemFontOfSize:14];
                    
                    [cell addSubview:dayButton];
                    [cell addSubview:hourButton];
                    [dayButton addTarget:self action:@selector(daySelct:) forControlEvents:UIControlEventTouchUpInside];
                    [hourButton addTarget:self action:@selector(timeSelect:) forControlEvents:UIControlEventTouchUpInside];
                }
                cell.textLabel.text = @"收货时间";
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
            break;
        case 1:
        {
            CarGoodCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CarGoodCell"];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"CarGoodCell" owner:self options:nil] lastObject];
                cell.btnDelete.hidden = YES;
                cell.btnAdd.hidden = YES;
                cell.btnReduce.hidden = YES;
                cell.imgLeading.constant = -22;  //36
                cell.lblCountTrailing.constant = -30;
            }
            if (indexPath.row == 0) {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
                line.backgroundColor = SEPARATELINE_COLOR;
                [cell.contentView addSubview:line];
            }
            cell.VButtomLine.hidden = YES;  //短线
            cell.buttomLineV.hidden = NO; //长线
            cell.longLineHeight.constant = 0.5;
//            if (indexPath.row == _dataSourse.count-1) {
//                cell.VButtomLine.hidden = YES;
//                cell.buttomLineV.hidden = NO;
//            }
            CarGoodDetail *goodBase = [_dataSourse objectAtIndex:indexPath.row];
            [cell.imgVGood setImageWithURL:[NSURL URLWithString:goodBase.imgsrc] placeholderImage:nil];
            cell.lblName.text = goodBase.title;
            cell.lblMoney.text = [NSString stringWithFormat:@"¥ %.2f",[goodBase.price floatValue]];
            cell.lblGoodCount.text = [NSString stringWithFormat:@"X%@",goodBase.num];
            cell.lblGoodCount.textColor = [UIColor lightGrayColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        case 2:
        {
            if(indexPath.row == 0){
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardCell"];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cardCell"];
                    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, SCREEN_WIDTH, 0.5)];
                    line.backgroundColor = SEPARATELINE_COLOR;
                    [cell.contentView addSubview:line];
                    
                    label1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH-100-16, 50)];
                    label1.textAlignment = NSTextAlignmentRight;
                    [cell addSubview:label1];
                }
                label1.font = [UIFont systemFontOfSize:15];
                label1.text = [NSString stringWithFormat:@"%@元",_shipping];
                cell.textLabel.text = @"配送费";
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else if (indexPath.row == 1) {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cardCell"];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cardCell"];
                    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, SCREEN_WIDTH, 0.5)];
                    line.backgroundColor = SEPARATELINE_COLOR;
                    [cell.contentView addSubview:line];
                    
                    label2 = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH-100-30, 50)];
                    label2.textAlignment = NSTextAlignmentRight;
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    [cell addSubview:label2];
                }
                label2.font = [UIFont systemFontOfSize:15];
                if ([_coupon_num integerValue] > 0) {
                    if (_coupon_name) {
                        label2.text = _coupon_name;
                    }else{
                        label2.text = @"可用优惠券";
                    }
                }else{
                    label2.text = @"无可用优惠券";
                }
                cell.textLabel.font = [UIFont systemFontOfSize:15];
                cell.textLabel.text = @"使用优惠券";
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }else{
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noteCell"];
                if (!cell) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"noteCell"];
                    UITextField *tf = [[UITextField  alloc] initWithFrame:CGRectMake(14, 0, SCREEN_WIDTH-20, 40)];
                    tf.textAlignment = NSTextAlignmentLeft;
                    tf.font = [UIFont systemFontOfSize:15];
                    tf.clearsOnBeginEditing = YES;
                    tf.placeholder = @"请输入备注";
                    tf.returnKeyType = UIReturnKeyDone;
                    tf.autoresizingMask = UIViewAutoresizingFlexibleHeight;
                    [cell addSubview:tf];
                    tf.delegate = self;
                    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, SCREEN_WIDTH, 0.5)];
                    line.backgroundColor = SEPARATELINE_COLOR;
                    [cell.contentView addSubview:line];
                }
//                cell.textLabel.text = @"备注";
//                cell.textLabel.font = [UIFont systemFontOfSize:15];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
            break;
        case 3:
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"payCell"];
            
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"payCell"];
                UISwitch  *onoff = [[UISwitch alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 51 - 12, 10, 51, 30)];
                [onoff addTarget:self action:@selector(payWaySelect:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:onoff];
                
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, SCREEN_WIDTH, 0.5)];
                line.backgroundColor = SEPARATELINE_COLOR;
                [cell.contentView addSubview:line];
            }
            if (indexPath.row == 0) {
                UIView *line0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
                line0.backgroundColor = SEPARATELINE_COLOR;
                [cell.contentView addSubview:line0];
            }
            UISwitch  *onoff;
            for (int i = 0; i < cell.contentView.subviews.count; i++) {
                if([[cell.contentView.subviews objectAtIndex:i] isKindOfClass:[UISwitch class]])
                {
                    onoff = [cell.contentView.subviews objectAtIndex:i];
                    break ;
                }
            }
            cell.textLabel.font = [UIFont systemFontOfSize:15];
            if (indexPath.row == 0) {
                cell.textLabel.text = @"支付宝支付";
                onoff.tag = ALPAY;
            }else if(indexPath.row == 1){
                cell.textLabel.text = @"微信支付";
                onoff.tag = WXPAY;
            }else if(indexPath.row == 2){
                cell.textLabel.text = @"货到付款";
                onoff.tag = DFPAY;
            }
            onoff.on = NO;
            if(_payWayFlag == ALPAY && indexPath.row == 0){
                onoff.on = YES;
            }
            else if (_payWayFlag == WXPAY && indexPath.row == 1) {
                onoff.on = YES;
            }else if(_payWayFlag == DFPAY && indexPath.row == 2){
                onoff.on = YES;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
            break;
        default:
        {
            return nil;
        }
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                return 64;
            }else{
                return 50;
            }
        }
            break;
        case 1:
        {
            return 88;
        }
            break;
        case 2:
        {
            return 50;
        }
            break;
        case 3:
        {
            return 50;
        }
            break;
        default:
        {
            return 0;
        }
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 0;
    }else{
        return 10;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = HEADERVIEW_COLOR;
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    if (indexPath.section == 0 && indexPath.row == 0) {
        if ([_addressList isKindOfClass:[NSNull class]] ||_addressList.count == 0 || !_addressList) {
            AddAddressViewController *vc = [[AddAddressViewController alloc] initWithNibName:@"AddAddressViewController" bundle:nil];
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            JhActionSheet *action = [[JhActionSheet alloc] initWithConfirmTitle:@"取消" delegate:self addTitle:@"新增收货地址" arrList:_addressList];
            [action addTarget:action action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
            [[UIApplication sharedApplication].keyWindow addSubview:action];
        }
    }else if(indexPath.section == 2 && indexPath.row == 1){
        MyCouponsViewController *vc = [[MyCouponsViewController alloc] initWithNibName:@"MyCouponsViewController" bundle:nil];
        vc.fromFlag = 1000;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
#pragma mark 事件处理
- (IBAction)confirm:(id)sender {
    if(!_orderID){
        _time = [NSString stringWithFormat:@"%@%@",dayButton.titleLabel.text,hourButton.titleLabel.text];
        NSString *payType;
        if (_payWayFlag == WXPAY) {
            payType = @"微信支付";
        }else if(_payWayFlag == ALPAY){
            payType = @"支付宝支付";
        }else if(_payWayFlag == DFPAY){
            payType = @"货到付款";
        }else{
            /**************提示选择支付方式********************/
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"请选择支付方式!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
            [alertView show];
            return;
        }
        if(_addressModel){
            CLLocation *orig = [[CLLocation alloc] initWithLatitude:[_addressModel.latitude floatValue]  longitude:[_addressModel.longtitude floatValue]];
            NSString *placeModelPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"placeModel"];
            PlaceSearchResultModel*model=  [NSKeyedUnarchiver unarchiveObjectWithFile:placeModelPath];
            CLLocationCoordinate2D location2D = CLLocationCoordinate2DMake(model.latitude, model.longitude);
            CLLocationCoordinate2D location  = [WGS84TOGCJ02 locationBaiduFromMars:location2D];
            CLLocation* dist=[[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
            CLLocationDistance kilometers=[orig distanceFromLocation:dist]/1000;
            if (kilometers > 2) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"配送地址与首页定位地址超过2km,请选择正确的配送地址!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"好的", nil];
                [alertView show];
                return;
            }
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"友情提示" message:@"请填写配送地址!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了", nil];
            [alertView show];
            return;
            
        }
        NSArray *goodList = [self getPostGoodList];
        NSString *addressStr= @"";
        addressStr = [NSString stringWithFormat:@"%@ %@ %@",_addressModel.name,_addressModel.phonenum,_addressModel.address];
        [_manager createOrderWithAddress:addressStr time:_time area_id:_addressModel.area_id message:_message pay_type:payType goodParams:goodList];
    }else{
        OrderResultViewController *vc = [[OrderResultViewController alloc] initWithNibName:@"OrderResultViewController" bundle:nil];
        vc.orderSuccess = NO;
        vc.payWayFlag = _payWayFlag;
        vc.orderID = _orderID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (NSMutableArray *)getPostGoodList
{
    NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i <_dataSourse.count; i ++) {
        CarGoodDetail *base = [_dataSourse objectAtIndex:i];
        NSDictionary *dict = @{@"pid":base.pid,@"mid":base.mid,@"num":base.num};
        [list addObject:dict];
    }
    return list;
}
- (void)daySelct:(id)sender
{
    _dayAndHourFlag = 0;
    if (JhPickView) {
        [JhPickView remove];
    }
    JhPickView = [[ZHPickView alloc] initPickviewWithArray:@[@"今天",@"明天",@"后天"] isHaveNavControler:NO];
    JhPickView.delegate = self;
    [JhPickView show];
}
- (void)timeSelect:(id)sender
{
    _dayAndHourFlag = 1;
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:date];
    NSInteger hour = [dateComponent hour];
    NSMutableArray *timeList = [[NSMutableArray alloc] initWithCapacity:0];
    [timeList addObject:@"一个小时内"];
    for (int i = (int)hour; i < 24; i ++) {
        NSString *str = [NSString stringWithFormat:@"%2d:00-%2d:00",i,i+1];
        [timeList addObject:str];
    }
    if (JhPickView) {
        [JhPickView remove];
    }
    JhPickView = [[ZHPickView alloc] initPickviewWithArray:timeList isHaveNavControler:NO];
    [JhPickView show];
    JhPickView.delegate = self;
   
}
- (void)payWaySelect:(id)sender
{
    UISwitch *view  = (UISwitch*)sender;
    if (view.isOn) {
        _payWayFlag = view.tag ;
    }else{
        _payWayFlag = -1;
    }
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark 新增收获地址 delegate
- (void)chooseAddress:(MyAddressModel*)address
{
    _addressModel = address;
    [_addressList  insertObject:address atIndex:0];
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    NSArray *indexPathArr  = [NSArray arrayWithObjects:index, nil];
    [_tableView reloadRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark 优惠券代理
- (void)reloadCheckOut
{
    NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < _dataSourse.count; i ++) {
        CarGoodDetail *base = [_dataSourse objectAtIndex:i];
        NSDictionary *dict = @{@"pid":base.pid,@"mid":base.mid,@"num":base.num};
        [list addObject:dict];
    }
    [_manager getCheckoutParams:list];
}
#pragma mark jhdatamanager delegate
- (void)requestSuccess:(id)object withRequestType:(RequestType)requestType
{
    switch (requestType) {
        case JHCREATORDER:
        {
            _orderID = object;
            if (_payWayFlag == WXPAY || _payWayFlag == ALPAY) {
                [_manager getPaywayMessage:_payWayFlag withOrderID:_orderID];
            }else{//货到付款
                OrderResultViewController *vc = [[OrderResultViewController alloc] initWithNibName:@"OrderResultViewController" bundle:nil];
                vc.orderSuccess = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case JHPAYPARAMS:
        {
            if (_payWayFlag == WXPAY) {
                [self sendWXPay:object];
            }else{
                [self sendALPay:object];
            }
        }
            break;
        case JHCHECKOUT:
        {
            NSDictionary *dict = @{@"data":[object objectForKey:@"products"]};
            self.dataSourse   = [CarGoodDetail listFromJsonDictionnary:dict];
            self.couponList   = [CouponModel listFromJsonDictionnary:@{@"data":[object objectForKey:@"coupon_p"]}];
            self.addressList  = [MyAddressModel listFromJsonDictionnary:@{@"data":[object objectForKey:@"address"]}];
            self.totalPrice   = [NSString stringWithFormat:@"%@",[object objectForKey:@"amount"]];
            self.shipping     = [NSString stringWithFormat:@"%@",[object objectForKey:@"shipping"]];
            self.coupon_num   = [NSString stringWithFormat:@"%@",[object objectForKey:@"coupon_num"]];
            self.coupon_name  = [[[[object objectForKey:@"pmt_o"] objectForKey:@"list"] firstObject] objectForKey:@"pmt_describe"];
            _lblTotal.text = [ NSString stringWithFormat:@"%@元",_totalPrice];
            [_tableView reloadData];
        }
            break;
            
        default:
            break;
    }
}
- (void)requestFailure:(id)failReson withRequestType:(RequestType)requestType
{
    switch (requestType) {
        case JHCREATORDER:
        {
            if ([failReson isKindOfClass:[NSDictionary class]]) {
                [self.view makeToast:[failReson objectForKey:@"msg"]];
            }else if([failReson isKindOfClass:[NSString class]]){
                [self.view makeToast:failReson];
            }
        }
            break;
        case JHPAYPARAMS:
        {
            OrderResultViewController *vc = [[OrderResultViewController alloc] initWithNibName:@"OrderResultViewController" bundle:nil];
            vc.orderSuccess = NO;
            vc.payWayFlag = _payWayFlag;
            vc.orderID = _orderID;
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark  textView delegate
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    _buttomDistance.constant = kbSize.height;
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:2] atScrollPosition:kbSize.height animated:YES];
}
- (void)keyboardHidden:(NSNotification *)notification
{
    _buttomDistance.constant = 0;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _buttomDistance.constant = 0;
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _message = textField.text;
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

#pragma mark zhpickview delegate
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString
{
    if (_dayAndHourFlag == 0) {
        [dayButton setTitle:resultString forState:UIControlStateNormal];
    }else if (_dayAndHourFlag == 1){
        [hourButton setTitle:resultString forState:UIControlStateNormal];
    }
    [pickView remove];
}

#pragma mark actionsheet delegate
- (void)actionSheet:(JhActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)index;
{
    if(index == -1){            //取消
    
    }else if (index == -2){     //添加新的收获地址
        AddAddressViewController *vc = [[AddAddressViewController alloc] initWithNibName:@"AddAddressViewController" bundle:nil];
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }else{                      //刷新收货地址   第一行
        _addressModel = [_addressList objectAtIndex:index];
        NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
        NSArray *indexPathArr  = [NSArray arrayWithObjects:index, nil];
        [_tableView reloadRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationNone];
    }
}
- (void)sendALPay:(NSDictionary *)params
{
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"JhAlipay";
    //将商品信息拼接成字符串
    NSString *orderSpec = [params objectForKey:@"data"];
    [[AlipaySDK defaultService] payOrder:orderSpec fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        if([[resultDic objectForKey:@"resultStatus"] integerValue] == 9000){
            OrderResultViewController *vc = [[OrderResultViewController alloc] initWithNibName:@"OrderResultViewController" bundle:nil];
            vc.orderSuccess = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            OrderResultViewController *vc = [[OrderResultViewController alloc] initWithNibName:@"OrderResultViewController" bundle:nil];
            vc.orderSuccess = NO;
            vc.payWayFlag = _payWayFlag;
            vc.orderID = _orderID;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }];
}
- (void)sendWXPay:(NSDictionary *)params
{
    if (![WXApi isWXAppInstalled]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您尚未安装微信。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    JHGlobalApp.mainDelegate = self;
    //根据服务器端编码确定是否转码
    NSStringEncoding enc;
    //if UTF8编码
    //enc = NSUTF8StringEncoding;
    //if GBK编码
    enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSMutableString *stamp  = [params objectForKey:@"timestamp"];
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = [params objectForKey:@"appid"];
    req.partnerId           = [params objectForKey:@"partnerid"];
    req.prepayId            = [params objectForKey:@"prepayid"];
    req.nonceStr            = [params objectForKey:@"noncestr"];
    req.timeStamp           = stamp.intValue;
    req.package             = [params objectForKey:@"package"];
    req.sign                = [params objectForKey:@"sign"];
    [WXApi sendReq:req];
}
- (void)WXPay:(BaseResp *)resp
{
    if (resp.errCode == WXSuccess)
    {
        OrderResultViewController *vc = [[OrderResultViewController alloc] initWithNibName:@"OrderResultViewController" bundle:nil];
        vc.orderSuccess = YES;
        [self.navigationController pushViewController:vc animated:YES];//成功
    }else{
        OrderResultViewController *vc = [[OrderResultViewController alloc] initWithNibName:@"OrderResultViewController" bundle:nil];
        vc.orderSuccess = NO;
        vc.payWayFlag = _payWayFlag;
        vc.orderID = _orderID;
        [self.navigationController pushViewController:vc animated:YES];//失败
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
