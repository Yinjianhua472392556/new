//
//  ModifyPadController.m
//  YYDoctor
//
//  Created by apple on 15/11/2.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "ModifyPadController.h"
#import "PersonalAPIHelper.h"
#import "HUDHelper.h"
#import "LoginInfo.h"

@interface ModifyPadController ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *oldTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextFiled;
@property (nonatomic, weak) IBOutlet UITextField *confirmTextFiled;

- (IBAction)onChangePasswordClick:(id)sender;

@end

@implementation ModifyPadController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.oldTextField resignFirstResponder];
    [self.passwordTextFiled resignFirstResponder];
    [self.confirmTextFiled resignFirstResponder];
}

- (BOOL)isPasswordValid:(NSString *)password {
    NSString *passwordRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *passwordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passwordRegex];
    return [passwordPredicate evaluateWithObject:password];
}

#pragma mark - IBAciton

- (IBAction)onChangePasswordClick:(id)sender {
    NSString *oldPassword = self.oldTextField.text;
    BOOL isNewPasswordValid = [self isPasswordValid:self.passwordTextFiled.text];
    BOOL isConfirmPasswordValid = [self isPasswordValid:self.confirmTextFiled.text];
    if (oldPassword.length == 0 || self.passwordTextFiled.text.length == 0 || self.confirmTextFiled.text.length == 0) {
        [HUDHelper showMessage:@"请填写完整信息" toView:self.view];
        return;
    }
    if (!isNewPasswordValid||!isConfirmPasswordValid) {
        [HUDHelper showMessage:@"密码格式不正确" toView:self.view];
        return;
    }
    if (![self.passwordTextFiled.text isEqualToString:self.confirmTextFiled.text]) {
        [HUDHelper showMessage:@"两次密码输入不一致" toView:self.view];
        return;
    }
    [self modityPasswordRequest];
}

- (void)modityPasswordRequest {
    LoginInfo *loginInfo = [LoginInfo currentLoginInfo];
    [PersonalAPIHelper modifyPassword:loginInfo.userId
                          oldPassword:self.oldTextField.text
                          newPassword:self.passwordTextFiled.text
                      confirmPassword:self.confirmTextFiled.text completion:^(id response, NSError *error) {
                          if (response) {
                              NSLog(@"%@",response);
                              [HUDHelper showSuccess:@"修改成功"];
                          }else {
                              NSLog(@"%@",error);
                              [HUDHelper showError:@"修改失败"];
                          }
                      }];

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Lifetime

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
