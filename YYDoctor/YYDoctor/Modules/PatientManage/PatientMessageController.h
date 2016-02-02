//
//  PatientMessageController.h
//  YYDoctor
//
//  Created by QiuQuan Wu on 15/10/22.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PatientList;

@interface PatientMessageController : UIViewController
@property (strong, nonatomic) PatientList *patientData;  /**<病人好友详细数据*/
@property (assign, nonatomic) NSInteger groupId;         /**<所在分组ID*/
@end

