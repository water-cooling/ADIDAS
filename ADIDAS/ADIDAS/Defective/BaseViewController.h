//
//  BaseViewController.h
//  StoreVisitPack
//
//  Created by joinone on 15/3/2.
//  Copyright (c) 2015年 joinone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonUtil.h"
#import "NSString+SBJSON.h"
#import "CommonDefine.h"
#import "User.h"
#import "HttpAPIClient.h"


@interface BaseViewController : UIViewController

- (void)ShowSVProgressHUD ;

- (void)ShowSVProgressHUD:(NSString *)info ;

- (void)DismissSVProgressHUD ;

- (User *)GetLoginUser ;

- (void)showAlertWithDispear:(NSString *)info ;

- (void)showAlertWithLongDispear:(NSString *)info ;

- (void)ShowSuccessSVProgressHUD:(NSString *)info ;

- (void)ShowSuccessSVProgressHUDForTen:(NSString *)info;

- (void)ShowErrorSVProgressHUD:(NSString *)info ;

- (void)ShowProgressSVProgressHUD:(NSString *)info andProgress:(float)pregress ;
-(void)setIOS:(UIScrollView *)scroller;
- (void)ShowProgressSVProgressHUDProgress:(float)pregress ;

- (void)ShowWhiteSVProgressHUD ;

- (void)refreshDetailList ;

@end
