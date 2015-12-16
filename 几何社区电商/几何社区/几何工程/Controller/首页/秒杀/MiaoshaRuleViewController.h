//
//  MiaoshaRuleViewController.h
//  几何社区
//
//  Created by KMING on 15/10/13.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MiaoshaRuleViewController : JHBasicViewController
@property (weak, nonatomic) IBOutlet UIView *backV;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labls;

@end
