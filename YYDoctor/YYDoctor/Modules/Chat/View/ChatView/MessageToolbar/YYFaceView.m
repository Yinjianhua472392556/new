//
//  YYFaceView.m
//  YYDoctor
//
//  Created by apple on 15/10/24.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import "YYFaceView.h"
@interface YYFaceView ()<FacialViewDelegate>{
    FacialView *_facialView;
}
@end

@implementation YYFaceView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _facialView = [[FacialView alloc] initWithFrame: CGRectMake(5, 5, frame.size.width - 10, self.bounds.size.height - 10)];
        [_facialView loadFacialView:1 size:CGSizeMake(30, 30)];
        _facialView.delegate = self;
        [self addSubview:_facialView];
    }
    return self;
}


#pragma mark - FacialViewDelegate

-(void)selectedFacialView:(NSString*)str{
    if (_delegate) {
        [_delegate selectedFacialView:str isDelete:NO];
    }
}

-(void)deleteSelected:(NSString *)str{
    if (_delegate) {
        [_delegate selectedFacialView:str isDelete:YES];
    }
}

- (void)sendFace
{
    if (_delegate) {
        [_delegate sendFace];
    }
}

#pragma mark - public

- (BOOL)stringIsFace:(NSString *)string
{
    if ([_facialView.faces containsObject:string]) {
        return YES;
    }
    
    return NO;
}
@end
