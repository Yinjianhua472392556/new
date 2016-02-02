//
//  ConsultationBillModel.m
//  YYDoctor
//
//  Created by apple on 15/10/21.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "ConsultationBillModel.h"

@implementation ConsultationBillModel

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.userId    = dictionary[@"userId"];
        self.userName  = [dictionary[@"userName"] description];
        self.advType   = dictionary[@"advType"];
        self.currCost  = [dictionary[@"currCost"] description];
        self.orderDate = [dictionary[@"orderDate"] description];
    }
    return self;
}

@end
