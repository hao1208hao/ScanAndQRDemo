//
//  QRTool.h
//  Play
//
//  Created by haohao on 16/7/21.
//  Copyright © 2016年 haohao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QRTool : NSObject

/**
 *  生成二维码
 *
 *  @param qrContent 二维码内容
 *  @param imgSize   二维码尺寸
 *
 *  @return 返回生成的二维码图片
 */
+(UIImage*)createQRImgWithContent:(NSString*)qrContent imgSize:(CGFloat)imgSize;


@end
