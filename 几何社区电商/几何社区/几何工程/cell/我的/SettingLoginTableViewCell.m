//
//  SettingLoginTableViewCell.m
//  几何社区
//
//  Created by KMING on 15/9/7.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "SettingLoginTableViewCell.h"
#import "LoginViewController.h"
@implementation SettingLoginTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)loginAction:(id)sender
{
    LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    [self.delegate presentViewController:vc animated:YES completion:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
