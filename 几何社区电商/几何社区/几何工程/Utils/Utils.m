//
//  Utils.m
//  几何社区
//
//  Created by KMING on 15/9/5.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import "Utils.h"
#import <objc/runtime.h>

@implementation Utils
//判断是否为整形：

+ (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形：

+ (BOOL)isPureFloat:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
//小数点后两位
+ (NSString *)floatStringFromString:(NSString *)string
{
    NSString *str = [NSString stringWithFormat:@"%.2f",[string floatValue]];
    return str;
}
+ (CGSize)sizeFromString:(NSString *)string withFont:(float)font
{
    if (ISIOS7) {
        CGSize size = [string sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:font],NSStrokeColorAttributeName: [UIColor greenColor], NSForegroundColorAttributeName:[UIColor greenColor]}];
        CGSize statuseStrSize = CGSizeMake(ceilf(size.width), ceilf(size.height));
        return statuseStrSize;
        
    }else{
        CGSize size = [string sizeWithFont:[UIFont systemFontOfSize:font]];
        return size;
    }
}

@end
