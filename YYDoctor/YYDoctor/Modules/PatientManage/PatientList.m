//
//  PatientList.m
//  YYDoctor
//
//  Created by QiuQuan Wu on 15/10/21.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "PatientList.h"

@implementation PatientList

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.imageURL        = [dictionary[@"image"] description];
        self.nickName        = [dictionary[@"nickName"] description];
        self.userName        = [dictionary[@"userName"] description];
        self.userAccount     = [dictionary[@"userAccount"] description];
        self.PatDescription  = [dictionary[@"description"] description];
        self.gender          = [dictionary[@"sex"] integerValue];
        self.age             = [dictionary[@"age"] integerValue];
        self.friendId        = [dictionary[@"friendId"] integerValue];
    }
    return self;
}

@end
