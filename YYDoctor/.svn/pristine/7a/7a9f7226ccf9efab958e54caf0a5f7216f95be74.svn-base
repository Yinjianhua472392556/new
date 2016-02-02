//
//  YYFaceView.h
//  YYDoctor
//
//  Created by apple on 15/10/24.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacialView.h"
@protocol YYFaceDelegate <FacialViewDelegate>
@required
- (void)selectedFacialView:(NSString *)str isDelete:(BOOL)isDelete;
- (void)sendFace;
@end

@interface YYFaceView : UIView
@property (nonatomic, assign) id<YYFaceDelegate> delegate;
- (BOOL)stringIsFace:(NSString *)string;
@end
