//
//  PatientManageController.m
//  YYDoctor
//
//  Created by QiuQuan Wu on 15/10/20.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.


#import "PatientManageController.h"
#import "PatientListCell.h"
#import "PatientHeaderView.h"
#import "PatientGroup.h"
#import "PatientList.h"
#import "PatientMessageController.h"
#import "SectionManageController.h"
#import "PatientScanningController.h"
#import "PatientHttpTool.h"
#import "LoginInfo.h"
#import "ChatListModel.h"
#import "ChatController.h"

@interface PatientManageController ()
<UITableViewDataSource,
UITableViewDelegate,
PatientHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *maskView; //蒙板view
@property (weak, nonatomic) IBOutlet UIView *popView;  //右上角popview
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign, nonatomic) BOOL rightBarSelected; //记录rightBarButtonItem选中状态
@property (strong, nonatomic) NSMutableArray *groupDataSource; //分组数组
@property (strong, nonatomic) NSMutableArray *listDataSource;  //分组具体数据
//@property (strong, nonatomic) NSMutableArray *dataSource;
@property (assign, nonatomic) NSInteger groupId;    //分组ID

@end

@implementation PatientManageController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rightBarSelected = NO;
    
    //创建单击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    [self.maskView addGestureRecognizer:tap];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadPatientGroupAndListData];
    [self hideView];
}

//点击maskView，收起popView
- (void)hideView {
    self.popView.hidden = YES;
    self.maskView.hidden = YES;
    self.rightBarSelected = NO;
}

//加载好友分组和列表数据
- (void)loadPatientGroupAndListData {
    LoginInfo *loginInfo = [LoginInfo currentLoginInfo];
    [PatientHttpTool getPatientGroupAndListDataWithUserId:[loginInfo.userId integerValue] completion:^(id result, NSError *error) {
        self.groupDataSource = [NSMutableArray arrayWithArray:result];
        [self.tableView reloadData];
    }];
}

//右上角popview缩展操作
- (IBAction)moreClick:(UIBarButtonItem *)sender {
    [UIView animateWithDuration:1.0 animations:^{
        if (self.rightBarSelected == NO) {
            self.maskView.hidden = NO;
            self.popView.hidden = NO;
            self.rightBarSelected = YES;
        }else {
            self.maskView.hidden = YES;
            self.popView.hidden = YES;
            self.rightBarSelected = NO;
        }
    }];
}

- (IBAction)popViewClick:(UIControl *)sender {
    if (sender.tag == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Patient" bundle:nil];
        SectionManageController *section = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SectionManageController class])];
        [self.navigationController pushViewController:section animated:YES];
    }else if (sender.tag == 1) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Patient" bundle:nil];
        PatientScanningController *scanning = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([PatientScanningController class])];
        [self.navigationController pushViewController:scanning animated:YES];
    }else {
        [self hideView];
    }
}

#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.groupDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PatientGroup *patientGroup = self.groupDataSource[section];
    if (!patientGroup.isOpen) {
        return 0;
    }else{
        return patientGroup.patientList.count;
    }
}

#pragma mark -- UITableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"PatientListCell";
    PatientListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    PatientGroup *group = self.groupDataSource[indexPath.section];
    self.listDataSource = [NSMutableArray array];
    for (NSDictionary *dict in group.patientList) {
        PatientList *list = [[PatientList alloc] initWithDictionary:dict];
        [self.listDataSource addObject:list];
    }
    PatientList *item = self.listDataSource[indexPath.row];
    cell.name.text   = item.nickName;
    cell.remark.text = item.PatDescription;
    cell.age.text    = [NSString stringWithFormat:@"%ld岁", (long)item.age];
    if (item.gender == 1) {
        cell.genderIcon.image = [UIImage imageNamed:@"gender_boy"];
    }else {
        cell.genderIcon.image = [UIImage imageNamed:@"gender_girl"];
    }
    [cell addIconBlock:^(UIButton *sender) {
        //点击头像，跳转到好友详细信息界面
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Patient" bundle:nil];
        PatientMessageController *patientMessage = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([PatientMessageController class])];
        PatientGroup *item = self.groupDataSource[indexPath.section];
        patientMessage.patientData = self.listDataSource[indexPath.row];
        patientMessage.groupId = item.groupId;
        [self.navigationController pushViewController:patientMessage animated:YES];

    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

//点击cell，跳转到聊天界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatListModel *listModel = [[ChatListModel alloc] init];
    PatientList *patientData = self.listDataSource[indexPath.row];
    listModel.userAccount = patientData.userAccount;
    listModel.userName    = patientData.nickName;
    listModel.userPhoto   = patientData.imageURL;
    ChatController *chatVC = [[ChatController alloc] initWithChatter:patientData.userAccount isGroup:NO];
    chatVC.listModel = listModel;
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    PatientHeaderView *headerView = [PatientHeaderView headerViewWithTableView:tableView];
    headerView.delegate = self;
    headerView.patientGroup = self.groupDataSource[section];
    return headerView;
}

//调用HeaderView代理方法，同时刷新tableview
- (void)didClickHeaderView:(PatientHeaderView *)headerView {
    [self.tableView reloadData];
}

@end