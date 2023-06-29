//
//  MyAccoutViewController.m
//  VM
//
//  Created by leo.you on 14-8-8.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import "MyAccoutViewController.h"
#import "CacheManagement.h"
#import "ChangePasswordController.h"

@interface MyAccoutViewController ()

@end

@implementation MyAccoutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)changePassword
{
    ChangePasswordController* changeVC = [[ChangePasswordController alloc]initWithNibName:@"ChangePasswordController" bundle:nil];
    [self.navigationController pushViewController:changeVC animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    }
    self.title = @"我的账号";
    if (SYSLanguage == EN)
    {
        self.title = @"Account";
        self.label1.text = @"Account";
        self.label2.text = @"Name";
        self.label3.text = @"Position";
        [self.btn1 setTitle:@"Change Password" forState:UIControlStateNormal];
    }
    self.account.text = [CacheManagement instance].userLoginName;
    self.name.text = [CacheManagement instance].currentUser.UserName;
    self.zhiwei.text = [CacheManagement instance].currentUser.userPosition;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
