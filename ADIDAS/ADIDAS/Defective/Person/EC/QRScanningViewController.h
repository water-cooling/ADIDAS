//
//  QRScanningViewController.h
//  ComixB2B
//
//  Created by 桂康 on 2017/5/13.
//  Copyright © 2017年 joinone. All rights reserved.
//

#import "SGQRCodeScanningVC.h"


@protocol OpenDetailDelegate <NSObject>

- (void)openBarCode:(NSString *)barcode ;

@end

@interface QRScanningViewController : SGQRCodeScanningVC

@property (assign, nonatomic) id<OpenDetailDelegate> delegate ;

@end
