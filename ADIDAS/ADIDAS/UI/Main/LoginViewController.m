//
//  LoginViewController.m
//  WSE
//
//  Created by sow3 on 2/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "JSON.h"
#import "LoginResultEntity.h"
#import "CacheManagement.h"
#import "Utilities.h"
#import "SyncDataViewController.h"
#import "CommonDefine.h"
#import "GTMBase64.h"
#import "AppDelegate.h"
#import "StoreListViewController.h"
#import "VMSysSettingViewController.h"
#import "PlanViewController.h"
#import "AssistViewController.h"
#import "LeveyTabBarController.h"
#import "LanguageViewController.h"
#import "DateListViewController.h"
#import "SqliteHelper.h"
#import "CommonUtil.h"
#import "HttpAPIClient.h"
#import "NSString+filter.h"
#import "ChangePassWordViewController.h"

@interface LoginViewController()<UIActionSheetDelegate,ChangePassDelegate>

- (void) checkSyncVersion;

@end


@implementation LoginViewController

@synthesize needSyncVersions;
@synthesize txtUserName;
@synthesize txtPassword;
@synthesize btnLogin;
@synthesize btnIsSavePwd;
@synthesize isTimeOut;
@synthesize currentLoc;

-(void)ChosseLanguage
{
    LanguageViewController* languagevc = [[LanguageViewController alloc]initWithNibName:@"LanguageViewController" bundle:nil];
    [self.navigationController pushViewController:languagevc animated:YES];
}


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
    if ([self isViewLoaded] && [self.view window] == nil)
    {
        self.waitview = nil;
        self.btnLogin = nil;
        self.btnForget = nil;
        self.btnIsSavePwd = nil;
        self.txtPassword = nil;
        self.txtUserName = nil;
        self.saveLabel = nil;
        self.view = nil;
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(isSave == NO) txtPassword.text =@"";
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.WaitingLabel.text = SYSLanguage?@"Processing,please wait …":@"请稍等,正在执行..." ;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    if (SYSLanguage == EN)
    {
        self.saveLabel.text = @"Remember password";
        [self.btnLogin setTitle:@"Login" forState:UIControlStateNormal];
        [self.btnForget setTitle:@"Forget password" forState:UIControlStateNormal];
        self.txtUserName.placeholder = @"User Name";
        self.txtPassword.placeholder = @"Password";
    }
    else
    {
        self.saveLabel.text = @"记住密码";
        [self.btnLogin setTitle:@"登录" forState:UIControlStateNormal];
        [self.btnForget setTitle:@"忘记密码" forState:UIControlStateNormal];
        self.txtUserName.placeholder = @"用户名";
        self.txtPassword.placeholder = @"密码";
    }
    
    
//    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
  
//    NSString *workmainvalue = [ud valueForKey:kSOLUTIONWORKMAINID];
    
//    if (workmainvalue && ![workmainvalue isEqual:[NSNull null]]&& ![workmainvalue isEqualToString:@""]) {
//
//        if (self.waitview.hidden) self.waitview.hidden = NO;
//        NSString *savetime = [ud valueForKey:@"currenttime"];
//
//        if (!savetime || [savetime isEqual:[NSNull null]] || [savetime isEqualToString:@""]) savetime = [Utilities DateTimeNow];
//
//        [[HttpAPIClient sharedClient] POST:[[NSString stringWithFormat:@"%@%@",workmainvalue,savetime] mk_urlEncodedString__] parameters:@{@"ActionType":@"en"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//             self.waitview.hidden = YES;
//            [ud removeObjectForKey:kSOLUTIONWORKMAINID];
//            [ud synchronize] ;
//
//        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//             self.waitview.hidden = YES;
//        }];
//    }
    
    if([CacheManagement instance].currentDBUser!=nil) {
        if( [[CacheManagement instance].currentDBUser.isSavePwd isEqualToString:@"1"]) {
            txtPassword.text = [CacheManagement instance].currentDBUser.password;
        } else {
            txtPassword.text = @"";
        }
    }
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark - View lifecycle

- (void)createNavigationBar {
    
    self.naviTitleImageView.backgroundColor = [CommonUtil colorWithHexString:@"#3b3b3f"];
}

- (IBAction)saveUserEvent:(id)sender 
{
    if (isSave ==YES) {
        isSave=NO;
        [btnIsSavePwd setBackgroundImage:[UIImage imageNamed:@"pass.png"] forState:UIControlStateNormal];
    }
    else {
        isSave=YES;
        [btnIsSavePwd setBackgroundImage:[UIImage imageNamed:@"savepass.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)loginEvent:(id)sender 
{
    if([txtUserName.text length]<=0 || [txtPassword.text length]<=0)
    {
        [Utilities alertMessage:SYSLanguage?@"Please Fill in All Fields":@"用户名和密码不能为空"];
        return;
    }
    
    [CacheManagement instance].userLoginName = [txtUserName.text uppercaseString];
    [CacheManagement instance].userEncode = @"" ;
    
    self.waitview.hidden = NO;
     [self DefectiveLogin:NO];
                      
}



- (void) DefectiveLogin:(BOOL)show {

    NSDictionary *dic = @{@"UserAccount":[self.txtUserName.text uppercaseString],
                          @"Password":self.txtPassword.text,
//                          @"ActionType":@"en",
//                          @"VersionCode":@"",
                          @"VersionCode":[NSString stringWithFormat:@"%@",[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"]],
                          @"osType":@"iPhone",
                          @"AutoUpgrade":kAUTOUPGRADE};
    
    [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@UserLogin",KWebEHDefectiveString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.waitview.hidden = YES ;
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (![responseStr JSONValue]) {
            NSString *aesString = [AES128Util AES128Decrypt:responseStr key:[CommonUtil getDecryKey:[self.txtUserName.text uppercaseString]]]  ;
            responseObject = [aesString JSONValue] ;
        }else {
            responseObject = [responseStr JSONValue] ;
        }
        NSLog(@"responseObject%@",responseObject);
        if (responseObject && [[responseObject objectForKey:@"Code"] integerValue] == 200) {
            
            NSDictionary *userData = [[responseObject valueForKey:@"Msg"] JSONValue];
            
            if ([userData writeToFile:[CommonUtil getPlistPath:LOGINDATA] atomically:YES]) {
            
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud setValue:([userData valueForKey:@"Token"] && ![[userData valueForKey:@"Token"] isEqual:[NSNull null]]) ? [userData valueForKey:@"Token"] : @"" forKey:kDEFECTIVETOKEN] ;
                [ud synchronize];
                
                
                if ([[NSString stringWithFormat:@"%@",[userData valueForKey:@"NewVersion"]] isEqualToString:@"Y"]) {
                  
                    if ([[NSString stringWithFormat:@"%@",[userData valueForKey:@"MustVersion"]] isEqualToString:@"Y"]) {
                        
                        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"已有最新版本，如不更新则无法使用，现在立即更新。" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *ac1 = [UIAlertAction actionWithTitle:@"确认更新" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                            [self performSelector:@selector(goToAppStore:) withObject:[NSString stringWithFormat:@"%@",[userData valueForKey:@"UpgradeUrl"]] afterDelay:0];
                        }];
                        
                        [controller addAction:ac1];
                        [self presentViewController:controller animated:YES completion:^{}];
                        
                    } else {
                        UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"检测到新版本,是否马上更新?" preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *ac1 = [UIAlertAction actionWithTitle:@"下载更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [self performSelector:@selector(goToAppStore:) withObject:[NSString stringWithFormat:@"%@",[userData valueForKey:@"UpgradeUrl"]] afterDelay:0];
                        }];
                        UIAlertAction *ac2 = [UIAlertAction actionWithTitle:@"下次再说" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                           [self goToDefective:userData];
                        }];
                        [controller addAction:ac1];
                        [controller addAction:ac2];
                        [self presentViewController:controller animated:YES completion:^{}];
                    }
                    
                    return ;
                }
                
                [self goToDefective:userData];
            }
            else [Utilities alertMessage:@"登录失败,请重试!"];
        }
        else {
            
            [Utilities alertMessage:[responseObject valueForKey:@"Msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [Utilities alertMessage:@"服务器请求失败,请重试"];
        
        self.waitview.hidden = YES ;
    }];
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

- (void)goToAppStore:(NSString *)path {
    
    [self viewWillAppear:NO];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path]];
}


- (void)goToDefective:(NSDictionary *)userData {
    
//    NSString *changeInfoStr = [NSString stringWithFormat:@"%@",[userData valueForKey:@"PasswordDayDiff"]] ;
//    NSString *messageCode = [NSString stringWithFormat:@"%@",[userData valueForKey:@"MessageCode"]];
//
//    if ([messageCode isEqualToString:@"300"]) {
//
//        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:changeInfoStr preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"修改密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//            ChangePassWordViewController *vc = [[ChangePassWordViewController alloc] initWithNibName:@"ChangePassWordViewController" bundle:nil] ;
//            vc.delegate = self ;
//            vc.fromLogin = YES ;
//            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
//            self.navigationItem.backBarButtonItem = item ;
//            [self.navigationController pushViewController:vc animated:YES] ;
//        }];
//
//        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"下次再说" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//            if (isSave==YES) [CacheManagement instance].currentDBUser.isSavePwd=@"1";
//            else [CacheManagement instance].currentDBUser.isSavePwd=@"0";
//            [CacheManagement instance].currentDBUser.userID = [txtUserName.text uppercaseString];
//            [CacheManagement instance].currentDBUser.userName = [txtUserName.text uppercaseString];
//            [CacheManagement instance].currentDBUser.password = txtPassword.text;
//            [_usermanagement updateUser:[CacheManagement instance].currentDBUser];
//
//            UIStoryboard *board = [UIStoryboard storyboardWithName:@"defective" bundle:nil] ;
//            [self.navigationController pushViewController:[board instantiateInitialViewController] animated:YES] ;
//            [CacheManagement instance].showSpecial = [NSString stringWithFormat:@"%@",[userData valueForKey:@"ShowSpecial"]];
//            [CacheManagement instance].ShowRBK = [NSString stringWithFormat:@"%@",[userData valueForKey:@"ShowRBK"]];
//        }];
//
//        [ac addAction:action1];
//        [ac addAction:action2];
//        [self presentViewController:ac animated:YES completion:^{}];
//    } else if ([messageCode isEqualToString:@"400"]){
//        ChangePassWordViewController *vc = [[ChangePassWordViewController alloc] initWithNibName:@"ChangePassWordViewController" bundle:nil] ;
//        vc.delegate = self ;
//        vc.fromLogin = YES ;
//        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
//        self.navigationItem.backBarButtonItem = item ;
//        [self.navigationController pushViewController:vc animated:YES] ;
//        [Utilities alertMessage:changeInfoStr];
//    } else if ([messageCode isEqualToString:@"200"]){
//
//        if (isSave==YES) [CacheManagement instance].currentDBUser.isSavePwd=@"1";
//        else [CacheManagement instance].currentDBUser.isSavePwd=@"0";
//        [CacheManagement instance].currentDBUser.userID = [txtUserName.text uppercaseString];
//        [CacheManagement instance].currentDBUser.userName = [txtUserName.text uppercaseString];
//        [CacheManagement instance].currentDBUser.password = txtPassword.text;
//        [_usermanagement updateUser:[CacheManagement instance].currentDBUser];
//
//        UIStoryboard *board = [UIStoryboard storyboardWithName:@"defective" bundle:nil] ;
//        UIViewController *destination = [board instantiateInitialViewController] ;
//        [self.navigationController pushViewController:destination animated:YES] ;
//        [CacheManagement instance].showSpecial = [NSString stringWithFormat:@"%@",[userData valueForKey:@"ShowSpecial"]];
//        [CacheManagement instance].ShowRBK = [NSString stringWithFormat:@"%@",[userData valueForKey:@"ShowRBK"]];
//        [CacheManagement instance].listEcCaseTitle = [userData valueForKey:@"listEcCaseTitle"];
//
//        NSString *ToPerfectRemind = [NSString stringWithFormat:@"%@",[userData valueForKey:@"ToPerfectRemind"]];
//        if (![ToPerfectRemind isEqualToString:@""]&&![[ToPerfectRemind lowercaseString] containsString:@"null"]) {
//            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"" message:ToPerfectRemind preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *al = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
//            [ac addAction:al];
//            [destination presentViewController:ac animated:YES completion:^{}];
//        }
//    }
    
    if (isSave==YES) [CacheManagement instance].currentDBUser.isSavePwd=@"1";
    else [CacheManagement instance].currentDBUser.isSavePwd=@"0";
    [CacheManagement instance].currentDBUser.userID = [txtUserName.text uppercaseString];
    [CacheManagement instance].currentDBUser.userName = [txtUserName.text uppercaseString];
    [CacheManagement instance].currentDBUser.password = txtPassword.text;
    [_usermanagement updateUser:[CacheManagement instance].currentDBUser];
    
    
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"defective" bundle:nil] ;
    UIViewController *destination = [board instantiateInitialViewController] ;
    [self.navigationController pushViewController:destination animated:YES] ;
}

- (void) MobileSolutionLogin:(BOOL)show {

    [_usermanagement loginServer:[txtUserName.text uppercaseString] password:txtPassword.text];
}


- (void) DefectiveForgetPass:(BOOL)show {
    
    self.waitview.hidden = YES ;
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择找回方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"手机验证直接获取密码",@"联系品牌公司获取密码",nil];
    [sheet showInView:self.view] ;
}

- (void) MobileSolutionForgetPass:(BOOL)show {
    
    [_usermanagement forgetPwdServer:[txtUserName.text uppercaseString]];
}


//忘记密码
-(IBAction)ForgetPwdEvent:(id)sender
{
    if([txtUserName.text length]<=0)
    {
        [Utilities alertMessage:SYSLanguage?@"Please Fill in UserName Field":@"请输入用户名"];
        return;
    }
    
    [CacheManagement instance].userLoginName = [txtUserName.text uppercaseString];
    [CacheManagement instance].userEncode = @"" ;
    [self.txtPassword resignFirstResponder];
    [self.txtUserName resignFirstResponder];
    
    [self DefectiveForgetPass:NO];
    
}

//修改密码
-(IBAction)ChanJsongePwdEvent:(id)sender
{
    
//    NSURL *url = [NSURL URLWithString:@"MobileApp://com.Ynew.MobileApp"];      
//    [[UIApplication sharedApplication] openURL:url];
//    return;
    
    //跳转到修改密码页面
//    ChangePasswordController *controller = [[ChangePasswordController alloc] init];
//    [self.navigationController pushViewController:controller animated:YES];
//    [controller release];
}


//更新版本
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 120) {
        
        if (buttonIndex == 1) {
            
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"400-880-1515"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
    }
    
    if (alertView.tag == 999) {
        
        if (buttonIndex == 1) {
            
            UITextField *nameField = [alertView textFieldAtIndex:0];
            
            if (![nameField.text isEqualToString:@""]) {
                
                [self findPassword:nameField.text];
            }
            else {
                
                [Utilities alertMessage:@"请输入门店负责人手机号"];
            }
        }
        
        return ;
    }
    
    if (alertView.tag == 777) {
        
        self.waitview.hidden = NO;
        
        if (buttonIndex == 0) [self MobileSolutionLogin:YES];
        if (buttonIndex == 1) [self DefectiveLogin:YES];
        
        return ;
    }
    
    if (alertView.tag == 779) {
        
        self.waitview.hidden = NO;
        
        if (buttonIndex == 0) [self MobileSolutionForgetPass:YES];
        if (buttonIndex == 1) [self DefectiveForgetPass:YES];
        
        return ;
    }
    
    if (buttonIndex==0)
    {
        @try 
        {
            if ([CacheManagement instance].currentUser.UpgradeUrl==nil ||
                [[CacheManagement instance].currentUser.UpgradeUrl isEqualToString:@""]==YES) 
            {
                return;
            }
            
            NSString *iTunesLink = [NSString stringWithFormat:@"%@",[CacheManagement instance].currentUser.UpgradeUrl];
            NSURL *iTunesURL = [NSURL URLWithString:iTunesLink];
            
            // Produce a phobos.apple.com URL that will open the iTunes or App Store application directly
            [NSURL URLWithString:[NSString stringWithFormat:@"http://phobos.apple.com%@?%@",
                                  iTunesURL.path, iTunesURL.query]];
            [[UIApplication sharedApplication] openURL:iTunesURL];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
}


-(void) completeServer:(NSString *)responseString CurrentError:(NSString *)error InterfaceName:(NSString *)interface
{
//    [ HUD hideUIBlockingIndicator];
    
    NSString *resultString = nil;
    self.waitview.hidden= YES;
    
    if (error) 
    {
        if ([error isEqualToString:SYSLanguage?@"Request Failed":@"网络请求失败"])
        {
            [Utilities showNetworkErrorView];
        }
        else if([error isEqualToString:@"401"]==YES)
        {
            [Utilities alertMessage:SYSLanguage?@"Login Failed":@"登录失败"];
        }
        else 
        {
            [Utilities alertMessage:error];
        }
        self.waitview.hidden= YES;
        return;
    }
    
    
    if([interface isEqualToString:kLoginString]) //系统登录返回结果
    {
        NSArray *arr = [responseString JSONValue];
        if (!arr) {
            [Utilities alertMessage:SYSLanguage?@"Login Failed for null data":@"登录失败,返回数据为空"];
            return;
        }
        LoginResultEntity *entity = [[LoginResultEntity alloc] initWithDictionary:[arr firstObject]];
        [[CacheManagement instance].moduleArr removeAllObjects];
        for (id obj in [arr objectAtIndex:1])
        {
            [[CacheManagement instance].moduleArr addObject:[obj objectForKey:@"ModuleId"]];
        }
        if (!entity.UserId)
        {
            entity.UserId = @"testid";
        }
        
        if (entity.dataSource&&![entity.dataSource isEqual:[NSNull null]]) [CacheManagement instance].dataSource = [NSString stringWithFormat:@"%@",entity.dataSource] ;
        else [CacheManagement instance].dataSource = @"CN" ;
        
        [CacheManagement instance].userLoginName = [txtUserName.text uppercaseString];
        [CacheManagement instance].CurrentMonthLoinTimes = [[arr lastObject]valueForKey:@"CurrentMonthLoinTimes"];
        [CacheManagement instance].CurrentMonthVisitHours = [[arr lastObject]valueForKey:@"CurrentMonthVisitHours"];
        
        if([entity.CheckFlag isEqual:@"0"])
        {
            [HUD hideUIBlockingIndicator];
            resultString = entity.CheckError;
            [Utilities alertMessage:resultString];
        }
        else
        {
            
            if ([[NSString stringWithFormat:@"%@",entity.NewVersion] isEqualToString:@"Y"]) {
                
                if ([[NSString stringWithFormat:@"%@",entity.MustVersion] isEqualToString:@"Y"]) {
                    [self showRemindAlertWithMessage:@"检测到新版本,正在跳转到下载页面"];
                    [self performSelector:@selector(goToAppStore:) withObject:[NSString stringWithFormat:@"%@",entity.UpgradeUrl] afterDelay:1.5];
                } else {
                    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"检测到新版本,是否马上更新?" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *ac1 = [UIAlertAction actionWithTitle:@"下载更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self performSelector:@selector(goToAppStore:) withObject:[NSString stringWithFormat:@"%@",entity.UpgradeUrl] afterDelay:0];
                    }];
                    UIAlertAction *ac2 = [UIAlertAction actionWithTitle:@"下次再说" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                        entity.isLogin=@"1";//设置状态为登录状态
                        
                        if (isSave==YES) [CacheManagement instance].currentDBUser.isSavePwd=@"1";
                        else [CacheManagement instance].currentDBUser.isSavePwd=@"0";
                        
                        [CacheManagement instance].currentUser = entity;
                        [CacheManagement instance].currentDBUser.userID = entity.UserId;
                        [CacheManagement instance].currentDBUser.userName = [txtUserName.text uppercaseString];
                        [CacheManagement instance].currentDBUser.password = txtPassword.text;
                        [_usermanagement updateUser:[CacheManagement instance].currentDBUser];
                        
                        if ([CacheManagement instance].currentUser.OutTimeMin==nil ||
                            [[CacheManagement instance].currentUser.OutTimeMin isEqualToString:@""]) {
                            [CacheManagement instance].currentUser.OutTimeMin=@"720";
                        }
                        if ([CacheManagement instance].moduleArr&&[[CacheManagement instance].moduleArr containsObject:@"M0500"]) [self ChosseLanguage];
                        else [self checkSyncVersion];
                        
                        
                    }];
                    [controller addAction:ac1];
                    [controller addAction:ac2];
                    [self presentViewController:controller animated:YES completion:^{}];
                }
                
                return ;
            }
            
            
            entity.isLogin=@"1";//设置状态为登录状态
            
            if (isSave==YES) [CacheManagement instance].currentDBUser.isSavePwd=@"1";
            else [CacheManagement instance].currentDBUser.isSavePwd=@"0";
            
            [CacheManagement instance].currentUser = entity;
            [CacheManagement instance].currentDBUser.userID = entity.UserId;
            [CacheManagement instance].currentDBUser.userName = [txtUserName.text uppercaseString];
            [CacheManagement instance].currentDBUser.password = txtPassword.text;
            [_usermanagement updateUser:[CacheManagement instance].currentDBUser];
            
            if ([CacheManagement instance].currentUser.OutTimeMin==nil ||
                [[CacheManagement instance].currentUser.OutTimeMin isEqualToString:@""]) {
                [CacheManagement instance].currentUser.OutTimeMin=@"720";
            }
            if ([CacheManagement instance].moduleArr&&[[CacheManagement instance].moduleArr containsObject:@"M0500"]) [self ChosseLanguage];
            else [self checkSyncVersion];
        }
    }
    
    if([interface isEqualToString: kReGetPasswordString]) //忘记密码返回接口
    {
        NSDictionary *dictionary = [responseString JSONValue];
        [Utilities alertMessage:[dictionary valueForKey:@"CheckError"]];
    }
}


//判断是否需要下载数据
-(void) checkSyncVersion
{
    _issueManagement = [[IssueManagement alloc] init]; 
    _issueManagement.delegate = self;
    
    self.waitview.hidden= NO;
    //获取Issue表信息
    [_issueManagement getTableDataServer:kNVM_SYNC_PARAMETER_VERSION];
}


//下载Issue 数据  服务器取到的表数据
-(void) completeDownloadServer:(NSString *)responseString CurrentError:(NSString *)error InterfaceName:(NSString *)interface {
    self.waitview.hidden = YES ;
    if (error) {
        if ([error isEqualToString:SYSLanguage?@"Request Failed":@"网络请求失败"]) [Utilities showNetworkErrorView];
        else [Utilities alertMessage:error];
    } else {
        //本地
        NSMutableArray *localSyncVersions =  [_issueManagement getLocalSyncVersion];  // 本地表版本信息
        NSArray *array = [responseString JSONValue];    // 接口返回表版本信息
        NSMutableArray *dictSyncVersion = [[NSMutableArray alloc] init];
        if ([localSyncVersions count] == 0)
        {
            for (NSDictionary *dic in array)
            {
                SyncParaVersionEntity *net_entity = [[SyncParaVersionEntity alloc] initWithDictionary:dic];
                [dictSyncVersion addObject:net_entity];
            }
        } else {
            for (NSDictionary *dictionary  in array) {
                
                SyncParaVersionEntity *net_entity = [[SyncParaVersionEntity alloc] initWithDictionary:dictionary];
                
                BOOL isExist = NO ;
                
                for (SyncParaVersionEntity *loc in localSyncVersions)
                {
                    if([loc.paraType isEqualToString:net_entity.paraType])
                    {
                        isExist = YES ;
                        if ([loc.paraVersion intValue] != [net_entity.paraVersion intValue])
                        {
                            [dictSyncVersion addObject:net_entity];
                        }
                    }
                }
                
                if (!isExist&&![[NSString stringWithFormat:@"%@",net_entity.paraType] isEqualToString:@"SYS_PARAMETER"]) {
                    
                    [dictSyncVersion addObject:net_entity];
                }
            }
        }
        
        needSyncVersions = dictSyncVersion;
 
        if(needSyncVersions.count>0) {
            //需要跳转到下载数据页面
            SyncDataViewController *mainController = [[SyncDataViewController alloc] init];
            [mainController setSyncVersions:needSyncVersions];
            [self.navigationController pushViewController:mainController animated:YES];
        } else {
            [self ChosseLanguage];
        }
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect wFrame = self.waitview.frame ;
    wFrame.size.height = PHONE_HEIGHT ;
    wFrame.size.width = PHONE_WIDTH ;
    wFrame.origin.x = 0 ;
    wFrame.origin.y = 0 ;
    self.waitview.frame = wFrame ;
    
    [self.view addSubview:self.waitview];
    [self.view bringSubviewToFront:self.waitview];
    
    [self.waitview setHidden:YES];
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
#endif

    [self createNavigationBar];
    

    txtUserName.returnKeyType = UIReturnKeyDone;
    txtUserName.delegate=self;
    
    txtPassword.secureTextEntry=TRUE; //密码格式
    txtPassword.returnKeyType = UIReturnKeyDone;
    txtPassword.delegate=self;

    
    isSave=YES;
    [btnIsSavePwd setBackgroundImage:[UIImage imageNamed:@"savepass.png"] forState:UIControlStateNormal];
    
    if([CacheManagement instance].currentDBUser!=nil)
    {
        txtUserName.text = [CacheManagement instance].currentDBUser.userName;
        
        if( [[CacheManagement instance].currentDBUser.isSavePwd isEqualToString:@"1"])
        {
            txtPassword.text = [CacheManagement instance].currentDBUser.password;
            isSave=YES;
            [btnIsSavePwd setBackgroundImage:[UIImage imageNamed:@"savepass.png"] forState:UIControlStateNormal];
        }
        else 
        {
            isSave=NO;
            [btnIsSavePwd setBackgroundImage:[UIImage imageNamed:@"pass.png"] forState:UIControlStateNormal];
        }
    }

    _usermanagement = [[UserInfoManagement alloc] init]; 
    _usermanagement.delegate = self;
}

- (void)viewDidUnload
{
    [self setWaitingLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

    

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 0) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请输入门店负责人手机号" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.alertViewStyle = UIAlertViewStylePlainTextInput ;
        
        UITextField *nameField = [alert textFieldAtIndex:0];
        nameField.placeholder = @"请输入门店负责人手机号";
        nameField.clearButtonMode = UITextFieldViewModeWhileEditing ;
        nameField.keyboardType = UIKeyboardTypeNumberPad ;
        
        alert.tag = 999 ;
        [alert show];
    }
    
    if (buttonIndex == 1) {
        
//        [self findPassword:@""];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请致电 400-880-1515 获取密码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
        alert.tag = 120 ;
        [alert show] ;
    }
}

- (void) findPassword:(NSString *)phone {
    
    NSDictionary *dic = @{@"UserAccount":[self.txtUserName.text uppercaseString],@"StoreManagePhone":phone,@"ActionType":@"en"};
    
    [[HttpAPIClient sharedClient] POST:[NSString stringWithFormat:@"%@GetPwd",KWebEHDefectiveString] parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.waitview.hidden = YES ;
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (![responseStr JSONValue]) {
            NSString *aesString = [AES128Util AES128Decrypt:responseStr key:[CommonUtil getDecryKey:[self.txtUserName.text uppercaseString]]]  ;
            responseObject = [aesString JSONValue] ;
        }else {
            responseObject = [responseStr JSONValue] ;
        }
        if ([[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"Code"]] isEqualToString:@"200"]) {
            
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"Msg"]] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"复制密码" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSString *password = [[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"Msg"]] stringByReplacingOccurrencesOfString:@"获取密码成功，您的密码是" withString:@""];
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = password;
            }];
            [ac addAction:action];
            [self presentViewController:ac animated:YES completion:nil];
        } else {
            [Utilities alertMessage:[responseObject valueForKey:@"Msg"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [Utilities alertMessage:@"服务器请求失败,请重试"];
        
        self.waitview.hidden = YES ;
    }];
}

- (void)changedSuccess {
    
    txtPassword.text =@"";
}

@end
