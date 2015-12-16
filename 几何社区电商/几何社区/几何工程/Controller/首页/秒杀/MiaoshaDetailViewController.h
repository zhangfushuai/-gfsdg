//
//  MiaoshaDetailViewController.h
//  几何社区
//
//  Created by KMING on 15/10/13.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiaoshaDetailModel.h"
#import "MZTimerLabel.h"
@interface MiaoshaDetailViewController : JHBasicViewController
@property (nonatomic,strong)MiaoshaDetailModel *model;
@property (weak, nonatomic) IBOutlet UILabel *shi;
@property (weak, nonatomic) IBOutlet UILabel *fen;
@property (weak, nonatomic) IBOutlet UILabel *miao;

@property (weak, nonatomic) IBOutlet UILabel *juliLbl;
@property (weak, nonatomic) IBOutlet UIButton *qiangBtn;
@end
