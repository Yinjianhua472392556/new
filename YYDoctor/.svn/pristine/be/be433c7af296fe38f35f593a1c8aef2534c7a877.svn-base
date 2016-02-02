//
//  YYCharUrlTexBubbleView.m
//  YYDoctor
//
//  Created by apple on 15/12/1.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "YYCharUrlTexBubbleView.h"
#import "UIResponder+Router.h"
NSString *const kRouterEventJumpButtonEventName = @"kRouterEventJumpButtonEventName";

@interface YYCharUrlTexBubbleView()
@property (nonatomic,strong) UIButton *jumpButton; //用于跳转URL的按钮
@end

@implementation YYCharUrlTexBubbleView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.numberOfLines = 0;
        _textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        _textLabel.font = [UIFont systemFontOfSize:LABEL_FONT_SIZE];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.userInteractionEnabled = NO;
        _textLabel.multipleTouchEnabled = NO;
        [self addSubview:_textLabel];
        
        _jumpButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _jumpButton.backgroundColor = [UIColor clearColor];
        [_jumpButton addTarget:self action:@selector(jumpButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_jumpButton];
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.bounds;
    frame.size.width -= BUBBLE_ARROW_WIDTH;
    frame = CGRectInset(frame, BUBBLE_VIEW_PADDING, BUBBLE_VIEW_PADDING);
    if (self.model.isSender) {
        frame.origin.x = BUBBLE_VIEW_PADDING;
    }else{
        frame.origin.x = BUBBLE_VIEW_PADDING + BUBBLE_ARROW_WIDTH;
    }
    
    frame.origin.y = BUBBLE_VIEW_PADDING;
    [self.textLabel setFrame:frame];
    [self.jumpButton setFrame:self.bounds];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    CGSize textBlockMinSize = {TEXTLABEL_MAX_WIDTH, CGFLOAT_MAX};
    CGSize retSize;
    NSString *content;
    
    if ([[self.model.message.ext objectForKey:@"URL"] isEqualToString:@""]) { //通过判断@"URL"的值来判断是拒绝还是同意
        content = [NSString stringWithFormat:@"%@拒绝了您查阅健康档案的申请",self.model.chatterName];
    }else{
        content = [NSString stringWithFormat:@"%@已通过您查阅健康档案的申请。授权的健康档案有效期至本次咨询结束。 可点击查阅%@的健康档案",self.model.chatterName,self.model.chatterName];
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:[[self class] lineSpacing]];//调整行间距
        
        retSize = [content boundingRectWithSize:textBlockMinSize options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:@{
                                                  NSFontAttributeName:[[self class] textLabelFont],
                                                  NSParagraphStyleAttributeName:paragraphStyle
                                                  }
                                        context:nil].size;
    }else{
        retSize = [content sizeWithFont:[[self class] textLabelFont] constrainedToSize:textBlockMinSize lineBreakMode:[[self class] textLabelLineBreakModel]];
    }
    
    CGFloat height = 40;
    if (2*BUBBLE_VIEW_PADDING + retSize.height > height) {
        height = 2*BUBBLE_VIEW_PADDING + retSize.height;
    }
    
    return CGSizeMake(retSize.width + BUBBLE_VIEW_PADDING*2 + BUBBLE_VIEW_PADDING, height);
}


- (void)setModel:(MessageModel *)model
{
    [super setModel:model];
    NSString *content;
    if ([[self.model.message.ext objectForKey:@"URL"] isEqualToString:@""]) { //通过判断@"URL"的值来判断是拒绝还是同意
        content = [NSString stringWithFormat:@"%@拒绝了您查阅健康档案的申请",self.model.chatterName];
    }else{
        content = [NSString stringWithFormat:@"%@已通过您查阅健康档案的申请。授权的健康档案有效期至本次咨询结束。 可点击查阅%@的健康档案",self.model.chatterName,self.model.chatterName];
    }
    
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]
                                                    initWithString:content];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:[[self class] lineSpacing]];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, [content length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [content length])];
    if ([[self.model.message.ext objectForKey:@"URL"] isEqualToString:@""]) {
        
    }else {
        [attributedString addAttribute:NSUnderlineStyleAttributeName value:@(1) range:NSMakeRange(0, [content length])];
    }
    
    [_textLabel setAttributedText:attributedString];
}



+(CGFloat)heightForBubbleWithObject:(MessageModel *)object
{
    CGSize textBlockMinSize = {TEXTLABEL_MAX_WIDTH, CGFLOAT_MAX};
    CGSize size;
    static float systemVersion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    });
    NSString *content;
    if ([[object.message.ext objectForKey:@"URL"] isEqualToString:@""]) {
        content = [NSString stringWithFormat:@"%@拒绝了您查阅健康档案的申请",object.chatterName];
    }else{
        
        content = [NSString stringWithFormat:@"%@已通过您查阅健康档案的申请。授权的健康档案有效期至本次咨询结束。 可点击查阅%@的健康档案",object.chatterName,object.chatterName];
    }
    if (systemVersion >= 7.0) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:[[self class] lineSpacing]];//调整行间距
        size = [content boundingRectWithSize:textBlockMinSize options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{
                                               NSFontAttributeName:[[self class] textLabelFont],
                                               NSParagraphStyleAttributeName:paragraphStyle
                                               }
                                     context:nil].size;
    }else{
        size = [content sizeWithFont:[self textLabelFont]
                   constrainedToSize:textBlockMinSize
                       lineBreakMode:[self textLabelLineBreakModel]];
    }
    return 2 * BUBBLE_VIEW_PADDING + size.height;
}


#pragma mark - UIButtonAction

- (void)jumpButtonAction {
    
    if ([[self.model.message.ext objectForKey:@"URL"] isEqualToString:@""]) {
        
    }else {
        [self routerEventWithName:kRouterEventJumpButtonEventName userInfo:@{KMESSAGEKEY:self.model}];
    }
}



+(UIFont *)textLabelFont
{
    return [UIFont systemFontOfSize:LABEL_FONT_SIZE];
}

+(CGFloat)lineSpacing{
    return LABEL_LINESPACE;
}

+(NSLineBreakMode)textLabelLineBreakModel
{
    return NSLineBreakByCharWrapping;
}
@end
