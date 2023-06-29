    //
//  StoreMenuViewController.m
//  ADIDAS
//
//  Created by wendy on 14-5-9.
//
//

#import "VMStoreMenuViewController.h"
#import "SqliteHelper.h"
#import "Utilities.h"
#import "CacheManagement.h"
#import "TakePhotoListViewController.h"
#import "ASIHTTPRequest.h"
#import "CommonDefine.h"
#import "NSString+SBJSON.h"
#import "VM_CHECK_ITEM_ViewController.h"
#import "IssueListViewController.h"
#import "SignViewController.h"
#import "RailManageViewController.h"
#import "CampaignViewController.h"
#import "StoreListViewController.h"
#import "NSString+filter.h"
#import "ScoreCardViewController.h"
#import "CommonUtil.h"
#import "RoIssueListViewController.h"
#import "HeadCountViewController.h"
#import "ExerciseViewController.h"
#import "IssueTrackingViewController.h"
#import "AuditListViewController.h"
#import "OnSiteFirstViewController.h"

@interface VMStoreMenuViewController ()

@end

@implementation VMStoreMenuViewController

@synthesize picarray;


//判断是否需要下载数据
-(void) checkEvent
{
    [HUD showUIBlockingIndicator];
    _issueManagement = [[IssueManagement alloc] init];
    _issueManagement.delegate = self;
    
    //获取Issue表信息
    [_issueManagement getTableDataServer:@"SYS_PARAMETER"];
}

-(void)completeDownloadServer:(NSString *)responseString CurrentError:(NSString *)error InterfaceName:(NSString *)interface
{
    [HUD hideUIBlockingIndicator];
    NSArray* arr = [responseString JSONValue];
    for (id obj in arr)
    {
        if([[obj objectForKey:@"PARAMETER_TYPE"]isEqualToString:@"SignatureText"])
        {
            [[NSUserDefaults standardUserDefaults]setObject:[obj objectForKey:@"PARAMETER_VALUE"] forKey:@"event"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [CacheManagement instance].SignatureText = [obj objectForKey:@"PARAMETER_VALUE"];
        }
        if([[obj objectForKey:@"PARAMETER_TYPE"]isEqualToString:@"SignOffText"])
        {
            [CacheManagement instance].SignOffText = [obj objectForKey:@"PARAMETER_VALUE"];
        }
    }
}

-(NSString*)GetlastCheckResult
{
    NSString* urlString = [NSString stringWithFormat:kGetStoreLastCheck,kWebDataString,[CacheManagement instance].userLoginName];
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIFormDataRequest* request = [[ASIFormDataRequest alloc]initWithURL:url];
    
    [request setValidatesSecureCertificate:NO];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    
    //添加ISA 密文验证
    if ([CacheManagement instance].userEncode&&![[CacheManagement instance].userEncode isEqualToString:@""])
        [request addRequestHeader:@"Authorization"
                            value:[NSString stringWithFormat:@"Basic %@",[CacheManagement instance].userEncode]];
    
    [request setPostValue:[CacheManagement instance].currentStore.StoreCode forKey:@"storeCode"];
    [request setPostValue:[Utilities DateTimeNow] forKey:@"checkTime"];
    [request setPostValue:[CacheManagement instance].userLoginName forKey:@"account"];
    [request setPostValue:@"ActionType" forKey:@"en"];
	[request setTimeOutSeconds:200];
    
    
	[request startSynchronous];
    NSError *error = [request error];
    NSString *response = nil;
    if (!error)
    {
        response = [request responseString];
        if (![response JSONValue]) {
            response = [AES128Util AES128Decrypt:[request responseString] key:[CommonUtil getDecryKey:[CacheManagement instance].currentDBUser.userName]]  ;
        }
    }
    return [response JSONValue];
}

-(NSString*)GetVMlastCheckResult
{
    NSString* urlString = [NSString stringWithFormat:kGetVMStoreLastCheck,kWebDataString,[CacheManagement instance].currentStore.StoreCode,[CacheManagement instance].userLoginName,[Utilities DateNow]];
    NSURL *url = [NSURL URLWithString:urlString];
    
    ASIFormDataRequest* request = [[ASIFormDataRequest alloc]initWithURL:url];
    
    [request setValidatesSecureCertificate:NO];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    
    //添加ISA 密文验证
    if ([CacheManagement instance].userEncode&&![[CacheManagement instance].userEncode isEqualToString:@""])
        [request addRequestHeader:@"Authorization"
                        value:[NSString stringWithFormat:@"Basic %@",[CacheManagement instance].userEncode]];
    [request setPostValue:[Utilities DateTimeNow] forKey:@"checkTime"];
    
	[request setTimeOutSeconds:250];
    
    
	[request startSynchronous];
    NSError *error = [request error];
    NSString *response = nil;
    if (!error)
    {
        response = [request responseString];
        if (![response JSONValue]) {
            response = [AES128Util AES128Decrypt:[request responseString] key:[CommonUtil getDecryKey:[CacheManagement instance].currentDBUser.userName]]  ;
        }
    }
    return [response JSONValue];
}

- (void) GetLocationMethod {
    
    //获取坐标信息
    if ([CLLocationManager locationServicesEnabled])
	{
        self.locationManager = [[AMapLocationManager alloc] init];
        
        // 带逆地理信息的一次定位（返回坐标和地址信息）
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
        //   定位超时时间，最低2s，此处设置为2s
        self.locationManager.locationTimeout = 2;
        
        [self.locationManager setDelegate:self];
        
        [self.locationManager setPausesLocationUpdatesAutomatically:NO];
        
        [self.locationManager startUpdatingLocation];
	}
}

#pragma mark - CLLocationManager Delegate
- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
	[self finishSearchLoation];
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
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
}


