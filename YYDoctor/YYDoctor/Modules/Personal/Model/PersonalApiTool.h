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

@interface PersonalApiTool : NSObject

//授权登录
+ (void)loginWithDoctorName:(NSString *)doctorName
                   password:(NSString *)password
                    address:(NSString *)address
                    success:(successBlock)success
                    failure:(failureBlock)failure;
//获取医生个人信息
+ (void)getDoctorDataWithDoctorAccount:(NSString *)account
                               success:(successBlock)success
                               failure:(failureBlock)failure;
//修改用户密码
+ (void)motityPassword:(NSString *)oldPassword
           newPassword:(NSString *)newPassword
       confirmPassword:(NSString *)confirmPassword
                userId:(NSInteger)userId
               success:(successBlock)success
               failure:(failureBlock)failure;
//获取咨询账单
+ (void)getConsultationBillWithDocId:(NSInteger)docId
                             advType:(NSString *)type
                             success:(successBlock)success
                             failure:(failureBlock)failure;
//获取总咨询费用
+ (void)getTotalCostWithDocId:(NSInteger)docId
                      advType:(NSString *)type
                      success:(successBlock)success
                      failure:(failureBlock)failure;

//加号提示
+ (void)addTipsWithDoctorId:(NSInteger)doctorId
                            success:(successBlock)success
                            failure:(failureBlock)failure;
//加号记录
+ (void)plusRecordWithDoctorId:(NSInteger)doctorId
                            success:(successBlock)success
                            failure:(failureBlock)failure;
//挂号记录
+ (void)getRegistrationRecordWithDoctorId:(NSInteger)doctorId
                                  success:(successBlock)success
                                  failure:(failureBlock)failure;

@end
