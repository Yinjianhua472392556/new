//
//  MessageModel.h
//  YYDoctor
//
//  Created by apple on 15/10/22.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//
/**
 *  @author 阮武文, 15-10-29 16:10:13
 *
 *消息中心全部记录Model  
 *
 */
#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic, assign) NSInteger messageId;//id
@property (nonatomic, assign) NSInteger docId;//医生id
@property (nonatomic, assign) NSInteger userId;//用户id
@property (nonatomic, assign) NSInteger shiftType;//班别类型
@property (nonatomic, assign) NSInteger state;//医生科室
@property (nonatomic, assign) NSInteger userSex;//性别
@property (nonatomic, copy) NSString *logCtime;//申请加号时间
@property (nonatomic, copy) NSString *userName;//申请人
@property (nonatomic, copy) NSString *time;//日期


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