-(IBAction)sign:(id)sender
{
    SignViewController* signvc = [[SignViewController alloc]initWithNibName:@"SignViewController" bundle:nil];
    [self.navigationController pushViewController:signvc animated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)requestFailed:(ASIHTTPRequest *)request {

    NSString* checkFlag = [[[request responseString]JSONValue]objectForKey:@"CheckFlag"];
    
    if (checkFlag && ![checkFlag isEqual:[NSNull null]] && [checkFlag isEqualToString:@"1"])
    {
        [HUD showUIBlockingSuccessIndicatorWithText:SYSLanguage?@"Check out successfully":@"签出成功" withTimeout:1];
        for (UIViewController *vc in self.navigationController.viewControllers)
        {
            if ( [vc isKindOfClass:[StoreListViewController class]])
            {
                [self.navigationController popToViewController:vc animated:NO];
            }
        }
    }
    else
    {
        [ HUD showUIBlockingIndicatorWithText:SYSLanguage?@"Fail to check out.":@"签出失败" withTimeout:1];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request {

    NSDictionary *resultDic = nil ;
    if (![[request responseString] JSONValue]) {
        NSString *aesString = [AES128Util AES128Decrypt:[request responseString] key:[CommonUtil getDecryKey:[CacheManagement instance].currentDBUser.userName]]  ;
        resultDic = [aesString JSONValue] ;
    }else {
        resultDic = [[request responseString] JSONValue];
    }
    
    NSString* checkFlag = [resultDic objectForKey:@"CheckFlag"];
    
    if (checkFlag && ![checkFlag isEqual:[NSNull null]] && [checkFlag isEqualToString:@"1"])
    {
        [HUD showUIBlockingSuccessIndicatorWithText:SYSLanguage?@"Check out successfully":@"签出成功" withTimeout:1];
        for (UIViewController *vc in self.navigationController.viewControllers)
        {
            if ( [vc isKindOfClass:[StoreListViewController class]])
            {
                [CacheManagement instance].dataSource = @"" ;
                
                AppDelegate *dele = (AppDelegate*)[UIApplication sharedApplication].delegate ;
                [dele.SaveTimer setFireDate:[NSDate distantFuture]] ;
                
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud removeObjectForKey:kSOLUTIONWORKMAINID] ;
                [ud synchronize];
                [self.tabBarController.navigationController popViewControllerAnimated:YES] ;
                [self.navigationController popToViewController:vc animated:NO];
            }
        }
    }
    else
    {
        [ HUD showUIBlockingIndicatorWithText:SYSLanguage?@"Fail to check out.":@"签出失败" withTimeout:1];
    }
}

-(void)checkout
{
    [HUD showUIBlockingIndicator];

    NSString* checkouttime = [Utilities DateTimeNow];
    NSString* sql = [NSString stringWithFormat: @"UPDATE IST_WORK_MAIN SET CHECK_OUT_TIME = '%@',CHECK_IN_TIME = '%@' WHERE STORE_CODE = '%@' and WORK_MAIN_ID = '%@'",checkouttime,[CacheManagement instance].checkinTime,[CacheManagement instance].currentStore.StoreCode,[CacheManagement instance].currentWorkMainID];
    [[SqliteHelper shareCommonSqliteHelper].database executeUpdate:sql];
    
    NSString* urlString = [[NSString stringWithFormat:kStoreCheckOut,kWebDataString,
                            [CacheManagement instance].currentStore.StoreCode,
                            [CacheManagement instance].currentLocation.locationX,
                            [CacheManagement instance].currentLocation.locationY,
                            [CacheManagement instance].checkinTime,
                            checkouttime,
                            [CacheManagement instance].currentWorkMainID,
                            [CacheManagement instance].userLoginName] mk_urlEncodedString__];
    
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
    [request setValidatesSecureCertificate:NO];
    request.delegate = self ;
    [request setRequestMethod:@"GET"];
    [request addRequestHeader:@"Accept" value:@"application/json"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    
    //添加ISA 密文验证
    if ([CacheManagement instance].userEncode&&![[CacheManagement instance].userEncode isEqualToString:@""])
        [request addRequestHeader:@"Authorization"
                        value:[NSString stringWithFormat:@"Basic %@",[CacheManagement instance].userEncode] ];
    
    [request setTimeOutSeconds:200];
    [request startAsynchronous];
  
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self GetLocationMethod];
    self.locationLabel.numberOfLines = 2 ;
    UIImageView* imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 104, DEWIDTH, 103)];
    imageview.image = [UIImage imageNamed:@"pic.png"];
    self.buttonarr  = [NSMutableArray new];
    [self.view addSubview:imageview];
   
    for (NSString *obj in [CacheManagement instance].moduleArr)
    {
        if ([obj isEqualToString:@"M0301"])
        {
            [self.buttonarr addObject:self.VMrailmanageBtn];
        }
        
        if ([obj isEqualToString:@"M0302"])
        {
            [self.buttonarr addObject:self.takephotoBtn];
        }
        
        if ([obj isEqualToString:@"M0303"])
        {
            [self.buttonarr addObject:self.issueBtn];
        }
        
        if ([obj isEqualToString:@"M0304"])
        {
            [self.buttonarr addObject:self.signBtn];
        }
        
        if ([obj isEqualToString:@"M0305"])
        {
            [self.buttonarr addObject:self.railmanageBtn];
        }
        
        if ([obj isEqualToString:@"M0306"])
        {
            [self.buttonarr addObject:self.popBtn];
        }
        
        if ([obj isEqualToString:@"M0307"])
        {
            [self.buttonarr addObject:self.railSignBtn];
        }
        
        if ([obj isEqualToString:@"M0308"])
        {
            [self.buttonarr addObject:self.scoreCardBtn];
        }
        
        if ([obj isEqualToString:@"M0309"])
        {
            [self.buttonarr addObject:self.roIssueBtn];
        }
        
        if ([obj isEqualToString:@"M0310"])
        {
            [self.buttonarr addObject:self.employeBtn];
        }
        
        if ([obj isEqualToString:@"M0311"])
        {
            [self.buttonarr addObject:self.exerciseBtn];
        }
        
        if ([obj isEqualToString:@"M0312"])
        {
            [self.buttonarr addObject:self.auditButton];
        }
        
        if ([obj isEqualToString:@"M0313"])
        {
            [self.buttonarr addObject:self.onSiteButton];
        }
    }
    
    if (![[CacheManagement instance].moduleArr containsObject:@"M0308"]&&[[CacheManagement instance].showScoreCard isEqualToString:@"1"])
    {
        [self.buttonarr insertObject:self.scoreCardBtn atIndex:0];
    }
    
    int i = 0;
    for (UIButton* button in self.buttonarr)
    {
        CGRect bframe = CGRectMake(20+(DEWIDTH/2.0-10)*(i%2), 10+(DEWIDTH/2.0-25)*(i/2), DEWIDTH/2.0-30, DEWIDTH/2.0-30) ;
        button.frame = bframe ;
        [self.BGScrollViewNew addSubview:button];
        i++;
    }
    
    if (i%2 != 0) i = i+1 ;
    
    self.BGScrollViewNew.contentSize = CGSizeMake(10, i/2*(DEWIDTH/2.0-25)+20);
    
    [HUD showUIBlockingIndicator];
    UIButton *checkout =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 21)];
	
