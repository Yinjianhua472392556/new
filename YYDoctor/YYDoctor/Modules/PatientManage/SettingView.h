//
//  SettingView.h
//  YYDoctor
//
//  Created by QiuQuan Wu on 15/11/28.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ButtonBlock)(UIButton *sender);

@interface SettingView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (strong, nonatomic) ButtonBlock btnBlock;

+ (instancetype)initWithXib;
- (void)addActionBlock:(ButtonBlock)btnBlock;

@end
