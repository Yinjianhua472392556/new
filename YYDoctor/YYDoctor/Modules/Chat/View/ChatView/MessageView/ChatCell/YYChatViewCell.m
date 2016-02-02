//
//  YYChatViewCell.m
//  YYDoctor
//
//  Created by apple on 15/10/26.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "YYChatViewCell.h"
#import "UIResponder+Router.h"


NSString *const kResendButtonTapEventName = @"kResendButtonTapEventName";
NSString *const kShouldResendCell = @"kShouldResendCell";


@implementation YYChatViewCell

- (id)initWithMessageModel:(MessageModel *)model reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithMessageModel:model reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.headImageView.clipsToBounds = YES;
        self.headImageView.layer.cornerRadius = 3.0;
    }
    return self;
}



//此方法在YYChatViewBaseCell（父类）的initWithMessageModel中调用
- (void)setupSubviewsForMessageModel:(MessageModel *)messageModel {
    [super setupSubviewsForMessageModel:messageModel];
    
    if (messageModel.isSender) {
        // 发送进度显示view
        _activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SEND_STATUS_SIZE, SEND_STATUS_SIZE)];
        [_activityView setHidden:YES];
        [self.contentView addSubview:_activityView];
        
        // 重发按钮
        _retryButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _retryButton.frame = CGRectMake(0, 0, SEND_STATUS_SIZE, SEND_STATUS_SIZE);
        [_retryButton addTarget:self action:@selector(retryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        //        [_retryButton setImage:[UIImage imageNamed:@"messageSendFail.png"] forState:UIControlStateNormal];
        [_retryButton setBackgroundImage:[UIImage imageNamed:@"messageSendFail.png"] forState:UIControlStateNormal];
        //[_retryButton setBackgroundColor:[UIColor redColor]];
        [_activityView addSubview:_retryButton];
        
        // 菊花
        _activtiy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activtiy.backgroundColor = [UIColor clearColor];
        [_activityView addSubview:_activtiy];
        
        //已读
        _hasRead = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SEND_STATUS_SIZE, SEND_STATUS_SIZE)];
        _hasRead.text = NSLocalizedString(@"hasRead", @"Read");
        _hasRead.textAlignment = NSTextAlignmentCenter;
        _hasRead.font = [UIFont systemFontOfSize:12];
        [_hasRead sizeToFit];
        [_activityView addSubview:_hasRead];
    }
    
    _bubbleView = [self bubbleViewForMessageModel:messageModel];
    [self.contentView addSubview:_bubbleView];
}


- (BOOL)canBecomeFirstResponder {
    return YES;
}


#pragma mark - public

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(MessageModel *)model {
    NSInteger bubbleHeight = [self bubbleViewHeightForMessageModel:model];
    NSInteger headHeight = HEAD_PADDING * 2 + HEAD_SIZE;
    if ((model.messageType != eMessageTypeChat) && !model.isSender) {
        headHeight += NAME_LABEL_HEIGHT;
    }
    return MAX(headHeight, bubbleHeight + NAME_LABEL_HEIGHT + NAME_LABEL_PADDING) + CELLPADDING;
}


