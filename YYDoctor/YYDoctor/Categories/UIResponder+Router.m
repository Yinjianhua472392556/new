//
//  UIResponder+Router.m
//  YYDoctor
//
//  Created by apple on 15/10/25.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "UIResponder+Router.h"

@implementation UIResponder (Router)
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    
    [self.nextResponder routerEventWithName:eventName userInfo:userInfo];
}
@end
