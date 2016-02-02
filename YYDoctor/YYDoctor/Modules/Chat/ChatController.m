//
//  ChatController.m
//  YYDoctor
//
//  Created by MaxJmac on 15/10/15.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "ChatController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>



//#import "SRRefreshView.h"
#import "YYAlertView.h"
#import "YYChatBarMoreView.h"
#import "YYRecordView.h"
#import "YYFaceView.h"
#import "YYChatViewCell.h"
#import "YYChatTimeCell.h"
#import "ChatSendHelper.h"
#import "MessageReadManager.h"
#import "MessageModelManager.h"
#import "ChatPopView.h"
//#import "LocationViewController.h"
//#import "ChatGroupDetailViewController.h"
#import "UIViewController+HUD.h"
#import "NSDate+Category.h"
#import "YYMessageToolBar.h"
#import "YYChatBarMoreView.h"
#import "ChatController+Category.h"
//#import "ChatroomDetailViewController.h"
#import "EMCDDeviceManager.h"
#import "EMCDDeviceManagerDelegate.h"
//#import "UserProfileViewController.h"
//#import "UserProfileManager.h"
#import "CallViewController.h"
#import "ExtViewCell.h"
#import "ChooseSectionController.h"
#import "HealthPermissionController.h"

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define KPageCount 20 //每次加载的消息条数
#define KHintAdjustY 50


@interface ChatController ()
<UITableViewDataSource,UITableViewDelegate,
UINavigationControllerDelegate, UIImagePickerControllerDelegate,
IChatManagerDelegate, EMCDDeviceManagerDelegate,EMCallManagerDelegate,
YYChatBarMoreViewDelegate, YYMessageToolBarDelegate> {
    UIMenuController *_menuController;
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    NSIndexPath *_longPressIndexPath;
    NSInteger _recordingCount;
    dispatch_queue_t _messageQueue;
    NSMutableArray *_messages;
    BOOL _isScrollToBottom;
}

@property (nonatomic) BOOL isChatGroup;
@property (nonatomic) EMConversationType conversationType;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) YYMessageToolBar *chatToolBar;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) MessageReadManager *messageReadManager;//message阅读的管理者
@property (strong, nonatomic) NSDate *chatTagDate;
@property (strong, nonatomic) NSMutableArray *messages;
@property (nonatomic) BOOL isScrollToBottom;
@property (nonatomic) BOOL isPlayingAudio;
@property (nonatomic) BOOL isKicked;

//聊天设置
@property (nonatomic, strong) UIView *dimView;
@property (nonatomic, strong) ChatPopView *popView;

//提示框
//@property (nonatomic, strong) UIAlertView *senderAlert;


@end

@implementation ChatController

- (instancetype)initWithChatter:(NSString *)chatter isGroup:(BOOL)isGroup
{
    EMConversationType type = isGroup ? eConversationTypeGroupChat : eConversationTypeChat;
    self = [self initWithChatter:chatter conversationType:type];
    if (self) {
        
    }
    
    return self;
}


- (instancetype)initWithChatter:(NSString *)chatter conversationType:(EMConversationType)type
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _isPlayingAudio = NO;
        _chatter = chatter;
        _conversationType = type;
        _messages = [NSMutableArray array];
        //根据接收者的username获取当前会话的管理者
        _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:chatter
                                                                    conversationType:type];
        [_conversation markAllMessagesAsRead:YES];
    }
    
    return self;
}

- (BOOL)isChatGroup {
    return _conversationType != eConversationTypeChat;
}

#pragma mark - Lifetime

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.listModel.userName) {
        self.title = self.listModel.userName; //抬头标题
    }else {
    
    }
    
    [self registerBecomeActive]; //分类
    self.view.backgroundColor = RGBACOLOR(248, 248, 248, 1);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    
    [self registerNotifications]; //注册所有的通知

    _messageQueue = dispatch_queue_create("easemob.com", NULL);
    _isScrollToBottom = YES;

    [self setupBarButtonItem];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.chatToolBar];
    
    //将self注册为chatToolBar的moreView的代理
    if ([self.chatToolBar.moreView isKindOfClass:[YYChatBarMoreView class]]) {
        [(YYChatBarMoreView *)self.chatToolBar.moreView setDelegate:self];
    }

    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden)];
    [self.view addGestureRecognizer:tap];

    //通过会话管理者获取已收发消息
    long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000 + 1;
    [self loadMoreMessagesFrom:timestamp count:KPageCount append:NO];
    
    //创建右上角弹窗popview和灰色蒙板view
    [self.view addSubview:self.dimView];
    self.popView = [ChatPopView instanceWithXib];
    self.popView.frame = CGRectMake(HYScreenW-120-10, 0, 120, 125);
    
    __weak typeof(self) weakself = self;
    [self.popView addActionBlock:^(NSInteger tag) {
//        NSLog(@"点击了%ld",(long)tag);
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Patient" bundle:nil];
        
        ChooseSectionController *chooseSectionVC = [storyBoard instantiateViewControllerWithIdentifier:NSStringFromClass([ChooseSectionController class])];
        chooseSectionVC.tag = 1;
        chooseSectionVC.chatModel = weakself.listModel;
        [weakself.navigationController pushViewController:chooseSectionVC animated:YES];
    }];
    
    [self.view addSubview:self.popView];
    self.popView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isShowPicker"];
    if (_isScrollToBottom) {
        [self scrollViewToBottom:NO];
    }else {
        _isScrollToBottom = YES;
    }
    self.isInvisible = NO;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // 设置当前conversation的所有message为已读
    [_conversation markAllMessagesAsRead:YES];
    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
    self.isInvisible = YES;
}



- (void)dealloc {
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _tableView = nil;
    
    _chatToolBar.delegate = nil;
    _chatToolBar = nil;
    
    [[EMCDDeviceManager sharedInstance] stopPlaying];
    [self unregisterNotifications]; //remove代理
    
    if (_imagePicker){
        [_imagePicker dismissViewControllerAnimated:NO completion:nil];
    }
}


- (void)scrollViewToBottom:(BOOL)animated {
    if (self.tableView.contentSize.height > self.tableView.frame.size.height) {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:animated];
    }
}



