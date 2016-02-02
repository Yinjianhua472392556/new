//
//  PatientMessageController.m
//  YYDoctor
//
//  Created by QiuQuan Wu on 15/10/22.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "PatientMessageController.h"
#import "HealthRecordController.h"
#import "ChooseSectionController.h"
#import "PatientList.h"
#import "PatientHttpTool.h"
#import "HUDHelper.h"
#import "LoginInfo.h"
#import "SettingView.h"

@interface PatientMessageController ()<UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *maskView;           //蒙板view
@property (weak, nonatomic) IBOutlet UIView *popView;            //右上角popView
@property (weak, nonatomic) IBOutlet UIImageView *headerIcon;    //头像
@property (weak, nonatomic) IBOutlet UIImageView *genderIcon;    //性别
@property (weak, nonatomic) IBOutlet UILabel *name;              //昵称
@property (weak, nonatomic) IBOutlet UILabel *age;               //年龄
@property (weak, nonatomic) IBOutlet UILabel *account;           //账号

@property (assign, nonatomic) BOOL rightBarSelected;             //记录右上角rightBar选中状态
@property (strong, nonatomic) SettingView *remarkView;          //设置备注view

@end

@implementation PatientMessageController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingFriendData];
    //创建单击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideView)];
    [self.maskView addGestureRecognizer:tap];
    [self addRemarkView];

}

//添加设置备注view
- (void)addRemarkView {
    self.remarkView = [SettingView initWithXib];
    self.remarkView.frame = CGRectMake((HYScreenW-240)/2, -130, 240, 130);
    self.remarkView.titleLab.text = @"设置备注";
    self.remarkView.textField.placeholder = @"请输入备注信息";
    [self.view addSubview:self.remarkView];
    __weak __typeof(self)weakSelf = self;
    [self.remarkView addActionBlock:^(UIButton *sender) {
        if (sender.tag == 0) {
            [weakSelf hideView];
        }else {
            NSInteger friendId = weakSelf.patientData.friendId;
            NSString *descText = weakSelf.remarkView.textField.text;
            [PatientHttpTool modifyPatientRemarkWithFriendId:friendId describe:descText completion:^(id result, NSError *error) {
                if (result) {
                    [weakSelf hideView];
                    [HUDHelper showSuccess:@"设置备注成功"];
                }else {
                    if (error.code == 0) {
                        [HUDHelper showError:@"设置备注失败"];
                    }else {
                        [HUDHelper showError:@"网络错误"];
                    }
                }
            }];
        }
    }];
}

//设置好友信息
- (void)settingFriendData {
    self.name.text = self.patientData.nickName;
    self.age.text = [NSString stringWithFormat:@"%ld岁",  self.patientData.age];
    self.account.text = self.patientData.userName;
    if (self.patientData.gender == 1) {
        self.genderIcon.image = [UIImage imageNamed:@"gender_boy"];
    }else {
        self.genderIcon.image = [UIImage imageNamed:@"gender_girl"];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
   [self hideView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


- (void)keyboardWillShow:(NSNotification *)aNotification {
    NSDictionary *info = [aNotification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect kbRect = [value CGRectValue];
    CGFloat height = kbRect.size.height;
    CGRect frame = self.remarkView.frame;
    if ((HYScreenH-height) < (frame.origin.y+frame.size.height)) {
        [UIView animateWithDuration:0.5 animations:^{
            CGFloat index = (frame.origin.y+frame.size.height)-(HYScreenH-height);
            self.remarkView.frame = CGRectMake(frame.origin.x,frame.origin.y-index-20 , frame.size.width, frame.size.height);
        }];
    }
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.remarkView.frame;
        self.remarkView.frame = CGRectMake((HYScreenW-frame.size.width)/2, (HYScreenH-frame.size.height)/2, frame.size.width, frame.size.height);
    }];
}

- (void)hideView {
    self.maskView.hidden = YES;
    self.popView.hidden = YES;
    self.rightBarSelected = NO;
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.remarkView.frame;
        self.remarkView.frame = CGRectMake((HYScreenW-frame.size.width)/2, -130, frame.size.width, frame.size.height);
    }];
}

//点击右上角barButtonItem对popView,maskView,remarkView进行显示与隐藏操作
- (IBAction)rightBarClick:(UIBarButtonItem *)sender {
    if (self.rightBarSelected == YES) {
        self.maskView.hidden = YES;
        self.popView.hidden = YES;
        
    }else {
        self.maskView.hidden = NO;
        self.popView.hidden = NO;
    }
    self.rightBarSelected = !self.rightBarSelected;
}

//设置备注点击事件
- (IBAction)setRemarkClick:(UIButton *)sender {
    self.maskView.hidden = NO;
    self.popView.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = self.remarkView.frame;
        self.remarkView.frame = CGRectMake((HYScreenW-frame.size.width)/2, (HYScreenH-frame.size.height)/2, frame.size.width, frame.size.height);
    }];
}

//popView对应每一项点击跳转事件
- (IBAction)popViewClick:(UIButton *)sender {
    if (sender.tag == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Patient" bundle:nil];
        ChooseSectionController *choose = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ChooseSectionController class])];
        choose.oldGroupId = self.groupId;
        choose.friendId = self.patientData.friendId;
        choose.tag = 0;
        [self.navigationController pushViewController:choose animated:YES];
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"删除好友" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

//查看健康档案按钮点击跳转事件
- (IBAction)checkHealthRecord:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Patient" bundle:nil];
    HealthRecordController *record = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([HealthRecordController class])];
    [self.navigationController pushViewController:record animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        LoginInfo *loginInfo = [LoginInfo currentLoginInfo];
        NSInteger friendId = self.patientData.friendId;
        [PatientHttpTool deletePatientWithUserId:[loginInfo.userId integerValue] FriendId:friendId completion:^(id result, NSError *error) {
            if (result) {
                [self.navigationController popViewControllerAnimated:YES];
                [HUDHelper showSuccess:@"删除成功"];
            }else {
                if (error.code == 0) {
                    [HUDHelper showError:@"删除失败"];
                }else {
                    [HUDHelper showError:@"网络错误"];
                }
            }
        }];
    }
}



@end
