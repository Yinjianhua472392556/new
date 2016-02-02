//
//  LoginInfo.h
//  YYDoctor
//
//  Created by MaxJmac on 15/11/21.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DoctorInfo.h"

@interface LoginInfo : NSObject <NSCoding>

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, strong) NSNumber *expires;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, strong) DoctorInfo *doctorInfo;
@property (nonatomic, strong) NSNumber *onlineState; /**< 在线状态，1在线 0隐身 */

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

+ (instancetype)currentLoginInfo;
+ (void)saveLoginInfo:(LoginInfo *)info;
+ (void)deleteLoginInfo;

@end
