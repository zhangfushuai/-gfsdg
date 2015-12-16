//
//  MyOrderViewController.m
//  几何社区
//
//  Created by KMING on 15/8/27.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "MyOrderViewController.h"
#import "Define.h"
#import "AllOrderView.h"
#import "WaitToPayOrderView.h"
#import "ProcessingOrderView.h"
#import "TransportOrderView.h"
#import "FinishedOrderView.h"

@interface MyOrderViewController ()<UIScrollViewDelegate,JHDataMagerDelegate>

//下面五个数组用来存放五个页面，若数组为空表明没有加载过页面，若有，表明该页面已经有了，不需要再次网络请求
@property (nonatomic,strong)NSMutableArray *allarr;
@property (nonatomic,strong)NSMutableArray *waitForPayArr;
@property (nonatomic,strong)NSMutableArray *processingArr;
@property (nonatomic,strong)NSMutableArray *transportArr;
@property (nonatomic,strong)NSMutableArray *finishedArr;


@property (nonatomic,strong)UIView *downRedLine;//滑动的红线
@end

@implementation MyOrderViewController
-(void)viewWillAppear:(BOOL)animated{
    [self makeNavigation];
    [super viewWillAppear:animated];
   
    [MobClick beginLogPageView:@"MyOrderViewController"];
    
//    [_manager getALLOrder];
    //[_manager getAllCoupon];
    self.view.backgroundColor = [UIColor whiteColor];
    //self.view.backgroundColor = HEADERVIEW_COLOR;
   
    
}
-(void)makeNavigation{
    self.title = @"我的订单";
    [self setLeftNavButtonWithType:BACK];
//    [self setNavColor:[UIColor whiteColor]];
    [self setNavTitleColor:[UIColor blackColor]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.allarr = [NSMutableArray array];
    self.waitForPayArr = [NSMutableArray array];
    self.processingArr = [NSMutableArray array];
    self.transportArr= [NSMutableArray array];
    self.finishedArr = [NSMutableArray array];
    
    self.topBtnArr = [NSMutableArray array];
    [self makeTopbuttons];
    
    
    /**
     *  scrollview
     */
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.myscroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT-64-40)];
    self.myscroll.delegate = self;
    self.myscroll.contentSize = CGSizeMake(SCREEN_WIDTH*5, SCREEN_HEIGHT-104);
    self.myscroll.pagingEnabled = YES;
    
    [self.view addSubview:self.myscroll];
    AllOrderView *allorderview = [[AllOrderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104)];
    allorderview.delegate = self;
    
    [self.myscroll addSubview:allorderview];
    //[self.allarr addObject:allorderview];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"MyOrderViewController"];
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int i = scrollView.contentOffset.x/SCREEN_WIDTH;
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"cancelTheOrder" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"orderDetrailPageCanceled" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"payTheOrder" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"orderDetrailPagePaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"orderDetailPageBack" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"commentTheOrder" object:nil];
    float offx =scrollView.contentOffset.x;
        if (offx>100) {
            for (UIView *subV in self.myscroll.subviews) {
                [subV removeFromSuperview];
            }
        }
   // NSLog(@"%d",i);
    
    //NSLog(@"%f",offx);
    [UIView animateWithDuration:0.05 animations:^{
        self.downRedLine.center = CGPointMake(SCREEN_WIDTH/5/2+i*SCREEN_WIDTH/5, self.downRedLine.center.y);
        
        for (UIButton *topbtn in self.topBtnArr) {
            if (topbtn.tag!=i) {
                topbtn.selected = NO;
            }else{
                topbtn.selected = YES;
            }
        }
        
    }];
    switch (i) {
        case 0:
        {
//            if (offx>200) {
                AllOrderView *allorderview = [[AllOrderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104)];
                allorderview.delegate = self;
                [self.myscroll addSubview:allorderview];
           // }
            
        }
            break;
        case 1:
        {
           // if (offx>200) {
                WaitToPayOrderView *waitView = [[WaitToPayOrderView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104)];
                waitView.delegate = self;
                [self.myscroll addSubview:waitView];
                
          //  }
            
        }
            
            break;
        case 2:
        {
            //if (offx>200) {
                ProcessingOrderView *processView = [[ProcessingOrderView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104)];
                [self.myscroll addSubview:processView];
                processView.delegate = self;
            //}
            
        }
            
            break;
        case 3:
        {
            //if (offx>200) {
                TransportOrderView *transportView = [[TransportOrderView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*3, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104)];
                [self.myscroll addSubview:transportView];
                transportView.delegate = self;
            //}
            
            
        }
            
            break;
        case 4:
        {
            //if (offx>200) {
                FinishedOrderView *finishView = [[FinishedOrderView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*4, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104)];
                [self.myscroll addSubview:finishView];
                finishView.delegate = self;
           // }
            
        }
            
            break;
            
            
        default:
            break;
    }

}


