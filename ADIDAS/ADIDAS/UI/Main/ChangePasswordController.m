//
//  ChangePasswordController.m
//  ADIDAS
//
//  Created by testing on 2/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChangePasswordController.h"
#import "Utilities.h"
#import "UserInfoEntity.h"
#import "UserInfoManagement.h"
#import "JSON.h"
#import "LoginResultEntity.h"
#import "CommonDefine.h"
#import "LoginViewController.h"
#import "CacheManagement.h"
#import "UIUnderlinedButton.h"

#define REGEX_PASSWORD_LIMIT @"^.{7,20}$"
#define REGEX_PASSWORD @"^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z]).{7,}$"


@implementation ChangePasswordController
@synthesize bgImageView;
@synthesize usernametextfield,passwdtextfield,newpasswdtextfield,confirmpasswdtextfield;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}



#pragma mark - View lifecycle

- (void)createNavigationbar
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    if (SYSLanguage == EN)
    {
        [Utilities createRightBarButton:self clichEvent:@selector(SubmitEvent:) btnSize:CGSizeMake(50, 30)
                               btnTitle:@"Submit"];
    }
    else
        [Utilities createRightBarButton:self clichEvent:@selector(SubmitEvent:) btnSize:CGSizeMake(50, 30)
                           btnTitle:@"提交"];
}

- (void)backItemPressed:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//初始化
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.newpasswdtextfield addRegx:REGEX_PASSWORD_LIMIT withMsg:SYSLanguage?@"密码规则:至少7个字符，包含大小写字母和数字.": @"Password policy: At least 7 characters, including letters and numbers."];
    [self.newpasswdtextfield addRegx:REGEX_PASSWORD withMsg:SYSLanguage?@"密码规则:至少7个字符，包含大小写字母和数字.":@"Password policy: At least 7 characters, including letters and numbers."];


    if (SYSLanguage == EN) {
        self.title = @"Change Password";
        self.label1.text = @"Old Password";
        self.label1.font = [UIFont systemFontOfSize:11];
        self.label2.text = @"New Password";
        self.label2.font = [UIFont systemFontOfSize:11];
        self.label3.text = @"Confirm Password";
        self.label3.font = [UIFont systemFontOfSize:11];
        [self.btn1 setTitle:@"Password Rules" forState:UIControlStateNormal];
        self.titlelabel.text =  @"Password policy: At least 7 characters, including letters and numbers.";
    }
    else
    {
        self.title = @"修改密码";
    }
    if (SYSLanguage == EN) {
        self.passwdtextfield.placeholder = @"Input old password";
        self.newpasswdtextfield.placeholder = @"Input new password";
        self.confirmpasswdtextfield.placeholder = @"Confirm new password";
    }
    usernametextfield.text = [CacheManagement instance].userLoginName;
    [passwdtextfield becomeFirstResponder];
    [self createNavigationbar];
  
    _usermanagement = [[UserInfoManagement alloc] init]; 
    _usermanagement.delegate = self;
}

//密码规则
-(IBAction)PwdRuleEvent:(id)sender
{
    //这边需要弹出提示
    if (SYSLanguage == EN)
        [Utilities alertMessage:@""];
        
    else
        [Utilities alertMessage:NSLocalizedString(@"msgPwdRuleMessage", nil)];
}

-(BOOL)checkKongGe:(NSString*)inputstring
{
//    if ([inputstring containsString:@" "])
//    {
//        return NO;
//    }
    NSString *temp = nil;
    for(int i =0; i < [inputstring length]; i++)
    {
        temp = [inputstring substringWithRange:NSMakeRange(i, 1)];
        if ([temp isEqualToString:@" "])
        {
            return NO;
        }
    }
    
    return YES;
}

-(IBAction)SubmitEvent:(id)sender
{
    if ([self checkKongGe:self.newpasswdtextfield.text])
    {
    
        if([usernametextfield.text length]<=0||[passwdtextfield.text length]<=0||
           [newpasswdtextfield.text length]<=0|| [confirmpasswdtextfield.text length]<=0)
        {
        if (SYSLanguage == EN)
            [Utilities alertMessage:@"Please input all information"];
        
        else
            [Utilities alertMessage:NSLocalizedString(@"msgUserPageError", nil)];
        return;
        }
        else if([passwdtextfield.text compare:newpasswdtextfield.text]== NSOrderedSame)
        {
            if (SYSLanguage == EN)
                [Utilities alertMessage:@"New password must different with old password"];
            
            else
                [Utilities alertMessage:NSLocalizedString(@"msgNewPwdError", nil)];
            return;
        }
        else if([newpasswdtextfield.text compare:confirmpasswdtextfield.text] != NSOrderedSame)
        {
            if (SYSLanguage == EN)
                [Utilities alertMessage:@"New Password and Confirm New Password are not the same"];
            else
                [Utilities alertMessage:NSLocalizedString(@"msgConfirmPwdError", nil)];
            return;
        }

        else if([self.newpasswdtextfield validate])
        {
            //友盟记录
//            [Utilities umengTracking:kUmAdidasChangePwd userCode:usernametextfield.text];
            //提交服务器
            [_usermanagement changePwdServer: usernametextfield.text password:passwdtextfield.text newPassword: newpasswdtextfield.text];
        }
        else
        {
            [Utilities alertMessage:SYSLanguage?@"Password policy: At least 7 characters, including letters and numbers.":@"密码规则:至少7个字符，包含大小写字母和数字."];
        }
    }
    else
    {
        [Utilities alertMessage:SYSLanguage?@"Password can not contain space":@"密码不能包含空格"];
    }
}

-(void) completeServer:(NSString *)responseString CurrentError:(NSString *)error InterfaceName:(NSString *)interface
{
    NSString *resultString = nil;
    if (error) {
        [Utilities alertMessage:error];
    }
    else {
        NSDictionary *dictionary = [responseString JSONValue];
        LoginResultEntity *entity = [[[LoginResultEntity alloc] initWithDictionary:dictionary] autorelease];
        if([entity.CheckFlag isEqual:@"0"]) //有错误信息
        {
            resultString = entity.CheckError;
            [Utilities alertMessage:resultString];
        }
        else
        {
            [CacheManagement instance].currentDBUser.password = newpasswdtextfield.text ;
            if (SYSLanguage == EN)
                [Utilities alertMessage:@"Change Password Successfully"];
            else
                [Utilities alertMessage:NSLocalizedString(@"msgOperationSuccess", nil) delegate:self];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self backItemPressed:nil];
}

//Table View Method


//获取分区的数量 
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView  
{
    return 1;
}

//获取分区里的行的数量
//section为其中的一个分区
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == usernametextfield)
    {
        [passwdtextfield becomeFirstResponder];
    }
    else if (textField == passwdtextfield)
    {
        [newpasswdtextfield becomeFirstResponder];
    }
    else if (textField == newpasswdtextfield)
    {
        [confirmpasswdtextfield becomeFirstResponder];
    }
    
    return TRUE;
}


//thistableViews改成inputs试一下吧


- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setBgImageView:nil];
   
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    if(_usermanagement){
        [_usermanagement release];
        _usermanagement = nil;
    }
    [bgImageView release];
    [super dealloc];
}
@end
