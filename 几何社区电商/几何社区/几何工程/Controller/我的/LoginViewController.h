//
//  LoginViewController.h
//  几何社区
//
//  Created by KMING on 15/9/7.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : JHBasicViewController
@property (weak, nonatomic) IBOutlet UIView *naviView;
@property (weak, nonatomic) IBOutlet UILabel *getCodeLabel;
@property (weak, nonatomic) IBOutlet UITextField *phonetf;
@property (weak, nonatomic) IBOutlet UITextField *codetf;
@property (weak, nonatomic) IBOutlet UIButton *logBtn;

@property (weak, nonatomic) IBOutlet UIView *backV;
@property (nonatomic,strong) UIButton *getcodeBtn;
@property (nonatomic)int seconds;
@property (weak, nonatomic) IBOutlet UILabel *shoubudaoLbl;
@property (weak, nonatomic) IBOutlet UILabel *zhaohuanLbl;
@property (weak, nonatomic) IBOutlet UIButton *yuYinBtn;
@property (weak, nonatomic) IBOutlet UILabel *callPhoneLbl;
@property (weak, nonatomic) IBOutlet UILabel *downLbl;
@property (nonatomic,strong)NSTimer *timer;
@end
