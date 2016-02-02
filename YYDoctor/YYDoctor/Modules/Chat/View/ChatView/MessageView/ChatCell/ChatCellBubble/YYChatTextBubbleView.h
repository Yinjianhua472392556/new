//
//  YYChatTextBubbleView.h
//  YYDoctor
//
//  Created by apple on 15/10/25.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "YYChatBaseBubbleView.h"

#define TEXTLABEL_MAX_WIDTH 200 // textLaebl 最大宽度
#define LABEL_FONT_SIZE 14      // 文字大小
#define LABEL_LINESPACE 0       // 行间距

extern NSString *const kRouterEventTextURLTapEventName;
extern NSString *const kRouterEventMenuTapEventName;

@interface YYChatTextBubbleView : YYChatBaseBubbleView {
    NSDataDetector *_detector;
    NSArray *_urlMatches;
}

@property (nonatomic, strong) UILabel *textLabel;

@end