- (void)setupBarButtonItem {
    
    if (self.isChatGroup) {

    }else {
        UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        [clearButton setImage:[UIImage imageNamed:@"tool_msg"] forState:UIControlStateNormal];
        [clearButton addTarget:self action:@selector(chatSetting) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
    }
}

//聊天--设置
- (void)chatSetting {
    
    self.dimView.hidden = !self.dimView.hidden;
    self.popView.hidden = !self.popView.hidden;
}

- (void)dimViewTap {
    
    self.dimView.hidden = !self.dimView.hidden;
    self.popView.hidden = !self.popView.hidden;
    
}

//删除聊天信息
- (void)removeAllMessages:(id)sender {
    if (_dataSource.count == 0) {
        [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        return;
    }
    
    if ([sender isKindOfClass:[NSNotification class]]) {
        NSString *groupId = (NSString *)[(NSNotification *)sender object];
        if (self.isChatGroup && [groupId isEqualToString:_conversation.chatter]) {
            [_conversation removeAllMessages];
            [_messages removeAllObjects];
            _chatTagDate = nil;
            [_dataSource removeAllObjects];
            [_tableView reloadData];
            [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        }
    }
    else{
        __weak typeof(self) weakSelf = self;
        
        [YYAlertView showAlertWithTitle:@"提示"
                                message:@"请确定删除"
                        completionBlock:^(NSUInteger buttonIndex, YYAlertView *alertView) {
                            if (buttonIndex == 1) {
                                [weakSelf.conversation removeAllMessages];
                                [weakSelf.messages removeAllObjects];
                                weakSelf.chatTagDate = nil;
                                [weakSelf.dataSource removeAllObjects];
                                [weakSelf.tableView reloadData];
                            }
                        } cancelButtonTitle:@"取消"
                      otherButtonTitles:@"确定", nil];
    }
}

#pragma mark - GestureRecognizer

-(void)keyBoardHidden {
    [self.chatToolBar endEditing:YES];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan && [self.dataSource count] > 0) {
        CGPoint location = [recognizer locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:location];
        id object = [self.dataSource objectAtIndex:indexPath.row];
        if ([object isKindOfClass:[MessageModel class]]) {
            MessageModel *model = object;
            if (model.message.ext) { //扩展消息
                return;
            }else {
                YYChatViewCell *cell = (YYChatViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                [cell becomeFirstResponder];
                _longPressIndexPath = indexPath;
                [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.messageModel.type];
            }
        }
    }
}


- (void)showMenuViewController:(UIView *)showInView andIndexPath:(NSIndexPath *)indexPath messageType:(MessageBodyType)messageType {
    if (_menuController == nil) {
        _menuController = [UIMenuController sharedMenuController];
    }
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMenuAction:)];
    }
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMenuAction:)];
    }
    
    if (messageType == eMessageBodyType_Text) {
        [_menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem]];
    }
    else{
        [_menuController setMenuItems:@[_deleteMenuItem]];
    }
    
    [_menuController setTargetRect:showInView.frame inView:showInView.superview];
    [_menuController setMenuVisible:YES animated:YES];
}


#pragma mark - MenuItem actions

- (void)copyMenuAction:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (_longPressIndexPath.row > 0) {
        MessageModel *model = [self.dataSource objectAtIndex:_longPressIndexPath.row]; //取出dataSource
        pasteboard.string = model.content;
    }
    
    _longPressIndexPath = nil;
}

- (void)deleteMenuAction:(id)sender {
    if (_longPressIndexPath && _longPressIndexPath.row > 0) {
        MessageModel *model = [self.dataSource objectAtIndex:_longPressIndexPath.row]; //取出dataSource

        NSMutableIndexSet *indexs = [NSMutableIndexSet indexSetWithIndex:_longPressIndexPath.row];
        [_conversation removeMessage:model.message];
        [self.messages removeObject:model.message];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:_longPressIndexPath, nil];;
        if (_longPressIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataSource objectAtIndex:(_longPressIndexPath.row - 1)];
            if (_longPressIndexPath.row + 1 < [self.dataSource count]) {
                nextMessage = [self.dataSource objectAtIndex:(_longPressIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [indexs addIndex:_longPressIndexPath.row - 1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(_longPressIndexPath.row - 1) inSection:0]];
            }
        }
        
        [self.dataSource removeObjectsAtIndexes:indexs]; //删除对应的数据源
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
    
    _longPressIndexPath = nil;
}


//通过会话管理者获取已收发消息
- (void)loadMoreMessagesFrom:(long long)timestamp count:(NSInteger)count append:(BOOL)append {
    __weak typeof(self) weakSelf = self;
    dispatch_async(_messageQueue, ^{
        NSArray *messages = [weakSelf.conversation loadNumbersOfMessages:count before:timestamp];
        if ([messages count] > 0) {
            NSInteger currentCount = 0;
            if (append) //添加到数组后面
            {
                [weakSelf.messages insertObjects:messages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [messages count])]];
                NSArray *formated = [weakSelf formatMessages:messages];
                id model = [weakSelf.dataSource firstObject];
                if ([model isKindOfClass:[NSString class]])
                {
                    NSString *timestamp = model;
                    [formated enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id model, NSUInteger idx, BOOL *stop) {
                        if ([model isKindOfClass:[NSString class]] && [timestamp isEqualToString:model])
                        {
                            [weakSelf.dataSource removeObjectAtIndex:0];
                            *stop = YES;
                        }
                    }];
                }
                currentCount = [weakSelf.dataSource count];
                [weakSelf.dataSource insertObjects:formated atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [formated count])]];
                
                EMMessage *latest = [weakSelf.messages lastObject];
                weakSelf.chatTagDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)latest.timestamp];
            }
            else
            {
                weakSelf.messages = [messages mutableCopy];
                weakSelf.dataSource = [[weakSelf formatMessages:messages] mutableCopy];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[weakSelf.dataSource count] - currentCount - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            });
            
            //从数据库导入时重新下载没有下载成功的附件
            for (EMMessage *message in messages)
            {
                [weakSelf downloadMessageAttachments:message];
            }
            
            NSMutableArray *unreadMessages = [NSMutableArray array];
            for (NSInteger i = 0; i < [messages count]; i++)
            {
                EMMessage *message = messages[i];
                if ([self shouldAckMessage:message read:NO])
                {
                    [unreadMessages addObject:message];
                }
            }
            if ([unreadMessages count])
            {
                [self sendHasReadResponseForMessages:unreadMessages];
            }
        }
    });
}

