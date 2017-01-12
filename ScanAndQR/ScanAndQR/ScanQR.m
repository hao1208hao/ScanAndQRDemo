//
//  ScanQR.m
//  Play
//
//  Created by haohao on 16/7/21.
//  Copyright © 2016年 haohao. All rights reserved.
//

#import "ScanQR.h"
#import "QDBAlert.h"
#import "QRView.h"
#import <AVFoundation/AVFoundation.h>

@interface ScanQR ()<AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) AVCaptureSession *session;

@property (nonatomic,weak) QRView *qrView;
@end

@implementation ScanQR

- (void)viewDidLoad {
    [super viewDidLoad];
    // 标题
    self.title = @"扫一扫";
    self.view.backgroundColor = [UIColor whiteColor];
    [self scanQR];
}

/** 扫描区域 */
-(void)scanQR{
    
    /** 判断授权状态 */
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusAuthorized) {
        //授权
        
    }else if(status == AVAuthorizationStatusNotDetermined){
        //未决定
    }else{        
        [[QDBAlert shareAlertTool] showAlertViewWithVC:self title:@"提示" message:@"您可以进入系统“设置>隐私>相机”,允许“此APP”访问您的相机" cancel:@"取消" other:@"设置" cancleAction:^{
            /** 取消 */
            [self.navigationController popViewControllerAnimated:YES];
        } confirmAction:^{
            if ([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
            }else{
                NSURL*url=[NSURL URLWithString:@"prefs:root=Privacy"];
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        return;
        
    }
    
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    
    // Output
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:input])
    {
        [_session addInput:input];
    }
    
    if ([_session canAddOutput:output])
    {
        [_session addOutput:output];
    }
    
    
    // 3.1.设置输入元数据的类型(类型是二维码数据)
   // [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code,
                                    AVMetadataObjectTypeEAN8Code,
                                    AVMetadataObjectTypeCode128Code,
                                    AVMetadataObjectTypeQRCode];
    
    
    // Preview
    AVCaptureVideoPreviewLayer *preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
    preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:preview atIndex:0];
    
    [_session startRunning];
   
    
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    QRView *qrRectView = [[QRView alloc] initWithFrame:screenRect];
    
    CGFloat qrvX = 240;
    CGFloat qrvY = 240;
    
    qrRectView.transparentArea = CGSizeMake(qrvX, qrvY);
    qrRectView.backgroundColor = [UIColor clearColor];
    qrRectView.center = CGPointMake(screenWidth/ 2, screenHeight/ 2+64);
    [self.view addSubview:qrRectView];
    self.qrView = qrRectView;
    
    CGFloat cropY = (screenHeight - qrvY) / 2-120;
    if (screenHeight == 480) {
        cropY = (screenHeight - qrvY) / 2 - 60;
    }
    
    //修正扫描区域
    CGRect cropRect = CGRectMake((screenWidth - qrRectView.transparentArea.width) / 2,
                                 cropY,
                                 qrvX,
                                 qrvY);
    
    [output setRectOfInterest:CGRectMake(cropRect.origin.y / screenHeight,
                                          cropRect.origin.x / screenWidth,
                                          cropRect.size.height / screenHeight,
                                          cropRect.size.width / screenWidth)];
    
}

#pragma mark - 实现output的回调方法
// 当扫描到数据时就会执行该方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        // 停止扫描
        [self.session stopRunning];
        [self.qrView stopAnimation];

        //震动提示
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        AVMetadataMachineReadableCodeObject *object = [metadataObjects lastObject];
        
        [self getResult:object.stringValue];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSLog(@"没有扫描到数据");
    }
}

-(void)getResult:(NSString*)result{
    if ([self.scanDelegate respondsToSelector:@selector(getScanResult:)]) {
        [self.scanDelegate getScanResult:result];
    }
}

@end
