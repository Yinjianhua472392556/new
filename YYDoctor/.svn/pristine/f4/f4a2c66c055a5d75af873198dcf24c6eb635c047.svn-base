//
//  PersonalApiTool.h
//  YYDoctor
//
//  Created by apple on 15/10/27.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^successBlock)(id result);
typedef void(^failureBlock) (NSError *error);
typedef void(^completionBlock)(id result, NSError *error);

@interface DoctorPersonalApiTool : NSObject

////加号提示
//+ (void)addTipsWithDoctorId:(NSInteger)doctorId
//                            success:(successBlock)success
//                            failure:(failureBlock)failure;
////加号记录
//+ (void)plusRecordWithDoctorId:(NSInteger)doctorId
//                            success:(successBlock)success
//                            failure:(failureBlock)failure;
////挂号记录
//+ (void)getRegistrationRecordWithDoctorId:(NSInteger)doctorId
//                                  success:(successBlock)success
//                                  failure:(failureBlock)failure;
//修改医生在线状态
+ (void)modifyDoctorStateWithDoctorId:(NSInteger)doctorId
                          onlineState:(NSNumber *)onlineState
                           completion:(completionBlock)completion;

//同意加号、拒绝加号
+ (void)agreeOrRefusePlusWithMessageId:(NSInteger)messageId
                                 state:(NSInteger)state
                            completion:(completionBlock)completion;


@end
