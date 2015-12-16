//
//  HomeClickActvityViewController.m
//  几何社区
//
//  Created by KMING on 15/9/10.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "HomeClickActvityViewController.h"
#import "Utils.h"
#import "ProductDetailViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
@interface HomeClickActvityViewController ()<UIWebViewDelegate,JHDataMagerDelegate,NJKWebViewProgressDelegate>

@property (nonatomic,copy)NSString *daoshuEr;
@end

@implementation HomeClickActvityViewController
{
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
-(void)viewWillAppear:(BOOL)animated{
//    [self setNavColor:[UIColor whiteColor]];
    [super viewWillAppear:animated];
    [self setLeftNavButtonWithType:BACK];
    _manager.delegate = self;
    [self setNavTitleColor:[UIColor blackColor]];
    self.title = @"专题页面";
    [MobClick beginLogPageView:@"HomeClickActvityViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIWebView *webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    webView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webView];
    
    _progressProxy = [[NJKWebViewProgress alloc] init]; // instance variable
    webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    
    _manager = [JHDataManager getInstance];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [webView loadRequest:request];
   [self.navigationController.navigationBar addSubview:_progressView];
    [_progressView setProgress:0.0];
}
#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    
   [_progressView setProgress:progress animated:YES];
   
    //self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSString *urlString = [[request URL] absoluteString];
    //NSLog(@"%@",urlString);
    NSArray *urlcomps = [urlString componentsSeparatedByString:@"://"];
    NSString *urlstring = urlcomps[1];
    NSArray *urlarr = [urlString componentsSeparatedByString:@"/"];
    NSString *numberstr = [urlarr lastObject];

    //如果倒数第二个是product，最后面是纯数字，就是商品id,跳到商品详情页面
    
    self.daoshuEr = urlarr[urlarr.count-2];
    if (([self.daoshuEr isEqualToString:@"product"]&&[Utils isPureInt:numberstr]) || ([self.daoshuEr isEqualToString:@"goods"]&&[Utils isPureInt:numberstr])) {
        [_manager getGoodDetailWithID:numberstr];
        return NO;
    }
    return YES;
}
-(void)requestSuccess:(id)object withRequestType:(RequestType)requestType{
    switch (requestType) {
        case JHGETGOODDETAIL:
        {
//            ProductDetailViewController *vc = [[ProductDetailViewController alloc] init];
//            vc.goodDetail   = object;
//            
//            [self.navigationController pushViewController:vc animated:YES];
            if ([self.daoshuEr isEqualToString:@"goods"]) {
                ProductDetailViewController *vc = [[ProductDetailViewController alloc] init];
                vc.fromFlag = 1000;
                vc.goodDetail   = object;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else{
                ProductDetailViewController *vc = [[ProductDetailViewController alloc] init];
                vc.goodDetail   = object;
                [self.navigationController pushViewController:vc animated:YES];
            }

        }
            break;
        default:
            break;
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
    [MobClick endLogPageView:@"HomeClickActvityViewController"];
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
