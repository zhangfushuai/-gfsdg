//
//  JhActionSheet.h
//  几何社区
//
//  Created by 颜 on 15/9/23.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JhActionSheet;
@protocol JHActionSheetDelegate <NSObject>
@optional
- (void)actionSheet:(JhActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)index;  //-1 confirm
                                                                        //-2 add  0以上表示列表的其中一个
@end
@interface JhActionSheet : UIControl <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic , assign)id <JHActionSheetDelegate>delegate;
@property (nonatomic , strong)NSArray *datasourse;

-(id)initWithConfirmTitle:(NSString *)confirmTitle delegate:(id)delegate addTitle:(NSString *)addTitle arrList:(NSArray *)List;
@end