//	[back setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
//    //    back.contentMode = UIViewContentModeLeft;
    [checkout setTitle:@"签出"forState:UIControlStateNormal];
	checkout.contentEdgeInsets = UIEdgeInsetsMake(5, -20, 0, 0);
	checkout.titleLabel.font = [UIFont systemFontOfSize:17.0];
    if (SYSLanguage == EN)
    {
        checkout.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [checkout setTitle:@"Check Out" forState:UIControlStateNormal];
    }
    
	UIBarButtonItem *checkoutitem = [[UIBarButtonItem alloc] initWithCustomView:checkout];
    if (!self.ShowLeftButton) {
        [checkout addTarget:self action:@selector(checkout) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = checkoutitem;
    }
    
    NSMutableArray * lastScoreArray = [NSMutableArray array] ;
    NSMutableArray * VMlastScoreArray = [NSMutableArray array] ;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        for (id obj in (NSMutableArray*)[self GetlastCheckResult])
        {
            [lastScoreArray addObject:obj];
        }
        for (id obj in (NSMutableArray*)[self GetVMlastCheckResult])
        {
            [VMlastScoreArray addObject:obj];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideUIBlockingIndicator];
            
            [[APPDelegate lastScoreArray]removeAllObjects];
            [[APPDelegate VMlastScoreArray]removeAllObjects];
            [[APPDelegate lastScoreArray] addObjectsFromArray:lastScoreArray];
            [[APPDelegate VMlastScoreArray] addObjectsFromArray:VMlastScoreArray];
        });
    });
    [self.navigationController.navigationItem setHidesBackButton:YES animated:YES];
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"adidas.png"]];

    self.locationLabel.text = [CacheManagement instance].currentStore.StoreName;
    
     ((AppDelegate*)[UIApplication sharedApplication].delegate).menuController = self;
