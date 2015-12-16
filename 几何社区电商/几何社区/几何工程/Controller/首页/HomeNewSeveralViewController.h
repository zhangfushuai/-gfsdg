//
//  HomeNewSeveralViewController.h
//  几何社区
//
//  Created by KMING on 15/10/8.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeNewBannerModel.h"
@interface HomeNewSeveralViewController : JHBasicViewController
@property (nonatomic,strong)HomeNewBannerModel *model;
@property (nonatomic,strong)MJRefreshHeaderView *header;
@property (nonatomic,copy)NSString *url;
@end
