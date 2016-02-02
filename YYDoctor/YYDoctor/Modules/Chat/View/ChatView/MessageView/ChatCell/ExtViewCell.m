//
//  ExtViewCell.m
//  YYDoctor
//
//  Created by apple on 15/11/17.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "ExtViewCell.h"

@interface ExtViewCell()
@property(nonatomic,strong) UILabel *extLable;
@end

@implementation ExtViewCell



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _extLable = [[UILabel alloc] init];
        _extLable.font = [UIFont systemFontOfSize:13];
        _extLable.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_extLable];
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)setExtText:(NSString *)extText {

    CGSize size = [extText sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]}];
    _extLable.center = self.contentView.center;
    _extLable.bounds = CGRectMake(0, 0, size.width, size.height);
    _extLable.text = extText;

}

+ (CGFloat)extCellHeightWithStr:(NSString *)extText {
    CGSize size = [extText sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}];
    return size.height + 15;
}
@end