//    [self checkEvent];
//    [APPDelegate railcheck] = rail;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [APPDelegate CountUploadFileNum];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    self.navigationController.navigationBarHidden = NO;
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    NSInteger vmrail = 0;
    NSInteger issuecheck = 0;
    NSInteger sign = 0;
    NSInteger arsmsign = 0;
    NSInteger takephoto = 0;
    NSInteger rail = 0;
    NSInteger install = 0 ;
    NSInteger scorecard = 0 ;
    NSInteger roissuecheck = 0 ;
    NSInteger headcount = 0 ;
    NSInteger trainingcheck = 0 ;
    NSInteger storeauditcheck = 0 ;
    NSInteger onsitecheck = 0 ;
    
    NSString* sql = [NSString stringWithFormat:@"select * from NVM_STATUS WHERE WORKMAINID = '%@'",[CacheManagement instance].currentWorkMainID];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
    
    while ([rs next])
    {
        vmrail = [rs intForColumn:@"VMRAILCHECK"];
        issuecheck = [rs intForColumn:@"ISSUECHECK"];
        sign = [rs intForColumn:@"SIGN"];
        arsmsign = [rs intForColumn:@"ARSMSIGN"];
        takephoto = [rs intForColumn:@"TAKEPHOTO"];
        rail = [rs intForColumn:@"RAILCHECK"];
        install = [rs intForColumn:@"INSTALL"];
        scorecard = [rs intForColumn:@"SCORECARD"];
        roissuecheck = [rs intForColumn:@"ROISSUECHECK"];
        headcount = [rs intForColumn:@"HEADCOUNT"];
        trainingcheck = [rs intForColumn:@"TRAININGCHECK"];
        storeauditcheck = [rs intForColumn:@"STOREAUDITCHECK"];
        onsitecheck = [rs intForColumn:@"OnSiteCheck"];
    }
    if (vmrail&&sign&&takephoto)
    {
        self.allDone = YES;
    }
    else
    {
        self.allDone = NO;
    }
    
    if (install) {
        [self.popBtn setBackgroundImage:[UIImage imageNamed:@"popDone.png"] forState:UIControlStateNormal];
        if (SYSLanguage == EN)
        {
            [self.popBtn setBackgroundImage:[UIImage imageNamed:@"popDone_en.png"] forState:UIControlStateNormal];
        }
    }
    else
    {
        [self.popBtn setBackgroundImage:[UIImage imageNamed:@"pop.png"] forState:UIControlStateNormal];
        if (SYSLanguage == EN)
        {
            [self.popBtn setBackgroundImage:[UIImage imageNamed:@"pop_en.png"] forState:UIControlStateNormal];
        }
    }
    
    if (rail) {
        
        if ([[[CacheManagement instance].dataSource lowercaseString] containsString:@"rbk"]) {
            [self.railmanageBtn setBackgroundImage:[UIImage imageNamed:@"rbk_ro_armDone_en.png"] forState:UIControlStateNormal];
        } else {
            [self.railmanageBtn setBackgroundImage:[UIImage imageNamed:@"ro_armDone_en.png"] forState:UIControlStateNormal];
        }
        
        NSString *pathStore = [NSString stringWithFormat:@"%@/storetypeforkid.plist",[Utilities SysDocumentPath]] ;
        NSDictionary *storeType = [NSDictionary dictionaryWithContentsOfFile:pathStore];
        if (!storeType) storeType = [NSDictionary dictionary];
        NSString *dataSource = [NSString stringWithFormat:@"%@",[storeType valueForKey:[CacheManagement instance].currentStore.StoreCode]];
        if ([dataSource.uppercaseString containsString:@"CN"])
        {
            [self.railmanageBtn setBackgroundImage:[UIImage imageNamed:@"rbk_ro_armDone_cn.png"] forState:UIControlStateNormal];
        }
    }
    else
    {
        if ([[[CacheManagement instance].dataSource lowercaseString] containsString:@"rbk"]) {
            [self.railmanageBtn setBackgroundImage:[UIImage imageNamed:@"rbk_ro_arm.png"] forState:UIControlStateNormal];
        } else {
            [self.railmanageBtn setBackgroundImage:[UIImage imageNamed:@"ro_arm.png"] forState:UIControlStateNormal];
        }
        
        NSString *pathStore = [NSString stringWithFormat:@"%@/storetypeforkid.plist",[Utilities SysDocumentPath]] ;
        NSDictionary *storeType = [NSDictionary dictionaryWithContentsOfFile:pathStore];
        if (!storeType) storeType = [NSDictionary dictionary];
        NSString *dataSource = [NSString stringWithFormat:@"%@",[storeType valueForKey:[CacheManagement instance].currentStore.StoreCode]];
        if ([dataSource.uppercaseString containsString:@"CN"])
        {
            [self.railmanageBtn setBackgroundImage:[UIImage imageNamed:@"rbk_ro_armCN.png"] forState:UIControlStateNormal];
        }
    }
    
    if (vmrail)
    {
        [self.VMrailmanageBtn setBackgroundImage:[UIImage imageNamed:@"checkDone.png"] forState:UIControlStateNormal];
        if (SYSLanguage == EN)
        {
            [self.VMrailmanageBtn setBackgroundImage:[UIImage imageNamed:@"checkDone_en.png"] forState:UIControlStateNormal];
        }
    }
    else
    {
        [self.VMrailmanageBtn setBackgroundImage:[UIImage imageNamed:@"check.png"] forState:UIControlStateNormal];
        if (SYSLanguage == EN)
        {
            [self.VMrailmanageBtn setBackgroundImage:[UIImage imageNamed:@"check_en.png"] forState:UIControlStateNormal];
        }

    }
    
    if (sign)
    {
        [self.signBtn setBackgroundImage:[UIImage imageNamed:@"signDone.png"] forState:UIControlStateNormal];
        if (SYSLanguage == EN)
        {
            [self.signBtn setBackgroundImage:[UIImage imageNamed:@"signDone_en.png"] forState:UIControlStateNormal];
        }
    }
    else
    {
        [self.signBtn setBackgroundImage:[UIImage imageNamed:@"sign.png"] forState:UIControlStateNormal];
        if (SYSLanguage == EN)
        {
            [self.signBtn setBackgroundImage:[UIImage imageNamed:@"sign_en.png"] forState:UIControlStateNormal];
        }
    }
    
    if (arsmsign)
    {
        if ([[[CacheManagement instance].dataSource lowercaseString] containsString:@"rbk"]){
            [self.railSignBtn setBackgroundImage:[UIImage imageNamed:@"rbk_ro_signoffDone.png"] forState:UIControlStateNormal];
        }else {
           [self.railSignBtn setBackgroundImage:[UIImage imageNamed:@"ro_signoffDone.png"] forState:UIControlStateNormal];
        }
        if (SYSLanguage == EN)
        {
            if ([[[CacheManagement instance].dataSource lowercaseString] containsString:@"rbk"]){
                [self.railSignBtn setBackgroundImage:[UIImage imageNamed:@"rbk_ro_signoffDone_en.png"] forState:UIControlStateNormal];
            }else {
                [self.railSignBtn setBackgroundImage:[UIImage imageNamed:@"ro_signoffDone_en.png"] forState:UIControlStateNormal];
            }
        }
    }
    else
    {
        if ([[[CacheManagement instance].dataSource lowercaseString] containsString:@"rbk"]){
            [self.railSignBtn setBackgroundImage:[UIImage imageNamed:@"rbk_ro_signoff.png"] forState:UIControlStateNormal];
        }else {
            [self.railSignBtn setBackgroundImage:[UIImage imageNamed:@"ro_signoff.png"] forState:UIControlStateNormal];
        }
        if (SYSLanguage == EN)
        {
            if ([[[CacheManagement instance].dataSource lowercaseString] containsString:@"rbk"]){
                [self.railSignBtn setBackgroundImage:[UIImage imageNamed:@"rbk_ro_signoff_en.png"] forState:UIControlStateNormal];
            }else {
                [self.railSignBtn setBackgroundImage:[UIImage imageNamed:@"ro_signoff_en.png"] forState:UIControlStateNormal];
            }
        }
    }
    
    if (issuecheck)
    {
        [self.issueBtn setBackgroundImage:[UIImage imageNamed:@"issueDone.png"] forState:UIControlStateNormal];
        if (SYSLanguage == EN)
        {
            [self.issueBtn setBackgroundImage:[UIImage imageNamed:@"issueDone_en.png"] forState:UIControlStateNormal];
        }
    }
    else
    {
        [self.issueBtn setBackgroundImage:[UIImage imageNamed:@"issue.png"] forState:UIControlStateNormal];
        if (SYSLanguage == EN)
        {
            [self.issueBtn setBackgroundImage:[UIImage imageNamed:@"issue_en.png"] forState:UIControlStateNormal];
        }
    }
    
    if (takephoto)
    {
        [self.takephotoBtn setBackgroundImage:[UIImage imageNamed:@"takephotoDone.png"] forState:UIControlStateNormal];
        if (SYSLanguage == EN)
        {
            [self.takephotoBtn setBackgroundImage:[UIImage imageNamed:@"takephotoDone_en.png"] forState:UIControlStateNormal];
        }
    }
    else
    {
        [self.takephotoBtn setBackgroundImage:[UIImage imageNamed:@"takephoto.png"] forState:UIControlStateNormal];
        if (SYSLanguage == EN)
        {
            [self.takephotoBtn setBackgroundImage:[UIImage imageNamed:@"takephoto_en.png"] forState:UIControlStateNormal];
        }
    }
    
    if (scorecard)
    {
        [self.scoreCardBtn setBackgroundImage:[UIImage imageNamed:@"scorecardDone_en@2x.png"] forState:UIControlStateNormal];
        if (SYSLanguage == EN)
        {
            [self.scoreCardBtn setBackgroundImage:[UIImage imageNamed:@"scorecardDone_en@2x.png"] forState:UIControlStateNormal];
        }
    }
    else
    {
        [self.scoreCardBtn setBackgroundImage:[UIImage imageNamed:@"scorecard_en.png"] forState:UIControlStateNormal];
        if (SYSLanguage == EN)
        {
            [self.scoreCardBtn setBackgroundImage:[UIImage imageNamed:@"scorecard_en.png"] forState:UIControlStateNormal];
        }
        
    }
    
    if (roissuecheck)
    {
        if ([[[CacheManagement instance].dataSource lowercaseString] containsString:@"rbk"]){
            [self.roIssueBtn setBackgroundImage:[UIImage imageNamed:@"rbk_ro_issue_done.png"] forState:UIControlStateNormal];
        }else {
            [self.roIssueBtn setBackgroundImage:[UIImage imageNamed:@"ro_issue_done.png"] forState:UIControlStateNormal];
        }
        if (SYSLanguage == EN)
        {
            if ([[[CacheManagement instance].dataSource lowercaseString] containsString:@"rbk"]){
                [self.roIssueBtn setBackgroundImage:[UIImage imageNamed:@"rbk_ro_issue_en_done.png"] forState:UIControlStateNormal];
            }else {
                [self.roIssueBtn setBackgroundImage:[UIImage imageNamed:@"ro_issue_en_done.png"] forState:UIControlStateNormal];
            }
        }
    }
    else
    {
        if ([[[CacheManagement instance].dataSource lowercaseString] containsString:@"rbk"]){
            [self.roIssueBtn setBackgroundImage:[UIImage imageNamed:@"rbk_ro_issue.png"] forState:UIControlStateNormal];
        }else {
            [self.roIssueBtn setBackgroundImage:[UIImage imageNamed:@"ro_issue.png"] forState:UIControlStateNormal];
        }
        if (SYSLanguage == EN)
        {
            if ([[[CacheManagement instance].dataSource lowercaseString] containsString:@"rbk"]){
                [self.roIssueBtn setBackgroundImage:[UIImage imageNamed:@"rbk_ro_issue_en.png"] forState:UIControlStateNormal];
            }else {
                [self.roIssueBtn setBackgroundImage:[UIImage imageNamed:@"ro_issue_en.png"] forState:UIControlStateNormal];
            }
        }
    }
    
    if (headcount)
    {
        [self.employeBtn setBackgroundImage:[UIImage imageNamed:@"employe_countDone.png"] forState:UIControlStateNormal];
        if (SYSLanguage == EN)
        {
            [self.employeBtn setBackgroundImage:[UIImage imageNamed:@"employe_en_countDone.png"] forState:UIControlStateNormal];
        }
    }
    else
    {
        [self.employeBtn setBackgroundImage:[UIImage imageNamed:@"employe_count.png"] forState:UIControlStateNormal];
        if (SYSLanguage == EN)
        {
            [self.employeBtn setBackgroundImage:[UIImage imageNamed:@"employe_en_count.png"] forState:UIControlStateNormal];
        }
    }
    
    if (trainingcheck)
    {
        [self.exerciseBtn setBackgroundImage:[UIImage imageNamed:@"training_Done.png"] forState:UIControlStateNormal];
        if (SYSLanguage == EN)
        {
            [self.exerciseBtn setBackgroundImage:[UIImage imageNamed:@"training_en_Done.png"] forState:UIControlStateNormal];
        }
    }
    else
    {
        [self.exerciseBtn setBackgroundImage:[UIImage imageNamed:@"training.png"] forState:UIControlStateNormal];
        if (SYSLanguage == EN)
        {
            [self.exerciseBtn setBackgroundImage:[UIImage imageNamed:@"training_en.png"] forState:UIControlStateNormal];
        }
    }
    
    if (storeauditcheck) {
        [self.auditButton setBackgroundImage:[UIImage imageNamed:@"StoreAuditCheckDoneCN.png"] forState:UIControlStateNormal];
        if (SYSLanguage == EN) [self.auditButton setBackgroundImage:[UIImage imageNamed:@"StoreAuditCheckDone.png"] forState:UIControlStateNormal];
    } else {
        [self.auditButton setBackgroundImage:[UIImage imageNamed:@"StoreAuditCheckCN.png"] forState:UIControlStateNormal];
        if (SYSLanguage == EN) [self.auditButton setBackgroundImage:[UIImage imageNamed:@"StoreAuditCheck.png"] forState:UIControlStateNormal];
    }
    
    if (onsitecheck) {
        [self.onSiteButton setBackgroundImage:[UIImage imageNamed:@"onsiteDoneCN.png"] forState:UIControlStateNormal];
        if (SYSLanguage == EN) [self.onSiteButton setBackgroundImage:[UIImage imageNamed:@"onsiteDone.png"] forState:UIControlStateNormal];
    } else {
        [self.onSiteButton setBackgroundImage:[UIImage imageNamed:@"onsiteCN.png"] forState:UIControlStateNormal];
        if (SYSLanguage == EN) [self.onSiteButton setBackgroundImage:[UIImage imageNamed:@"onsite.png"] forState:UIControlStateNormal];
    }
    
    [self viewDidAppear:NO];
