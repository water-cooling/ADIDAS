//
//  SysSettingViewController.m
//  ADIDAS
//
//  Created by wendy on 14-5-6.
//
//

#import "VMSysSettingViewController.h"
#import "ChangePasswordController.h"
#import "LoginViewController.h"
#import "CacheManagement.h"
#import "AppDelegate.h"
#import "LeveyTabBarController.h"
#import "CacheManagement.h"
#import "CommonDefine.h"
#import "NSString+SBJSON.h"
#import "UploadFileViewController.h"
#import "MyAccoutViewController.h"
#import "HistoryListViewController.h"
#import "Utilities.h"
#import "CommonUtil.h"

@interface VMSysSettingViewController ()

@end

@implementation VMSysSettingViewController


-(IBAction)Myaccount
{
    MyAccoutViewController* myaccount = [[MyAccoutViewController alloc]initWithNibName:@"MyAccoutViewController" bundle:nil];
    [self.leveyTabBarController hidesTabBar:YES animated:YES];
    [self.navigationController pushViewController:myaccount animated:YES];
}

-(IBAction)onoff:(id)sender
{
    BOOL on = [[NSUserDefaults standardUserDefaults]boolForKey:@"upload"];
    if (on) {
        [CacheManagement instance].uploaddata = NO;
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"upload"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.button setBackgroundImage:[UIImage imageNamed:@"OFF_en.png"] forState:UIControlStateNormal];
    }
    else
    {
        if ([APPDelegate UploadFileNum] > 0)
        {
            [Utilities alertMessage:SYSLanguage?@"Please upload saved file first": @"请先上传已保存的文件"];
            return;
        }
        [CacheManagement instance].uploaddata = YES;
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"upload"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.button setBackgroundImage:[UIImage imageNamed:@"ON_en.png"] forState:UIControlStateNormal];
    }
}

- (void) GetLocationMethod {
    //获取坐标信息
    
    if (![CLLocationManager locationServicesEnabled])
	{
        if (SYSLanguage == EN) {
            [HUD showUIBlockingIndicatorWithText:@"Please turn on LBS" withTimeout:1];
        }
        else
        {
            [HUD showUIBlockingIndicatorWithText:@"请开启手机定位功能" withTimeout:1];
        }
        return;
	}
    
    self.locationManager = [[AMapLocationManager alloc] init];
    
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout = 2;
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManager Delegate
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
	NSLog(@"Location manager error: %@", [error description]);
    [self finishSearchLoation];
    //弹出错误信息
    //弹出错误信息
    if (SYSLanguage == EN) {
        [HUD showUIBlockingIndicatorWithText:@"Please turn on LBS" withTimeout:2];
    }
    else
    {
        [HUD showUIBlockingIndicatorWithText:@"请开启手机定位功能" withTimeout:2];
    }
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
	LocationEntity * currLoc = [[LocationEntity alloc] init];
    currLoc.locationX=[NSString stringWithFormat:@"%f", location.coordinate.longitude];
    currLoc.locationY=[NSString stringWithFormat:@"%f", location.coordinate.latitude];
    
    [CacheManagement instance].currentLocation=currLoc;
    [self finishSearchLoation];
}

- (void)finishSearchLoation
{
    // Stop the location task
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
}


-(IBAction)logout {
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
}

-(IBAction)trylogout
{
    if (SYSLanguage == EN)
    {
        UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"Are you sure?" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        [av show];
    }
    else
    {
        UIAlertView* av = [[UIAlertView alloc]initWithTitle:@"是否确定" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [av show];
    }
}


-(IBAction)UploadFileList:(id)sender
{
    UploadFileViewController* uploadvc = [[UploadFileViewController alloc]initWithNibName:@"UploadFileViewController" bundle:nil];
    [self.leveyTabBarController hidesTabBar:YES animated:YES];
    [self.navigationController pushViewController:uploadvc animated:YES];
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0)
    {
        if (ISDelete) {
            
            ISDelete = NO ;
            NSString *dateString = [Utilities  NSDateToDateString:[NSDate dateWithTimeInterval:-24*60*60*3 sinceDate:[Utilities TransFormate:[Utilities NSStringToNSDate2:[Utilities DateNow]]]]];
            
            NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[Utilities SysDocumentPath] error:nil];
            BOOL isExit = NO ;
            for (NSString *TimeStr in files) {
                
                NSDate *OldDate = [Utilities TransFormate:[Utilities NSStringToNSDate2:TimeStr]];
                
                if (OldDate) {
                    
                    NSDate *LastDate = [Utilities TransFormate:[Utilities NSStringToNSDate2:dateString]];
                    if ([OldDate isEqualToDate:[OldDate earlierDate:LastDate]]) {
                        
                        isExit = YES ;
                        NSString *DeleteString = [NSString stringWithFormat:@"%@/%@",[Utilities SysDocumentPath],TimeStr];
                        
                        NSFileManager *appFileManager = [NSFileManager defaultManager];
                        NSError *err = nil ;
                        if ([appFileManager fileExistsAtPath:DeleteString]) {
                            
                            [appFileManager removeItemAtPath:DeleteString error:&err] ;
                            if (err) {
                                NSLog(@"%@",[err localizedDescription]) ;
                            }
                            else {
                                
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:SYSLanguage?@"Success": @"删除成功" delegate:nil
                                                                      cancelButtonTitle:nil otherButtonTitles:nil];
                                [alert show];
                                [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:1.0];
                            }
                        }
                    }
                }
                
            }
            
            if (!isExit) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil  message:SYSLanguage?@"Not Exist Data": @"未存在数据" delegate:nil
               cancelButtonTitle:nil
               otherButtonTitles:nil];
                [alert show];
                [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:1.0];
            }
        }
     }
    else if(buttonIndex == 1)
    {
        if (ISDelete) {
            
            ISDelete = NO ;
            return ;
        }
        [self logout];
    }
}

