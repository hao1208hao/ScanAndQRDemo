//
//  ScanQR.h
//  Play
//
//  Created by haohao on 16/7/21.
//  Copyright © 2016年 haohao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol scanQRDelegate <NSObject>

-(void)getScanResult:(NSString*)scanResult;

@end

@interface ScanQR : UIViewController

/** 扫描结果代理 */
@property(nonatomic,weak) id<scanQRDelegate> scanDelegate;

/**
 *  扫描二维码
 */
-(void)scanQR;
@end
