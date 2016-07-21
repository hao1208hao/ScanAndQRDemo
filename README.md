# ScanAndQRDemo
生成二维码和扫描二维码
仿微信扫描框

生成二维码关键部分 
```objc
 CIFilter* filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    NSData* data = [qrContent dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    CIImage* outImg = [filter outputImage];
```
