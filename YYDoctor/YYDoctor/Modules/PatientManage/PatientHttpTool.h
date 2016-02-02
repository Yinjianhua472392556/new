//
//  PatientHttpTool.h
//  YYDoctor
//
//  Created by QiuQuan Wu on 15/10/29.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SuccessBlock)(id result);
typedef void(^FailureBlock) (NSError *error);
typedef void(^completionBlock)(id result, NSError *error);

@interface PatientHttpTool : NSObject

/**
 *  @author 叶辉翔, 15-12-23 17:12:24
 *
 *  获取病人分组数据
 *
 *  @param userId     用户ID
 *  @param completion
 */
+ (void)getPatientGroup:(NSNumber *)userId
             completion:(completionBlock)completion;

/**
 *  @author 叶辉翔, 15-12-23 17:12:47
 *
 *  新增一个好友分组
 *
 *  @param params     参数
 *  @param completion
 */
+ (void)addNewPatientGroup:(NSDictionary *)params
                completion:(completionBlock)completion;

/**
 *  @author 伍秋权, 15-10-30 08:10:25
 *
 *  删除一个好友分组
 *
 *  @param params  参数字典
 *  @param success
 *  @param failure
 */
+ (void)deletePatientGroupWithGroupId:(NSInteger)groupId
                       defaultGroupId:(NSInteger)defaultGroupId
                           completion:(completionBlock)completion;

/**
 *  @author 伍秋权, 15-10-30 11:10:55
 *
 *  修改病人好友备注
 *
 *  @param friendId 好友ID
 *  @param describe 备注描述
 *  @param success
 *  @param failure  
 */
+ (void)modifyPatientRemarkWithFriendId:(NSInteger)friendId
                               describe:(NSString *)describe
                             completion:(completionBlock)completion;

/**
 *  @author 伍秋权, 15-10-30 15:10:36
 *
 *  移动好友到其它分组
 *
 *  @param friendId   好友ID
 *  @param groupIdOld 原分组ID
 *  @param groupIdNew 新的分组ID
 *  @param success
 *  @param failure    
 */
+ (void)movePatientToNewGroupWithFriendId:(NSInteger)friendId
                                   userId:(NSInteger)userId
                               groupParam:(NSString *)groupParam
                               completion:(completionBlock)completion;

/**
 *  @author 伍秋权, 15-10-30 20:10:50
 *
 *  获取好友分组及好友列表
 *
 *  @param userId  用户登录ID
 *  @param success
 *  @param failure 
 */
+ (void)getPatientGroupAndListDataWithUserId:(NSInteger)userId
                                  completion:(completionBlock)completion;

/**
 *  @author 伍秋权, 15-10-31 08:10:31
 *
 *  删除病人好友
 *
 *  @param friendId 好友ID
 *  @param success
 *  @param failure  
 */
+ (void)deletePatientWithUserId:(NSInteger)userId
                       FriendId:(NSInteger)friendId
                     completion:(completionBlock)completion;

/**
 *  @author 伍秋权, 15-10-31 11:10:02
 *
 *  病人好友分组重命名
 *
 *  @param userId       用户登录ID
 *  @param groupNameOld 原分组名
 *  @param groupNameNew 新的分组名
 *  @param success      
 *  @param failure
 */
+ (void)modifyGroupNameWithUserId:(NSInteger)userId
                     groupNameOld:(NSString *)groupNameOld
                     groupNameNew:(NSString *)groupNameNew
                       completion:(completionBlock)completion;

/**
 *  @author 叶辉翔, 15-12-24 09:12:52
 *
 *  添加好友
 *
 *  @param params
 *  @param completion
 */
+ (void)addNewFriend:(NSDictionary *)params
          completion:(completionBlock)completion;

/**
 *  @author 叶辉翔, 15-12-24 10:12:09
 *
 *  修改分组排序
 *
 *  @param params
 *  @param completion
 */
+ (void)modifyGroupSort:(NSDictionary *)params
             completion:(completionBlock)completion;


@end