- (void)sendHasReadResponseForMessages:(NSArray*)messages
{
    dispatch_async(_messageQueue, ^{
        for (EMMessage *message in messages)
        {
            [[EaseMob sharedInstance].chatManager sendReadAckForMessage:message];
        }
    });
}


- (BOOL)shouldAckMessage:(EMMessage *)message read:(BOOL)read
{
    NSString *account = [[EaseMob sharedInstance].chatManager loginInfo][kSDKUsername];
    if (message.messageType != eMessageTypeChat || message.isReadAcked || [account isEqualToString:message.from] || ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) || self.isInvisible)
    {
        return NO;
    }
    
    id<IEMMessageBody> body = [message.messageBodies firstObject];
    if (((body.messageBodyType == eMessageBodyType_Video) ||
         (body.messageBodyType == eMessageBodyType_Voice) ||
         (body.messageBodyType == eMessageBodyType_Image)) &&
        !read)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}


- (void)downloadMessageAttachments:(EMMessage *)message
{
    __weak typeof(self) weakSelf = self;
    void (^completion)(EMMessage *aMessage, EMError *error) = ^(EMMessage *aMessage, EMError *error) {
        if (!error)
        {
            [weakSelf reloadTableViewDataWithMessage:message];
        }
        else
        {
            [weakSelf showHint:NSLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
        }
    };
    
    id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
    if ([messageBody messageBodyType] == eMessageBodyType_Image) {
        EMImageMessageBody *imageBody = (EMImageMessageBody *)messageBody;
        if (imageBody.thumbnailDownloadStatus > EMAttachmentDownloadSuccessed)
        {
            //下载缩略图
            [[[EaseMob sharedInstance] chatManager] asyncFetchMessageThumbnail:message progress:nil completion:completion onQueue:nil];
        }
    }
    else if ([messageBody messageBodyType] == eMessageBodyType_Video)
    {
        EMVideoMessageBody *videoBody = (EMVideoMessageBody *)messageBody;
        if (videoBody.thumbnailDownloadStatus > EMAttachmentDownloadSuccessed)
        {
            //下载缩略图
            [[[EaseMob sharedInstance] chatManager] asyncFetchMessageThumbnail:message progress:nil completion:completion onQueue:nil];
        }
    }
    else if ([messageBody messageBodyType] == eMessageBodyType_Voice)
    {
        EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody*)messageBody;
        if (voiceBody.attachmentDownloadStatus > EMAttachmentDownloadSuccessed)
        {
            //下载语言
            [[EaseMob sharedInstance].chatManager asyncFetchMessage:message progress:nil];
        }
    }
}


- (void)reloadTableViewDataWithMessage:(EMMessage *)message{
    __weak ChatController *weakSelf = self;
    dispatch_async(_messageQueue, ^{
        if ([weakSelf.conversation.chatter isEqualToString:message.conversationChatter])
        {
            for (int i = 0; i < weakSelf.dataSource.count; i ++) {
                id object = [weakSelf.dataSource objectAtIndex:i];
                if ([object isKindOfClass:[MessageModel class]]) {
                    MessageModel *model = (MessageModel *)object;
                    if ([message.messageId isEqualToString:model.messageId]) {
                        MessageModel *cellModel = [MessageModelManager modelWithMessage:message];
                        if ([self->_delelgate respondsToSelector:@selector(nickNameWithChatter:)]) {
                            NSString *showName = [self->_delelgate nickNameWithChatter:model.username];
                            cellModel.nickName = showName?showName:cellModel.username;
                        }else {
                            cellModel.nickName = cellModel.username;
                        }
                        
                        if ([self->_delelgate respondsToSelector:@selector(avatarWithChatter:)]) {
                            cellModel.headImageURL = [NSURL URLWithString:[self->_delelgate avatarWithChatter:cellModel.username]];
                        }                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.tableView beginUpdates];
                            [weakSelf.dataSource replaceObjectAtIndex:i withObject:cellModel];
                            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                            [weakSelf.tableView endUpdates];
                        });
                        break;
                    }
                }
            }
        }
    });
}


- (NSArray *)formatMessages:(NSArray *)messagesArray
{
    NSMutableArray *formatArray = [[NSMutableArray alloc] init];
    if ([messagesArray count] > 0) {
        for (EMMessage *message in messagesArray) {
            NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp]; //消息发送或接收的时间
            NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.chatTagDate]; //消息时间和上一条聊天消息的时间间隔
            if (tempDate > 60 || tempDate < -60 || (self.chatTagDate == nil)) { //在规定的时间间隔内
                [formatArray addObject:[createDate formattedTime]];  //将时间加入数据源
                self.chatTagDate = createDate;
            }
            
            MessageModel *model = [MessageModelManager modelWithMessage:message]; //将消息转化为消息模型
            model.chatterName = self.title; //自定义属性
            if ([_delelgate respondsToSelector:@selector(nickNameWithChatter:)]) {
                NSString *showName = [_delelgate nickNameWithChatter:model.username];
                model.nickName = showName?showName:model.username;
            }else {
                model.nickName = model.username;
            }
            
            if ([_delelgate respondsToSelector:@selector(avatarWithChatter:)]) {
                model.headImageURL = [NSURL URLWithString:[_delelgate avatarWithChatter:model.username]];
            }
            
            if (model) {
                [formatArray addObject:model]; //将消息模型加入数据源
            }
        }
    }
    
    return formatArray;
}


#pragma mark - helper
- (NSURL *)convert2Mp4:(NSURL *)movUrl {
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetHighestQuality];
        mp4Url = [movUrl copy];
        mp4Url = [mp4Url URLByDeletingPathExtension];
        mp4Url = [mp4Url URLByAppendingPathExtension:@"mp4"];
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"completed.");
                } break;
                default: {
                    NSLog(@"others.");
                } break;
            }
            dispatch_semaphore_signal(wait);
        }];
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            NSLog(@"timeout.");
        }
        if (wait) {
            //dispatch_release(wait);
            wait = nil;
        }
    }
    
    return mp4Url;
}

#pragma mark - registerNotifications

-(void)registerNotifications{
    [self unregisterNotifications];
    
    [EMCDDeviceManager sharedInstance].delegate = self;
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callOutWithChatter:) name:@"callOutWithChatter" object:nil]; //监测实时语音或视频开始的通知
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callControllerClose:) name:@"callControllerClose" object:nil]; //监测实时语音或视频结束的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertCallMessage:) name:@"insertCallMessage" object:nil]; //注册电话控制器的通知，通话结束后将电话消息插入数据源
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:@"applicationDidEnterBackground" object:nil]; //应用进入后台的通知
}

