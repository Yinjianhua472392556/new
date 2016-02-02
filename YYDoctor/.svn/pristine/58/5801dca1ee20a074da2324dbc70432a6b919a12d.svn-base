//
//  MessageModel.m
//  YYDoctor
//
//  Created by apple on 15/10/22.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "MessageInfo.h"

@implementation MessageInfo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.docId        = [dictionary[@"docId"]integerValue];
        self.userId       = [dictionary[@"userId"] integerValue];
        self.shiftType    = [dictionary[@"shiftType"] integerValue];
        self.time         = [dictionary[@"time"] description];
        self.state        = [dictionary[@"state"] integerValue];
        self.userName     = [dictionary[@"userName"] description];
        self.logCtime     = [dictionary[@"logCtime"] description];
        self.patSex       = [dictionary[@"patSex"] integerValue];
        self.patName      = [dictionary[@"patName"] description];
        self.patId        = [dictionary[@"patId"] description];
        self.schRegfee    = [dictionary[@"schRegfee"] integerValue];
        self.schDate      = [dictionary[@"schDate"] description];
        self.seqBeginTime = [dictionary[@"seqBeginTime"] description];
        self.seqEndTime   = [dictionary[@"seqEndTime"] description];
        self.regstatus    = [dictionary[@"regStatus"] integerValue];
        if (![dictionary[@"userSex"] isEqual:[NSNull null]]) {
            self.userSex  = [dictionary[@"userSex"] integerValue];
        }
        if (![dictionary[@"id"] isEqual:[NSNull null]]) {
             self.messageId = [dictionary[@"id"] integerValue];
        }
    }
    return self;
}

@end
