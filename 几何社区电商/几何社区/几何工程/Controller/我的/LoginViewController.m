//
//  LoginViewController.m
//  几何社区
//
//  Created by KMING on 15/9/7.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "LoginViewController.h"
#import "MBProgressHUD.h"
#import "Utils.h"
@interface LoginViewController ()
//@property (nonatomic,copy)NSString *phonenum;
@property (nonatomic)int getCodeCount;
@end

@implementation LoginViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _manager.delegate = self;
    [MobClick beginLogPageView:@"LoginViewController"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEADERVIEW_COLOR;
    self.naviView.backgroundColor = NAVIGATIONBAR_COLOR;
    self.seconds = 60;
    self.getCodeLabel.textColor =NAVIGATIONBAR_COLOR;
    
    _manager = [JHDataManager getInstance];
    
    UIView *centerline = [[UIView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH-24, 0.5)];
    centerline.backgroundColor = [UIColor colorWithWhite:0.827 alpha:1.000];
    [self.backV addSubview:centerline];
    [self.logBtn setTitleColor:[UIColor colorWithWhite:0.976 alpha:1.000] forState:UIControlStateDisabled];
    self.logBtn.backgroundColor = NAVIGATIONBAR_COLOR;
    self.logBtn.layer.masksToBounds = YES;
    self.logBtn.layer.cornerRadius = 4;
//    [self.codetf addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
//    if ([self.codetf.text isEqualToString:@""]) {
//        self.logBtn.enabled = NO;
//    }
    self.shoubudaoLbl.textColor = Color242424;
    self.zhaohuanLbl.textColor = Color242424;
    
    
    self.getcodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 86, 24)];
    self.getcodeBtn.center = CGPointMake(SCREEN_WIDTH-12-12-43-12, 22);
    [self.getcodeBtn setBackgroundImage:[UIImage imageNamed:@"hq"] forState:UIControlStateNormal];
    self.getcodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.getcodeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.getcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.getcodeBtn addTarget:self action:@selector(getCodeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backV addSubview:self.getcodeBtn];
    
    self.getCodeLabel.textColor = [UIColor colorWithRed:0.196 green:0.380 blue:0.996 alpha:1.000];
}
- (IBAction)getYuYinCode:(id)sender {
    
    NSDictionary *dict = @{@"phone" : self.phonetf.text};
    [MobClick event:@"getVoiceCode" attributes:dict];
    if ([Utils isPureInt:self.phonetf.text]&&self.phonetf.text.length==11) {
        [_manager getVoiceCodeWithPhone:self.phonetf.text];
        
        
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入正确手机号";
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [hud removeFromSuperview];
            
        }];
    }
    
    
}
-(void)getCodeAction{
    
    NSDictionary *dict = @{@"phone" : self.phonetf.text};
    [MobClick event:@"getVerifyCode" attributes:dict];
    
    
    if ([Utils isPureInt:self.phonetf.text]&&self.phonetf.text.length==11) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
        NSDictionary *params = @{@"phone":self.phonetf.text};
        self.getCodeCount = 1;
        [_manager getVerificationCodeWithParams:params];
        
        
    }else{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入正确手机号";
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [hud removeFromSuperview];
            
        }];
    }

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"LoginViewController"];
}
//-(void)textFieldValueChanged:(UITextField*)tf{
//    if ([tf.text isEqualToString:@""]) {
//        self.logBtn.enabled = NO;
//    }else{
//         self.logBtn.enabled = YES;
//    }
//   
//    
//}
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)loginAction:(id)sender {
    [self.view endEditing:YES];
    NSDictionary *dict = @{@"phone" : self.phonetf.text};
    [MobClick event:@"loginAction" attributes:dict];
//    if ([Utils isPureInt:self.codetf.text]&&self.codetf.text.length==4) {
//        NSDictionary *params = @{@"phone":self.phonetf.text,@"code":self.codetf.text};
//        [_manager loginWithParams:params];
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        // hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"登录中...";
//        
//
//    }else{
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"请输入正确格式验证码";
//        [hud showAnimated:YES whileExecutingBlock:^{
//            sleep(1);
//        } completionBlock:^{
//            [hud removeFromSuperview];
//            
//        }];
//    }
    if ([self.codetf.text isEqualToString:@""]) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"验证码不能为空";
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [hud removeFromSuperview];
            
        }];
    }else if (![Utils isPureInt:self.phonetf.text] || self.phonetf.text.length!=11){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"请输入正确手机号";
        [hud showAnimated:YES whileExecutingBlock:^{
            sleep(1);
        } completionBlock:^{
            [hud removeFromSuperview];
            
        }];
    }
    else{
        NSDictionary *params = @{@"phone":self.phonetf.text,@"code":self.codetf.text};
        [_manager loginWithParams:params];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        // hud.mode = MBProgressHUDModeText;
        hud.labelText = @"登录中...";
    }
    
    
    
    
    
}
-(void)stopHud{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)timerFireMethod:(NSTimer *)timer {
    if (self.seconds == 1) {
        [self.timer invalidate];
        self.seconds = 60;
        self.getcodeBtn.hidden = NO;
        if (self.getCodeCount!=0) {
            [self.getcodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        }else{
            [self.getcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        }
        self.getCodeLabel.text = @"";
        [self.getcodeBtn setEnabled:YES];
    }else{
        self.seconds--;
        NSString *title = [NSString stringWithFormat:@"%ds",self.seconds];
        self.getcodeBtn.hidden = YES;
        [self.getcodeBtn setEnabled:NO];
        self.getCodeLabel.text = title;
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
-(void)requestSuccess:(id)object withRequestType:(RequestType)requestType{
    switch (requestType) {
        case JHGETVERIFYCODE:
        {
           // NSDictionary *dic =object;
//            if ([[dic objectForKey:@"msg"] isEqualToString:@"验证码发送成功"]) {
//               
//                
//            }else{
//                NSLog(@"验证码发送失败");
//                [self.timer invalidate];
//                self.seconds = 60;
//                
//                self.getcodeBtn.hidden = NO;
//                if (self.getCodeCount!=0) {
//                    [self.getcodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
//                }else{
//                    [self.getcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//                }
//                [self.getcodeBtn setEnabled:YES];
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                hud.mode = MBProgressHUDModeText;
//                hud.labelText = @"验证码获取失败，请重新获取";
//                [hud showAnimated:YES whileExecutingBlock:^{
//                    sleep(1);
//                } completionBlock:^{
//                    [hud removeFromSuperview];
//                    
//                }];
//            }
           // NSLog(@"验证码发送成功");
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"验证码已发送";
            [hud showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [hud removeFromSuperview];
                
            }];
        }
            break;
        case JHLOGIN:
        {
            
            NSDictionary *dic =object;
//            if ([[dic objectForKey:@"msg"] isEqualToString:@"登录成功"]) {
//                NSLog(@"登录成功");
//                NSDictionary *dataDic = [dic objectForKey:@"data"];
//                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//                [ud setObject:@"登录" forKey:@"logState"];//保存登录状态到userdefault
//                [ud setObject:[dataDic objectForKey:@"phone"] forKey:@"phone"];//保存手机号到userdefault
//                [ud setObject:[dataDic objectForKey:@"name"] forKey:@"name"];//保存手机号到userdefault
//                [ud setObject:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"number"]] forKey:@"number"];  //购物车数量
//                [ud synchronize];
//                
//                MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
//                hud.mode = MBProgressHUDModeText;
//                hud.labelText = @"登录成功";
//                [hud showAnimated:YES whileExecutingBlock:^{
//                    sleep(1);
//                } completionBlock:^{
//                    [hud removeFromSuperview];
//                    [self dismissViewControllerAnimated:YES completion:nil];
//                }];
//
//            }else{
//                NSLog(@"验证码不正确");
//                MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
//                hud.mode = MBProgressHUDModeText;
//                hud.labelText = @"验证码不正确";
//                [hud showAnimated:YES whileExecutingBlock:^{
//                    sleep(1);
//                } completionBlock:^{
//                    [hud removeFromSuperview];
//                    
//                }];
//            }
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:@"登录" forKey:@"logState"];//保存登录状态到userdefault
            [ud setObject:[dataDic objectForKey:@"phone"] forKey:@"phone"];//保存手机号到userdefault
            [ud setObject:[dataDic objectForKey:@"name"] forKey:@"name"];//保存手机号到userdefault
            [ud setObject:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"number"]] forKey:@"number"];  //购物车数量
            [ud synchronize];
            
            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"登录成功";
            [hud showAnimated:YES whileExecutingBlock:^{
                sleep(1);
            } completionBlock:^{
                [hud removeFromSuperview];
                [self dismissViewControllerAnimated:YES completion:nil];
            }];

        }
            break;
        case JHGETVOICECODE:
        {
            self.downLbl.hidden = NO;
            self.callPhoneLbl.hidden = NO;
            NSDictionary *dic = object;
            self.callPhoneLbl.text = [dic objectForKey:@"displayNum"];
        }
            
        default:
            break;
    }
}
-(void)requestFailure:(id)failReson withRequestType:(RequestType)requestType{

    switch (requestType) {
        case JHGETVERIFYCODE:
        {
            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
            [hud removeFromSuperview];
            if ([failReson isKindOfClass:[NSDictionary class]]) {
                [self.view makeToast:[failReson objectForKey:@"msg"]];
            }else if([failReson isKindOfClass:[NSString class]]){
                [self.view makeToast:failReson];
            }
            [self.timer invalidate];
            self.seconds = 60;
            self.getCodeLabel.text = @"";
            self.getcodeBtn.hidden = NO;
            if (self.getCodeCount!=0) {
                [self.getcodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
            }else{
                [self.getcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            }
            [self.getcodeBtn setEnabled:YES];
            
        }
            break;
        case JHLOGIN:
        {
            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
            [hud removeFromSuperview];
            if ([failReson isKindOfClass:[NSDictionary class]]) {
                [self.view makeToast:[failReson objectForKey:@"msg"]];
            }else if([failReson isKindOfClass:[NSString class]]){
                [self.view makeToast:failReson];
            } 
            NSLog(@"%@",failReson);
        }
            break;
        case JHGETVOICECODE:
        {
            if ([failReson isKindOfClass:[NSDictionary class]]) {
                [self.view makeToast:[failReson objectForKey:@"msg"]];
            }else if([failReson isKindOfClass:[NSString class]]){
                [self.view makeToast:failReson];
            }
        }
            break;
        
            
        default:
            break;
    }
}
//-(void)requestFailure:(id)failReson withRequestType:(RequestType)requestType{
//    switch (requestType) {
//        case JHGETVERIFYCODE:
//        {
//            [self.timer invalidate];
//            self.seconds = 60;
//            self.getCodeLabel.text = @"";
//            self.getcodeBtn.hidden = NO;
//            if (self.getCodeCount!=0) {
//                [self.getcodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
//            }else{
//                [self.getcodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//            }
//            [self.getcodeBtn setEnabled:YES];
//            NSLog(@"%@",failReson);
//            if (!failReson) {
//                failReson = @"获取验证码失败";
//            }
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = failReson;
//            [hud showAnimated:YES whileExecutingBlock:^{
//                sleep(2);
//            } completionBlock:^{
//                [hud removeFromSuperview];
//                
//            }];
//        }
//            break;
//        
//        case JHLOGIN:
//        {   NSLog(@"%@",failReson);
//            if (!failReson) {
//                failReson = @"登录失败";
//            }
//            MBProgressHUD *hud = [MBProgressHUD HUDForView:self.view];
//            hud.mode = MBProgressHUDModeText;
//            hud.labelText = failReson;
//            [hud showAnimated:YES whileExecutingBlock:^{
//                sleep(2);
//            } completionBlock:^{
//                [hud removeFromSuperview];
//                
//            }];
//        }
//            break;
//            
//        default:
//            break;
//    }
//}
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
