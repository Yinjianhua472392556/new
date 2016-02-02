//
//  ConsultDetailsController.m
//  YYDoctor
//
//  Created by apple on 15/11/3.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "ConsultDetailsController.h"
#import "ChatController.h"

@interface ConsultDetailsController()
//个人信息
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *genderLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;
@property (weak, nonatomic) IBOutlet UILabel *depatLabel;
//问题详情
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

//图片
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (nonatomic, assign) BOOL spreadOut;
@end

@implementation ConsultDetailsController
- (void)viewDidLoad {
    self.title = @"咨询详情";
    self.detailLabel.text = self.model.quesDetail;
    self.detailLabel.numberOfLines = 1;
    self.nameLabel.text = self.model.userName;
}

- (IBAction)answerBtnAction {
    ChatController *chatVC = [[ChatController alloc]
                              initWithChatter:self.model.userAccount isGroup:NO];
    chatVC.listModel = self.model;
    [self.navigationController pushViewController:chatVC animated:YES];
}
- (IBAction)detailBtnAction:(UIButton *)sender {
    
    self.spreadOut = !self.spreadOut;
    if (self.spreadOut) {
        self.detailLabel.numberOfLines = 0;
    }else {
        self.detailLabel.numberOfLines = 1;
    }
}

@end
