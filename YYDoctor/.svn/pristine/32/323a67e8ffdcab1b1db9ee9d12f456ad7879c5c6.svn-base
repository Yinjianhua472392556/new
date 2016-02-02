//
//  SettingInfo.m
//  YYDoctor
//
//  Created by apple on 15/10/28.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "SettingInfo.h"

@implementation SettingInfo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.docId     = [dictionary[@"docId"] integerValue];
        self.beginTime = [dictionary[@"bTime"] substringToIndex:5];
        self.endTime   = [dictionary[@"eTime"] substringToIndex:5];
    }
    return self;
}


@end
