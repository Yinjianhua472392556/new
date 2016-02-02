//
//  ChatListModel.m
//  YYDoctor
//
//  Created by apple on 15/10/30.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "ChatListModel.h"

@implementation ChatListModel

- (instancetype)initWithDict:(NSDictionary *)dict {

    if (self = [super init]) {
        self.quesDetail = [NSString stringWithFormat:@"%@",dict[@"quesDetail"]];
        self.userPhoto = [NSString stringWithFormat:@"%@",dict[@"userPhoto"]];
        NSString *timeStr = [NSString stringWithFormat:@"%@",dict[@"logCtime"]];
        NSRange range = NSMakeRange(timeStr.length - 5, 5);
        self.logCtime = [timeStr stringByReplacingCharactersInRange:range withString:@""];
        self.advType = [NSString stringWithFormat:@"%@",dict[@"advType"]];
        self.userAccount = [NSString stringWithFormat:@"%@",dict[@"userAccount"]];
        self.userName = [NSString stringWithFormat:@"%@",dict[@"userName"]];
        self.ID = [NSString stringWithFormat:@"%@",dict[@"id"]];
        self.userId = [NSString stringWithFormat:@"%@",dict[@"userId"]];
    }
    return self;
}

@end
