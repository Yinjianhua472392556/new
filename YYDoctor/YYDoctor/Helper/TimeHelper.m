//
//  TimeHelper.m
//  YYDoctor
//
//  Created by apple on 15/12/16.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "TimeHelper.h"

@implementation TimeHelper
//时间转化时间戳
+ (NSString *)passTime:(NSString *)timeStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:timeStr];
    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[date timeIntervalSince1970]];
    return timeSp;
}

+ (NSComparisonResult)compareTime:(NSString *)timeA to:(NSString *)timeB {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:MM"];
    NSDate *dateA = [formatter dateFromString:timeA];
    NSDate *dateB = [formatter dateFromString:timeB];
    return [dateA compare:dateB];
}

@end
