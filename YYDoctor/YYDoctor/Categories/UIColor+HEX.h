//
//  UIColor+HEX.h
//  YYDoctor
//
//  Created by MaxJmac on 15/10/14.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HEX)

/**
 *  @author 叶辉翔, 15-10-14 15:10:45
 *
 *  十六进制描述颜色
 *
 *  @param hexValue   十六进制颜色值  0xFFFFFF
 *  @param alphaValue 透明度  (0.0f-1.0f)
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHEX:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (UIColor *)colorWithHEX:(NSInteger)hexValue;

@end
