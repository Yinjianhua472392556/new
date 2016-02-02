//
//  SettingsFooterView.h
//  YYDoctor
//
//  Created by MaxJmac on 15/11/17.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsFooterViewDelegate <NSObject>

- (void)settingsAddTimeClick:(UIButton *)sender;

@end

@interface SettingsFooterView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<SettingsFooterViewDelegate> delegate;

- (IBAction)addTimeClick:(UIButton *)sender;

@end
