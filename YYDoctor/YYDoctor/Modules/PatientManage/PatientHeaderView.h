//
//  HeaderView.h
//  YYDoctor
//
//  Created by QiuQuan Wu on 15/10/21.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PatientHeaderView, PatientGroup;

@protocol PatientHeaderViewDelegate <NSObject>

- (void)didClickHeaderView:(PatientHeaderView *)headerView;

@end

@interface PatientHeaderView : UITableViewHeaderFooterView

@property (assign, nonatomic) id<PatientHeaderViewDelegate> delegate;
@property (strong, nonatomic) PatientGroup *patientGroup; /*<病人组别模型*/

+ (instancetype)headerViewWithTableView:(UITableView *)tableView;

@end
