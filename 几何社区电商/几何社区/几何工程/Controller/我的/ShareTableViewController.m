//
//  ShareTableViewController.m
//  几何社区
//
//  Created by KMING on 15/9/25.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "ShareTableViewController.h"
#import "ShareFirstTableViewCell.h"
#import "ShareSecondTableViewCell.h"
#import "ShareListTableViewCell.h"
#import <ShareSDK/ShareSDK.h>
#import "ShareModel.h"
#import "UIImageView+AFNetworking.h"
#import "WeiboSDK.h"
@interface ShareTableViewController ()<JHDataMagerDelegate,MJRefreshBaseViewDelegate>
@property (nonatomic,strong)ShareModel *model;
@property (nonatomic,strong)MJRefreshHeaderView *header;
@end

@implementation ShareTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sdkNum=0;
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    _manager = [JHDataManager getInstance];
    _manager.delegate = self;
    [_manager getShareInfo];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.labelText =@"加载中...";
    self.tableView.backgroundColor = HEADERVIEW_COLOR;
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    self.header = [MJRefreshHeaderView header];
    self.header.scrollView = self.tableView;
    self.header.delegate = self;
    
    
}
#pragma mark - MJRefresh
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    [_manager getShareInfo];
}
-(void)dealloc{
    [self.header free];
}
-(void)viewWillAppear:(BOOL)animated{
    [self setNavColor:[UIColor whiteColor]];
    [super viewWillAppear:animated];
    [self setLeftNavButtonWithType:BACK];
    _manager.delegate = self;
    [self setNavTitleColor:[UIColor blackColor]];
    self.title = @"分享给朋友";
    [MobClick beginLogPageView:@"ShareTableViewController"];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"ShareTableViewController"];

}
-(void)requestSuccess:(id)object withRequestType:(RequestType)requestType{
    switch (requestType) {
        case JHGETSHARE:
        {
            [self.header endRefreshing];
            MBProgressHUD *hud = [MBProgressHUD HUDForView:[UIApplication sharedApplication].keyWindow];
            [hud removeFromSuperview];
                       
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
        case JHGETSHARE:
        {
            [self.header endRefreshing];
            MBProgressHUD *hud = [MBProgressHUD HUDForView:[UIApplication sharedApplication].keyWindow];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"加载失败";
            [hud showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [hud removeFromSuperview];
                
            }];
        }
            break;
            
        default:
            break;
    }
}
- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event

{
    
    
    
    //摇动结束
    
    if (event.subtype == UIEventSubtypeMotionShake) {
        
        if (self.sdkNum==0) {
            //NSLog(@"摇动");
            if (self.model.name==nil) {
                self.model.name=@"";
            }
            NSDictionary *dict = @{@"name" : self.model.name};
            [MobClick event:@"shareYaoyiyao" attributes:dict];
            
            self.sdkNum=1;
            //something happens
            /* 邀请好友送优惠券*/
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"120-120" ofType:@"png"];
            
            
            //1、构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:@"指尖轻触,美味零食/水果/外卖/下午茶等秒速配送到家门口,让您躺在家里悠然逛超市!"
                                               defaultContent:@"指尖轻触,美味零食/水果/外卖/下午茶等秒速配送到家门口,让您躺在家里悠然逛超市!"
                                                        image:[ShareSDK imageWithPath:imagePath]
                                                        title:@"点酒水过把瘾，点零食来解馋，点外卖及时送，点日化清新家……几何社区，您生活的全能左右手。"
                                                          url:self.model.url
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
                                        self.sdkNum=0;
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
        
        
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source
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
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
        view1.backgroundColor = HEADERVIEW_COLOR;
        UIView *downline = [[UIView alloc]initWithFrame:CGRectMake(0, 7.5, SCREEN_WIDTH, 0.5)];
        downline.backgroundColor = SEPARATELINE_COLOR;
        [view1 addSubview:downline];
        return view1;
    }else if (section==1){
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
        view2.backgroundColor = HEADERVIEW_COLOR;
        UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        topline.backgroundColor = SEPARATELINE_COLOR;
        [view2 addSubview:topline];
        UIView *downline = [[UIView alloc]initWithFrame:CGRectMake(0, 31.5, SCREEN_WIDTH, 0.5)];
        downline.backgroundColor = SEPARATELINE_COLOR;
        [view2 addSubview:downline];
        
        UILabel *textLbl = [[UILabel alloc]initWithFrame:CGRectMake(12, 12, 48, 12)];
        textLbl.text = @"邀请方式";
        textLbl.textColor = Color757575;
        textLbl.font = [UIFont systemFontOfSize:12];
        [view2 addSubview:textLbl];
        return view2;
    }else{
        UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
        view2.backgroundColor = HEADERVIEW_COLOR;
        UIView *topline = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
        topline.backgroundColor = SEPARATELINE_COLOR;
        [view2 addSubview:topline];
        UIView *downline = [[UIView alloc]initWithFrame:CGRectMake(0, 31.5, SCREEN_WIDTH, 0.5)];
        downline.backgroundColor = SEPARATELINE_COLOR;
        [view2 addSubview:downline];
        
        UILabel *textLbl = [[UILabel alloc]initWithFrame:CGRectMake(12, 12, 48, 12)];
        textLbl.text = @"邀请记录";
        textLbl.textColor = Color757575;
        textLbl.font = [UIFont systemFontOfSize:12];
        [view2 addSubview:textLbl];
        return view2;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 8;
    }else{
        return 32;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        return SCREEN_WIDTH/2+20;
    }else if (indexPath.section==1){
        return SCREEN_WIDTH/2;
    }else{
        return 44;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0||section==1) {
        return 1;
    }else{
        return self.model.sharelist.count;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        ShareFirstTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"ShareFirstTableViewCell" owner:self options:0]firstObject];
        cell.phoneLbl.text = self.model.name;
        [cell.touxiang setImageWithURL:[NSURL URLWithString:self.model.headimgurl] placeholderImage:[UIImage imageNamed:@"tx"]];
        cell.yaoqingNumLbl.text = self.model.share_num;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.priceNumLbl.text = [NSString stringWithFormat:@"￥%@",self.model.share_total];
        return cell;
    }else if (indexPath.section==1){
        ShareSecondTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"ShareSecondTableViewCell" owner:self options:0]firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.url=self.model.url;
        return cell;
    }else{
        ShareListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ShareListTableViewCell" owner:self options:0]firstObject];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.shareDic = self.model.sharelist[indexPath.row];
        return cell;
    }
}

@end
