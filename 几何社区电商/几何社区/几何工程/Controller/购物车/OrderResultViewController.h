//
//  OrderResultViewController.h
//  几何社区
//
//  Created by 颜 on 15/9/25.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "JHBasicViewController.h"

@interface OrderResultViewController : JHBasicViewController
@property (nonatomic,assign) BOOL orderSuccess;
@property (weak, nonatomic) IBOutlet UIImageView *imgVHeader;
@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnReturn;

@property (nonatomic ,assign) NSInteger payWayFlag;
@property (nonatomic ,strong) NSString *orderID;

@end
