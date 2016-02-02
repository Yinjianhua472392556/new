//
//  PatientGroup.m
//  YYDoctor
//
//  Created by QiuQuan Wu on 15/10/21.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "PatientGroup.h"
#import "PatientList.h"

@implementation PatientGroup

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        
        self.groupName = [dictionary[@"groupName"] description];
        self.groupId   = [dictionary[@"groupId"] integerValue];
        self.size      = [dictionary[@"size"] integerValue];
        self.orderNum  = [dictionary[@"orderNum"] integerValue];
        if (self.size == 0) {
            self.patientList = nil;
        }else if (self.size == 1){
            self.patientList = @[dictionary[@"friendList"]];
        }else {
            self.patientList = dictionary[@"friendList"];
        }
    }
    return self;
}

@end
