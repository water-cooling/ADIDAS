//
//  ReviewSyssettingViewController.m
//  MobileApp
//
//  Created by 桂康 on 2018/6/11.
//

#import "ReviewSyssettingViewController.h"
#import "ChangePasswordController.h"
#import "LoginViewController.h"
#import "CacheManagement.h"
#import "AppDelegate.h"
#import "LeveyTabBarController.h"
#import "CacheManagement.h"
#import "CommonDefine.h"
#import "NSString+SBJSON.h"
#import "MyAccoutViewController.h"
#import "Utilities.h"

@interface ReviewSyssettingViewController ()

@end

@implementation ReviewSyssettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.waitView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEWIDTH, DEHEIGHT)];
    UIImageView* imageview = [[UIImageView alloc]initWithFrame:CGRectMake(DEWIDTH/2.0-100, 176, 200, 108)];
    imageview.image = [UIImage imageNamed:@"waiting.png"];
    [self.waitView addSubview:imageview];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(DEWIDTH/2.0-100, 245, 200, 21)];
    label.tag = 88;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [self.waitView addSubview:label];
    UIActivityIndicatorView* acview = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [acview startAnimating];
    acview.frame = CGRectMake((DEWIDTH-37)/2.0, 193, 37, 37);
    [self.waitView addSubview:acview];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.waitView ];
    ((UILabel*)[self.waitView viewWithTag:88]).text = SYSLanguage?@"Processing,please wait …":@"请稍等,正在执行...";
    [self.waitView setHidden:YES];
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)){
        self.navigationController.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    }
    
    self.navigationItem.title = @"系统";
    if (SYSLanguage == EN) {
        self.navigationItem.title = @"System";
    }
    self.accountLabel.text = [CacheManagement instance].currentUser.UserName;

    if (SYSLanguage == EN)
    {
        [self.btn3 setTitle:@"Logout" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
    
    NSString *title = @"是否确定" ;
    NSString *cancel = @"取消" ;
    NSString *other = @"确定" ;
    
    if (SYSLanguage == EN) {
        title = @"Are you sure?" ;
        cancel = @"Cancel" ;
        other = @"OK" ;
    }

    UIAlertController *ac = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAC = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *otherAC = [UIAlertAction actionWithTitle:other style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.waitView.hidden = NO;
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSString* urlString = [NSString stringWithFormat:kLogOut,kWebDataString,
                                   [CacheManagement instance].userLoginName,
                                   [CacheManagement instance].currentLocation.locationX,
                                   [CacheManagement instance].currentLocation.locationY];
            NSURL *url = [NSURL URLWithString:urlString];
            
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
            [request setValidatesSecureCertificate:NO];
            [request setRequestMethod:@"GET"];
            [request addRequestHeader:@"Accept" value:@"application/json"];
            [request addRequestHeader:@"Content-Type" value:@"application/json"];
            
            //添加ISA 密文验证
            if ([CacheManagement instance].userEncode&&![[CacheManagement instance].userEncode isEqualToString:@""])
                [request addRequestHeader:@"Authorization"
                                    value:[NSString stringWithFormat:@"Basic %@",[CacheManagement instance].userEncode] ];
            
            [request setTimeOutSeconds:250];
            
            [request startSynchronous];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.waitView removeFromSuperview];
                NSError *error = [request error];
                if (!error) {
                    
                    for (UIViewController* obj in self.leveyTabBarController.navigationController.viewControllers)
                    {
                        if ([obj isKindOfClass:[LoginViewController class]])
                        {
                            [self.leveyTabBarController.navigationController popToViewController:obj animated:YES];
                            return;
                        }
                    }
                }
            });
        });
        
    }];
    [ac addAction:cancelAC];
    [ac addAction:otherAC];
    [self presentViewController:ac animated:YES completion:nil] ;
}

- (IBAction)userAccount:(id)sender {
    MyAccoutViewController* myaccount = [[MyAccoutViewController alloc]initWithNibName:@"MyAccoutViewController" bundle:nil];
    [self.leveyTabBarController hidesTabBar:YES animated:YES];
    [self.navigationController pushViewController:myaccount animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.leveyTabBarController hidesTabBar:NO animated:YES];
}

@end