#pragma mark - 顶端的五个按钮
-(void)makeTopbuttons{
    NSArray *topBtnNames = @[@"全部",@"待支付",@"取货中",@"配送中",@"已完成"];
    for (int i=0; i<5; i++) {
        UIButton *topbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 22)];
        topbtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        topbtn.tag = i;
        if (i==0) {
            topbtn.selected = YES;
        }
        topbtn.center = CGPointMake(SCREEN_WIDTH/5/2+i*SCREEN_WIDTH/5, 20+64);
        topbtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [topbtn setTitleColor:RGBCOLOR(36.0, 36.0, 36.0,1) forState:UIControlStateNormal];
        [topbtn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        [topbtn setTitle:topBtnNames[i] forState:UIControlStateNormal];
        [topbtn addTarget:self action:@selector(topBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:topbtn];
        [self.topBtnArr addObject:topbtn];
    }
    UIView *downLine = [[UIView alloc]initWithFrame:CGRectMake(0, 64+39.5, SCREEN_WIDTH, 0.5)];
    downLine.backgroundColor = SEPARATELINE_COLOR;
    [self.view addSubview:downLine];
    
    self.downRedLine = [[UIView alloc]initWithFrame:CGRectMake(0, 37.5+64, SCREEN_WIDTH/5, 2)];
    self.downRedLine.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.downRedLine];
}
#pragma mark - 顶端的几个按钮点击
-(void)topBtnClicked:(UIButton*)btn{
    [UIView animateWithDuration:0.3 animations:^{
        self.downRedLine.center = CGPointMake(SCREEN_WIDTH/5/2+btn.tag*SCREEN_WIDTH/5, self.downRedLine.center.y);
    }];
    btn.selected = YES;
    for (UIButton *topbtn in self.topBtnArr) {
        if (topbtn.tag!=btn.tag) {
            topbtn.selected = NO;
        }
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"cancelTheOrder" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"orderDetrailPageCanceled" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"payTheOrder" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"orderDetrailPagePaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"orderDetailPageBack" object:nil];
    for (UIView *subV in self.myscroll.subviews) {
        [subV removeFromSuperview];
    }
    self.myscroll.contentOffset = CGPointMake(btn.tag*SCREEN_WIDTH, 0);
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"subViewLeave" object:@{@"index":[NSString stringWithFormat:@"%ld",btn.tag+10]}];
    
    switch (btn.tag) {
        case 0:
        {
            AllOrderView *allorderview = [[AllOrderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104)];
            allorderview.delegate = self;
            [self.myscroll addSubview:allorderview];
        }
            break;
        case 1:
        {
            WaitToPayOrderView *waitView = [[WaitToPayOrderView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104)];
            [self.myscroll addSubview:waitView];
            waitView.delegate = self;
        }
            
            break;
        case 2:
        {
            ProcessingOrderView *processView = [[ProcessingOrderView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104)];
            [self.myscroll addSubview:processView];
            processView.delegate = self;
        }
            
            break;
        case 3:
        {
            TransportOrderView *transportView = [[TransportOrderView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*3, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104)];
            [self.myscroll addSubview:transportView];
            transportView.delegate = self;
            
        }
            
            break;
        case 4:
        {
            FinishedOrderView *finishView = [[FinishedOrderView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*4, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104)];
            [self.myscroll addSubview:finishView];
            finishView.delegate = self;
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