-(void)unregisterNotifications{
    [EMCDDeviceManager sharedInstance].delegate = nil;
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].callManager removeDelegate:self];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"callOutWithChatter" object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"callControllerClose" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"insertCallMessage" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"applicationDidEnterBackground" object:nil];
}

#pragma mark - getter

- (void)setIsInvisible:(BOOL)isInvisible
{
    _isInvisible =isInvisible;
    if (!_isInvisible)
    {
        NSMutableArray *unreadMessages = [NSMutableArray array];
        for (EMMessage *message in self.messages)
        {
            if ([self shouldAckMessage:message read:NO])
            {
                [unreadMessages addObject:message];
            }
        }
        if ([unreadMessages count])
        {
            [self sendHasReadResponseForMessages:unreadMessages];
        }
        
        [_conversation markAllMessagesAsRead:YES];
    }
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}


- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.chatToolBar.frame.size.height) style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGBACOLOR(248, 248, 248, 1);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        lpgr.minimumPressDuration = .5;
        [_tableView addGestureRecognizer:lpgr];
    }
    
    return _tableView;
}


- (YYMessageToolBar *)chatToolBar {
    if (_chatToolBar == nil) {
        _chatToolBar = [[YYMessageToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [YYMessageToolBar defaultHeight], self.view.frame.size.width, [YYMessageToolBar defaultHeight])];
        _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _chatToolBar.delegate = self;
     
    }

    return _chatToolBar;
}

- (UIImagePickerController *)imagePicker {
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.modalPresentationStyle= UIModalPresentationOverFullScreen;
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}

- (MessageReadManager *)messageReadManager {
    if (_messageReadManager == nil) {
        _messageReadManager = [MessageReadManager defaultManager];
    }
    
    return _messageReadManager;
}

- (NSDate *)chatTagDate {
    if (_chatTagDate == nil) {
        _chatTagDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:0];
    }
    
    return _chatTagDate;
}

- (UIView *)dimView {

    if (_dimView == nil) {
        _dimView = [[UIView alloc] initWithFrame:self.view.bounds];
        _dimView.hidden = YES;
        _dimView.alpha = 0.5;
        _dimView.backgroundColor = [UIColor lightGrayColor];
        UITapGestureRecognizer *dimTapGS = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimViewTap)];
        [_dimView addGestureRecognizer:dimTapGS];
        

    }
    return _dimView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < [self.dataSource count]) {
        id obj = [self.dataSource objectAtIndex:indexPath.row];
        if ([obj isKindOfClass:[NSString class]]) { //显示时间
            YYChatTimeCell *timeCell = (YYChatTimeCell *)[tableView dequeueReusableCellWithIdentifier:@"MessageCellTime"];
            if (timeCell == nil) {
                timeCell = [[YYChatTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageCellTime"];
                timeCell.backgroundColor = [UIColor clearColor];
                timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            timeCell.textLabel.text = (NSString *)obj;
            
            return timeCell;
        }
        else{ //显示对应的消息
                MessageModel *model = (MessageModel *)obj;
                NSString *cellIdentifier = [YYChatViewCell cellIdentifierForMessageModel:model];
                YYChatViewCell *cell = (YYChatViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil) {
                    cell = [[YYChatViewCell alloc] initWithMessageModel:model reuseIdentifier:cellIdentifier];
                    cell.backgroundColor = [UIColor clearColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell.messageModel = model; //为模型赋值
                
                return cell;
            }
        }
    
    return nil;
}


#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *obj = [self.dataSource objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[NSString class]]) {
        return 40;
    }else {
        MessageModel *model = (MessageModel *)obj;

            return [YYChatViewCell tableView:tableView heightForRowAtIndexPath:indexPath withObject:model];
    }
}


- (void)reloadData { //外部调用的公开方法
    _chatTagDate = nil;
    self.dataSource = [[self formatMessages:self.messages] mutableCopy]; //初始化数据源
    [self.tableView reloadData];
    
    //回到前台时
    if (!self.isInvisible) {
        NSMutableArray *unreadMessages = [NSMutableArray array];
        for (EMMessage *message in self.messages) {
            if ([self shouldAckMessage:message read:NO]) { //判断消息数组中的消息是否为未读消息
                [unreadMessages addObject:message];
            }
        }
        if ([unreadMessages count]) {
            [self sendHasReadResponseForMessages:unreadMessages]; //发送已读的回应
        }
        [_conversation markAllMessagesAsRead:YES];
    }
}


#pragma mark - UIResponder actions

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    MessageModel *model = [userInfo objectForKey:KMESSAGEKEY];
    if ([eventName isEqualToString:kRouterEventTextURLTapEventName]) {
        [self chatTextCellUrlPressed:[userInfo objectForKey:@"url"]];
    }
    else if ([eventName isEqualToString:kRouterEventAudioBubbleTapEventName]) {
        [self chatAudioCellBubblePressed:model];
    }
    else if ([eventName isEqualToString:kRouterEventImageBubbleTapEventName]){
        [self chatImageCellBubblePressed:model];
    }
    else if ([eventName isEqualToString:kRouterEventLocationBubbleTapEventName]){
        [self chatLocationCellBubblePressed:model];
    }
    else if([eventName isEqualToString:kResendButtonTapEventName]){ //重发消息
        YYChatViewCell *resendCell = [userInfo objectForKey:kShouldResendCell];
        MessageModel *messageModel = resendCell.messageModel;
        if ((messageModel.status != eMessageDeliveryState_Failure) && (messageModel.status != eMessageDeliveryState_Pending))
        {
            return;
        }
        id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
        [chatManager asyncResendMessage:messageModel.message progress:nil];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:resendCell];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }else if([eventName isEqualToString:kRouterEventChatCellVideoTapEventName]){
        [self chatVideoCellPressed:model];
    }else if ([eventName isEqualToString:kRouterEventMenuTapEventName]) {
        [self sendTextMessage:[userInfo objectForKey:@"text"] ext:nil];
    }else if ([eventName isEqualToString:kRouterEventChatHeadImageTapEventName]) {
        //        [self chatHeadImagePressed:model];
    }else if([eventName isEqualToString:kRouterEventJumpButtonEventName]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HealthPermissionController *hpc = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HealthPermissionController class])];
        hpc.healthUrl = [model.message.ext objectForKeyedSubscript:@"URL"];
        [self.navigationController pushViewController:hpc animated:YES];
