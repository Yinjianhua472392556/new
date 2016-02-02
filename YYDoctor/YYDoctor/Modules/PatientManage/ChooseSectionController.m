//
//  ChooseSectionController.m
//  YYDoctor
//
//  Created by QiuQuan Wu on 15/10/22.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "ChooseSectionController.h"
#import "ChooseSectionCell.h"
#import "PatientGroup.h"
#import "PatientHttpTool.h"
#import "HUDHelper.h"
#import "LoginInfo.h"
#import "ChatListModel.h"


@interface ChooseSectionController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) ChooseSectionCell *selectedCell;
@property (strong, nonatomic) NSMutableArray *groupIdArray;      //存放选中cell对应的分组ID数组
@property (strong, nonatomic) NSMutableArray *groupParamArray;   //存放选中分组ID的字典模型数组

@end

@implementation ChooseSectionController

//移动好友到新的分组
- (void)moveFriendToNewGroups {
    NSInteger friendId = self.friendId;
    [self.groupParamArray removeAllObjects];
    //遍历分组ID数组，添加到字典模型数组
    for (int i = 0; i < self.groupIdArray.count; i++) {
        NSInteger groupId = [self.groupIdArray[i] integerValue];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@(groupId),@"groupId", nil];
        [self.groupParamArray addObject:dict];
    }
    //把字典模型数组装化为json格式的数据
    NSData *groupData = [self toJSONData:self.groupParamArray];
    NSString *groupParam = [[NSString alloc] initWithData:groupData encoding:NSUTF8StringEncoding];
    LoginInfo *loginInfo = [LoginInfo currentLoginInfo];
    [PatientHttpTool movePatientToNewGroupWithFriendId:friendId userId:[loginInfo.userId integerValue] groupParam:groupParam completion:^(id result, NSError *error) {
        if (result) {
            [HUDHelper showSuccess:@"成功移动好友到新分组"];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            if (error.code == 0) {
                [HUDHelper showError:@"移动好友失败"];
            }else {
                [HUDHelper showError:@"网络错误"];
            }
        }
    }];
}

//添加好友（从聊天界面跳转过来进行的操作）
- (void)addNewFriend {
    //遍历分组ID数组，添加到字典模型数组
    for (int i = 0; i < self.groupIdArray.count; i++) {
        NSInteger groupId = [self.groupIdArray[i] integerValue];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@(groupId),@"groupId", nil];
        [self.groupParamArray addObject:dict];
    }
    //把字典模型数组装化为json格式的数据
    NSData *groupData = [self toJSONData:self.groupParamArray];
    NSString *groupParam = [[NSString alloc] initWithData:groupData encoding:NSUTF8StringEncoding];
    LoginInfo *loginInfo = [LoginInfo currentLoginInfo];
    NSDictionary *params = @{@"groupParam":groupParam,
                             @"image":self.chatModel.userPhoto,
                             @"nickName":self.chatModel.userName,
                             @"desc":@"暂无描述",
                             @"userName":@"",
                             @"dUserId":loginInfo.userId,
                             @"pUserId":self.chatModel.userId};
    [PatientHttpTool addNewFriend:params completion:^(id result, NSError *error) {
        if (!result) {
            [HUDHelper showError:error.description];
            return;
        }
        NSInteger code = [result[@"code"] integerValue];
        if (code == 1) {
            [HUDHelper showSuccess:@"添加成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [HUDHelper showError:@"添加失败"];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSectionData];
    self.groupIdArray    = [NSMutableArray array];
    self.groupParamArray = [NSMutableArray array];
}

//加载分组数据
- (void)loadSectionData {
    LoginInfo *loginInfo = [LoginInfo currentLoginInfo];
    [PatientHttpTool getPatientGroup:loginInfo.userId completion:^(id result, NSError *error) {
        if (result) {
            self.dataSource = [NSMutableArray arrayWithArray:result];
            [self.tableView reloadData];
        }else {
            [HUDHelper showError:error.description];
        }
    }];
}

//好友移动到分组完成点击事件
- (IBAction)finishMoveToNewGroup:(UIBarButtonItem *)sender {
    if (self.tag == 0) {
        [self moveFriendToNewGroups];
    }else {
        [self addNewFriend];
    }
}

#pragma mark -- UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

#pragma mark -- UITableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ChooseSectionCell";
    ChooseSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    PatientGroup *item = self.dataSource[indexPath.row];
    cell.title.text = item.groupName;
    cell.choose = NO;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChooseSectionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    PatientGroup *group = self.dataSource[indexPath.row];
    NSString *groupId = [NSString stringWithFormat:@"%tu", group.groupId];
    if (cell.choose == NO) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sectionCheckMark"]];
        cell.choose = YES;
        [self.groupIdArray addObject:groupId];
        
    }else {
        cell.accessoryView = nil;
        cell.choose = NO;
        [self.groupIdArray removeObject:groupId];
    }
}

//把对象转化为JSON数据格式
- (NSData *)toJSONData:(id)theData{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if ([jsonData length] > 0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

@end