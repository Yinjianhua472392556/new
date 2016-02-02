//
//  YYChatViewBaseCell.h
//  YYDoctor
//
//  Created by apple on 15/10/26.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"
#import "YYChatBaseBubbleView.h"
#import "UIResponder+Router.h"

#define HEAD_SIZE 40 // 头像大小
#define HEAD_PADDING 5 // 头像到cell的内间距和头像到bubble的间距
#define CELLPADDING 8 // Cell之间间距

#define NAME_LABEL_WIDTH 180 // nameLabel最大宽度
#define NAME_LABEL_HEIGHT 20 // nameLabel 高度
#define NAME_LABEL_PADDING 5 // nameLabel间距
#define NAME_LABEL_FONT_SIZE 14 // 字体

extern NSString *const kRouterEventChatHeadImageTapEventName;

@interface YYChatViewBaseCell : UITableViewCell {
    UIImageView *_headImageView; 
    UILabel *_nameLabel;
    YYChatBaseBubbleView *_bubbleView;
    CGFloat _nameLabelHeight;
    MessageModel *_messageModel;
}
@property (nonatomic, strong) MessageModel *messageModel;
@property (nonatomic, strong) UIImageView *headImageView;       //头像
@property (nonatomic, strong) UILabel *nameLabel;               //姓名（暂时不支持显示）
@property (nonatomic, strong) YYChatBaseBubbleView *bubbleView;   //内容区域

- (id)initWithMessageModel:(MessageModel *)model reuseIdentifier:(NSString *)reuseIdentifier;
- (void)setupSubviewsForMessageModel:(MessageModel *)model;
+ (NSString *)cellIdentifierForMessageModel:(MessageModel *)model;
+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(MessageModel *)model;

@end
