//
//  LoginInfo.m
//  YYDoctor
//
//  Created by MaxJmac on 15/11/21.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "LoginInfo.h"

NSString *const kLoginInfoKey = @"LoginInfo";
NSString *const kAccessTokenKey = @"AccessToken";
NSString *const kExpiresKey = @"Expires";
NSString *const kUserIdKey = @"UserId";
NSString *const kAccountKey = @"Account";
NSString *const kDoctorInfoKey= @"DoctorInfo";
NSString *const kOnlineStateKey = @"OnlineState";

@implementation LoginInfo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.accessToken = [dictionary[@"accessToken"] description];
        self.expires = dictionary[@"expiresIn"];
        self.userId = dictionary[@"userId"];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.accessToken = [aDecoder decodeObjectForKey:kAccessTokenKey];
        self.expires = [aDecoder decodeObjectForKey:kExpiresKey];
        self.userId = [aDecoder decodeObjectForKey:kUserIdKey];
        self.account = [aDecoder decodeObjectForKey:kAccountKey];
        self.doctorInfo = [aDecoder decodeObjectForKey:kDoctorInfoKey];
        self.onlineState = [aDecoder decodeObjectForKey:kOnlineStateKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.accessToken forKey:kAccessTokenKey];
    [aCoder encodeObject:self.expires forKey:kExpiresKey];
    [aCoder encodeObject:self.userId forKey:kUserIdKey];
    [aCoder encodeObject:self.account forKey:kAccountKey];
    [aCoder encodeObject:self.doctorInfo forKey:kDoctorInfoKey];
    [aCoder encodeObject:self.onlineState forKey:kOnlineStateKey];
}

+ (instancetype)currentLoginInfo {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kLoginInfoKey];
    LoginInfo *info = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return info;
}

+ (void)saveLoginInfo:(LoginInfo *)loginInfo {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:loginInfo];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kLoginInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)deleteLoginInfo {
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kLoginInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
