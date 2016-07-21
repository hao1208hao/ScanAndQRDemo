//
//  QRTool.m
//  Play
//
//  Created by haohao on 16/7/21.
//  Copyright © 2016年 haohao. All rights reserved.
//

#import "QRTool.h"
#import <CoreImage/CoreImage.h>

@implementation QRTool

/**
 *  生成二维码
 *
 *  @param qrContent 二维码内容
 *  @param imgSize   二维码尺寸
 *
 *  @return 返回生成的二维码
 */
+(UIImage *)createQRImgWithContent:(NSString *)qrContent imgSize :(CGFloat)imgSize{
    
    CIFilter* filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    NSData* data = [qrContent dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    CIImage* outImg = [filter outputImage];
    
    if (!imgSize) {
        imgSize = 200;
    }
    
    return [self createNonInterpolatedUIImageFormCIImage:outImg withSize:imgSize];
    
}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end
