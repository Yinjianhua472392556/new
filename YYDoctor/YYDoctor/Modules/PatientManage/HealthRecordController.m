//
//  HealthRecordController.m
//  YYDoctor
//
//  Created by QiuQuan Wu on 15/10/22.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "HealthRecordController.h"
#import "HealthRecordCell.h"

@interface HealthRecordController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation HealthRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = [@[@[@{@"title":@"血常规检查"},@{@"title":@"肝功四项"},@{@"title":@"B超"}],
                       @[@{@"title":@"B超"},@{@"title":@"血常规检查"},@{@"title":@"肝功四项"}],
                       @[@{@"title":@"肝功四项"},@{@"title":@"B超"},@{@"title":@"血常规检查"}]]mutableCopy];
}

#pragma mark -- UITableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *item = self.dataSource[section];
    return item.count;
}

#pragma mark -- UITableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HealthRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HealthRecordCell class])];
    NSDictionary *item = self.dataSource[indexPath.section][indexPath.row];
    cell.title.text = item[@"title"];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"2015-09-15";
    }else if (section == 1) {
        return @"2015-08-15";
    }else {
        return @"2015-07-15";
    }
}

@end
