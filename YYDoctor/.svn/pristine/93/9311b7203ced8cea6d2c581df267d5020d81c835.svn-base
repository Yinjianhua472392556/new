//
//  PatientListCell.h
//  YYDoctor
//
//  Created by QiuQuan Wu on 15/10/21.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^IconBlock)(UIButton *sender);
@interface PatientListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *iconBtn; /*<头像*/
@property (weak, nonatomic) IBOutlet UILabel *name;     /*<姓名*/
@property (weak, nonatomic) IBOutlet UILabel *remark;   /*<备注*/
@property (weak, nonatomic) IBOutlet UIImageView *genderIcon;/*<性别*/
@property (weak, nonatomic) IBOutlet UILabel *age;      /*<年龄*/
@property (strong, nonatomic) IconBlock iconBlock;

- (void)addIconBlock:(IconBlock)iconBlock;

@end
