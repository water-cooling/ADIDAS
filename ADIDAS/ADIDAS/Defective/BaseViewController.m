//
//  BaseViewController.m
//  StoreVisitPack
//
//  Created by joinone on 15/3/2.
//  Copyright (c) 2015年 joinone. All rights reserved.
//

#import "BaseViewController.h"
#import "SVProgressHUD.h"


@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (@available(iOS 13.0, *)) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    
    self.view.backgroundColor = [CommonUtil colorWithHexString:@"#ebeff2"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent]; 
    [self.navigationController.navigationBar setBarTintColor:[CommonUtil colorWithHexString:@"1a1b1f"]] ;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    if(@available(iOS 15.0,*)){
        UINavigationBarAppearance* appearance = [[UINavigationBarAppearance alloc]init];
        appearance.backgroundColor = [CommonUtil colorWithHexString:@"#1a1b1f"];
        appearance.shadowColor = [UIColor clearColor];
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
        self.navigationController.navigationBar.standardAppearance = appearance;
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)ShowSVProgressHUD{

    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack] ;
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD show];
}

- (void)ShowSVProgressHUD:(NSString *)info{
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack] ;
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:info];
}

- (void)ShowErrorSVProgressHUD:(NSString *)info{
    
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack] ;
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showErrorWithStatus:info];
}

- (void)ShowSuccessSVProgressHUD:(NSString *)info{
    
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack] ;
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showSuccessWithStatus:info];
}

- (void)ShowSuccessSVProgressHUDForTen:(NSString *)info{
    
    [SVProgressHUD setMinimumDismissTimeInterval:10];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack] ;
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showSuccessWithStatus:info];
}

- (void)ShowProgressSVProgressHUD:(NSString *)info andProgress:(float)pregress{
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack] ;
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showProgress:pregress status:info];
}
-(void)setIOS:(UIScrollView *)scroller{
    if (@available(iOS 11.0, *)) {
        scroller.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    if ([scroller isKindOfClass:[UITableView class]]) {
        if (@available(iOS 15.0, *)) {
            UITableView * tem =(UITableView *)scroller;
            tem.sectionHeaderTopPadding = 0;
        }
    }
}

- (void)ShowProgressSVProgressHUDProgress:(float)pregress{
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone] ;
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD showProgress:pregress];
}

- (void)ShowWhiteSVProgressHUD{
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear] ;
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD show];
}

- (void)DismissSVProgressHUD{
    
    [SVProgressHUD dismiss];
}



-(void)showRemindAlertWithMessage:(NSString *)info{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:info delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [alert show];
    
    [self performSelector:@selector(Disapear:) withObject:alert afterDelay:1.5];
}


- (void)Disapear:(UIAlertView *)alert {
    
    if (alert) {
        
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}


- (User *)GetLoginUser {

    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[CommonUtil getPlistPath:LOGINDATA]];
    
    return [[User alloc] initWith:dic] ;
}


- (void)showAlertWithDispear:(NSString *)info {

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:info delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [alert show];
    
    [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:1];
}

- (void)showAlertWithLongDispear:(NSString *)info {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:info delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [alert show];
    
    [self performSelector:@selector(dismissAlert:) withObject:alert afterDelay:2];
}


- (void)dismissAlert:(UIAlertView *)alert {

    [alert dismissWithClickedButtonIndex:0 animated:YES];
}



@end
























