//
//  MessageCenterViewController.m
//  YYDoctor
//
//  Created by apple on 15/10/22.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "MessageCenterController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "MessageCell.h"
#import "MessageCenterInfo.h"
#import "YYAPIRequest.h"
#import "DoctorPersonalApiTool.h"
#import "HUDHelper.h"
#import "LoginInfo.h"
#import "PersonalAPIHelper.h"
#import "TimeHelper.h"

@interface MessageCenterController ()
<UITableViewDataSource,
UITableViewDelegate,
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;//消息类型
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//姓名
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;//性别
@property (weak, nonatomic) IBOutlet UILabel *visitLabel;//预约时间
@property (weak, nonatomic) IBOutlet UILabel *shiftTypeLabel;//班别类型
@property (weak, nonatomic) IBOutlet UIView *popView;//右上角弹出view
@property (weak, nonatomic) IBOutlet UIView *maskView;//覆盖view
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bookinginformationPopView;//显示挂号信息view
@property (weak, nonatomic) IBOutlet UIButton *registrationButton;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;//同意按钮
@property (weak, nonatomic) IBOutlet UIButton *refuseButton;//拒绝按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bookInformationHeightConstraints;

@property (nonatomic, strong) NSMutableArray *dataSource;//数据源
@property (nonatomic, assign) BOOL popViewSelected;
@property (nonatomic, strong) NSNumber *messageId;

@end

@implementation MessageCenterController

#pragma mark - IBAction

- (IBAction)sureClick:(UIButton *)sender {
    if ([self.agreeButton.titleLabel.text isEqualToString:@"同意加号"]) {
        [self agreePlusRequest];
        [self.dataSource removeObjectAtIndex:sender.tag];
        [self.tableView reloadData];
        self.maskView.hidden = YES;
        self.bookinginformationPopView.hidden = YES;
    }else {
        self.maskView.hidden = YES;
        self.bookinginformationPopView.hidden = YES;
    }
}

- (IBAction)backClick:(UIButton *)sender {
    if ([self.refuseButton.titleLabel.text isEqualToString:@"拒绝加号"]) {
        [self refusePlusRequest];
        [self.dataSource removeObjectAtIndex:sender.tag];
        [self.tableView reloadData];
        self.maskView.hidden = YES;
        self.bookinginformationPopView.hidden = YES;
    }else {
        self.maskView.hidden = YES;
        self.bookinginformationPopView.hidden = YES;
    }
}

- (IBAction)bookingTpyeClick:(UIButton *)sender {
    [self.dataSource removeAllObjects];
    NSInteger tag = sender.tag;
    if (tag == 101) {
        [self addTipsRequest];
        [self plusRecordRequest];
        [self registrationRecordRequest];
    }else if (tag == 102) {
        [self addTipsRequest];
    }else if (tag == 103) {
        [self plusRecordRequest];
    }else if (tag == 104) {
        [self registrationRecordRequest];
    }
    [self.tableView reloadData];
    self.popView.hidden = YES;
    self.maskView.hidden = YES;
    self.popViewSelected = NO;
}

- (IBAction)bookingType:(id)sender {
    if (!self.popViewSelected) {
        self.popView.hidden  = NO;
        self.maskView.hidden = NO;
        self.popViewSelected = YES;
    }else {
        self.popView.hidden  = YES;
        self.maskView.hidden = YES;
        self.popViewSelected = NO;
    }
}

#pragma mark - Lifetime

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.popView.hidden = YES;
    self.maskView.hidden = YES;
    self.bookinginformationPopView.hidden = YES;
    self.popViewSelected = NO;
    self.dataSource = [NSMutableArray array];
    [self addTipsRequest];
    [self plusRecordRequest];
    [self registrationRecordRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 单击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide:)];
    [self.maskView addGestureRecognizer:tap];
    self.tableView.tableFooterView = [UIView new];
}

//点击view隐藏弹出视图
- (void)hide:(UITapGestureRecognizer *)tapgesture {
    self.maskView.hidden = YES;
    self.popView.hidden  = YES;
    self.bookinginformationPopView.hidden = YES;
    self.popViewSelected = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - request
//同意加号
- (void)agreePlusRequest {
    [DoctorPersonalApiTool agreeOrRefusePlusWithMessageId:[self.messageId integerValue] state:1 completion:^(id result, NSError *error) {
        if (result) {
            [HUDHelper showMessage:@"同意加号成功"];
        }else {
            if (error.code == 0) {
                [HUDHelper showMessage:@"同意加号不成功"];
            }else {
                [HUDHelper showMessage:@"抱歉！网络不可用"];
            }
        }
    }];
}

//拒绝加号
- (void)refusePlusRequest {
    [DoctorPersonalApiTool agreeOrRefusePlusWithMessageId:[self.messageId integerValue] state:2 completion:^(id result, NSError *error) {
        if (result) {
            [HUDHelper showMessage:@"拒绝加号成功"];
        }else {
            if (error.code == 0) {
                [HUDHelper showMessage:@"拒绝加号不成功"];
            }else {
                [HUDHelper showMessage:@"抱歉！网络不可用"];
            }
        }
    }];
}

//加号记录数据请求
- (void)plusRecordRequest {
    LoginInfo *loginInfo = [LoginInfo currentLoginInfo];
    [PersonalAPIHelper requestPlusRecord:loginInfo.doctorInfo.doctorId completion:^(id response, NSError *error) {
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dict in response) {
            MessageCenterInfo *info = [[MessageCenterInfo alloc] initWithDictionary:dict];
            info.type = @4;
            [dataArray addObject:info];
        }
        [self.dataSource addObjectsFromArray:dataArray];
        [self.tableView reloadData];
    }];
}
//加号提示数据请求
- (void)addTipsRequest {
    LoginInfo *loginInfo = [LoginInfo currentLoginInfo];
    [PersonalAPIHelper requestPlusTips:loginInfo.doctorInfo.doctorId completion:^(id response, NSError *error) {
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dict in response) {
            MessageCenterInfo *info = [[MessageCenterInfo alloc] initWithDictionary:dict];
            info.type = 0;
            [dataArray addObject:info];
        }
        [self.dataSource addObjectsFromArray:dataArray];
        [self.tableView reloadData];
    }];
}
//挂号记录数据请求
- (void)registrationRecordRequest {
    LoginInfo *loginInfo = [LoginInfo currentLoginInfo];
    [PersonalAPIHelper requestBookingRecord:loginInfo.doctorInfo.doctorId completion:^(id response, NSError *error) {
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dict in response) {
            MessageCenterInfo *info = [[MessageCenterInfo alloc] initWithDictionary:dict];
            info.type = @1;
            [dataArray addObject:info];
        }
        [self.dataSource addObjectsFromArray:dataArray];
        [self.tableView reloadData];
    }];
}

