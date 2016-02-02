//
//  MessageModel.h
//  YYDoctor
//
//  Created by apple on 15/10/22.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageInfo : NSObject

@property (nonatomic, assign) NSInteger docId;//医生id
@property (nonatomic, assign) NSInteger userId;//用户id
@property (nonatomic, assign) NSInteger shiftType;//班别（1.上午2.下午）
@property (nonatomic, assign) NSInteger state;//加号状态（0表示用户申请没处理)
@property (nonatomic, copy) NSString *userName;//申请人
@property (nonatomic, copy) NSString *time;//日期
@property (nonatomic, copy) NSString *logCtime;//申请加号时间
@property (nonatomic, assign) NSInteger userSex;//性别

@property (nonatomic, assign) NSInteger patSex;//病人性别
@property (nonatomic, assign) NSInteger schRegfee;//挂号费用
@property (nonatomic, assign) NSInteger regstatus;//就诊状态（1已预约待支付，2已付费待就诊，3已就诊待评价，4已评价，5已取号,8待退费，9已取消）
@property (nonatomic, assign) NSInteger messageId;//主键Id
@property (nonatomic, copy) NSString *patName;//病人姓名
@property (nonatomic, copy) NSString *seqBeginTime;//就诊开始时间
@property (nonatomic, copy) NSString *seqEndTime;//就诊结束时间
@property (nonatomic, copy) NSString *patId;//病人id
@property (nonatomic, copy) NSString *schDate;//就诊日期
@property (nonatomic, assign) NSInteger type;//区分类型变量

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;



@end
