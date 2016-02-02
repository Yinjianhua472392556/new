//
//  SettingsHeaderView.h
//  YYDoctor
//
//  Created by MaxJmac on 15/11/17.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsHeaderViewDelegate <NSObject>

- (void)settingsTimeSaveClick:(UIButton *)sender;

@end

@interface SettingsHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<SettingsHeaderViewDelegate> delegate;

- (IBAction)onTimeSaveClick:(UIButton *)sender;

@end
