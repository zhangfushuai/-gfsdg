//
//  MiaoShaListTableViewController.h
//  几何社区
//
//  Created by KMING on 15/10/12.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiaoShaListTableViewController : JHBasicTableViewController
@property (weak, nonatomic) IBOutlet UIView *headV;
@property (weak, nonatomic) UILabel *countTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *juliLbl;
@property (weak, nonatomic) IBOutlet UILabel *hideTimeL;
@property (weak, nonatomic) IBOutlet UILabel *shiLbl;
@property (weak, nonatomic) IBOutlet UILabel *fenLbl;
@property (weak, nonatomic) IBOutlet UILabel *miaoLBl;
@property (nonatomic,strong)MJRefreshHeaderView *header;
@end
