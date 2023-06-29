//
//  QRScanningViewController.m
//  ComixB2B
//
//  Created by 桂康 on 2017/5/13.
//  Copyright © 2017年 joinone. All rights reserved.
//

#import "QRScanningViewController.h"
#import "SGQRCode.h"



@interface QRScanningViewController ()

@end

@implementation QRScanningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 注册观察者
    [SGQRCodeNotificationCenter addObserver:self selector:@selector(SGQRCodeInformationFromeAibum:) name:SGQRCodeInformationFromeAibum object:nil];
    [SGQRCodeNotificationCenter addObserver:self selector:@selector(SGQRCodeInformationFromeScanning:) name:SGQRCodeInformationFromeScanning object:nil];
}

- (void)SGQRCodeInformationFromeAibum:(NSNotification *)noti {
    NSString *string = noti.object;
    
    [self showAlertWithMessage:string];
}

- (void)SGQRCodeInformationFromeScanning:(NSNotification *)noti {
   
    NSString *string = noti.object;
    [self.navigationController popViewControllerAnimated:NO] ;
    [self.delegate openBarCode:string];
}

- (void)dealloc {
   
    [SGQRCodeNotificationCenter removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
