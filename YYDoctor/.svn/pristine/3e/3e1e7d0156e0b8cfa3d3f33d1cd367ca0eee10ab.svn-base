//
//  SettingsTimeInfo.m
//  YYDoctor
//
//  Created by MaxJmac on 15/11/17.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "SettingsTimeInfo.h"

@implementation SettingsTimeInfo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.doctorId  = dictionary[@"docId"];
        self.beginTime = [dictionary[@"bTime"] substringToIndex:5];
        self.endTime   = [dictionary[@"eTime"] substringToIndex:5];
    }
    return self;
}

@end