- (void) dimissAlert:(UIAlertView *)alert
{
    if(alert)
    {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.BGScroll.contentSize = CGSizeMake(20, 530);
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
    
    self.btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft ;
    self.btn2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft ;
    self.DeleteCacheButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft ;
    self.HistoryButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft ;
    
    //    self.waitView .backgroundColor = [UIColor blackColor];
//    self.waitView .alpha = 0.5;
//    [self.view addSubview:view];
//    [self.view bringSubviewToFront:view];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.waitView ];
//    [[UIApplication sharedApplication].keyWindow.rootViewController.view  bringSubviewToFront:self.waitView];
    ((UILabel*)[self.waitView viewWithTag:88]).text = SYSLanguage?@"Processing,please wait …":@"请稍等,正在执行...";
    [self.waitView setHidden:YES];

    [self GetLocationMethod];
    self.LoinTimesLabel.text = [NSString stringWithFormat:@"%@",[CacheManagement instance].CurrentMonthLoinTimes];
    self.VisitHoursLabel.text =  [NSString stringWithFormat:@"%@",[CacheManagement instance].CurrentMonthVisitHours];
//
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    }
    self.title = @"系统";
    if (SYSLanguage == EN) {
        self.title = @"System";
    }
    self.accountLabel.text = [CacheManagement instance].currentUser.UserName;
    self.usernameLabel.text = [CacheManagement instance].currentUser.UserName;
    self.positionLabel.text = [CacheManagement instance].currentUser.UserType;
    
    BOOL on = [[NSUserDefaults standardUserDefaults]boolForKey:@"upload"];
    if (on) {
        [self.button setBackgroundImage:[UIImage imageNamed:@"ON_en.png"] forState:UIControlStateNormal];
    }
    else
    {
        [self.button setBackgroundImage:[UIImage imageNamed:@"OFF_en.png"] forState:UIControlStateNormal];
    }
    
    [self.btn3 setBackgroundImage:[UIImage imageNamed:@"logout.png"] forState:UIControlStateNormal];
    
    [self.btn3 setBackgroundColor:[CommonUtil colorWithHexString:@"c0391f"]];
    if (SYSLanguage == EN)
    {
        self.label1.text = @"Login times this month";
        self.label1.font = [UIFont systemFontOfSize:12];
        self.label2.text = @"Total hours of store visit this month";
        self.label2.font = [UIFont systemFontOfSize:9];
        [self.btn1 setTitle:@"Data to be uploaded" forState:UIControlStateNormal];
        [self.btn2 setTitle:@"Upload timely" forState:UIControlStateNormal];
        [self.btn3 setTitle:@"Logout" forState:UIControlStateNormal];
        [self.DeleteCacheButton setTitle:@"Clear cache" forState:UIControlStateNormal] ;
        [self.HistoryButton setTitle:@"Store visit record" forState:UIControlStateNormal];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.leveyTabBarController hidesTabBar:NO animated:YES];
    [APPDelegate CountUploadFileNum];
    int num = (int)[APPDelegate UploadFileNum];
    if (num == 0)
    {
        [self.notiImageView setHidden:YES];
        [self.notiNumLabel setHidden:YES];
    }
    else
    {
        [self.notiImageView setHidden:NO];
        [self.notiNumLabel setHidden:NO];
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && [self.view window] == nil)
    {
        self.view = nil;
    }
}

#pragma mark - tablevew 
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0)
    {
        ChangePasswordController* changepsswdVC = [[ChangePasswordController alloc]initWithNibName:@"ChangePasswordController" bundle:nil];
        [self.tabBarController.navigationController pushViewController:changepsswdVC animated:YES];
    }
    else if (indexPath.section == 1)
    {
        UIAlertView* av = [[UIAlertView alloc]initWithTitle:nil message:@"是否退出登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [av show];
    }
}

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1)
//    {
//        for (UIViewController* obj in self.tabBarController.navigationController.viewControllers)
//        {
//            if ([obj isKindOfClass:[LoginViewController class]])
//            {
//                [self.tabBarController.navigationController popToViewController:obj animated:YES];
//                return;
//            }
//        }
//    }
//}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"cell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section == 0)
    {
         cell.textLabel.text = @"修改密码";
        if (SYSLanguage == EN)
        {
            cell.textLabel.text = @"Change Password";
        }
    }
    else if(indexPath.section == 1)
    {
        cell.textLabel.text = @"Logout";
    }
    return cell;
}

- (IBAction)DeleteCache:(id)sender {

    [Utilities alertMessageSelected:SYSLanguage?@"Delete saved picture?": @"确定删除数据?" delegate:self];
    ISDelete = YES ;
}

- (IBAction)SearchHistory:(id)sender {
    
    HistoryListViewController *controller = [[HistoryListViewController alloc] initWithNibName:@"HistoryListViewController" bundle:nil];
    [self.leveyTabBarController hidesTabBar:YES animated:YES];
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)viewDidUnload {
    [self setHistoryButton:nil];
    [self setBGScroll:nil];
    [super viewDidUnload];
}

@end