//    self.tabBarController.navigationItem.rightBarButtonItem = nil;
}

-(void)showMsg
{
    if (Uploadstatu == 1)
    {
        {
            if ([CacheManagement instance].uploaddata == NO)
            {
                [HUD showUIBlockingIndicatorWithText:SYSLanguage?@"Instant upload closed,please upload in system": @"即时上传功能已关闭，请到系统中手工上传数据" withTimeout:2] ;
            }
            else
            {
                [HUD showUIBlockingSuccessIndicatorWithText:SYSLanguage?@"Submit successfully": @"上传成功" withTimeout:2];
            }
            
        }
    }
    Uploadstatu = 0;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self performSelector:@selector(showMsg) withObject:nil afterDelay:0.8];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && [self.view window] == nil)
    {
        self.view = nil;
        self.picarray = nil;
        self.buttonarr = nil;
    }
}

- (IBAction)railSingAction:(id)sender{

    SignViewController* signvc = [[SignViewController alloc]initWithNibName:@"SignViewController" bundle:nil];
    signvc.isFromRailManage = YES ;
    [self.navigationController pushViewController:signvc animated:YES];
}

- (IBAction)scoreCardAction:(id)sender {
    
    if ([[CacheManagement instance].moduleArr containsObject:@"M0308"]&&[[CacheManagement instance].showScoreCard isEqualToString:@"1"]) {
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:SYSLanguage?@"Please Select Score Card Type":@"请选择类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet] ;
        
        UIAlertAction *ok1 = [UIAlertAction actionWithTitle:SYSLanguage?@"Score Card - Daily Visit":@"Score Card - 日常巡店" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            ScoreCardViewController* score = [[ScoreCardViewController alloc]initWithNibName:@"ScoreCardViewController" bundle:nil];
            score.type = @"D";
            [self.navigationController pushViewController:score animated:YES];
        }];
        
        UIAlertAction *ok2 = [UIAlertAction actionWithTitle:SYSLanguage?@"Score Card - Monthly Report":@"Score Card - 月度报告" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            ScoreCardViewController* score = [[ScoreCardViewController alloc]initWithNibName:@"ScoreCardViewController" bundle:nil];
            score.type = @"M";
            [self.navigationController pushViewController:score animated:YES];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:SYSLanguage?@"Cancel":@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [controller addAction:ok1] ;
        [controller addAction:ok2] ;
        [controller addAction:cancel] ;
        [self presentViewController:controller animated:YES completion:^{}];
        
        return ;
    }
    
    if ([[CacheManagement instance].moduleArr containsObject:@"M0308"]) {
        
        ScoreCardViewController* score = [[ScoreCardViewController alloc]initWithNibName:@"ScoreCardViewController" bundle:nil];
        score.type = @"D";
        [self.navigationController pushViewController:score animated:YES];
        
        return ;
    }
    
    if ([[CacheManagement instance].showScoreCard isEqualToString:@"1"]) {
        
        ScoreCardViewController* score = [[ScoreCardViewController alloc]initWithNibName:@"ScoreCardViewController" bundle:nil];
        score.type = @"M";
        [self.navigationController pushViewController:score animated:YES];
        
        return ;
    }
}

