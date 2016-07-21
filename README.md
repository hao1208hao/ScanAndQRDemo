# ScanAndQRDemo

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
       
       <!--if ([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0) {-->
       <!--   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];-->
       <!--}else{-->
       <!--    NSURL*url=[NSURL URLWithString:@"prefs:root=Privacy"];-->
       <!--    [[UIApplication sharedApplication] openURL:url];-->
       <!--}-->
       
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
