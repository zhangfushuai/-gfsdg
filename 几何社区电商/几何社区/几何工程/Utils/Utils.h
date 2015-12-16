//
//  Utils.h
//  几何社区
//
//  Created by KMING on 15/9/5.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject
//判断是否为整形：
+ (BOOL)isPureInt:(NSString*)string;
//判断是否为浮点形：
+ (BOOL)isPureFloat:(NSString*)string;
//小数点后两位
+ (NSString *)floatStringFromString:(NSString *)string;
//计算字符串长度
+ (CGSize)sizeFromString:(NSString *)string withFont:(float)font;
@end
