//
//  ConsultationBillModel.h
//  YYDoctor
//
//  Created by apple on 15/10/21.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//
/**
 *  @author 阮武文, 15-10-29 16:10:10
 * 
 *咨询账单Model
 *
 */
#import <Foundation/Foundation.h>

@interface ConsultationBillModel : NSObject

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSNumber *advType;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *currCost;
@property (nonatomic, copy) NSString *orderDate;
@property (nonatomic, copy) NSString *timeCompare;
@property (nonatomic, copy) NSString *monthStr;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
