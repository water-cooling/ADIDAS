//
//  AppDelegate.m
//  ADIDAS
//
//  Created by testing on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "LoadingViewController.h"
#import "Reachability.h"
#import "LoginViewController.h"
#import "CommonUtil.h"
#import "CommonDefine.h"
#import "SqliteHelper.h"
#import "Utilities.h"
#import "ASIHTTPRequest.h"
#import "CacheManagement.h"
#import "NSString+SBJSON.h"
#import "LeveyTabBarController.h"
#import "VMStoreMenuViewController.h"
#import "HttpAPIClient.h"
#import "User.h"



@implementation AppDelegate

@synthesize window = _window;
@synthesize navController;


-(void)CountUploadFileNum
{
    self.UploadFileNum = 0;
    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM NVM_FILE_LIST where USER_ID = '%@'",[CacheManagement instance].currentUser.UserId];
    FMDatabase* db = [[SqliteHelper shareCommonSqliteHelper]database];
    FMResultSet* rs = [db executeQuery:sql];
    
    while ([rs next]) {
        
        self.UploadFileNum ++;
    }
    if (self.UploadFileNum > 0) {
        
        [[[[CacheManagement instance]leveyTabbarController].tabBar viewWithTag:888] setHidden:NO];
    }
    else {
        
        [[[[CacheManagement instance]leveyTabbarController].tabBar viewWithTag:888] setHidden:YES];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.SaveTimer = [NSTimer timerWithTimeInterval:60 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.SaveTimer forMode:NSDefaultRunLoopMode];
    [self.SaveTimer setFireDate:[NSDate distantFuture]] ;

    self.railmanageIssueList = [[NSMutableArray alloc]init];
    self.outTime_Work_Main_ID_List = [[NSMutableArray alloc]init];
    self.outTime_IST_CHK_ID_List = [[NSMutableArray alloc]init];
    self.Store_NA_List = [[NSMutableArray alloc]init];
    self.lastScoreArray = [[NSMutableArray alloc]init];
    self.VMlastScoreArray = [[NSMutableArray alloc]init];
    self.VM_CHECK_ItemList = [[NSMutableArray alloc]init];
    FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
    
    [db beginTransaction];
    BOOL result = YES;
    @try {
        [self deleteOutTimeWorkMain:db];
        [self deleteOutTimeARMSChk:db];
        [self deleteOutTimeARMSChkItem:db];
        [self deleteOutTimeIST_ISSUE_PHOTO_and_OUTTime_IST_STORE_PHOTO:db];
        [self deleteOutTimeVMChk:db];
        [self deleteOutTimeVMChkItem:db];
//        [self deleteOutTimeFileList:db];
    }
    @catch (NSException *exception) {
        result = NO;
    }
    @finally {
        if (result == YES)
        {
            [db commit];
        }
        else if(result == NO)
        {
            [ db rollback];
        }
    }
    [self CountUploadFileNum];
    BOOL on = [[NSUserDefaults standardUserDefaults]boolForKey:@"upload"];
    [CacheManagement instance].uploaddata = on;
 
    //友盟统计分析服务
//    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:(ReportPolicy) REALTIME channelId:nil];
//    [MobClick setCrashReportEnabled:YES];
//    [Utilities umengTracking:kUmAdidasOpenApp userCode:nil];
    
    //***********
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    // 检测网络连接
    [[NSNotificationCenter defaultCenter] addObserver: self 
                                             selector: @selector(reachabilityChanged:) 
                                                 name: kReachabilityChangedNotification 
                                               object: nil];
    
	hostReach = [[Reachability reachabilityWithHostName: @"www.sina.com.cn"] retain];//Server address
	[hostReach startNotifier];
    
    
    LoadingViewController *controller = [[[LoadingViewController alloc] init]autorelease];
    navController = [[[UINavigationController alloc] initWithRootViewController:controller]autorelease];
    
    
    [[UINavigationBar appearance] setBarTintColor:[CommonUtil colorWithHexString:@"1a1b1f"]] ;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    
    if(@available(iOS 15.0,*)){
        UINavigationBarAppearance* appearance = [[UINavigationBarAppearance alloc]init];
        appearance.backgroundColor = [CommonUtil colorWithHexString:@"#3b3b3f"];
        appearance.shadowColor = [UIColor clearColor];
        appearance.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
        [UINavigationBar appearance].scrollEdgeAppearance = appearance;
        [UINavigationBar appearance].standardAppearance = appearance;
    }
    
    _window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    return YES;
}

-(BOOL)checkNetWork
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.sina.com.cn"];
    BOOL NET_OK = YES;
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            NET_OK = NO;
            break;
        case ReachableViaWWAN:
             NET_OK = YES;
            break;
        case ReachableViaWiFi:
             NET_OK = YES;
            break;
    }
    return NET_OK;
}

