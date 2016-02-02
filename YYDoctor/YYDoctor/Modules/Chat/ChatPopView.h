//
//  ChatPopView.h
//  YYDoctor
//
//  Created by QiuQuan Wu on 15/11/4.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PopViewBlock)(NSInteger tag);

@interface ChatPopView : UIView

@property (copy, nonatomic) PopViewBlock popBlock;

+ (instancetype)instanceWithXib;

- (void)addActionBlock:(PopViewBlock)popBlock;


@end
