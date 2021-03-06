//
//  MessageModel.h
//  YYDoctor
//
//  Created by apple on 15/10/25.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KFIRETIME 20

@interface MessageModel : NSObject {
    BOOL _isPlaying;
}

@property (nonatomic) MessageBodyType type;
@property (nonatomic, readonly) MessageDeliveryState status;

@property (nonatomic) BOOL isSender;    //是否是发送者
@property (nonatomic) BOOL isRead;      //是否已读
@property (nonatomic) EMMessageType messageType;  // 消息类型（单聊，群里，聊天室）

@property (nonatomic, strong, readonly) NSString *messageId;
@property (nonatomic, strong) NSURL *headImageURL;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *username;

//text
@property (nonatomic, strong) NSString *content;

//image
@property (nonatomic) CGSize size;
@property (nonatomic) CGSize thumbnailSize;
@property (nonatomic, strong) NSURL *imageRemoteURL;
@property (nonatomic, strong) NSURL *thumbnailRemoteURL;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *thumbnailImage;


//audio
@property (nonatomic, strong) NSString *localPath;
@property (nonatomic, strong) NSString *remotePath;
@property (nonatomic) NSInteger time;
@property (nonatomic, strong) EMChatVoice *chatVoice;
@property (nonatomic) BOOL isPlaying;
@property (nonatomic) BOOL isPlayed;

//location
@property (nonatomic, strong) NSString *address;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@property (nonatomic, strong)id<IEMMessageBody> messageBody;
@property (nonatomic, strong)EMMessage *message;

//自己添加的属性
@property (nonatomic, strong) NSString *chatterName; //后台的名字

@end
