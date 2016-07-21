//
//  QDBAlert.m
//  qiandaibao_pos
//
//  Created by haohao on 16/5/7.
//  Copyright © 2016年 钱袋宝. All rights reserved.
//

#import "QDBAlert.h"

#define ADIOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

typedef void (^confirm)();
typedef void (^cancel)();

@interface QDBAlert() <UIAlertViewDelegate>
@property (nonatomic, copy) confirm confirmParam;
@property (nonatomic, copy) cancel cancelParam;
@end

@implementation QDBAlert

+ (instancetype)shareAlertTool {
    static QDBAlert *shareAlertTool = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareAlertTool = [[self alloc] init];
    });
    return shareAlertTool;
}

// 重写该方法，保证该对象不会被释放，如果被释放，iOS8以下的UIAlertView的回调时候会崩溃
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    static QDBAlert *_shareAlertView = nil;
    dispatch_once(&onceToken, ^{
        if (_shareAlertView == nil) {
            _shareAlertView = [super allocWithZone:zone];
        }
    });
    return _shareAlertView;
}

- (void)showAlertViewWithVC:(UIViewController *)vc title:(NSString *)title message:(NSString *)message confirmAction:(void (^)())confirm {
    [self showAlertViewWithVC:vc title:title message:message cancel:nil other:@"确认" cancleAction:^{} confirmAction:confirm];
}

- (void)showAlertViewWithVC:(UIViewController *)vc title:(NSString *)title message:(NSString *)message cancleAction:(void (^)())cancel confirmAction:(void (^)())confirm {
    [self showAlertViewWithVC:vc title:title message:message cancel:@"取消" other:@"确认" cancleAction:cancel confirmAction:confirm];
}

- (void)showAlertViewWithVC:(UIViewController *)vc title:(NSString *)title message:(NSString *)message cancel:(NSString *)cancelTitle other:(NSString *)otherTitle cancleAction:(void (^)())cancel confirmAction:(void (^)())confirm {
    self.confirmParam = confirm;
    self.cancelParam = cancel;
    if (ADIOS8) { // iOS8以上(包括iOS8)
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        // Create the actions.
        if (cancelTitle && self.cancelParam) {
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                self.cancelParam();
            }];
            // Add the actions.
            [alertController addAction:cancelAction];
        }
        if (otherTitle && self.confirmParam) {
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                self.confirmParam();
            }];
            // Add the actions.
            [alertController addAction:otherAction];
        }
        if (vc) {
            [vc presentViewController:alertController animated:YES completion:nil];
        }
    } else { // iOS8以下
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:otherTitle, nil];
        [alertView show];
    }
}

-(void)showAlertViewWithVC:(UIViewController*)vc message:(NSString*)message confirmAction:(void(^)())confirm{
    [self showAlertViewWithVC:vc title:@"提示" message:message cancel:@"取消" other:@"确认" cancleAction:^{} confirmAction:confirm];
}

#pragma mark - UIAlertViewDelegate
#pragma mark

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (self.cancelParam) self.cancelParam();
    } else {
        if (self.confirmParam)  self.confirmParam();
    }
}

@end
