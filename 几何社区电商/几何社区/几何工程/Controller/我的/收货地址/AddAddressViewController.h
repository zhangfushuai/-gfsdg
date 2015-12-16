//
//  AddAddressViewController.h
//  几何社区
//
//  Created by KMING on 15/8/29.
//  Copyright (c) 2015年 lmh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAddressModel.h"
@protocol AddressDelegate <NSObject>
@optional
- (void)chooseAddress:(MyAddressModel*)address;
@end
@interface AddAddressViewController : JHBasicViewController 
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *nameTf;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *downview;
@property (weak, nonatomic) IBOutlet UITextField *menpaihaoTf;
@property (weak, nonatomic) IBOutlet UILabel *shouhuoAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *districtLabel;

@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textfields;

@property (nonatomic)NSInteger selectIndex;//编辑的序号
@property (nonatomic,strong)MyAddressModel *myaddressM;
@property (nonatomic,copy)NSString *selectCity;//记录选择的城市，用来传值给下一个页面,还有要保存到模型里，否则编辑时当在某一个城市poi搜索时候他不知道到底在哪一个城市poi搜索


@property (nonatomic)CGFloat latitude;
@property (nonatomic)CGFloat longtitude;

@property (nonatomic , assign)id <AddressDelegate> delegate;
@end