+ (CGFloat)bubbleViewHeightForMessageModel:(MessageModel *)messageModel {
    switch (messageModel.type) {
        case eMessageBodyType_Text:
        {
            if ([messageModel.message.ext objectForKey:@"View_information"]) {
                if ([messageModel.message.ext objectForKey:@"URL"]) {
                    return [YYCharUrlTexBubbleView heightForBubbleWithObject:messageModel];
                }else {
                    return [YYChatTextBubbleView heightForBubbleWithObject:messageModel];
                }
            } else {
                return [YYChatTextBubbleView heightForBubbleWithObject:messageModel];
            }
        }
            break;
        case eMessageBodyType_Image:
        {
            return [YYChatImageBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        case eMessageBodyType_Voice:
        {
            return [YYChatAudioBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        case eMessageBodyType_Location:
        {
            return [YYChatLocationBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        case eMessageBodyType_Video:
        {
            return [YYChatVideoBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        default:
            break;
    }
    
    return HEAD_SIZE;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    CGRect bubbleFrame = _bubbleView.frame;
    bubbleFrame.origin.y = self.headImageView.frame.origin.y;
    
    if (self.messageModel.isSender) {
        bubbleFrame.origin.y = self.headImageView.frame.origin.y;
        // 菊花状态 （因不确定菊花具体位置，要在子类中实现位置的修改）
        _hasRead.hidden = YES;
        switch (self.messageModel.status) {
            case eMessageDeliveryState_Delivering:
            {
                [_activityView setHidden:NO];
                [_retryButton setHidden:YES];
                [_activtiy setHidden:NO];
                [_activtiy startAnimating];
            }
                break;
            case eMessageDeliveryState_Delivered:
            {
                [_activtiy stopAnimating];
                [_retryButton setHidden:YES];
                if (self.messageModel.message.isReadAcked)
                {
                    _activityView.hidden = NO;
                    _hasRead.hidden = NO;
                }
                else
                {
                    [_activityView setHidden:YES];
                }
            }
                break;
            case eMessageDeliveryState_Pending:
            case eMessageDeliveryState_Failure:
            {
                [_activityView setHidden:NO];
                [_activtiy stopAnimating];
                [_activtiy setHidden:YES];
                [_retryButton setHidden:NO];
            }
                break;
            default:
                break;
        }
        
        bubbleFrame.origin.x = self.headImageView.frame.origin.x - bubbleFrame.size.width - HEAD_PADDING;
        _bubbleView.frame = bubbleFrame;
        
        CGRect frame = self.activityView.frame;
        if (_hasRead.hidden){
            frame.size.width = SEND_STATUS_SIZE;
        }else {
            frame.size.width = _hasRead.frame.size.width;
        }
        frame.origin.x = bubbleFrame.origin.x - frame.size.width - ACTIVTIYVIEW_BUBBLE_PADDING;
        frame.origin.y = _bubbleView.center.y - frame.size.height / 2;
        self.activityView.frame = frame;
    }else {
        bubbleFrame.origin.x = HEAD_PADDING * 2 + HEAD_SIZE;
        if (self.messageModel.messageType != eMessageTypeChat) {
            bubbleFrame.origin.y = NAME_LABEL_HEIGHT + NAME_LABEL_PADDING;
        }
        _bubbleView.frame = bubbleFrame;
    }
}

- (void)setMessageModel:(MessageModel *)model {
    [super setMessageModel:model];
    
    if (model.messageType != eMessageTypeChat) {
        _nameLabel.text = model.nickName;
        _nameLabel.hidden = model.isSender;
    }
    _bubbleView.model = self.messageModel;
    [_bubbleView sizeToFit]; //Call this method when you want to resize the current view so that it uses the most appropriate amount of space. You should not override this method. If you want to change the default sizing information for your view, override the sizeThatFits: instead.
}

#pragma mark - action

// 重发按钮事件
-(void)retryButtonPressed:(UIButton *)sender {
    [self routerEventWithName:kResendButtonTapEventName
                     userInfo:@{kShouldResendCell:self}];
}



#pragma mark - 私有方法

- (YYChatBaseBubbleView *)bubbleViewForMessageModel:(MessageModel *)messageModel {
    switch (messageModel.type) {
        case eMessageBodyType_Text:
        {
            if ([messageModel.message.ext objectForKey:@"View_information"]) { //医生查看档案
                if ([messageModel.message.ext objectForKey:@"URL"]) {
                    return [[YYCharUrlTexBubbleView alloc] init];
                }else {
                    return [[YYChatTextBubbleView alloc] init];
                }
            } else {
                return [[YYChatTextBubbleView alloc] init];
            }
        }
            break;
        case eMessageBodyType_Image:
        {
            return [[YYChatImageBubbleView alloc] init];
        }
            break;
        case eMessageBodyType_Voice:
        {
            return [[YYChatAudioBubbleView alloc] init];
        }
            break;
        case eMessageBodyType_Location:
        {
            return [[YYChatLocationBubbleView alloc] init];
        }
            break;
        case eMessageBodyType_Video:
        {
            return [[YYChatVideoBubbleView alloc] init];
        }
            break;
        default:
            break;
    }
    
    return nil;
}


@end