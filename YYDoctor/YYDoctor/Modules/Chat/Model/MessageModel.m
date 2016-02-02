//
//  MessageModel.m
//  YYDoctor
//
//  Created by apple on 15/10/25.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

- (NSString *)messageId {
    return _message.messageId;
}

- (MessageDeliveryState)status {
    return _message.deliveryState;
}

@end
