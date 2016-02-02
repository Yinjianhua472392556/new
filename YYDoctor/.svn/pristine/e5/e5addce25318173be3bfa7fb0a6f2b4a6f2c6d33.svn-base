//
//  YYAPIRequest.h
//  YYDoctor
//
//  Created by apple on 15/10/27.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYAPIRequest : NSObject

+ (void)GET:(NSString *)path
     params:(NSDictionary *)params
 completion:(void(^)(id response, NSError *error))completion;

+ (void)POST:(NSString *)path
      params:(NSDictionary *)params
  completion:(void(^)(id response, NSError *error))completion;

+ (void)PUT:(NSString *)path
     params:(NSDictionary *)params
 completion:(void(^)(NSDictionary *response, NSError *error))completion;

+ (void)DELETE:(NSString *)path
        params:(NSDictionary *)params
    completion:(void(^)(NSDictionary *response, NSError *error))completion;

@end
