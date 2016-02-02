//
//  PatientHttpTool.m
//  YYDoctor
//
//  Created by QiuQuan Wu on 15/10/29.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "PatientHttpTool.h"
#import "YYAPIRequest.h"
#import "PatientGroup.h"
#import "PatientList.h"
#import "YYConfig.h"
#import <AFNetworking.h>

@implementation PatientHttpTool
//JavaBridgeTemplate621/api/app/
//获取病人分组数据
+ (void)getPatientGroup:(NSNumber *)userId completion:(completionBlock)completion {
    NSString *path = @"JavaBridgeTemplate621/api/app/chatgroup/list";
    [YYAPIRequest GET:path params:@{@"userId":userId} completion:^(id response, NSError *error) {
        if (!response) {
            completion(response, error);
            return;
        }
        NSMutableArray *groupArray = [NSMutableArray array];
        if ([response isKindOfClass:[NSDictionary class]]) {
            PatientGroup *group = [[PatientGroup alloc] initWithDictionary:response];
            [groupArray addObject:group];
        }else {
            NSArray *array = (NSArray *)response;
            for (NSDictionary *dict in array) {
                PatientGroup *group = [[PatientGroup alloc] initWithDictionary:dict];
                [groupArray addObject:group];
            }
        }
        completion(groupArray, error);
    }];
}

//新增一个好友分组
+ (void)addNewPatientGroup:(NSDictionary *)params completion:(completionBlock)completion {
    NSString *path = @"JavaBridgeTemplate621/api/app/chatgroup/add";
    [YYAPIRequest POST:path params:params completion:^(id response, NSError *error) {
        completion(response, error);
    }];
}

//删除一个好友分组
+ (void)deletePatientGroupWithGroupId:(NSInteger)groupId
                       defaultGroupId:(NSInteger)defaultGroupId
                           completion:(completionBlock)completion {
    NSString *path = [NSString stringWithFormat:@"JavaBridgeTemplate621/api/app/chatgroup/%tu/%tu", groupId, defaultGroupId];
    NSDictionary *params = @{@"groupId":@(groupId),
                             @"defaultGroupId":@(defaultGroupId)};
    [YYAPIRequest DELETE:path params:params completion:^(NSDictionary *response, NSError *error) {
        completion(response, error);
    }];
}

//修改病人好友备注
+ (void)modifyPatientRemarkWithFriendId:(NSInteger)friendId
                              describe:(NSString *)describe
                            completion:(completionBlock)completion {
    NSString *path = [NSString stringWithFormat:@"JavaBridgeTemplate621/api/app/friend/modify/%tu", friendId];
    NSDictionary *params = @{@"friendId":@(friendId),
                             @"description":describe};
    [YYAPIRequest PUT:path params:params completion:^(NSDictionary *response, NSError *error) {
        completion(response, error);
    }];
}

//移动好友到其它分组
+ (void)movePatientToNewGroupWithFriendId:(NSInteger)friendId
                                   userId:(NSInteger)userId
                               groupParam:(NSString *)groupParam
                               completion:(completionBlock)completion {
    NSString *path = [NSString stringWithFormat:@"JavaBridgeTemplate621/api/app/friend/alter/%tu/%tu", userId, friendId];
    NSDictionary *params = @{@"userId":@(userId),
                             @"friendId":@(friendId),
                             @"groupParam":groupParam};
    [YYAPIRequest PUT:path params:params completion:^(NSDictionary *response, NSError *error) {
        completion(response, error);
    }];
}

//获取好友分组及好友列表
+ (void)getPatientGroupAndListDataWithUserId:(NSInteger)userId
                                  completion:(completionBlock)completion {
    NSString *path = @"JavaBridgeTemplate621/api/app/chatgroup/list/groupfriend";
    NSDictionary *params = @{@"userId":@(userId)};
    [YYAPIRequest GET:path params:params completion:^(id response, NSError *error) {
        NSMutableArray *groupArray = [NSMutableArray array];
        if ([response isKindOfClass:[NSDictionary class]]) {
            PatientGroup *group = [[PatientGroup alloc] initWithDictionary:response];
            [groupArray addObject:group];
            completion(groupArray, error);
        }else {
            NSArray *array = (NSArray *)response;
            for (NSDictionary *dict in array) {
                PatientGroup *group = [[PatientGroup alloc] initWithDictionary:dict];
                [groupArray addObject:group];
            }
            completion(groupArray, error);
        }
    }];
}

//删除病人好友
+ (void)deletePatientWithUserId:(NSInteger)userId
                       FriendId:(NSInteger)friendId
                     completion:(completionBlock)completion {
    NSString *path = [NSString stringWithFormat:@"JavaBridgeTemplate621/api/app/friend/delete/%tu/%tu", userId, friendId];
    NSDictionary *params = @{@"userId":@(userId),
                             @"friendId":@(friendId)};
    [YYAPIRequest DELETE:path params:params completion:^(NSDictionary *response, NSError *error) {
        completion(response, error);
    }];
}

//病人好友分组重命名
+ (void)modifyGroupNameWithUserId:(NSInteger)userId
                     groupNameOld:(NSString *)groupNameOld
                     groupNameNew:(NSString *)groupNameNew
                       completion:(completionBlock)completion {
    NSString *path = [NSString stringWithFormat:@"JavaBridgeTemplate621/api/app/chatgroup/update/%tu", userId];
    NSDictionary *params = @{@"userId":@(userId),
                             @"groupNameOld":groupNameOld,
                             @"groupNameNew":groupNameNew};
    [YYAPIRequest PUT:path params:params completion:^(NSDictionary *response, NSError *error) {
        completion(response, error);
    }];
}

//添加好友
+ (void)addNewFriend:(NSDictionary *)params
          completion:(completionBlock)completion {
    NSString *path = @"JavaBridgeTemplate621/api/app/friend";
    [YYAPIRequest POST:path params:params completion:^(id response, NSError *error) {
        NSDictionary *result = response[@"Result"];
        completion(result, error);
    }];
}

//修改分组排序
+ (void)modifyGroupSort:(NSDictionary *)params
             completion:(completionBlock)completion {
    NSString *path = @"JavaBridgeTemplate621/api/app/chatgroup/orderNum";
    [YYAPIRequest POST:path params:params completion:^(id response, NSError *error) {
        NSDictionary *result = response[@"Result"];
        completion(result, error);
    }];
}

@end
