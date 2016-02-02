//
//  SettingView.m
//  YYDoctor
//
//  Created by QiuQuan Wu on 15/11/28.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "SettingView.h"

@implementation SettingView

+ (instancetype)initWithXib {
    return [[[NSBundle mainBundle] loadNibNamed:@"SettingView" owner:self options:nil] lastObject];
}

- (IBAction)buttonClick:(UIButton *)sender {
    if (self.btnBlock) {
        self.btnBlock(sender);
    }
}

- (void)addActionBlock:(ButtonBlock)btnBlock {
    self.btnBlock = btnBlock;
}

@end
