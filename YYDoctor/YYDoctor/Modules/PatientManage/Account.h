//
//  Account.h
//  YYDoctor
//
//  Created by apple on 15/10/28.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject

@property (nonatomic, assign) NSInteger userId;//用户ID
@property (nonatomic, copy) NSString *access_token;//登录成功返回的访问令牌
@property (nonatomic, copy) NSString *userAccount;//用户账号
@property (nonatomic, copy) NSString *expires_in; //超时时间

//获取Account对象
+ (Account *)currentAccount;
//保存Account对象
+ (void)saveCurrentAccount:(Account *)account;
//删除Account对象
+ (void)deleteCurrentAccount;

@end
