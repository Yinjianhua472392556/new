//
//  YYConfig.m
//  YYDoctor
//
//  Created by apple on 15/10/27.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "YYConfig.h"

static NSDictionary *config;

@implementation YYConfig

+ (void)initialize {
    [self readFile];
}

+ (void)readFile {
    config = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Config" ofType:@"plist"]];
}

+ (NSString *)formalServerAddress {
    if (!config) {
        [self readFile];
    }
    NSString *address = [config objectForKey:@"LocalServer"];
    return address;
}

+ (NSString *)serverAddress {
    if (!config) {
        [self readFile];
    }
    NSString *address = [config objectForKey:@"serverAddress"];
    return address;
}

@end
