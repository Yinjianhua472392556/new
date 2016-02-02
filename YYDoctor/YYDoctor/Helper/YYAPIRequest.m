//
//  YYAPIRequest.m
//  YYDoctor
//
//  Created by apple on 15/10/27.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "YYAPIRequest.h"
#import "YYConfig.h"
#import "AFNetworking.h"

@implementation YYAPIRequest

+ (void)GET:(NSString *)path
     params:(NSDictionary *)params
 completion:(void(^)(id response, NSError *error))completion {
    NSMutableString *requestPath = [NSMutableString stringWithString:[YYConfig formalServerAddress]];
    [requestPath appendString:path];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    [manager GET:requestPath parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *result = responseObject[@"Result"];
        if (!result) {
            result = responseObject;
        }
        NSInteger code = [result[@"code"] integerValue];
        id data = result[@"data"];
        if (code == 1 && ![data isEqual:[NSNull null]]) {
            completion(data, nil);
        }else {
            NSError *error = [NSError errorWithDomain:@"YYAPIRequestError" code:code userInfo:@{@"description":result[@"desc"]}];
            completion(nil, error);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

+ (void)POST:(NSString *)path
      params:(NSDictionary *)params
  completion:(void(^)(id response, NSError *error))completion {
    NSMutableString *requestPath = [NSMutableString stringWithString:[YYConfig formalServerAddress]];
    [requestPath appendString:path];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    [manager POST:requestPath parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        completion(responseObject, nil);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

+ (void)PUT:(NSString *)path
     params:(NSDictionary *)params
 completion:(void(^)(NSDictionary *response, NSError *error))completion {
    NSMutableString *requestPath = [NSMutableString stringWithString:[YYConfig formalServerAddress]];
    [requestPath appendString:path];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    [manager PUT:requestPath parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *result = responseObject[@"Result"];
        if (!result) {
            result = responseObject;
        }
        NSInteger code = [result[@"code"] integerValue];
        if (code == 1) {
            completion(result, nil);
        }else {
            NSError *error = [NSError errorWithDomain:@"YYAPIRequestError" code:code userInfo:@{@"Description":result[@"desc"]}];
            completion(nil, error);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

+ (void)DELETE:(NSString *)path
        params:(NSDictionary *)params
    completion:(void (^)(NSDictionary *, NSError *))completion {
    NSMutableString *requestPath = [NSMutableString stringWithString:[YYConfig formalServerAddress]];
    [requestPath appendString:path];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer.timeoutInterval = 10.0;
    [manager DELETE:requestPath parameters:params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSDictionary *result = responseObject[@"Result"];
        if (!result) {
            result = responseObject;
        }
        NSInteger code = [result[@"code"] integerValue];
        if (code == 1) {
            completion(result, nil);
        }else {
            NSError *error = [NSError errorWithDomain:@"YYAPIRequestError" code:code userInfo:@{@"Description":result[@"desc"]}];
            completion(nil, error);
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        completion(nil, error);
    }];

}

@end
