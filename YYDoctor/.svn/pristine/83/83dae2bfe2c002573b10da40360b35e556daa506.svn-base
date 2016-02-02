//
//  MessageModel.m
//  YYDoctor
//
//  Created by apple on 15/10/22.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.messageId = [dictionary[@"id"] integerValue];
        self.docId     = [dictionary[@"docId"] integerValue];
        self.userId    = [dictionary[@"userId"] integerValue];
        self.shiftType = [dictionary[@"shiftType"] integerValue];
        self.state     = [dictionary[@"state"] integerValue];
        self.userSex   = [dictionary[@"userSex"] integerValue];
        self.logCtime  = [dictionary[@"logCtime"] description];
        self.userName  = [dictionary[@"userName"] description];
        self.time      = [dictionary[@"time"] description];

    }
    return self;
}


@end
