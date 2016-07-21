//
//  QDBAlert.h
//  qiandaibao_pos
//
//  Created by haohao on 16/5/7.
//  Copyright © 2016年 钱袋宝. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface QDBAlert : NSObject

+ (instancetype)shareAlertTool;

/**
 *  AlertView封装(只带确认按钮)
 *
 *  @param viewController    当前控制器
 *  @param title             标题
 *  @param message           提示信息
 *  @param confirm           点击确定事件
 */
- (void)showAlertViewWithVC:(UIViewController *)vc title:(NSString *)title message:(NSString *)message confirmAction:(void (^)())confirm;

/**
 *  AlertView封装(带取消和确认按钮)
 *
 *  @param viewController    当前控制器
 *  @param title             标题
 *  @param message           提示信息
 *  @param cancle            点击取消事件
 *  @param confirm           点击确定事件
 */
- (void)showAlertViewWithVC:(UIViewController *)vc title:(NSString *)title message:(NSString *)message cancleAction:(void (^)())cancel confirmAction:(void (^)())confirm;

/**
 *  AlertView封装(带两个按钮)
 *
 *  @param viewController    当前控制器
 *  @param title             标题
 *  @param message           提示信息
 *  @param cancelTitle       取消按钮
 *  @param otherTitle        其他按钮
 *  @param cancle            点击取消事件
 *  @param confirm           点击确定事件
 */
- (void)showAlertViewWithVC:(UIViewController *)vc title:(NSString *)title message:(NSString *)message cancel:(NSString *)cancelTitle other:(NSString *)otherTitle cancleAction:(void (^)())cancel confirmAction:(void (^)())confirm;

/**
 *  AlertView封装(带两个按钮)
 *
 *  @param vc      当前控制器
 *  @param message 提示信息
 *  @param confirm 点击确定事件
 */
-(void)showAlertViewWithVC:(UIViewController*)vc message:(NSString*)message confirmAction:(void(^)())confirm;

@end
