//
//  YYChatBarMoreView.m
//  YYDoctor
//
//  Created by apple on 15/10/24.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "YYChatBarMoreView.h"
#define CHAT_BUTTON_SIZE 55
#define INSETS 8

@interface YYChatBarMoreView ()

@property (nonatomic,strong) UILabel *photoLabel;
@property (nonatomic,strong) UILabel *audioLabel;
@property (nonatomic,strong) UILabel *videoLabel;
@property (nonatomic,strong) UILabel *xuanjiaoLabel;
@property (nonatomic,strong) UILabel *suifangLabel;
@property (nonatomic,strong) UILabel *chakanbingliLabel;

@end

@implementation YYChatBarMoreView

- (instancetype)initWithFrame:(CGRect)frame type:(ChatMoreType)type{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupSubviewsForType:type];
    }
    return self;
}

- (void)setupSubviewsForType:(ChatMoreType)type {
    self.backgroundColor = [UIColor clearColor];
    CGFloat insets = (self.frame.size.width - 4 * CHAT_BUTTON_SIZE) / 5;
    
    _photoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_photoButton setFrame:CGRectMake(insets, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_photoButton setImage:[UIImage imageNamed:@"chatBar_colorMore_photo"] forState:UIControlStateNormal];
    [_photoButton setImage:[UIImage imageNamed:@"chatBar_colorMore_photoSelected"] forState:UIControlStateHighlighted];
    [_photoButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_photoButton];
    //图片
    _photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(insets, CGRectGetMaxY(self.photoButton.frame), CHAT_BUTTON_SIZE, 30)];
    _photoLabel.textAlignment = NSTextAlignmentCenter;
    _photoLabel.font = [UIFont systemFontOfSize:13];
    _photoLabel.text = @"图片";
    [self addSubview:_photoLabel];
    
    _audioCallButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_audioCallButton setFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_audioCallButton setImage:[UIImage imageNamed:@"chatBar_colorMore_location"] forState:UIControlStateNormal];
    [_audioCallButton setImage:[UIImage imageNamed:@"chatBar_colorMore_locationSelected"] forState:UIControlStateHighlighted];
    [_audioCallButton addTarget:self action:@selector(audioCallAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_audioCallButton];
    //语音
    _audioLabel = [[UILabel alloc] initWithFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE, CGRectGetMaxY(self.audioCallButton.frame), CHAT_BUTTON_SIZE, 30)];
    _audioLabel.textAlignment = NSTextAlignmentCenter;
    _audioLabel.font = [UIFont systemFontOfSize:13];
    _audioLabel.text = @"语音";
    [self addSubview:_audioLabel];

    
    
    _videoCallButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_videoCallButton setFrame:CGRectMake(insets * 3 + CHAT_BUTTON_SIZE * 2, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
    [_videoCallButton setImage:[UIImage imageNamed:@"chatBar_colorMore_camera"] forState:UIControlStateNormal];
    [_videoCallButton setImage:[UIImage imageNamed:@"chatBar_colorMore_cameraSelected"] forState:UIControlStateHighlighted];
    [_videoCallButton addTarget:self action:@selector(videoCallAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_videoCallButton];
    //视频
    _videoLabel = [[UILabel alloc] initWithFrame:CGRectMake(insets * 3 + CHAT_BUTTON_SIZE * 2, CGRectGetMaxY(self.videoCallButton.frame), CHAT_BUTTON_SIZE, 30)];
    _videoLabel.textAlignment = NSTextAlignmentCenter;
    _videoLabel.font = [UIFont systemFontOfSize:13];
    _videoLabel.text = @"视频";
    [self addSubview:_videoLabel];

    
    
    CGRect frame = self.frame;
    if (type == ChatMoreTypeChat) {
        frame.size.height = 200; //moreView的高度
        _educationButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_educationButton setFrame:CGRectMake(insets * 4 + CHAT_BUTTON_SIZE * 3, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        [_educationButton setImage:[UIImage imageNamed:@"chatBar_colorMore_audioCall"] forState:UIControlStateNormal];
        [_educationButton setImage:[UIImage imageNamed:@"chatBar_colorMore_audioCallSelected"] forState:UIControlStateHighlighted];
        [_educationButton addTarget:self action:@selector(educationAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_educationButton];
        
        //宣教
        _xuanjiaoLabel = [[UILabel alloc] initWithFrame:CGRectMake(insets * 4 + CHAT_BUTTON_SIZE * 3, CGRectGetMaxY(self.audioCallButton.frame), CHAT_BUTTON_SIZE, 30)];
        _xuanjiaoLabel.textAlignment = NSTextAlignmentCenter;
        _xuanjiaoLabel.font = [UIFont systemFontOfSize:13];
        _xuanjiaoLabel.text = @"宣教";
        [self addSubview:_xuanjiaoLabel];

        
        _suifangButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_suifangButton setFrame:CGRectMake(insets, 10 * 2 + CHAT_BUTTON_SIZE + 40, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        [_suifangButton setImage:[UIImage imageNamed:@"chatBar_colorMore_videoCall"] forState:UIControlStateNormal];
        [_suifangButton setImage:[UIImage imageNamed:@"chatBar_colorMore_videoCallSelected"] forState:UIControlStateHighlighted];
        [_suifangButton addTarget:self action:@selector(suifangAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_suifangButton];
        
        //随访
        _suifangLabel = [[UILabel alloc] initWithFrame:CGRectMake(insets , CGRectGetMaxY(self.suifangButton.frame), CHAT_BUTTON_SIZE, 30)];
        _suifangLabel.textAlignment = NSTextAlignmentCenter;
        _suifangLabel.font = [UIFont systemFontOfSize:13];
        _suifangLabel.text = @"随访";
        [self addSubview:_suifangLabel];
        
        
        _chakanbingliButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chakanbingliButton setFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE, 10 * 2 + CHAT_BUTTON_SIZE + 40, CHAT_BUTTON_SIZE, CHAT_BUTTON_SIZE)];
        [_chakanbingliButton setImage:[UIImage imageNamed:@"chatBar_colorMore_bingli"] forState:UIControlStateNormal];
        [_chakanbingliButton setImage:[UIImage imageNamed:@"chatBar_colorMore_bingliSelected"] forState:UIControlStateHighlighted];
        [_chakanbingliButton addTarget:self action:@selector(chakanbingliAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_chakanbingliButton];
        
        //查看病历
        _chakanbingliLabel = [[UILabel alloc] initWithFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE, CGRectGetMaxY(self.chakanbingliButton.frame), CHAT_BUTTON_SIZE, 30)];
        _chakanbingliLabel.textAlignment = NSTextAlignmentCenter;
        _chakanbingliLabel.font = [UIFont systemFontOfSize:13];
        _chakanbingliLabel.text = @"查看病历";
        [self addSubview:_chakanbingliLabel];

    }
    else if (type == ChatMoreTypeGroupChat)
    {
        frame.size.height = 80;
    }
    self.frame = frame;
}


#pragma mark - action

- (void)photoAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]) {
        [_delegate moreViewPhotoAction:self];
    }
}

- (void)audioCallAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewAudioCallAction:)]) {
        [_delegate moreViewAudioCallAction:self];
    }
}

- (void)takeAudioCallAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewAudioCallAction:)]) {
        [_delegate moreViewAudioCallAction:self];
    }
}

- (void)videoCallAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewVideoCallAction:)]) {
        [_delegate moreViewVideoCallAction:self];
    }
}

- (void)educationAction {

    if (_delegate && [_delegate respondsToSelector:@selector(moreViewEducationAction:)]) {
        [_delegate moreViewEducationAction:self];
    }

}

- (void)suifangAction {

    if (_delegate && [_delegate respondsToSelector:@selector(moreViewSuifangAction:)]) {
        [_delegate moreViewSuifangAction:self];
    }
}

- (void)chakanbingliAction {

    if (_delegate && [_delegate respondsToSelector:@selector(moreViewChakanbingliAction:)]) {
        [_delegate moreViewChakanbingliAction:self];
    }
}
@end
