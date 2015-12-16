//
//  OrderCommentTableViewController.m
//  几何社区
//
//  Created by KMING on 15/10/20.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "OrderCommentTableViewController.h"
#import "CommentProductTableViewCell.h"
#import "ServiceCommentTableViewCell.h"
#import "MyorderProductModel.h"
@interface OrderCommentTableViewController ()
@property (nonatomic,copy)NSString *selected;
@property (nonatomic,copy)NSString *index;


@end

@implementation OrderCommentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(speedComment:) name:@"speedComment" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(serviceComment:) name:@"serviceComment" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(commentTheProduct:) name:@"commentTheProduct" object:nil];
    self.tableView.backgroundColor = HEADERVIEW_COLOR;
    self.tableView.tableFooterView = [[UIView alloc]init];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setLeftNavButtonWithType:BACK];
    [self setNavColor:[UIColor whiteColor]];
    [self setNavTitleColor:[UIColor blackColor]];
    self.title = @"评价";
}
#pragma mark - 评论送货速度
-(void)speedComment:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification object];
    NSString *star = [nameDictionary objectForKey:@"star"];
    NSLog(@"评价几颗星---%@",star);
}
#pragma mark - 评论单个商品
-(void)commentTheProduct:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification object];
    self.selected = [nameDictionary objectForKey:@"selected"];
    self.index = [nameDictionary objectForKeyedSubscript:@"index"];
    NSLog(@"按钮选中---%@--index:%@",self.selected,self.index);
    [self.tableView reloadData];
//    if ([selected isEqualToString:@"1"]) {
//        <#statements#>
//    }
    
}
#pragma mark - 评论服务态度
-(void)serviceComment:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification object];
    NSString *star = [nameDictionary objectForKey:@"star"];
    NSLog(@"评价几颗星---%@",star);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"speedComment" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"serviceComment" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"commentTheProduct" object:nil];
}
#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if ([self.selected isEqualToString:@"1"]) {
            if ([[NSString stringWithFormat:@"%ld",(long)indexPath.row] isEqualToString:self.index]) {
                return 140;
            }else{
                return 70;
            }
        }else{
            return 70;
        }
    }else{
        return 95;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section==0) {
        return self.products.count;
    }else{
        return 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 8;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
   if (section==0){
        UIView *view = [[UIView alloc]
                        initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
        view.backgroundColor = HEADERVIEW_COLOR;
         UIView *downline = [[UIView alloc]initWithFrame:CGRectMake(0, 7.5, SCREEN_WIDTH, 0.5)];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        CommentProductTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"CommentProductTableViewCell" owner:self options:0]firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
         MyorderProductModel *model = self.products[indexPath.row];
        cell.model=model;
        cell.index = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        if ([self.selected isEqualToString:@"1"]) {
            if ([[NSString stringWithFormat:@"%ld",(long)indexPath.row] isEqualToString:self.index]) {
                cell.btnSelected = @"1";
                cell.downV.hidden = NO;
            }else{
                cell.btnSelected = @"0";
                cell.downV.hidden = YES;
            }
        }else{
            cell.btnSelected = @"0";
            cell.downV.hidden = YES;
        }

        
        return cell;
    }else{
        ServiceCommentTableViewCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"ServiceCommentTableViewCell" owner:self options:0]firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    
    }

}


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

@end
