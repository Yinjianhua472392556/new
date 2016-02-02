//
//  UIColor+HEX.m
//  YYDoctor
//
//  Created by MaxJmac on 15/10/14.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "UIColor+HEX.h"

@implementation UIColor (HEX)

+ (UIColor *)colorWithHEX:(NSInteger)hexValue alpha:(CGFloat)alphaValue {
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)((hexValue & 0xFF)))/255.0
                           alpha:alphaValue];
}

+ (UIColor *)colorWithHEX:(NSInteger)hexValue {
    return [self colorWithHEX:hexValue alpha:1.0f];
}

@end
