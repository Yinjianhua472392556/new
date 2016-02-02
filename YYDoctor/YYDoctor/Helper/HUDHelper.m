//
//  HUDHelper.m
//  YYDoctor
//
//  Created by MaxJmac on 15/10/16.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "HUDHelper.h"
#import <MBProgressHUD.h>

@implementation HUDHelper

+ (void)showHUD:(NSString *)text toView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
}

+ (void)hideHUD:(UIView *)view {
    [MBProgressHUD hideHUDForView:view animated:YES];
}

+ (void)show:(NSString *)icon text:(NSString *)text toView:(UIView *)view {
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    if (icon == nil) {
        hud.mode = MBProgressHUDModeText;
    }else {
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    }
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.0];
}

+ (void)showMessage:(NSString *)text toView:(UIView *)view {
    [self show:nil text:text toView:view];
}

+ (void)showMessage:(NSString *)text {
    [self showMessage:text toView:nil];
}


+ (void)showSuccess:(NSString *)text toView:(UIView *)view {
    [self show:@"HUDSuccess" text:text toView:view];
}

+ (void)showSuccess:(NSString *)text {
    [self showSuccess:text toView:nil];
}


+ (void)showError:(NSString *)text toView:(UIView *)view {
    [self show:@"HUDError" text:text toView:view];
}

+ (void)showError:(NSString *)text {
    [self showError:text toView:nil];
}

@end
