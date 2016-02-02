//
//  PaidChatListModel.h
//  YYDoctor
//
//  Created by apple on 15/11/6.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.


/**
 *  @author 尹建华, 15-11-06 09:11:19
 *
 * 单个用户信息
 *
 */

#import <Foundation/Foundation.h>
#import "EMConversation.h"

@interface PaidChatListModel : NSObject
//@property (nonatomic, strong) EMConversation *conversation; //该用户对应的环信对话列表
@property (nonatomic, copy) NSString *userAccount;//帐号
@property (nonatomic, copy) NSString *userAddress; //地址
@property (nonatomic, copy) NSString *userEmail; //用户邮箱
@property (nonatomic, copy) NSString *userIdcard; //用户身份证
@property (nonatomic, copy) NSString *userMobile; //手机号
@property (nonatomic, copy) NSString *userName; //用户名称
@property (nonatomic, copy) NSString *patientID; //本人的患者信息号
@property (nonatomic, copy) NSString *userPic; //头像
@end
