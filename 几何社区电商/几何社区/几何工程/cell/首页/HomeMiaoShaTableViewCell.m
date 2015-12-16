//
//  HomeMiaoShaTableViewCell.m
//  几何社区
//
//  Created by KMING on 15/10/14.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "HomeMiaoShaTableViewCell.h"
#import "UIImageView+AFNetworking.h"
@implementation HomeMiaoShaTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.myLbl= [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.myLbl.text = @"99:99:99";
    [self.contentView addSubview:self.myLbl];
    self.myLbl.hidden = YES;
    self.timer= [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkTime) userInfo:nil repeats:YES];
    
    

}
-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    
    [self.imgV setImageWithURL:[NSURL URLWithString:self.imgUrl] placeholderImage:[UIImage imageNamed:@"首页banner默认图"]];
     self.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 8+SCREEN_WIDTH*105/320);
    
    UIView *seperateV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
    seperateV.backgroundColor = HEADERVIEW_COLOR;
    UIView *topLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    topLine.backgroundColor = SEPARATELINE_COLOR;
    [seperateV addSubview:topLine];
    UIView *downLine = [[UIView alloc]initWithFrame:CGRectMake(0, 7.5, SCREEN_WIDTH, 0.5)];
    downLine.backgroundColor = SEPARATELINE_COLOR;
    [seperateV addSubview:downLine];
    [self.contentView addSubview:seperateV];
    
    
    if ([self.flag isEqualToString:@"1"]) {
        self.juliLbl.text = @"距离结束";
    }else{
        self.juliLbl.text = @"距离开抢";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    
    NSDate *date2=[dateFormatter dateFromString:self.flag_time];
    NSDate *date1=[dateFormatter dateFromString:self.time];
    NSTimeInterval timein = [date2 timeIntervalSinceDate:date1];
    
    [timerExample3 removeFromSuperview];
    timerExample3 = [[MZTimerLabel alloc] initWithLabel:self.myLbl andTimerType:MZTimerLabelTypeTimer];
    [timerExample3 setCountDownTime:timein]; //** Or you can use [timer3 setCountDownToDate:aDate];
    [timerExample3 start];
    
}
-(void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}
-(void)checkTime{
    NSArray *timeArr = [self.myLbl.text componentsSeparatedByString:@":"];
    NSString *shi = timeArr[0];
    NSString *fen = timeArr[1];
    NSString *miao = timeArr[2];
    // NSLog(@"%@---%@---%@",shi,fen,miao);
    self.shi.text = shi;
    self.fen.text = fen;
    self.miao.text = miao;
    
    
    
    
    
    if ([self.flag isEqualToString:@"1"]) {
        
        self.juliLbl.text = @"距离结束";
        
    }else{
        self.juliLbl.text = @"距离开抢";
       
        
        
    }
    
    //    //NSLog(@"%@",self.countTimeLbl.text);
    //    if ([self.hideLbl.text isEqualToString:@"00:00:00"]) {
    //        [self.timer invalidate];
    //        NSDictionary *ard = @{@"area_id":[[NSUserDefaults standardUserDefaults]objectForKey:@"regionId"]};
    //        [_manager getMiaoshaListWithAreaId:ard];
    //    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
