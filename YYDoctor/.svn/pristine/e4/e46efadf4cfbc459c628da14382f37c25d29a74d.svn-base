//
//  OpenServiceCell.h
//  YYDoctor
//
//  Created by apple on 15/10/21.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OpenServiceCellDelegate <NSObject>

- (void)serviceOpened:(UISwitch *)sw;

@end

@interface OpenServiceCell : UITableViewCell

@property (nonatomic, assign)id <OpenServiceCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UISwitch *openSwitch;

- (IBAction)openService:(UISwitch *)sender;

@end