#pragma mark - EmptyDataDelegate

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    UIImage *image = [UIImage imageNamed:@"EmptyDataSet"];
    return image;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:18.0],NSForegroundColorAttributeName:[UIColor blackColor]};
    NSAttributedString *string = [[NSAttributedString alloc]initWithString:@"暂无内容" attributes:attribute];
    return string;
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *messageCell = @"MessageCell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:messageCell];
    [self configCell:cell indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.bookinginformationPopView.hidden = NO;
    self.maskView.hidden = NO;
    self.popView.hidden = YES;
    self.popViewSelected = NO;
    
    MessageCenterInfo *info = self.dataSource[indexPath.row];
    NSInteger type = [info.type integerValue];
    if (type == 0) {
        self.messageId = info.messageId;
        self.typeLabel.text = @"加号提示";
        self.nameLabel.text = [NSString stringWithFormat:@"申请人: %@",info.userName];
        self.visitLabel.text = [NSString stringWithFormat:@"预约时间: %@",info.time];
        NSString *sex = [info.userSex isEqual: @1]?@"男":@"女";
        self.sexLabel.text = sex;
        self.agreeButton.hidden = NO;
        self.refuseButton.hidden = NO;
        [self.agreeButton setTitle:@"同意加号" forState:UIControlStateNormal];
        [self.refuseButton setTitle:@"拒绝加号" forState:UIControlStateNormal];
        self.bookInformationHeightConstraints.constant = 195;
        NSString *whenInDay = [info.shiftType isEqual:@1]?@"上午":@"下午";
        self.shiftTypeLabel.text = whenInDay;
    }else if (type == 1) {
        self.typeLabel.text = @"挂号记录";
        self.agreeButton.hidden = YES;
        self.refuseButton.hidden = YES;
        self.bookInformationHeightConstraints.constant = 142;
        self.nameLabel.text = [NSString stringWithFormat:@"申请人: %@",info.patName];
        self.visitLabel.text = [NSString stringWithFormat:@"预约时间: %@",info.schDate];
        NSString *sex = [info.userSex isEqual:@1]?@"男":@"女";
        self.sexLabel.text = sex;
    }else if (type == 4) {
        self.typeLabel.text = @"加号记录";
        self.agreeButton.hidden = YES;
        self.refuseButton.hidden = YES;
        self.bookInformationHeightConstraints.constant = 142;
        self.nameLabel.text = [NSString stringWithFormat:@"申请人: %@",info.userName];
        self.visitLabel.text = [NSString stringWithFormat:@"预约时间: %@",info.time];
        NSString *sex = [info.userSex isEqual:@1]?@"男":@"女";
        self.sexLabel.text = sex;
        NSString *whenInDay = [info.shiftType isEqual:@1]?@"上午":@"下午";
        self.shiftTypeLabel.text = whenInDay;
    }
}

- (void)configCell:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    MessageCenterInfo *info = self.dataSource[indexPath.row];
    MessageCell *messageCell = (MessageCell *)cell;
    NSInteger type = [info.type integerValue];
    if (type == 0) {
        messageCell.userNameLabel.text = info.userName;
        messageCell.timeLabel.text = info.time;
        messageCell.feeLabel.hidden = YES;
        messageCell.feeDetailLabel.hidden = YES;
        messageCell.bookingTypeLabel.text = @"加号提示";
    }else if (type == 1) {
        messageCell.userNameLabel.text = info.patName;
        messageCell.timeLabel.text = info.schDate;
        messageCell.feeLabel.hidden = NO;
        messageCell.feeDetailLabel.hidden = NO;
        messageCell.feeLabel.text = [NSString stringWithFormat:@"%@元",info.schRegfee];
        messageCell.bookingTypeLabel.text = @"挂号记录";
    }else if (type == 4) {
        messageCell.bookingTypeLabel.text = @"加号记录";
        messageCell.userNameLabel.text = info.userName;
        messageCell.timeLabel.text = info.time;
        messageCell.feeLabel.hidden = YES;
        messageCell.feeDetailLabel.hidden = YES;
    }
}
@end
