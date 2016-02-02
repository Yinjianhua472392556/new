//
//  SettingsTimeInfo.h
//  YYDoctor
//
//  Created by MaxJmac on 15/11/17.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsTimeInfo : NSObject

@property (nonatomic, strong) NSNumber *doctorId;
@property (nonatomic, copy) NSString *beginTime;
@property (nonatomic, copy) NSString *endTime;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
