# ScanAndQRDemo

调用
1、引用 
#import "QRTool.h"
#import "ScanQR.h"

2、生成二维码
```objc
    CGFloat w = 200;
    /** 第一个参数：生成二维的内容
        第二个参数：二维码图片的尺寸
    */
    UIImage* img =[QRTool createQRImgWithContent:@"http://www.baidu.com" imgSize:w];
```

3、扫描二维码
```objc
  ScanQR *scan = [[ScanQR alloc]init];    
    scan.scanDelegate = self;
    [self.navigationController pushViewController:scan animated:YES];
```
3.1 扫描结果获取
```ojbc
 -(void)getScanResult:(NSString *)scanResult{
    UIAlertView* alert =[[UIAlertView alloc]initWithTitle:@"扫描结果" message:scanResult delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

```


生成二维码关键部分 
```objc
 CIFilter* filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    NSData* data = [qrContent dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    CIImage* outImg = [filter outputImage];
```

判断相机授权状态
```objc
 AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusAuthorized) {
        //授权
        
    }else if(status == AVAuthorizationStatusNotDetermined){
        //未决定
    }else{
       //拒绝----弹窗提示跳转设置权限
       
       //if ([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0) {
       //   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
       //}else{
       //    NSURL*url=[NSURL URLWithString:@"prefs:root=Privacy"];
       //    [[UIApplication sharedApplication] openURL:url];
       //}
       
    }

```

创健扫描部分
```objc
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
    [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    // Preview
    AVCaptureVideoPreviewLayer *preview =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    preview.videoGravity =AVLayerVideoGravityResizeAspectFill;
    preview.frame =self.view.layer.bounds;
    [self.view.layer insertSublayer:preview atIndex:0];
    
    [_session startRunning];
```

扫描结果部分
```objc

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (metadataObjects.count > 0) {
        // 停止扫描
        [self.session stopRunning];
        [self.qrView stopAnimation];

        //震动提示
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        
        AVMetadataMachineReadableCodeObject *object = [metadataObjects lastObject];
        NSLog(@"扫描结果是:%@",object.stringValue);
    } else {
        NSLog(@"没有扫描到数据");
    }
}

```
