//
//  HomeActivityModel.h
//  几何社区
//
//  Created by KMING on 15/9/8.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeActivityModel : NSObject
@property (nonatomic,copy)NSString *imgsrc;//图片网址
@property (nonatomic,copy)NSString *url;//点击跳到webview的网址
@property (nonatomic,copy)NSString *start_time;
@property (nonatomic,copy)NSString *end_time;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *mid;
@property (nonatomic,copy)NSString *pid;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *redirect_type;
@property (nonatomic,copy)NSString *cid;
@property (nonatomic,copy)NSString *activity_title;
+(NSMutableArray*)listFromJsonDictionary:(NSDictionary*)dic;
@end
