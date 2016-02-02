//
//  ConsultListCell.h
//  YYDoctor
//
//  Created by MaxJmac on 15/10/15.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsultListCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *headImageView;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *lastMessageLabel;
@property (nonatomic, weak) IBOutlet UILabel *lastTimeLabel;
@end