//-(void)deletetest
//{
//    NSString* sql = [NSString stringWithFormat:@""]
//}

-(void)deleteOutTimeFileList:(FMDatabase*)db
{
    NSString* date = [Utilities  NSDateToDateString:[NSDate dateWithTimeInterval:-24*60*60*10 sinceDate:[Utilities TransFormate:[Utilities NSStringToNSDate2:[Utilities DateNow]]]]];
    NSString *sql = [NSString stringWithFormat:@"delete from NVM_FILE_LIST where date(CREATE_DATE) <= '%@'",date];
    [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql];
    
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[Utilities SysDocumentPath] error:nil];
    for (NSString *TimeStr in files) {
        
        NSDate *OldDate = [Utilities NSStringToNSDate2:TimeStr];
        if (OldDate) {
            
            NSDate *LastDate = [Utilities NSStringToNSDate2:date];
            if ([OldDate isEqualToDate:[OldDate earlierDate:LastDate]]) {
                
                NSString *DeleteString = [NSString stringWithFormat:@"%@/%@",[Utilities SysDocumentPath],TimeStr];
                
                NSFileManager *appFileManager = [NSFileManager defaultManager];
                NSError *err = nil ;
                if ([appFileManager fileExistsAtPath:DeleteString]) {
                    
                    [appFileManager removeItemAtPath:DeleteString error:&err] ;
                    if (err) {
                        NSLog(@"%@",[err localizedDescription]) ;
                    }
                }
            }
        }
        
    }
}

-(void)deleteOutTimeWorkMain:(FMDatabase*)db
{
    NSString* date = [Utilities  NSDateToDateString:[NSDate dateWithTimeInterval:-24*60*60*10 sinceDate:[Utilities TransFormate:[Utilities NSStringToNSDate2:[Utilities DateNow]]]]];
    NSString* sql_ = [NSString stringWithFormat:@"select * from IST_WORK_MAIN where date(CHECK_IN_TIME) <= '%@'",date];
    
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql_];
    while ([rs next])
    {
        //获取表中过期id
        NSString* outtimeworkmainid = [rs stringForColumnIndex:0];
        [self.outTime_Work_Main_ID_List addObject:outtimeworkmainid];
    }
    [rs close];
    NSString *sql = [NSString stringWithFormat:@"delete from IST_WORK_MAIN where date(CHECK_IN_TIME) <= '%@'",date];
    [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql];
}

-(void)deleteOutTimeARMSChk:(FMDatabase*)db
{
    for (NSString* outtimeworkmainid in self.outTime_Work_Main_ID_List)
    {
        NSString* sql = [NSString stringWithFormat:@"select * from IST_FR_ARMS_CHK where WORK_MAIN_ID = '%@'",outtimeworkmainid];
        FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
        while ([rs next])
        {
            NSString* outtimeArmschkid = [rs stringForColumnIndex:0];
            [self.outTime_IST_CHK_ID_List addObject:outtimeArmschkid];
        }
        [rs close];
        NSString* sql_ = [NSString stringWithFormat:@"delete from IST_FR_ARMS_CHK where WORK_MAIN_ID = '%@'",outtimeworkmainid];
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql_];
    }
}

-(void)deleteOutTimeARMSChkItem:(FMDatabase*)db
{
    // 首先删除对应图片
    for (NSString* outtimeArmschkid in self.outTime_IST_CHK_ID_List)
    {
        NSString* sql = [NSString stringWithFormat:@"select * from IST_FR_ARMS_CHK_ITEM where FR_ARMS_CHK_ID = '%@'",outtimeArmschkid];
        FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
        while ([rs next])
        {
            [[NSFileManager defaultManager]removeItemAtPath:[rs stringForColumnIndex:6] error:nil];
            [[NSFileManager defaultManager]removeItemAtPath:[rs stringForColumnIndex:7] error:nil];
        }
        [rs close];
    }
    
    for (NSString* outtimeArmschkid in self.outTime_IST_CHK_ID_List)
    {
        NSString* sql = [NSString stringWithFormat:@"delete from IST_FR_ARMS_CHK_ITEM where FR_ARMS_CHK_ID = '%@'",outtimeArmschkid];
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql];
    }
}

