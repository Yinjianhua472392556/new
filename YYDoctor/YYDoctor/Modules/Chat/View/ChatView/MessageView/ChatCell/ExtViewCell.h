//
//  ExtViewCell.h
//  YYDoctor
//
//  Created by apple on 15/11/17.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExtViewCell : UITableViewCell
@property (nonatomic, strong) NSString *extText;
+ (CGFloat)extCellHeightWithStr:(NSString *)extText;
@end
