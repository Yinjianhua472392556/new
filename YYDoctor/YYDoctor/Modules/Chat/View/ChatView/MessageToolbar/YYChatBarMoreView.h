//
//  YYChatBarMoreView.h
//  YYDoctor
//
//  Created by apple on 15/10/24.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    ChatMoreTypeChat,
    ChatMoreTypeGroupChat,
}ChatMoreType;

@protocol YYChatBarMoreViewDelegate;


@interface YYChatBarMoreView : UIView
@property (nonatomic,assign) id<YYChatBarMoreViewDelegate> delegate;

@property (nonatomic, strong) UIButton *photoButton;//图片按钮
//@property (nonatomic, strong) UIButton *takePicButton;
//@property (nonatomic, strong) UIButton *locationButton;
//@property (nonatomic, strong) UIButton *videoButton;
//@property (nonatomic, strong) UIButton *pictureButton;
@property (nonatomic, strong) UIButton *audioCallButton;  //语音按钮
@property (nonatomic, strong) UIButton *videoCallButton; //视频按钮
@property (nonatomic, strong) UIButton *educationButton; //宣教按钮
@property (nonatomic, strong) UIButton *suifangButton; //随访按钮
@property (nonatomic, strong) UIButton *chakanbingliButton; //查看病历按钮

- (instancetype)initWithFrame:(CGRect)frame type:(ChatMoreType)type;
- (void)setupSubviewsForType:(ChatMoreType)type;
@end


@protocol YYChatBarMoreViewDelegate <NSObject>

@required
//- (void)moreViewTakePicAction:(YYChatBarMoreView *)moreView;
- (void)moreViewPhotoAction:(YYChatBarMoreView *)moreView;
//- (void)moreViewLocationAction:(YYChatBarMoreView *)moreView;
- (void)moreViewAudioCallAction:(YYChatBarMoreView *)moreView;
- (void)moreViewVideoCallAction:(YYChatBarMoreView *)moreView;
- (void)moreViewEducationAction:(YYChatBarMoreView *)moreView;
- (void)moreViewSuifangAction:(YYChatBarMoreView *)moreView;
- (void)moreViewChakanbingliAction:(YYChatBarMoreView *)moreView;
@end
