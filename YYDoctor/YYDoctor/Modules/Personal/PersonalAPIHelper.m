//
//  PersonalAPIHelper.m
//  YYDoctor
//
//  Created by MaxJmac on 15/11/20.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "PersonalAPIHelper.h"
#import "YYAPIRequest.h"
#import "YYConfig.h"
#import <AFNetworking/AFNetworking.h>

static NSString *const kUrlJavaBridge = @"JavaBridgeTemplate621/api/app/";
static NSString *const kUrlCloudDoctor = @"CloudDoctor/ws/rest/";
static NSString *const kUrlJianKang = @"http://jiankang120.com.cn:8080/SMS/ws/rest/wjxjt/";

@implementation PersonalAPIHelper

+ (void)loginWithAccount:(NSString *)account
                password:(NSString *)password
              completion:(completion)completion {
    NSMutableString *path = [NSMutableString stringWithString:kUrlJavaBridge];
    [path appendString:@"oauth2/access_token"];
    NSDictionary *params = @{@"client_id":@"ios",
                             @"usertype":@2,
                             @"username":account,
                             @"password":password,
                             @"grant_type":@"password",
                             @"logAddress":@"广东省广州市"};
    [YYAPIRequest POST:path params:params completion:^(id response, NSError *error) {
        completion(response, error);
    }];
}

+ (void)logoutWithAccessToken:(NSString *)accessToken
                       userId:(NSNumber *)userId
                   completion:(completion)completion {
    NSMutableString *path = [NSMutableString stringWithString:kUrlJavaBridge];
    [path appendString:@"oauth2/revokeoauth"];
    NSDictionary *params = @{@"access_token":accessToken,@"userId":userId};
    [YYAPIRequest POST:path params:params completion:^(id response, NSError *error) {
        completion(response, error);
    }];
}

+ (void)requestDoctorInformation:(NSString *)doctorAccount
                      completion:(completion)completion {
    NSString *path = [NSString stringWithFormat:@"%@doctors/%@", kUrlJavaBridge, doctorAccount];
    [YYAPIRequest GET:path params:nil completion:^(id response, NSError *error) {
        completion(response, error);
    }];
}

+ (void)modifyPassword:(NSNumber *)userId
           oldPassword:(NSString *)oldPassword
           newPassword:(NSString *)newPassowrd
       confirmPassword:(NSString *)confirmPassword
            completion:(completion)completion {
    NSMutableString *path = [NSMutableString stringWithString:[YYConfig formalServerAddress]];
    [path appendString:kUrlJavaBridge];
    [path appendFormat:@"user/%@/pd",userId];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"oldPassword":oldPassword,
                             @"newPassword":newPassowrd,
                             @"confirmPassword":confirmPassword,
                             @"userId":userId};
    [manager PUT:path parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        //TODO:接口暂不可用
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

+ (void)requestConsultationBill:(NSNumber *)doctorId
                           type:(NSNumber *)type
                     completion:(completion)completion {
    NSString *path = [NSString stringWithFormat:@"%@advbill", kUrlCloudDoctor];
    NSDictionary *params = @{@"docId":doctorId,@"advType":type};
    if ([type isEqualToNumber:@0]) {
        params = @{@"docId":doctorId};
    }
    [YYAPIRequest GET:path params:params completion:^(id response, NSError *error) {
        completion(response, error);
    }];
}

+ (void)sendMessageVerificationCodeWithPhone:(NSString *)phone
                                  completion:(completion)completion {
    NSMutableString *path = [NSMutableString stringWithString:kUrlJianKang];
    [path appendFormat:@"genAuthInfo/%@",phone];
    NSDictionary *params = @{@"phoneNumber":phone};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id response) {
        completion(response,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil,error);
    }];
}

+ (void)verCodeVerificationWithPhone:(NSString *)phone
                             verCode:(NSString *)verCode
                          completion:(completion)completion {
    NSMutableString *path = [NSMutableString stringWithString:kUrlJianKang];
    [path appendFormat:@"checkCode?phoneNumber=%@&verCode=%@",phone,verCode];
    NSDictionary *params = @{@"phoneNumber":phone,@"verCode":verCode};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id response) {
        completion(response,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil,error);
    }];
}

+ (void)requestBillCost:(NSNumber *)doctorId
                   type:(NSNumber *)type
             completion:(completion)completion {
    NSString *path = [NSString stringWithFormat:@"%@advbill/totalCost",kUrlCloudDoctor];
    NSDictionary *params = @{@"docId":doctorId,@"advType":type};
    if ([type isEqualToNumber:@0]) {
        params = @{@"docId":doctorId};
    }
    [YYAPIRequest GET:path params:params completion:^(id response, NSError *error) {
        completion(response, error);
    }];
}

+ (void)requestPlusTips:(NSNumber *)doctorId
             completion:(completion)completion {
    NSString *path = [NSString stringWithFormat:@"%@seq/state/%@/0",kUrlCloudDoctor,doctorId];
    [YYAPIRequest GET:path params:nil completion:^(id response, NSError *error) {
        completion(response, error);
    }];
}

+ (void)requestPlusRecord:(NSNumber *)doctorId
               completion:(completion)completion {
    NSString *path = [NSString stringWithFormat:@"%@seq/getChecked/%@",kUrlCloudDoctor,doctorId];
    [YYAPIRequest GET:path params:nil completion:^(id response, NSError *error) {
        completion(response, error);
    }];
}

+ (void)requestBookingRecord:(NSNumber *)doctorId
                  completion:(completion)completion {
    NSString *path = [NSString stringWithFormat:@"%@reg/%@",kUrlCloudDoctor,doctorId];
    [YYAPIRequest GET:path params:nil completion:^(id response, NSError *error) {
        completion(response, error);
    }];
}

@end