//        NSURL *url = [NSURL URLWithString:[model.message.ext objectForKey:@"URL"]];
//        [[UIApplication sharedApplication] openURL:url];
    }

}

//链接被点击
- (void)chatTextCellUrlPressed:(NSURL *)url {
    if (url) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

// 语音的bubble被点击
-(void)chatAudioCellBubblePressed:(MessageModel *)model {
    id <IEMFileMessageBody> body = [model.message.messageBodies firstObject];
    EMAttachmentDownloadStatus downloadStatus = [body attachmentDownloadStatus];
    if (downloadStatus == EMAttachmentDownloading) {
        [self showHint:@"正在下载语音，稍后点击"];
        return;
    }else if (downloadStatus == EMAttachmentDownloadFailure)
    {
        [self showHint:@"正在下载语音，稍后点击"];
        [[EaseMob sharedInstance].chatManager asyncFetchMessage:model.message progress:nil];
        
        return;
    }
    
    // 播放音频
    if (model.type == eMessageBodyType_Voice) {
        //发送已读回执
        if ([self shouldAckMessage:model.message read:YES])
        {
            [self sendHasReadResponseForMessages:@[model.message]];
        }
        __weak ChatController *weakSelf = self;
        BOOL isPrepare = [self.messageReadManager prepareMessageAudioModel:model updateViewCompletion:^(MessageModel *prevAudioModel, MessageModel *currentAudioModel) {
            if (prevAudioModel || currentAudioModel) {
                [weakSelf.tableView reloadData];
            }
        }];
        
        if (isPrepare) {
            _isPlayingAudio = YES;
            __weak ChatController *weakSelf = self;
            [[EMCDDeviceManager sharedInstance] enableProximitySensor];
            [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:model.chatVoice.localPath completion:^(NSError *error) {
                [weakSelf.messageReadManager stopMessageAudioModel];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                    weakSelf.isPlayingAudio = NO;
                    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
                });
            }];
        }else {
            _isPlayingAudio = NO;
        }
    }
}


// 图片的bubble被点击
-(void)chatImageCellBubblePressed:(MessageModel *)model {
    __weak ChatController *weakSelf = self;
    id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
    if ([model.messageBody messageBodyType] == eMessageBodyType_Image) {
        EMImageMessageBody *imageBody = (EMImageMessageBody *)model.messageBody;
        if (imageBody.thumbnailDownloadStatus == EMAttachmentDownloadSuccessed) {
            if (imageBody.attachmentDownloadStatus == EMAttachmentDownloadSuccessed)
            {
                //发送已读回执
                if ([self shouldAckMessage:model.message read:YES])
                {
                    [self sendHasReadResponseForMessages:@[model.message]];
                }
                NSString *localPath = model.message == nil ? model.localPath : [[model.message.messageBodies firstObject] localPath];
                if (localPath && localPath.length > 0) {
                    UIImage *image = [UIImage imageWithContentsOfFile:localPath];
                    self.isScrollToBottom = NO;
                    if (image)
                    {
                        [self.messageReadManager showBrowserWithImages:@[image]];
                    }
                    else
                    {
//                        YYLog(@"Read %@ failed!", localPath);
                    }
                    return ;
                }
            }
            [weakSelf showHudInView:weakSelf.view hint:@"正在获取大图..."];
            [chatManager asyncFetchMessage:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
                [weakSelf hideHud];
                if (!error) {
                    //发送已读回执
                    if ([weakSelf shouldAckMessage:model.message read:YES])
                    {
                        [weakSelf sendHasReadResponseForMessages:@[model.message]];
                    }
                    NSString *localPath = aMessage == nil ? model.localPath : [[aMessage.messageBodies firstObject] localPath];
                    if (localPath && localPath.length > 0) {
                        UIImage *image = [UIImage imageWithContentsOfFile:localPath];
                        weakSelf.isScrollToBottom = NO;
                        if (image)
                        {
                            [weakSelf.messageReadManager showBrowserWithImages:@[image]];
                        }
                        else
                        {
//                            YYLog(@"Read %@ failed!", localPath);
                        }
                        return ;
                    }
                }
                [weakSelf showHint:@"大图获取失败!"];
            } onQueue:nil];
        }else{
            //获取缩略图
            [chatManager asyncFetchMessageThumbnail:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
                if (!error) {
                    [weakSelf reloadTableViewDataWithMessage:model.message];
                }else{
                    [weakSelf showHint:@"缩略图获取失败!"];
                }
                
            } onQueue:nil];
        }
    }else if ([model.messageBody messageBodyType] == eMessageBodyType_Video) {
        //获取缩略图
        EMVideoMessageBody *videoBody = (EMVideoMessageBody *)model.messageBody;
        if (videoBody.thumbnailDownloadStatus != EMAttachmentDownloadSuccessed) {
            [chatManager asyncFetchMessageThumbnail:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
                if (!error) {
                    [weakSelf reloadTableViewDataWithMessage:model.message];
                }else{
                    [weakSelf showHint:@"缩略图获取失败!"];
                }
            } onQueue:nil];
        }
    }
}


// 位置的bubble被点击
-(void)chatLocationCellBubblePressed:(MessageModel *)model {
//    _isScrollToBottom = NO;
//    LocationViewController *locationController = [[LocationViewController alloc] initWithLocation:CLLocationCoordinate2DMake(model.latitude, model.longitude)];
//    [self.navigationController pushViewController:locationController animated:YES];
}


