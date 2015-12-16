//
//  ShareListTableViewCell.h
//  几何社区
//
//  Created by KMING on 15/9/25.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusLbl;
@property (nonatomic,strong)NSDictionary *shareDic;
@property (nonatomic,copy)NSString* timeChuo;
@property (weak, nonatomic) IBOutlet UILabel *time;
@end