- (IBAction)roIssueAction:(id)sender {
    
    RoIssueListViewController* issuevc = [[RoIssueListViewController alloc]initWithNibName:@"RoIssueListViewController" bundle:nil];
    [self.navigationController pushViewController:issuevc animated:YES];
}

- (IBAction)employeAction:(id)sender { //员工人数检查
    
    HeadCountViewController* headcount = [[HeadCountViewController alloc]initWithNibName:@"HeadCountViewController" bundle:nil];
    [self.navigationController pushViewController:headcount animated:YES];
}

- (IBAction)exerciseAction:(id)sender {
    
    ExerciseViewController* headcount = [[ExerciseViewController alloc]initWithNibName:@"ExerciseViewController" bundle:nil];
    [self.navigationController pushViewController:headcount animated:YES];
}

- (IBAction)auditAction:(id)sender {
    AuditListViewController *audit = [[AuditListViewController alloc] init];
    [self.navigationController pushViewController:audit animated:YES];
}

-(IBAction)VMrailmanage:(id)sender
{
    // 查询数据库是否已有改店面的检查主表
    [CacheManagement instance].currentVMCHKID = nil;
    NSString* sql = [NSString stringWithFormat:@"Select * FROM NVM_IST_VM_CHECK where WORK_MAIN_ID = '%@' and STORE_CODE = '%@'",[CacheManagement instance].currentWorkMainID,[CacheManagement instance].currentStore.StoreCode];
//    NSMutableArray* result = [[NSMutableArray alloc]init];

    FMResultSet* rs = nil;
    rs = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
    while ([rs next])
    {
        [CacheManagement instance].currentVMCHKID = [rs stringForColumnIndex:0];
        break;
    }
    [rs close];
     
    VM_CHECK_ITEM_ViewController* vm_checkvc = [[VM_CHECK_ITEM_ViewController alloc]init];
    [self.navigationController pushViewController:vm_checkvc animated:YES];
}

