//
//  PersonalCenterDetalViewController.m
//  YYDoctor
//
//  Created by apple on 15/10/22.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "PersonalInformationController.h"
#import "DoctorPersonalApiTool.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ChooseSectionCell.h"
#import "HUDHelper.h"
#import "LoginInfo.h"

@interface PersonalInformationController ()
<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL cellChoose;
@property (nonatomic, strong) ChooseSectionCell *chooseeCell;
@property (nonatomic, assign) NSInteger states;
@property (nonatomic, strong) LoginInfo *loginInfo;

@end

@implementation PersonalInformationController

#pragma mark - tableViewDelegate 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 60.0f;
        }
    }
    return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else if (section == 1) {
        return 1;
    }else if (section == 2) {
        return 3;
    }else if (section == 3) {
        return 2;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 5.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0) {
        NSArray *titleArray = @[@"头像",@"医生Id",@"二维码名片"];
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setFrame:CGRectMake(0, 0, 35, 30)];
        if (indexPath.row == 0) {
            imageView.image = [UIImage imageNamed:@"UserHeadImage"];
            cell.accessoryView = imageView;
        }else if (indexPath.row == 1) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 20)];
            label.text = [NSString stringWithFormat:@"%@",self.loginInfo.doctorInfo.doctorId];
            label.textAlignment = NSTextAlignmentRight;
            cell.accessoryView = label;
        }else {
            imageView.image = [UIImage imageNamed:@"QRCodeImage"];
            cell.accessoryView = imageView;
        }
        cell.textLabel.text = titleArray[indexPath.row];
        return cell;
        }else if (indexPath.section == 1) {
            cell.textLabel.text = @"账号安全";
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake
                            (0,0,70,20)];
            label.text = @"修改密码";
            label.textAlignment = NSTextAlignmentRight;
            cell.accessoryView = label;
            return cell;
        }else if (indexPath.section == 2){
            NSArray *titleArray = @[@"性别",@"地区",@"所在医院"];
            cell.textLabel.text = titleArray[indexPath.row];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake
                            (0,0,220,20)];
            label.textAlignment = NSTextAlignmentRight;
            if (indexPath.row == 0) {
                if ([self.loginInfo.doctorInfo.gender isEqualToNumber:@1]) {
                    label.text = @"男";
                }else {
                    label.text = @"女";
                }
                cell.accessoryView = label;
            }else if (indexPath.row == 1) {
                label.text = self.loginInfo.doctorInfo.regionName;
                cell.accessoryView = label;
            }else {
                label.text = self.loginInfo.doctorInfo.hospitalName;
                cell.accessoryView = label;
            }
            
        }else if (indexPath.section == 3) {
            static NSString *chooseCell = @"ChooseSectionCell";
            ChooseSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:chooseCell ];
            if (!cell) {
                cell = [[ChooseSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:chooseCell];
            }
            NSArray *array = @[@"在线",@"隐身"];
            cell.textLabel.text = array[indexPath.row];
            if (indexPath.row == 0) {
                if ([self.loginInfo.onlineState isEqualToNumber:@1]) {
                    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sectionCheckMark"]];
                    cell.choose = YES;
                    self.chooseeCell = cell;
                }
            }else if (indexPath.row == 1) {
                if ([self.loginInfo.onlineState isEqualToNumber:@0]) {
                    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sectionCheckMark"]];
                    cell.choose = YES;
                    self.chooseeCell = cell;
                }
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"QRCodeCardController"];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.section == 1) {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"VerificationCodeController"];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.section == 3) {
        ChooseSectionCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.chooseeCell.choose = NO;
        self.chooseeCell.accessoryView = nil;
        if (cell.choose == NO) {
            if (indexPath.row == 0) {
                [self requestDoctorState:@1];
            }else {
                [self requestDoctorState:@0];
            }
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sectionCheckMark"]];
            cell.choose = YES;
        }else {
            cell.accessoryView = nil;
            cell.choose = NO;
        }
        self.chooseeCell = cell;
    }
}
#pragma mark - request
//修改医生在线状态
- (void)requestDoctorState:(NSNumber *)state {
    [DoctorPersonalApiTool modifyDoctorStateWithDoctorId:[self.loginInfo.doctorInfo.doctorId integerValue] onlineState:state completion:^(id result, NSError *error) {
        if (result) {
            self.loginInfo.onlineState = state;
            [LoginInfo saveLoginInfo:self.loginInfo];
            [HUDHelper showMessage:@"状态修改成功"];
        }else {
            if (error.code == 0) {
                [HUDHelper showMessage:@"状态修改不成功"];
            }else {
                [HUDHelper showMessage:@"修改医生状态不成功"];
            }
        }
    }];
}

#pragma mark - lifetime
- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginInfo = [LoginInfo currentLoginInfo];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end