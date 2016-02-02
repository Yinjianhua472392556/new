//
//  ImproveDataViewController.m
//  YYDoctor
//
//  Created by apple on 15/10/21.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "ImproveDataController.h"
#import "ImproveDataCell.h"

@interface ImproveDataController ()
<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation ImproveDataController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = @[@{@"image":@"re2_06",@"placeholder":@"姓名"},
                       @{@"image":@"re2_09",@"placeholder":@"医院"},
                       @{@"image":@"re2_16",@"placeholder":@"科室"},
                       @{@"image":@"re2_18",@"placeholder":@"职称，如:主治医师"},
                       @{@"image":@"re2_20",@"placeholder":@"科室电话，如020-1234567"},
                       @{@"image":@"re2_23",@"placeholder":@"擅长及诊所介绍"}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"ImproveDataCell";
    ImproveDataCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ImproveDataCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.leftImageView.image = [UIImage imageNamed:dict[@"image"]];
    cell.textfield.placeholder = dict[@"placeholder"];
    if (indexPath.row == 2 || indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (IBAction)finishRegister:(id )sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
