//
//  SettingInfo.h
//  YYDoctor
//
//  Created by apple on 15/10/28.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//
/**
 *  @author 阮武文, 15-10-29 16:10:23
 *
 *个人中心设置Model
 *
 */
#import <Foundation/Foundation.h>

@interface SettingInfo : NSObject

@property (nonatomic, assign) NSInteger docId;//医生id
@property (nonatomic, copy) NSString *beginTime;//开始时间
@property (nonatomic, copy) NSString *endTime;//结束时间

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
