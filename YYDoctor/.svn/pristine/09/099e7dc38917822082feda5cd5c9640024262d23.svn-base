//
//  YYAlertView.h
//  YYDoctor
//
//  Created by apple on 15/10/26.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YYAlertView : UIAlertView
/**
 *  @author 尹建华, 15-10-26 15:10:14
 *
 *  自定义 alertView
 *
 *  @param title             提示标题
 *  @param message           提示语句
 *  @param block             点击按钮后的回调
 *  @param cancelButtonTitle 按钮文字
 *  @param otherButtonTitles 按钮文字
 *
 *  @return id
 */
+ (id)showAlertWithTitle:(NSString *)title
                 message:(NSString *)message
         completionBlock:(void (^)(NSUInteger buttonIndex, YYAlertView *alertView))block
       cancelButtonTitle:(NSString *)cancelButtonTitle
       otherButtonTitles:(NSString *)otherButtonTitles, ...;

@end
