//
//  AppDelegate.h
//  YYDoctor
//
//  Created by MaxJmac on 15/10/14.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,IChatManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSDate *lastPlaySoundDate; //记录提示的最后时间，用于间隔提示
@end

