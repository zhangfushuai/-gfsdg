//
//  CategoryViewController.m
//  几何社区
//
//  Created by KMING on 15/8/20.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryDetailViewController.h"

#import "GoodData.h"

#import "GoodCategaryCell.h"
#import "GoodCollectionViewCell.h"
#import "CollectionReusableView.h"
#import "XLPlainFlowLayout.h"

#import "SearchGoodViewController.h"

#import "UIImageView+AFNetworking.h"

@interface CategoryViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSInteger valideSelectFlag;         //点击选中的大类
    NSInteger invalideSelectFlag;       //之前保留的大类   为了不需重新刷新所有列表
    
    NSString *classifyId;               //分类id
    NSString *className;                //分类名字
}

@end

@implementation CategoryViewController
-(void)rightButtonOnClick:(id)sender{
    [_manager getHotWords];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.automaticallyAdjustsScrollViewInsets = NO;
    valideSelectFlag = 0;
    invalideSelectFlag = -1;
     self.view.backgroundColor = [UIColor whiteColor];
    [self setRightNavButtonWithType:SEARCH];
    _manager = [JHDataManager getInstance];
    _manager.delegate = self;
    [_manager getGoodListWithParams:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _manager.delegate = self;
    [self setNavTitleColor:[UIColor whiteColor]];
    self.title = @"分类";
    if (!(_datasourse && _datasourse.count>0)) {
        [_manager getGoodListWithParams:nil];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)createTableView
{
    // 导航栏（navigationbar）
    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height+[[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat tabbarHeight = self.navigationController.tabBarController.tabBar.frame.size.height;
    if(!_tbCategary){
        _tbCategary = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, (0.25)*SCREEN_WIDTH, SCREEN_HEIGHT-navHeight-tabbarHeight)];
        _tbCategary.delegate = self;
        _tbCategary.dataSource = self;
        _tbCategary.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tbCategary.showsVerticalScrollIndicator= NO;
        [self.view addSubview:_tbCategary];
    }
    if (!_collectionView) {
//        XLPlainFlowLayout *layout = [XLPlainFlowLayout new];  //设置headerview 悬浮的方法
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
//        layout.naviHeight = 0;
        layout.headerReferenceSize = CGSizeMake((0.75)*SCREEN_WIDTH, 48);   //必须设置header的高度，否则不调用headerview的代理
//
//        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
        _collectionView  =[[UICollectionView alloc]initWithFrame:CGRectMake((0.25)*SCREEN_WIDTH, navHeight, (0.75)*SCREEN_WIDTH, SCREEN_HEIGHT-navHeight-tabbarHeight) collectionViewLayout:layout];

        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[GoodCollectionViewCell class] forCellWithReuseIdentifier:@"GoodCollectionViewCell"];
        [_collectionView registerClass:[CollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionReusableView"];
        _collectionView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_collectionView];

    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datasourse.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_tbCategary]) {
        GoodCategaryCell *cell =[tableView dequeueReusableCellWithIdentifier:@"categaryCell"];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"GoodCategaryCell" owner:self options:nil] firstObject];
        }
        GoodData *data = [_datasourse objectAtIndex:indexPath.row];
        cell.lblText.text = data.name;
        cell.downLine.hidden = NO;
        cell.redLine.hidden = YES;
        cell.rightLine.hidden = NO;
        cell.lblText.textColor = [UIColor blackColor];
        cell.contentView.backgroundColor = RGBCOLOR(248, 248, 248,1);
        if (indexPath.row == valideSelectFlag) {
            cell.redLine.hidden = NO;
            cell.rightLine.hidden = YES;
            cell.downLine.hidden = YES;
            cell.lblText.textColor = RGBCOLOR(248, 28, 25,1);
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        return cell;
    }else{
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"categaryCell1"];
        if (!cell) {
            cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"categaryCell1"];
        }
        GoodData *data = [_datasourse objectAtIndex:indexPath.row];
        cell.textLabel.text = data.name;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 48;
    return 56;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    invalideSelectFlag = valideSelectFlag;
    valideSelectFlag = indexPath.row;
    NSIndexPath *index1 = [NSIndexPath indexPathForRow:invalideSelectFlag inSection:0];
    NSIndexPath *index2 = [NSIndexPath indexPathForRow:valideSelectFlag inSection:0];
    NSArray *indexPathArr  = [NSArray arrayWithObjects:index1,index2, nil];
    [tableView reloadRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationNone];
    
    [_collectionView reloadData];
    
}
#pragma mark colectView delegate
- (CGFloat)minimumInteritemSpacing
{
    return 0.0f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    GoodData *data = [_datasourse objectAtIndex:valideSelectFlag];
    GoodData *data1 = [data.child objectAtIndex:section];
    return data1.child.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UINib *nib = [UINib nibWithNibName:@"CollectionReusableView" bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forSupplementaryViewOfKind:kind withReuseIdentifier:@"CollectionReusableView"];
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader){
        
        CollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionReusableView" forIndexPath:indexPath];
        GoodData *data = [_datasourse objectAtIndex:valideSelectFlag];
        GoodData *data1 = [data.child objectAtIndex:indexPath.section];
        headerView.lblName.text = data1.name;
        
        
        headerView.backView.layer.cornerRadius = 12;
        headerView.backView.backgroundColor = RGBCOLOR(248, 248, 248,1);
        
//        if(indexPath.section == 0){
//            headerView.topDistance.constant = 0;
//        }else{
//            headerView.topDistance.constant = 8;
//        }
        reusableview = headerView;
    }
    return reusableview;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UINib *nib = [UINib nibWithNibName:@"GoodCollectionViewCell"
                                bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:@"GoodCollectionViewCell"];
    
    GoodCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"GoodCollectionViewCell"
                                                     forIndexPath:indexPath];
    
    GoodData *data  = [_datasourse objectAtIndex:valideSelectFlag];
    GoodData *data1 = [data.child objectAtIndex:indexPath.section];
    GoodData *data2 = [data1.child objectAtIndex:indexPath.row];
    cell.lblName.text = data2.name;
    if ([data2.imgsrc length]>0 && data2.imgsrc) {
        [cell.imgVGood setImageWithURL:[NSURL URLWithString:data2.imgsrc] placeholderImage:[UIImage imageNamed:@"产品默认图"]];

    }else{
        cell.imgVGood.image = [UIImage imageNamed:@"产品默认图"];
    }
    return cell;
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    GoodData *data = [_datasourse objectAtIndex:valideSelectFlag];
    return data.child.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0) {
//        ((UICollectionViewFlowLayout*)collectionViewLayout).headerReferenceSize = CGSizeMake((0.75)*SCREEN_WIDTH, 36);
//    }else{
//        ((UICollectionViewFlowLayout*)collectionViewLayout).headerReferenceSize = CGSizeMake((0.75)*SCREEN_WIDTH, 52);
//    }
    return CGSizeMake((0.75*SCREEN_WIDTH)/3, (0.75*SCREEN_WIDTH)/3+16);
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView cellForItemAtIndexPath:indexPath].backgroundColor = HEADERVIEW_COLOR;
    
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView cellForItemAtIndexPath:indexPath].backgroundColor = [UIColor clearColor];

}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView cellForItemAtIndexPath:indexPath].backgroundColor = [UIColor clearColor];
    GoodData *data  = [_datasourse objectAtIndex:valideSelectFlag];
    GoodData *data1 = [data.child objectAtIndex:indexPath.section];
    GoodData *data2 = [data1.child objectAtIndex:indexPath.row];
    classifyId = data2.tid;
    className = data2.name;
    [_manager getSearchGoodWithKeyWord:nil classify:data2.tid area_id:[[NSUserDefaults standardUserDefaults] objectForKey:@"regionId"] sort:nil page:1];
}
- (void)requestSuccess:(id)object withRequestType:(RequestType)requestType
{
    switch (requestType) {
        case JHGETGOODLIST:
        {
            _datasourse = object;
            [self createTableView];
        }
            break;
        case JHSEARCHGOOD:
        {
            if (object==nil||((NSArray*)object).count==0) {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"该区域暂未开通服务";
                [hud showAnimated:YES whileExecutingBlock:^{
                    sleep(1);
                } completionBlock:^{
                    [hud removeFromSuperview];
                    
                }];
            }else{
                CategoryDetailViewController *vc = [[CategoryDetailViewController alloc]init];
                vc.title = className;
                vc.classifyId = classifyId;
                vc.datasourse = object;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
            break;
        case JHHOTWORLD:
        {
            SearchGoodViewController *vc = [[SearchGoodViewController alloc] init];
            vc.hotSearchList = [object objectForKey:@"data"];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
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
