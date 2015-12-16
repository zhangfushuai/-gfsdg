//
//  HomeMiaoShaTableViewCell.h
//  几何社区
//
//  Created by KMING on 15/10/14.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTimerLabel.h"
@interface HomeMiaoShaTableViewCell : UITableViewCell<MZTimerLabelDelegate>
{
    MZTimerLabel *timerExample3;
}
@property (weak, nonatomic) IBOutlet UILabel *shi;
@property (weak, nonatomic) IBOutlet UILabel *fen;
@property (weak, nonatomic) IBOutlet UILabel *miao;
@property (weak, nonatomic) IBOutlet UILabel *juliLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;

//首页秒杀时间
@property (nonatomic,copy)NSString *flag;//1为正在抢，0为还未开始
@property (nonatomic,copy)NSString *flag_time;//截止时间
@property (nonatomic,copy)NSString *time;//当前服务器时间

@property (nonatomic,strong)UILabel *myLbl;

@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,copy)NSString *imgUrl;
@end
