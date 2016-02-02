//
//  Account.m
//  YYDoctor
//
//  Created by apple on 15/10/28.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "Account.h"

@implementation Account

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:_access_token forKey:@"TOKEN"];
    [aCoder encodeObject:_expires_in forKey:@"ECPIRES"];
    [aCoder encodeInteger:_userId forKey:@"UID"];
    [aCoder encodeObject:_userAccount forKey:@"ACCOUNT"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self) {
        _access_token = [aDecoder decodeObjectForKey:@"TOKEN"];
        _expires_in = [aDecoder decodeObjectForKey:@"ECPIRES"];
        _userId = [aDecoder decodeIntegerForKey:@"UID"];
        _userAccount = [aDecoder decodeObjectForKey:@"ACCOUNT"];
    }
    return self;
}

//获取Account对象
+ (Account *)currentAccount {
    NSData *AccountData = [[NSUserDefaults standardUserDefaults]
                           objectForKey:@"account"];
    Account *account = (Account *)[NSKeyedUnarchiver unarchiveObjectWithData: AccountData];
    return account;
}
//保存Account对象
+ (void)saveCurrentAccount:(Account *)account {
    NSData *accountData = [NSKeyedArchiver archivedDataWithRootObject:account];
    [[NSUserDefaults standardUserDefaults] setObject:accountData forKey:@"account"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
//删除Account对象
+ (void)deleteCurrentAccount {
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"account"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}



@end
