//
//  QRCodeCardController.m
//  YYDoctor
//
//  Created by apple on 15/11/26.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "QRCodeCardController.h"
#import "LoginInfo.h"

@interface QRCodeCardController ()

@property (weak, nonatomic) IBOutlet UILabel *doctorName;
@property (weak, nonatomic) IBOutlet UILabel *hospitalName;
@property (weak, nonatomic) IBOutlet UIImageView *doctorHeadImageView;

@end

@implementation QRCodeCardController

- (void)DoctorInformation {
    LoginInfo *loginInfo = [LoginInfo currentLoginInfo];
    self.doctorName.text = loginInfo.doctorInfo.name;
    self.hospitalName.text = loginInfo.doctorInfo.hospitalName;
    self.doctorHeadImageView.image = [UIImage imageNamed:@"UserHeadImage"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self DoctorInformation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
