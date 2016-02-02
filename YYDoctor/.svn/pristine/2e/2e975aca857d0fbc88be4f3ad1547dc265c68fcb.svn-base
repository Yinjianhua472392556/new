//
//  HeaderView.m
//  YYDoctor
//
//  Created by QiuQuan Wu on 15/10/21.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "PatientHeaderView.h"
#import "PatientGroup.h"

@interface PatientHeaderView ()

@property (strong, nonatomic) UIButton *button;

@end

@implementation PatientHeaderView


//初始化tableview的headerview
+ (instancetype)headerViewWithTableView:(UITableView *)tableView {
    static NSString *headerIdentifier = @"header";
    PatientHeaderView *header = [tableView dequeueReusableCellWithIdentifier:headerIdentifier];
    if (header == nil) {
        header = [[PatientHeaderView alloc] initWithReuseIdentifier:headerIdentifier];
    }
    return header;
}

//在headerview上添加button
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:[UIImage imageNamed:@"headerBg"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"headerArrow"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.imageView.contentMode = UIViewContentModeCenter;
        button.imageView.clipsToBounds = NO;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [button addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        self.button = button;
    }
    return self;
}

//点击按钮触发代理方法，改变open的状态
- (void)headBtnClick:(UIButton *)button {
       self.patientGroup.open = !self.patientGroup.isOpen;
    if ([self.delegate respondsToSelector:@selector(didClickHeaderView:)]) {
        [self.delegate didClickHeaderView:self];
    }
}

//设置组名
- (void)setPatientGroup:(PatientGroup *)patientGroup {
    _patientGroup = patientGroup;
    [self.button setTitle:patientGroup.groupName forState:UIControlStateNormal];
}

//点击按钮的时候改变箭头的方向
- (void)didMoveToSuperview {
    if (self.patientGroup.isOpen) {
        self.button.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }else {
        self.button.imageView.transform = CGAffineTransformMakeRotation(0);
    }
 
}

//设置button的frame
- (void)layoutSubviews {
    [super layoutSubviews];
    self.button.frame = self.bounds;
}


@end
