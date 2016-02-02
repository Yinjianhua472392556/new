//
//  YYChatBaseBubbleView.h
//  YYDoctor
//
//  Created by apple on 15/10/25.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
#import "YYProgressView.h"
#import "UIResponder+Router.h"

extern NSString *const kRouterEventChatCellBubbleTapEventName;
#define BUBBLE_LEFT_IMAGE_NAME @"chat_receiver_bg" // bubbleView 的背景图片
#define BUBBLE_RIGHT_IMAGE_NAME @"chat_sender_bg"
#define BUBBLE_ARROW_WIDTH 5 // bubbleView中，箭头的宽度
#define BUBBLE_VIEW_PADDING 8 // bubbleView 与 在其中的控件内边距

#define BUBBLE_RIGHT_LEFT_CAP_WIDTH 5 // 文字在右侧时,bubble用于拉伸点的X坐标
#define BUBBLE_RIGHT_TOP_CAP_HEIGHT 35 // 文字在右侧时,bubble用于拉伸点的Y坐标

#define BUBBLE_LEFT_LEFT_CAP_WIDTH 35 // 文字在左侧时,bubble用于拉伸点的X坐标
#define BUBBLE_LEFT_TOP_CAP_HEIGHT 35 // 文字在左侧时,bubble用于拉伸点的Y坐标
#define BUBBLE_PROGRESSVIEW_HEIGHT 10 // progressView 高度

#define KMESSAGEKEY @"message"

@interface YYChatBaseBubbleView : UIView {
    YYProgressView *_progressView;
    MessageModel *_model;
}

@property (nonatomic, strong) MessageModel *model;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) YYProgressView *progressView;

- (void)bubbleViewPressed:(id)sender;
+ (CGFloat)heightForBubbleWithObject:(MessageModel *)object;
@end
