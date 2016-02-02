//
//  AppDelegate.m
//  YYDoctor
//
//  Created by MaxJmac on 15/10/14.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+EaseMob.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - 

//自定义UI样式
- (void)setupCustomStyle {
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHEX:0x25BFB2]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    NSDictionary *navbarTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - Lifetime

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //自定义UI样式
    [self setupCustomStyle];
    
    //初始化环信SDK，详细内容在AppDelegate+EaseMob.m文件中
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

@end