// 视频的bubble被点击
- (void)chatVideoCellPressed:(MessageModel *)model {
    EMVideoMessageBody *videoBody = (EMVideoMessageBody*)model.messageBody;
    if (videoBody.attachmentDownloadStatus == EMAttachmentDownloadSuccessed)
    {
        NSString *localPath = model.message == nil ? model.localPath : [[model.message.messageBodies firstObject] localPath];
        if (localPath && localPath.length > 0)
        {
            //发送已读回执
            if ([self shouldAckMessage:model.message read:YES])
            {
                [self sendHasReadResponseForMessages:@[model.message]];
            }
            [self playVideoWithVideoPath:localPath];
            return;
        }
    }
    
    __weak ChatController *weakSelf = self;
    id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
    [weakSelf showHudInView:weakSelf.view hint:@"正在获取视频..."];
    [chatManager asyncFetchMessage:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
        [weakSelf hideHud];
        if (!error) {
            //发送已读回执
            if ([weakSelf shouldAckMessage:model.message read:YES])
            {
                [weakSelf sendHasReadResponseForMessages:@[model.message]];
            }
            NSString *localPath = aMessage == nil ? model.localPath : [[aMessage.messageBodies firstObject] localPath];
            if (localPath && localPath.length > 0) {
                [weakSelf playVideoWithVideoPath:localPath];
            }
        }else{
            [weakSelf showHint:@"视频获取失败!"];
        }
    } onQueue:nil];
}

- (void)playVideoWithVideoPath:(NSString *)videoPath {
    _isScrollToBottom = NO;
    NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
    MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    [moviePlayerController.moviePlayer prepareToPlay];
    moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [self presentMoviePlayerViewControllerAnimated:moviePlayerController];
}

#pragma mark - IChatManagerDelegate
-(void)didSendMessage:(EMMessage *)message error:(EMError *)error { //发送消息后的回调
    [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if ([obj isKindOfClass:[MessageModel class]])
         {
             MessageModel *model = (MessageModel*)obj;
             if ([model.messageId isEqualToString:message.messageId])
             {
                 model.message.deliveryState = message.deliveryState;
                 *stop = YES;
             }
         }
     }];
    [self.tableView reloadData];
}

- (void)didReceiveHasReadResponse:(EMReceipt*)receipt { //收到"已读回执"时的回调方法
    [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if ([obj isKindOfClass:[MessageModel class]])
         {
             MessageModel *model = (MessageModel*)obj;
             if ([model.messageId isEqualToString:receipt.chatId])
             {
                 model.message.isReadAcked = YES;
                 *stop = YES;
             }
         }
     }];
    [self.tableView reloadData];
}


- (void)didMessageAttachmentsStatusChanged:(EMMessage *)message error:(EMError *)error { //SDK接收到消息时, 下载附件成功或失败的回调
    if (!error) {
        id<IEMFileMessageBody>fileBody = (id<IEMFileMessageBody>)[message.messageBodies firstObject];
        if ([fileBody messageBodyType] == eMessageBodyType_Image) { //图片
            EMImageMessageBody *imageBody = (EMImageMessageBody *)fileBody;
            if ([imageBody thumbnailDownloadStatus] == EMAttachmentDownloadSuccessed)
            {
                [self reloadTableViewDataWithMessage:message]; //重新刷新对应行的表格
            }
        }else if([fileBody messageBodyType] == eMessageBodyType_Video){ //视频
            EMVideoMessageBody *videoBody = (EMVideoMessageBody *)fileBody;
            if ([videoBody thumbnailDownloadStatus] == EMAttachmentDownloadSuccessed)
            {
                [self reloadTableViewDataWithMessage:message];
            }
        }else if([fileBody messageBodyType] == eMessageBodyType_Voice){//语音
            if ([fileBody attachmentDownloadStatus] == EMAttachmentDownloadSuccessed)
            {
                [self reloadTableViewDataWithMessage:message];
            }
        }
        
    }else{
        
    }
}

- (void)didFetchingMessageAttachments:(EMMessage *)message progress:(float)progress{ //SDK接收到消息时, 下载附件的进度回调, 回调方法有不在主线程中调用, 需要App自己切换到主线程中执行UI的刷新等操作
    NSLog(@"didFetchingMessageAttachment: %f", progress);
}


-(void)didReceiveMessage:(EMMessage *)message { //收到消息时的回调
    if ([_conversation.chatter isEqualToString:message.conversationChatter]) { //判断是否为当前的会话对象
        
            [self addMessage:message]; //将收到的消息加入数据源
        if ([self shouldAckMessage:message read:NO])
        {
            [self sendHasReadResponseForMessages:@[message]];
        }
        if ([self shouldMarkMessageAsRead])
        {
            [self markMessagesAsRead:@[message]];
        }
    }
}


-(void)didReceiveCmdMessage:(EMMessage *)message { //收到消息时的回调（命令消息或陈透传消息）
    if ([_conversation.chatter isEqualToString:message.conversationChatter]) {
        [self showHint:@"有透传消息"];
    }
}


- (void)didReceiveMessageId:(NSString *)messageId
                    chatter:(NSString *)conversationChatter
                      error:(EMError *)error {
    if (error && [_conversation.chatter isEqualToString:conversationChatter]) {
        
        __weak ChatController *weakSelf = self;
        for (int i = 0; i < self.dataSource.count; i ++) {
            id object = [self.dataSource objectAtIndex:i];
            if ([object isKindOfClass:[MessageModel class]]) {
                MessageModel *currentModel = [self.dataSource objectAtIndex:i];
                EMMessage *currMsg = [currentModel message];
                if ([messageId isEqualToString:currMsg.messageId]) {
                    currMsg.deliveryState = eMessageDeliveryState_Failure;
                    MessageModel *cellModel = [MessageModelManager modelWithMessage:currMsg];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.tableView beginUpdates];
                        [weakSelf.dataSource replaceObjectAtIndex:i withObject:cellModel];
                        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                        [weakSelf.tableView endUpdates];
                        
                    });
                    
                    if (error && error.errorCode == EMErrorMessageContainSensitiveWords)
                    {
                        CGRect frame = self.chatToolBar.frame;
                        [self showHint:@"你的消息包含不当言论" yOffset:-frame.size.height + KHintAdjustY];
                    }
                    break;
                }
            }
        }
    }
}


- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages { //接收到离线非透传消息的回调
    if (![offlineMessages count]) {
        return;
    }
    if ([self shouldMarkMessageAsRead]) {
        [_conversation markAllMessagesAsRead:YES];
    }
    _chatTagDate = nil;
    long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000 + 1;
    [self loadMoreMessagesFrom:timestamp count:[self.messages count] + [offlineMessages count] append:NO];
}


- (void)didInterruptionRecordAudio {
    [_chatToolBar cancelTouchRecord];
    
    // 设置当前conversation的所有message为已读
    [_conversation markAllMessagesAsRead:YES];
    
    [self stopAudioPlayingWithChangeCategory:YES];
}


