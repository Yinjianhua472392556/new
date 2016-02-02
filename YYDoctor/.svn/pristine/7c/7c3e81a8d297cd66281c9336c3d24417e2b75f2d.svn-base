//
//  EncryptHelper.m
//  YYDoctor
//
//  Created by MaxJmac on 15/11/20.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "EncryptHelper.h"
#import <CommonCrypto/CommonDigest.h>

@implementation EncryptHelper

+ (NSString *)md5:(NSString *)text {
    const char *original_str = [text UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, (CC_LONG)strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

@end
