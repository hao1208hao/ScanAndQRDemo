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

/**
 *  识别二维码
 *
 *  @param img 需要识别的二维码图片
 *
 *  @return 返回识别的二维码图片结果
 */
+(NSString*)recognizeImgWithImage:(UIImage*)img{
    NSString *result = @"";
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0) {
        UIImage * srcImage = img;
        CIContext *context = [CIContext contextWithOptions:nil];
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
        CIImage *image = [CIImage imageWithCGImage:srcImage.CGImage];
        NSArray *features = [detector featuresInImage:image];
        CIQRCodeFeature *feature = [features firstObject];
        result = feature.messageString;
    }else{
        //提示系统版本较低，最低需要8.0系统
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前暂未支持您的系统版本,最低要求iOS8.0系统" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return result;
    }
    //NSLog(@"识别结果是%@",result);    
    return result;
}

@end