- (void)stopAudioPlayingWithChangeCategory:(BOOL)isChange {
    //停止音频播放及播放动画
    [[EMCDDeviceManager sharedInstance] stopPlaying];
    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
    [EMCDDeviceManager sharedInstance].delegate = nil;
    MessageModel *playingModel = [self.messageReadManager stopMessageAudioModel];
    NSIndexPath *indexPath = nil;
    if (playingModel) {
        indexPath = [NSIndexPath indexPathForRow:[self.dataSource indexOfObject:playingModel] inSection:0];
    }
    
    if (indexPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        });
    }
}


- (BOOL)shouldMarkMessageAsRead {
    if (([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) || self.isInvisible) {
        return NO;
    }
    
    return YES;
}


- (void)markMessagesAsRead:(NSArray*)messages {
    EMConversation *conversation = _conversation;
    dispatch_async(_messageQueue, ^{
        for (EMMessage *message in messages)
        {
            [conversation markMessageWithId:message.messageId asRead:YES];
        }
    });
}


#pragma mark - IChatManagerDelegate 登录状态变化

- (void)didLoginFromOtherDevice { //当前登录账号在其它设备登录时的通知回调
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)didRemovedFromServer { //当前登录账号已经被从服务器端删除
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}


#pragma mark - EMChatBarMoreViewDelegate

- (void)moreViewPhotoAction:(YYChatBarMoreView *)moreView {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isShowPicker"];
    // 隐藏键盘
    [self keyBoardHidden];
    
    // 弹出照片选择
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
    self.isInvisible = YES;
}


//- (void)moreViewTakePicAction:(YYChatBarMoreView *)moreView {
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isShowPicker"];
//    [self keyBoardHidden];
//    
//#if TARGET_IPHONE_SIMULATOR
//    [self showHint:@"模拟器不支持拍照"];
//#elif TARGET_OS_IPHONE
//    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
//    [self presentViewController:self.imagePicker animated:YES completion:NULL];
//    self.isInvisible = YES;
//#endif
//}

//- (void)moreViewLocationAction:(YYChatBarMoreView *)moreView {
//    // 隐藏键盘
//    [self keyBoardHidden];
//    
////    LocationViewController *locationController = [[LocationViewController alloc] initWithNibName:nil bundle:nil];
////    locationController.delegate = self;
////    [self.navigationController pushViewController:locationController animated:YES];
//}

- (void)moreViewAudioCallAction:(YYChatBarMoreView *)moreView {
    // 隐藏键盘
    [self keyBoardHidden];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"callOutWithChatter" object:@{@"chatter":self.chatter, @"type":[NSNumber numberWithInt:eCallSessionTypeAudio]}];
}


- (void)moreViewVideoCallAction:(YYChatBarMoreView *)moreView {
    // 隐藏键盘
    [self keyBoardHidden];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"callOutWithChatter" object:@{@"chatter":self.chatter, @"type":[NSNumber numberWithInt:eCallSessionTypeVideo]}];
}

- (void)moreViewEducationAction:(YYChatBarMoreView *)moreView {

    NSLog(@"moreViewEducationAction");
}

- (void)moreViewSuifangAction:(YYChatBarMoreView *)moreView {
    NSLog(@"moreViewSuifangAction");

}

- (void)moreViewChakanbingliAction:(YYChatBarMoreView *)moreView {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"申请查看对方病历资料" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertView show];
}
#pragma mark - YYMessageToolBarDelegate
- (void)inputTextViewWillBeginEditing:(YYMessageTextView *)messageInputTextView {
    [_menuController setMenuItems:nil];
}

- (void)didChangeFrameToHeight:(CGFloat)toHeight {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.tableView.frame;
        rect.origin.y = 0;
        rect.size.height = self.view.frame.size.height - toHeight;
        self.tableView.frame = rect;
    }];
    [self scrollViewToBottom:NO];
}

- (void)didSendText:(NSString *)text {
    if (text && text.length > 0) {
        [self sendTextMessage:text ext:nil];
    }
}


/**
 *  按下录音按钮开始录音
 */
- (void)didStartRecordingVoiceAction:(UIView *)recordView {
    if ([self canRecord]) {
        YYRecordView *tmpView = (YYRecordView *)recordView;
        tmpView.center = self.view.center;
        [self.view addSubview:tmpView];
        [self.view bringSubviewToFront:recordView];
        int x = arc4random() % 100000;
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
        
        [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName
                                                                 completion:^(NSError *error)
         {
             if (error) {
             }
         }];
    }
}


/**
 *  手指向上滑动取消录音
 */
- (void)didCancelRecordingVoiceAction:(UIView *)recordView {
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
}


/**
 *  松开手指完成录音
 */
- (void)didFinishRecoingVoiceAction:(UIView *)recordView {
    __weak typeof(self) weakSelf = self;
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (!error) {
            EMChatVoice *voice = [[EMChatVoice alloc] initWithFile:recordPath
                                                       displayName:@"audio"];
            voice.duration = aDuration;
            [weakSelf sendAudioMessage:voice ext:nil]; //发送语音消息
        }else {
            [weakSelf showHudInView:self.view hint:@"录音时间太短了"];
            weakSelf.chatToolBar.recordButton.enabled = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf hideHud];
                weakSelf.chatToolBar.recordButton.enabled = YES;
            });
        }
    }];
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *videoURL = info[UIImagePickerControllerMediaURL];
        [picker dismissViewControllerAnimated:YES completion:^{
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isShowPicker"];
        }];
        // video url:
        // file:///private/var/mobile/Applications/B3CDD0B2-2F19-432B-9CFA-158700F4DE8F/tmp/capture-T0x16e39100.tmp.9R8weF/capturedvideo.mp4
        // we will convert it to mp4 format
        NSURL *mp4 = [self convert2Mp4:videoURL];
        NSFileManager *fileman = [NSFileManager defaultManager];
        if ([fileman fileExistsAtPath:videoURL.path]) {
            NSError *error = nil;
            [fileman removeItemAtURL:videoURL error:&error];
            if (error) {
//                YYLog(@"failed to remove file, error:%@.", error);
            }
        }
        EMChatVideo *chatVideo = [[EMChatVideo alloc] initWithFile:[mp4 relativePath] displayName:@"video.mp4"];
        [self sendVideoMessage:chatVideo ext:nil];  //发送录制视频
        
    }else{
        UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
        [picker dismissViewControllerAnimated:YES completion:^{
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isShowPicker"];
        }];
        [self sendImageMessage:orgImage ext:nil];
    }
    self.isInvisible = NO;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isShowPicker"];
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    self.isInvisible = NO;
}