-(void)deleteOutTimeVMChk:(FMDatabase*)db
{
    for (NSString* outtimeworkmainid in self.outTime_Work_Main_ID_List)
    {
        NSString* sql = [NSString stringWithFormat:@"select * from NVM_IST_VM_CHECK where WORK_MAIN_ID = '%@'",outtimeworkmainid];
        FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
        while ([rs next])
        {
            NSString* outtimechkid = [rs stringForColumnIndex:0];
            [self.outTime_NVM_IST_VM_CHECK_List addObject:outtimechkid];
        }
        [rs close];
        NSString* sql_ = [NSString stringWithFormat:@"delete from NVM_IST_VM_CHECK where WORK_MAIN_ID = '%@'",outtimeworkmainid];
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql_];
        // 删除对应的STATUS 表
        NSString* sql__ = [NSString stringWithFormat:@"delete from NVM_STATUS where WORKMAINID = '%@'",outtimeworkmainid];
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql__];
        
    }
}

-(void)deleteOutTimeVMChkItem:(FMDatabase*)db
{
    // 首先删除对应图片
    for (NSString* outtimeArmschkid in self.outTime_NVM_IST_VM_CHECK_List)
    {
        NSString* sql = [NSString stringWithFormat:@"select * from NVM_IST_VM_CHECK_ITEM where VM_CHK_ID = '%@'",outtimeArmschkid];
        FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
        while ([rs next])
        {
            [[NSFileManager defaultManager]removeItemAtPath:[rs stringForColumnIndex:6] error:nil];
            [[NSFileManager defaultManager]removeItemAtPath:[rs stringForColumnIndex:7] error:nil];
        }
        [rs close];
    }
    
    for (NSString* outtimeArmschkid in self.outTime_NVM_IST_VM_CHECK_List)
    {
        NSString* sql = [NSString stringWithFormat:@"delete from NVM_IST_VM_CHECK_ITEM where VM_CHK_ID = '%@'",outtimeArmschkid];
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql];
    }
}

-(void)deleteOutTimeIST_ISSUE_PHOTO_and_OUTTime_IST_STORE_PHOTO:(FMDatabase*)db
{
    for (NSString* outtimeworkmainid in self.outTime_Work_Main_ID_List)
    {
        NSString* sql_ = [NSString stringWithFormat:@"delete from NVM_IST_ISSUE_PHOTO_LIST where ISSUE_CHECK_ID = '%@'",outtimeworkmainid];
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql_];
        NSString* sql__ = [NSString stringWithFormat:@"delete from NVM_IST_STORE_PHOTO_LIST where TAKE_ID = '%@'",outtimeworkmainid];
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql__];
        NSString* sql___ = [NSString stringWithFormat:@"delete from NVM_IST_STORE_TAKE_PHOTO where WORK_MAIN_ID = '%@'",outtimeworkmainid];
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql___];
        NSString* sql____ = [NSString stringWithFormat:@"delete from NVM_IST_ISSUE_CHECK where ISSUE_CHECK_ID = '%@'",outtimeworkmainid];
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql____];
    }
}

- (void)reachabilityChanged:(NSNotification *)note 
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass:[Reachability class]]);
    
    NetworkStatus status = [curReach currentReachabilityStatus];
    if (status == NotReachable) 
    {
//        [Utilities showNetworkErrorView];
        ALERTVIEW(@"网络无法连接");
    }
}

-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
//    NSLog(@"~~~~~~~~~~~~~~level~~~~~~~~~~~~~~~ %d", (int)OSMemoryNotificationCurrentLevel());
}

- (void)applicationWillResignActive:(UIApplication *)application
{
       /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

- (void)timerAction {

    NSString *timeStr = [Utilities DateTimeNow] ;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [ud setValue:timeStr forKey:@"currenttime"] ;
    
    [ud synchronize] ;
}


@end
