//
//  MessageModel.m
//  YYDoctor
//
//  Created by apple on 15/10/22.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "MessageCenterInfo.h"

@implementation MessageCenterInfo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.docId        = dictionary[@"docId"];
        self.userId       = dictionary[@"userId"] ;
        self.shiftType    = dictionary[@"shiftType"];
        self.time         = [dictionary[@"time"] description];
        self.state        = dictionary[@"state"] ;
        self.userName     = [dictionary[@"userName"] description];
        self.logCtime     = [dictionary[@"logCtime"] description];
        self.patSex       = dictionary[@"patSex"];
        self.patName      = [dictionary[@"patName"] description];
        self.patId        = [dictionary[@"patId"] description];
        self.schRegfee    = dictionary[@"schRegfee"];
        self.schDate      = [dictionary[@"schDate"] description];
        self.seqBeginTime = [dictionary[@"seqBeginTime"] description];
        self.seqEndTime   = [dictionary[@"seqEndTime"] description];
        self.regstatus    = dictionary[@"regStatus"];
        self.userSex      = dictionary[@"userSex"];
        self.messageId    = dictionary[@"id"];
    }
    return self;
}

@end
