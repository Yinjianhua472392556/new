//
//  YYChatVideoBubbleView.m
//  YYDoctor
//
//  Created by apple on 15/10/25.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "YYChatVideoBubbleView.h"

NSString *const kRouterEventChatCellVideoTapEventName = @"kRouterEventChatCellVideoTapEventName";
@interface YYChatVideoBubbleView ()
@property (strong, nonatomic)UIButton *videoPlayButton;

@end

@implementation YYChatVideoBubbleView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.videoPlayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *backgroundImage = [UIImage imageNamed:@"chat_video_play.png"];
        [self.videoPlayButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        [self.videoPlayButton addTarget:self action:@selector(playVideoAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.videoPlayButton];
    }
    return self;
}

- (void)playVideoAction:(id)sender{
    [self routerEventWithName:kRouterEventChatCellVideoTapEventName userInfo:@{KMESSAGEKEY:self.model}];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = 50.0f;
    CGFloat height = 50.0f;
    CGFloat x = self.frame.size.width/2 - width/2;
    CGFloat y = self.frame.size.height/2 - height/2;
    [self.videoPlayButton setFrame:CGRectMake(x, y, width, height)];
}


@end