- (IBAction)onSiteAction:(id)sender {
    
    OnSiteFirstViewController* photovc = [[OnSiteFirstViewController alloc]initWithNibName:@"OnSiteFirstViewController" bundle:nil];
    [self.navigationController pushViewController:photovc animated:YES];
}


-(IBAction)railmanage:(id)sender
{
    // 查询数据库是否已有改店面的检查主表
    [CacheManagement instance].currentCHKID = nil;
    NSString* sql = [NSString stringWithFormat:@"Select * FROM IST_FR_ARMS_CHK where WORK_MAIN_ID = '%@' and STORE_CODE = '%@'",[CacheManagement instance].currentWorkMainID,[CacheManagement instance].currentStore.StoreCode];
    //    NSMutableArray* result = [[NSMutableArray alloc]init];
    
    FMResultSet* rs = nil;
    rs = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
    while ([rs next])
    {
        [CacheManagement instance].currentCHKID = [rs stringForColumnIndex:0];
        break;
    }
    [rs close];
    
    RailManageViewController* railmanagevc = [[RailManageViewController alloc]init];
    [self.navigationController pushViewController:railmanagevc animated:YES];
}

-(IBAction)takephotos:(id)sender
{
    TakePhotoListViewController* photovc = [[TakePhotoListViewController alloc]initWithNibName:@"TakePhotoListViewController" bundle:nil];
    [self.navigationController pushViewController:photovc animated:YES];
}

