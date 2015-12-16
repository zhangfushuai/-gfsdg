//
//  ServiceCommentTableViewCell.m
//  几何社区
//
//  Created by KMING on 15/10/20.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import "ServiceCommentTableViewCell.h"

@implementation ServiceCommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)speedComment:(UIButton*)btn {
   [[NSNotificationCenter defaultCenter]postNotificationName:@"speedComment" object:@{@"star":[NSString stringWithFormat:@"%ld",(long)btn.tag]}];
}
- (IBAction)serviceComment:(UIButton*)btn {
     [[NSNotificationCenter defaultCenter]postNotificationName:@"serviceComment" object:@{@"star":[NSString stringWithFormat:@"%ld",(long)btn.tag]}];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
