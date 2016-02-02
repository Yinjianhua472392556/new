//
//  ConsultationBillCell.h
//  YYDoctor
//
//  Created by apple on 15/10/21.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConsultationBillCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *consultationTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *singleTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;

@end
