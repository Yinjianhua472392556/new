//
//  DoctorInfo.m
//  YYDoctor
//
//  Created by MaxJmac on 15/11/21.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "DoctorInfo.h"

NSString *const kDoctorAccountKey = @"DoctorAccount";
NSString *const kNameKey = @"DoctorName";
NSString *const kAvatarKey = @"DoctorAvatar";
NSString *const kPositionKey = @"DoctorPosition";
NSString *const kSectionCodeKey = @"SectionCode";
NSString *const kSectionNameKey = @"SectionName";
NSString *const kDepartmentCodeKey = @"DepartmentCode";
NSString *const kDepartmentNameKey = @"DepartmentName";
NSString *const kHospitalCodeKey = @"HospitalCode";
NSString *const kHospitalNameKey = @"HospitalName";
NSString *const kRegionCodeKey = @"RegionCode";
NSString *const kRegionNameKey = @"RegionName";
NSString *const kDoctorIdKey = @"DoctorId";
NSString *const kGenderKey = @"DoctorGender";

@implementation DoctorInfo

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.account = [dictionary[@"doctorAccount"] description];
        self.name = [dictionary[@"doctorName"] description];
        self.avatar = [dictionary[@"doctorPic"] description];
        self.position = [dictionary[@"doctorPosition"] description];
        self.sectionCode = [dictionary[@"sectionCode"] description];
        self.sectionName = [dictionary[@"sectionName"] description];
        self.departmentCode = [dictionary[@"departmentCode"] description];
        self.departmentName = [dictionary[@"departmentName"] description];
        self.hospitalCode = [dictionary[@"hospitalCode"] description];
        self.hospitalName = [dictionary[@"hospitalName"] description];
        self.regionCode = [dictionary[@"regionCode"] description];
        self.regionName = [dictionary[@"regionName"] description];
        self.doctorId = dictionary[@"docId"];
        self.gender = dictionary[@"doctorSex"];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.account = [aDecoder decodeObjectForKey:kDoctorAccountKey];
        self.name = [aDecoder decodeObjectForKey:kNameKey];
        self.avatar = [aDecoder decodeObjectForKey:kAvatarKey];
        self.position = [aDecoder decodeObjectForKey:kPositionKey];
        self.sectionCode = [aDecoder decodeObjectForKey:kSectionCodeKey];
        self.sectionName = [aDecoder decodeObjectForKey:kSectionNameKey];
        self.departmentCode = [aDecoder decodeObjectForKey:kDepartmentCodeKey];
        self.departmentName = [aDecoder decodeObjectForKey:kDepartmentNameKey];
        self.hospitalCode = [aDecoder decodeObjectForKey:kHospitalCodeKey];
        self.hospitalName = [aDecoder decodeObjectForKey:kHospitalNameKey];
        self.regionCode = [aDecoder decodeObjectForKey:kRegionCodeKey];
        self.regionName = [aDecoder decodeObjectForKey:kRegionNameKey];
        self.doctorId = [aDecoder decodeObjectForKey:kDoctorIdKey];
        self.gender = [aDecoder decodeObjectForKey:kGenderKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.account forKey:kDoctorAccountKey];
    [aCoder encodeObject:self.name forKey:kNameKey];
    [aCoder encodeObject:self.avatar forKey:kAvatarKey];
    [aCoder encodeObject:self.position forKey:kPositionKey];
    [aCoder encodeObject:self.sectionCode forKey:kSectionCodeKey];
    [aCoder encodeObject:self.sectionName forKey:kSectionNameKey];
    [aCoder encodeObject:self.departmentCode forKey:kDepartmentCodeKey];
    [aCoder encodeObject:self.departmentName forKey:kDepartmentNameKey];
    [aCoder encodeObject:self.hospitalCode forKey:kHospitalCodeKey];
    [aCoder encodeObject:self.hospitalName forKey:kHospitalNameKey];
    [aCoder encodeObject:self.regionCode forKey:kRegionCodeKey];
    [aCoder encodeObject:self.regionName forKey:kRegionNameKey];
    [aCoder encodeObject:self.doctorId forKey:kDoctorIdKey];
    [aCoder encodeObject:self.gender forKey:kGenderKey];
}

@end
