//
//  ShareModel.h
//  几何社区
//
//  Created by KMING on 15/9/29.
//  Copyright © 2015年 lmh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareModel : NSObject
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *headimgurl;
@property (nonatomic,copy)NSString *url;
@property (nonatomic,copy)NSString *share_num;
@property (nonatomic,copy)NSString *share_total;
@property (nonatomic,strong)NSMutableArray *sharelist;//装着字典，key：name(18888777765),id"133",login"0"created"1443606645",都是字符串
+ (ShareModel*)modelFromJsonDictionnary:(NSDictionary *)dic;
@end
