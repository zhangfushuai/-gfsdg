//
//  ServiceCommentTableViewCell.h
//  几何社区
//
//  Created by KMING on 15/10/20.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceCommentTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *speedComment;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *attitudeComment;


@end
