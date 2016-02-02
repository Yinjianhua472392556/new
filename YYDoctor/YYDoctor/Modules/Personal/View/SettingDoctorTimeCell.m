//
//  SettingDoctorTimeCell.m
//  YYDoctor
//
//  Created by apple on 15/11/3.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "SettingDoctorTimeCell.h"

@implementation SettingDoctorTimeCell

- (IBAction)onBeginTimeClick:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(beginTimeClick:)]) {
        [_delegate beginTimeClick:sender];
    }
}

- (IBAction)onEndTimeClick:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(endTimeClick:)]) {
        [_delegate endTimeClick:sender];
    }
}

@end
