//
//  ChatController.h
//  YYDoctor
//
//  Created by MaxJmac on 15/10/15.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMChatManagerDefs.h"
#import "ChatListModel.h"

@protocol ChatViewControllerDelegate <NSObject>

- (NSString *)avatarWithChatter:(NSString *)chatter;
- (NSString *)nickNameWithChatter:(NSString *)chatter;

@end

@interface ChatController : UIViewController
@property (strong, nonatomic, readonly) NSString *chatter;
@property (strong, nonatomic) NSMutableArray *dataSource;//tableView数据源
@property (nonatomic) BOOL isInvisible;
@property (nonatomic, strong) ChatListModel *listModel; //自己添加的属性，用于分组

@property (strong, nonatomic) EMConversation *conversation;//会话管理者
@property (nonatomic, assign) id <ChatViewControllerDelegate> delelgate;

- (instancetype)initWithChatter:(NSString *)chatter isGroup:(BOOL)isGroup; //初始化聊天界面
- (instancetype)initWithChatter:(NSString *)chatter conversationType:(EMConversationType)type;

- (void)reloadData;
- (void)hideImagePicker;

@end
