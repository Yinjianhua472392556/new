//
//  RegistrationRecordInfo.m
//  YYDoctor
//
//  Created by apple on 15/10/29.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "RegistrationRecordInfo.h"

@implementation RegistrationRecordInfo

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        self.patSex       = [dict[@"patSex"] integerValue];
        self.patName      = [dict[@"patName"] integerValue];
        self.patId        = dict[@"patId"];
        self.schRegfee    = [dict [@"schRegfee"] integerValue];
        self.schDate      = dict[@"schDate"];
        self.messageId    = [dict[@"id"] integerValue];
        self.seqBeginTime = dict[@"seqBeginTime"];
        self.seqEndTime   = dict[@"seqEndTime"];
        self.regstatus    = [dict[@"regstatus"] integerValue];
        self.docId        = [dict[@"docId"] integerValue];
    }
    return self;
}



@end
