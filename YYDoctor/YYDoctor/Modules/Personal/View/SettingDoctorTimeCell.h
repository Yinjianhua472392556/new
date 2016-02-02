//
//  SettingDoctorTimeCell.h
//  YYDoctor
//
//  Created by apple on 15/11/3.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SettingDoctorTimeCellDelegate <NSObject>

- (void)beginTimeClick:(UIButton *)sender;
- (void)endTimeClick:(UIButton *)sender;

@end

@interface SettingDoctorTimeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *beginTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *endTimeButton;

@property (nonatomic, assign)id <SettingDoctorTimeCellDelegate> delegate;

- (IBAction)onBeginTimeClick:(UIButton *)sender;
- (IBAction)onEndTimeClick:(UIButton *)sender;

@end
