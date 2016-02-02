//
//  PatientGroup.h
//  YYDoctor
//
//  Created by QiuQuan Wu on 15/10/21.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatientGroup : NSObject


@property (strong, nonatomic) NSArray *patientList; /**<存放当前组所有的病人信息 */
@property (copy, nonatomic) NSString *groupName; /**<组名 */
@property (assign, nonatomic) NSInteger groupId; /**<组ID */
@property (assign, nonatomic) NSInteger orderNum;/**<分组排序号 */
@property (assign, nonatomic) NSInteger size;
@property (assign, nonatomic, getter=isOpen) BOOL open; /*<记录当前组时候打开 */

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
