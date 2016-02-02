//
//  UIResponder+Router.h
//  YYDoctor
//
//  Created by apple on 15/10/25.
//  Copyright © 2015年 Guangdong ZSGR Technologies Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  @author 尹建华, 15-09-17 16:09:32
 *
 *  发送一个路由器消息, 对eventName感兴趣的 UIResponsder 可以对消息进行处理
 *
 *  @param eventName eventName 发生的事件名称
 *  @param userInfo  userInfo  传递消息时, 携带的数据, 数据传递过程中, 会有新的数据添加
 */

@interface UIResponder (Router)
- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo;
@end