#pragma mark - private

-(NSMutableArray *)formatMessage:(EMMessage *)message { //同formatMessages
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
    NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.chatTagDate];
    if (tempDate > 60 || tempDate < -60 || (self.chatTagDate == nil)) {
        [ret addObject:[createDate formattedTime]];
        self.chatTagDate = createDate;
    }
    

    MessageModel *model = [MessageModelManager modelWithMessage:message];
    model.chatterName = self.title; //自定义属性
    if ([_delelgate respondsToSelector:@selector(nickNameWithChatter:)]) {
        NSString *showName = [_delelgate nickNameWithChatter:model.username];
        model.nickName = showName?showName:model.username;
    }else {
        model.nickName = model.username;
    }
    
    if ([_delelgate respondsToSelector:@selector(avatarWithChatter:)]) {
        model.headImageURL = [NSURL URLWithString:[_delelgate avatarWithChatter:model.username]];
    }
    
    if (model) {
        [ret addObject:model];
    }
    
    return ret;
}


- (void)insertCallMessage:(NSNotification *)notification {
    id object = notification.object;
    if (object) {
        EMMessage *message = (EMMessage *)object;
        [self addMessage:message];
        [[EaseMob sharedInstance].chatManager insertMessageToDB:message append2Chat:YES];
    }
}

- (void)applicationDidEnterBackground
{
    [_chatToolBar cancelTouchRecord];
    
    // 设置当前conversation的所有message为已读
    [_conversation markAllMessagesAsRead:YES];
}

//聊天时的消息类型，可能为单聊类型，群聊类型，和聊天室消息
- (EMMessageType)messageType {
    EMMessageType type = eMessageTypeChat;
    switch (_conversationType) {
        case eConversationTypeChat:
            type = eMessageTypeChat;
            break;
        case eConversationTypeGroupChat:
            type = eMessageTypeGroupChat;
            break;
        case eConversationTypeChatRoom:
            type = eMessageTypeChatRoom;
            break;
        default:
            break;
    }
    return type;
}


#pragma mark - public

- (void)hideImagePicker {
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    self.isInvisible = NO;
}


#pragma mark - EMCDDeviceManagerDelegate
- (void)proximitySensorChanged:(BOOL)isCloseToUser {
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (isCloseToUser)
    {
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    } else {
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        if (!_isPlayingAudio) {
            [[EMCDDeviceManager sharedInstance] disableProximitySensor];
        }
    }
    [audioSession setActive:YES error:nil];
}





#pragma mark - send message
-(void)sendTextMessage:(NSString *)textMessage ext:(NSDictionary *)ext{
//    NSDictionary *ext = nil; 发送消息时的扩展内容，用来实现特殊需求，比如阅后即焚等
    EMMessage *tempMessage = [ChatSendHelper sendTextMessageWithString:textMessage
                                                            toUsername:_conversation.chatter
                                                           messageType:[self messageType]
                                                     requireEncryption:NO
                                                                   ext:ext];
    if (ext) { //扩展消息
        
    }
    [self addMessage:tempMessage];
}

-(void)sendImageMessage:(UIImage *)image ext:(NSDictionary *)ext{
//    NSDictionary *ext = nil;
    EMMessage *tempMessage = [ChatSendHelper sendImageMessageWithImage:image
                                                            toUsername:_conversation.chatter
                                                           messageType:[self messageType]
                                                     requireEncryption:NO
                                                                   ext:ext];
    [self addMessage:tempMessage];
}

-(void)sendAudioMessage:(EMChatVoice *)voice ext:(NSDictionary *)ext{
//    NSDictionary *ext = nil;
    EMMessage *tempMessage = [ChatSendHelper sendVoice:voice
                                            toUsername:_conversation.chatter
                                           messageType:[self messageType]
                                     requireEncryption:NO ext:ext];
    [self addMessage:tempMessage];
}

-(void)sendVideoMessage:(EMChatVideo *)video ext:(NSDictionary *)ext{
//    NSDictionary *ext = nil;
    EMMessage *tempMessage = [ChatSendHelper sendVideo:video
                                            toUsername:_conversation.chatter
                                           messageType:[self messageType]
                                     requireEncryption:NO ext:ext];
    [self addMessage:tempMessage];
}

//添加一条消息（可能为2条，其中包含一条时间的字符串消息）模型进数据源
-(void)addMessage:(EMMessage *)message {
    [_messages addObject:message]; //加入消息数组
    __weak ChatController *weakSelf = self;
    dispatch_async(_messageQueue, ^{
        NSArray *messages = [weakSelf formatMessage:message];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.dataSource addObjectsFromArray:messages]; //添加进数据源
            [weakSelf.tableView reloadData]; //刷新
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[weakSelf.dataSource count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES]; //滚动
        });
    });
}


#pragma mark - LocationViewDelegate

-(void)sendLocationLatitude:(double)latitude longitude:(double)longitude andAddress:(NSString *)address {
    NSDictionary *ext = nil;
    EMMessage *locationMessage = [ChatSendHelper sendLocationLatitude:latitude longitude:longitude address:address toUsername:_conversation.chatter messageType:[self messageType] requireEncryption:NO ext:ext];
    [self addMessage:locationMessage];
}

#pragma mark - call

#pragma mark - ICallManagerDelegate

- (void)callSessionStatusChanged:(EMCallSession *)callSession changeReason:(EMCallStatusChangedReason)reason error:(EMError *)error { //实时通话状态发生变化时的回调
    if (reason == eCallReasonNull) {
        if ([[EMCDDeviceManager sharedInstance] isPlaying]) {
            [self stopAudioPlayingWithChangeCategory:NO];
        }
    }
}


- (BOOL)canRecord {
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending) {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    
    return bCanRecord;
}

#pragma mark - alertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex == 0) { //确认发送查看病历申请
        NSString *message = [NSString stringWithFormat:@"您已发出查阅%@的健康档案的申请",self.title];
        [self sendTextMessage:message ext:@{@"View_information":@(YES)}];
    }
}

@end
