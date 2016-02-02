//
//  RegisterterViewController.m
//  YYDoctor
//
//  Created by apple on 15/10/21.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "RegisterController.h"
#import "ImproveDataController.h"
#import "PersonalCenterController.h"

@interface RegisterController ()

- (IBAction)onNextStepClick:(id)sender;

@end

@implementation RegisterController


- (IBAction)onNextStepClick:(id)sender {
    ImproveDataController *dvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ImproveDataController"];
    [self.navigationController pushViewController:dvc animated:YES];
}

#pragma mark - lifeTime
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
