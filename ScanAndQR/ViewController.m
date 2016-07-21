//
//  ViewController.m
//  AboutCameraDemo
//
//  Created by haohao on 16/7/21.
//  Copyright © 2016年 haohao. All rights reserved.
//

#import "ViewController.h"
#import "QRTool.h"
#import "ScanQR.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()<scanResultDelegate>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"QR-Demo";
    self.view.backgroundColor = [UIColor whiteColor];
    
    int left = 20;
    int top = 100;
    int w = (SCREEN_WIDTH-left*3)/2;
    int h = 40;
    UIButton* createQRBtn = [self createBtnWithTitle:@"生成二维码"];
    [createQRBtn setFrame:CGRectMake(left, top, w, h)];
    [createQRBtn addTarget:self action:@selector(createQR) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* scanQRBtn = [self createBtnWithTitle:@"扫描二维码"];
    [scanQRBtn setFrame:CGRectMake(left*2+w, top, w, h)];
    [scanQRBtn addTarget:self action:@selector(Scan) forControlEvents:UIControlEventTouchUpInside];
}


-(UIButton*)createBtnWithTitle:(NSString*)title{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor blueColor]];
    btn.layer.cornerRadius = 4;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [self.view addSubview:btn];
    return  btn;
}



- (void)createQR{
    
    CGFloat w = 200;
    /** 生成二维码 */
    UIImage* img =[QRTool createQRImgWithContent:@"http://www.baidu.com" imgSize:w];
    
    UIImageView* imgV = [[UIImageView alloc]initWithImage:img];
    [imgV setFrame:CGRectMake((SCREEN_WIDTH-w)/2, (SCREEN_HEIGHT-w)/2, w, w)];
    [imgV setCenter:self.view.center];
    [self.view addSubview:imgV];
    
}

- (void)Scan{
    
    /** 扫描二维码 */
    ScanQR *scan = [[ScanQR alloc]init];    
    scan.scanDelegate = self;
    [self.navigationController pushViewController:scan animated:YES];
    
}

-(void)getScanResult:(NSString *)scanResult{
    UIAlertView* alert =[[UIAlertView alloc]initWithTitle:@"扫描结果" message:scanResult delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

@end
