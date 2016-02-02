//
//  OpenServiceViewController.m
//  YYDoctor
//
//  Created by apple on 15/10/21.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "OpenServiceController.h"
#import "OpenServiceCell.h"
#import "YYAPIRequest.h"
#import "LoginInfo.h"
#import "YYConfig.h"

@interface OpenServiceController ()
<UITableViewDataSource,
UITableViewDelegate,
OpenServiceCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;

@end

@implementation OpenServiceController


#pragma mark - request
//   保存医生开通服务信息
- (void)saveServiceRequest:(NSString *)key state:(BOOL)isOn {
    NSString *path = @"CloudDoctor/ws/rest/advService/open";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    LoginInfo *loginInfo = [LoginInfo currentLoginInfo];
    [params setObject:loginInfo.doctorInfo.doctorId forKey:@"docId"];
    [params setObject:@(isOn) forKey:key];
    [YYAPIRequest POST:path params:params completion:^(id response, NSError *error) {
        if (response) {
            
        }else {
            NSLog(@"保存开通信息失败");
        }
    }];
}
//	获取医生开通服务信息
- (void)getOpenServiceRequest {
    NSString *path = @"CloudDoctor/ws/rest/advService/select?";
    LoginInfo *loginInfo = [LoginInfo currentLoginInfo];
    NSDictionary *params = @{@"docId":loginInfo.doctorInfo.doctorId};
    [YYAPIRequest GET:path params:params completion:^(id response, NSError *error) {
        if (response) {
            NSDictionary *dict = response[0];
            NSNumber *freeNumber = dict[@"freeAdv"];
            NSNumber *picNumber  = dict[@"picAdv"];
            NSNumber *phoNumber  = dict[@"phoAdv"];
            NSNumber *vidNumber  = dict[@"vidAdv"];
            NSNumber *addNumber  = dict[@"addRegAdv"];
            self.titleArray = [@[@{@"title":@"免费咨询服务",@"state":freeNumber},
                                 @{@"title":@"图文咨询服务",@"state":picNumber},
                                 @{@"title":@"电话咨询服务",@"state":phoNumber},
                                 @{@"title":@"视频咨询服务",@"state":vidNumber},
                                 @{@"title":@"加号服务",@"state":addNumber}] mutableCopy];
        }
        [self.tableView reloadData];
    }];
}

- (void)serviceOpened:(UISwitch *)sw {
    switch (sw.tag) {
        case 0:
            [self saveServiceRequest:@"freeAdv" state:sw.isOn];
             break;
        case 1:
            [self saveServiceRequest:@"picAdv" state:sw.isOn];
            break;
        case 2:
            [self saveServiceRequest:@"phoAdv" state:sw.isOn];
            break;
        case 3:
            [self saveServiceRequest:@"vidAdv" state:sw.isOn];
            break;
        case 4:
            [self saveServiceRequest:@"addRegAdv" state:sw.isOn];
            break;
    }
}

#pragma mark - tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"OpenService";
    OpenServiceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    NSDictionary *item = self.titleArray[indexPath.row];
    cell.titleLabel.text = item[@"title"];
    if (![item[@"state"] isEqual:[NSNull null]]) {
        cell.openSwitch.on = [item[@"state"] boolValue];
    }
    cell.openSwitch.tag = indexPath.row;
    cell.delegate = self;
    return cell;
}

#pragma mark - lifeTime

- (void)viewWillAppear:(BOOL)animated {
    [self getOpenServiceRequest];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
