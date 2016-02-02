//
//  ChatPopView.m
//  YYDoctor
//
//  Created by QiuQuan Wu on 15/11/4.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "ChatPopView.h"

@implementation ChatPopView

+ (instancetype)instanceWithXib {
    return [[[NSBundle mainBundle] loadNibNamed:@"ChatPopView" owner:self options:nil] lastObject];
}

- (IBAction)popViewClick:(UIButton *)sender {
    if (self.popBlock) {
        self.popBlock(sender.tag);
    }
     NSLog(@"点击了按钮");
}

- (void)addActionBlock:(PopViewBlock)popBlock {
    self.popBlock = popBlock;
}


@end