-(IBAction)issueList:(id)sender
{
    NSString* sql = [NSString stringWithFormat:@"select * from NVM_IST_ISSUE_TRACKING_CHECK where STORE_CODE ='%@' and USER_ID= '%@' and STATUS = '0'",[CacheManagement instance].currentStore.StoreCode,[CacheManagement instance].currentUser.UserId];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    if ([rs next]) {
        IssueTrackingViewController *detail = [[IssueTrackingViewController alloc] initWithNibName:@"IssueTrackingViewController" bundle:nil] ;
        detail.trackingCheckId = [rs stringForColumn:@"ISSUE_TRACKING_CHECK_ID"];
        detail.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [self.leveyTabBarController presentViewController:detail animated:NO completion:^{}];
        [rs close];
        return;
    }
    [rs close];
    
    IssueListViewController* issuevc = [[IssueListViewController alloc]initWithNibName:@"IssueListViewController" bundle:nil];
    [self.navigationController pushViewController:issuevc animated:YES];
}

-(IBAction)Campagin:(id)sender
{
    CampaignViewController* campaignvc = [[CampaignViewController alloc]initWithNibName:@"CampaignViewController" bundle:nil];
    campaignvc.storeCode = [CacheManagement instance].currentStore.StoreCode;
    [self.navigationController pushViewController:campaignvc animated:YES];
}


@end
