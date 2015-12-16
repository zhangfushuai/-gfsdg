//
//  ShareListTableViewCell.m
//  几何社区
//
//  Created by KMING on 15/9/25.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "ShareListTableViewCell.h"

@implementation ShareListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.nameLbl.textColor = RGBCOLOR(0, 0, 0, 1);
    self.statusLbl.textColor = Color757575;
    self.time.textColor = Color757575;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.nameLbl.text = [self.shareDic objectForKey:@"name"];
    if ([[self.shareDic objectForKey:@"login"]isEqualToString:@"0"]) {
        self.statusLbl.text = @"正在邀请";
    }else{
        self.statusLbl.text = @"邀请成功";
    }
    
    NSString *str=[self.shareDic objectForKey:@"created"];//时间戳
    NSTimeInterval time=[str doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    self.time.text = currentDateStr;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
