//
//  PatientListCell.m
//  YYDoctor
//
//  Created by QiuQuan Wu on 15/10/21.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "PatientListCell.h"

@implementation PatientListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)iconClick:(UIButton *)sender {
    if (self.iconBlock) {
        self.iconBlock(sender);
    }
}

- (void)addIconBlock:(IconBlock)iconBlock {
    self.iconBlock = iconBlock;
}

@end
