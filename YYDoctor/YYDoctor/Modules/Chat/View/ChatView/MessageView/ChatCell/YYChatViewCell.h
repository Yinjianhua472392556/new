//
//  YYChatViewCell.h
//  YYDoctor
//
//  Created by apple on 15/10/26.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "YYChatViewBaseCell.h"
#import "YYChatTextBubbleView.h"
#import "YYChatImageBubbleView.h"
#import "YYChatAudioBubbleView.h"
#import "YYChatVideoBubbleView.h"
#import "YYChatLocationBubbleView.h"
#import "YYCharUrlTexBubbleView.h"

#define SEND_STATUS_SIZE 20 // 发送状态View的Size
#define ACTIVTIYVIEW_BUBBLE_PADDING 5 // 菊花和bubbleView之间的间距

extern NSString *const kResendButtonTapEventName;
extern NSString *const kShouldResendCell;

@interface YYChatViewCell : YYChatViewBaseCell

//sender
@property (nonatomic, strong) UIActivityIndicatorView *activtiy;
@property (nonatomic, strong) UIView *activityView;
@property (nonatomic, strong) UIButton *retryButton;
@property (nonatomic, strong) UILabel *hasRead;

@end
