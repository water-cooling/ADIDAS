//
//  LanguageViewController.m
//  ADIDAS
//
//  Created by wendy on 14-9-3.
//
//

#import "LanguageViewController.h"
#import "LoginViewController.h"
#import "StoreListViewController.h"
#import "PlanViewController.h"
#import "AssistViewController.h"
#import "VMSysSettingViewController.h"
#import "CommonDefine.h"
#import "AppDelegate.h"
#import "CommonUtil.h"
#import "DateListViewController.h"
#import "HttpAPIClient.h"
#import "SqliteHelper.h"
#import "StoreReviewViewController.h"
#import "ReviewSyssettingViewController.h"

@interface LanguageViewController ()

@end

@implementation LanguageViewController

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

-(IBAction)PushTabbarVC
{
    [APPDelegate CountUploadFileNum];
    [self.navigationController  pushViewController:[CacheManagement instance].leveyTabbarController animated:YES];
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
    [self checkEvent];
    // Do any additional setup after loading the view from its nib.
    [self getSelectedDate];
    self.naviImageView.backgroundColor = [CommonUtil colorWithHexString:@"#3b3b3f"];
    
    StoreListViewController *first = [[[StoreListViewController alloc] initWithNibName:@"StoreListViewController" bundle:nil]autorelease];
//    PlanViewController* second = [[[PlanViewController alloc]initWithNibName:@"PlanViewController" bundle:nil]autorelease];
    DateListViewController* second = [[[DateListViewController alloc]initWithNibName:@"DateListViewController" bundle:nil]autorelease];
    AssistViewController* third = [[[AssistViewController alloc]initWithNibName:@"AssistViewController" bundle:nil]autorelease];
    VMSysSettingViewController* fourth = [[[VMSysSettingViewController alloc]initWithNibName:@"VMSysSettingViewController" bundle:nil]autorelease];
    StoreReviewViewController* fifth= [[[StoreReviewViewController alloc]initWithNibName:@"StoreReviewViewController" bundle:nil]autorelease];
    ReviewSyssettingViewController* sixth= [[[ReviewSyssettingViewController alloc]initWithNibName:@"ReviewSyssettingViewController" bundle:nil]autorelease];
    
    UINavigationController* firstnavi = [[[UINavigationController alloc]initWithRootViewController:first]autorelease];
    UINavigationController* secondnavi = [[[UINavigationController alloc]initWithRootViewController:second]autorelease];
    UINavigationController* thirdnavi = [[[UINavigationController alloc]initWithRootViewController:third]autorelease];
    UINavigationController* fourthnavi = [[[UINavigationController alloc]initWithRootViewController:fourth]autorelease];
    UINavigationController* fifthnavi = [[[UINavigationController alloc]initWithRootViewController:fifth]autorelease];
    UINavigationController* sixthnavi = [[[UINavigationController alloc]initWithRootViewController:sixth]autorelease];
    
    NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic setObject:[UIImage imageNamed:@"VM5.png"] forKey:@"Default"];
    [imgDic setObject:[UIImage imageNamed:@"VM1.png"] forKey:@"Highlighted"];
    [imgDic setObject:[UIImage imageNamed:@"VM1.png"] forKey:@"Seleted"];
    [imgDic setObject:SYSLanguage?@"Home":@"首页" forKey:@"title"];
    
    NSMutableDictionary *imgDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic2 setObject:[UIImage imageNamed:@"VM6.png"] forKey:@"Default"];
    [imgDic2 setObject:[UIImage imageNamed:@"VM2.png"] forKey:@"Highlighted"];
    [imgDic2 setObject:[UIImage imageNamed:@"VM2.png"] forKey:@"Seleted"];
    [imgDic2 setObject:SYSLanguage?@"Plan":@"计划" forKey:@"title"];
    
    NSMutableDictionary *imgDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic3 setObject:[UIImage imageNamed:@"VM7.png"] forKey:@"Default"];
    [imgDic3 setObject:[UIImage imageNamed:@"VM3.png"] forKey:@"Highlighted"];
    [imgDic3 setObject:[UIImage imageNamed:@"VM3.png"] forKey:@"Seleted"];
    [imgDic3 setObject:SYSLanguage?@"Assist":@"辅助" forKey:@"title"];
    
    NSMutableDictionary *imgDic4 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic4 setObject:[UIImage imageNamed:@"VM8.png"] forKey:@"Default"];
    [imgDic4 setObject:[UIImage imageNamed:@"VM4.png"] forKey:@"Highlighted"];
    [imgDic4 setObject:[UIImage imageNamed:@"VM4.png"] forKey:@"Seleted"];
    [imgDic4 setObject:SYSLanguage?@"System":@"系统" forKey:@"title"];

    if (SYSLanguage == 1)
    {
        [imgDic setObject:@"Store list" forKey:@"title"];
        [imgDic2 setObject:@"Plan" forKey:@"title"];
        [imgDic3 setObject:@"Documents" forKey:@"title"];
        [imgDic4 setObject:@"System" forKey:@"title"];
    }
    
    NSMutableArray *ctrlArr = [NSMutableArray arrayWithObjects:firstnavi,nil];
    NSMutableArray *imgArr = [NSMutableArray arrayWithObjects:imgDic,nil];
    
    if ([CacheManagement instance].moduleArr&&[[CacheManagement instance].moduleArr containsObject:@"M0500"]) {
        ctrlArr = [NSMutableArray arrayWithObjects:fifthnavi,nil];
        imgArr = [NSMutableArray arrayWithObjects:imgDic,nil];
    }
    
    for (NSString* obj in [CacheManagement instance].moduleArr)
    {
        if ([obj isEqualToString:@"M0100"]) {
            [imgArr addObject:imgDic2];
            [ctrlArr addObject:secondnavi];
        }
        if ([obj isEqualToString:@"M0200"]) {
            [imgArr addObject:imgDic3];
            [ctrlArr addObject:thirdnavi];
        }
    }
    
    if ([CacheManagement instance].moduleArr&&[[CacheManagement instance].moduleArr containsObject:@"M0500"]) {
        [ctrlArr addObject:sixthnavi];
        [imgArr addObject:imgDic4];
    }else{
        [ctrlArr addObject:fourthnavi];
        [imgArr addObject:imgDic4];
    }
    
    LeveyTabBarController* leveyTabBarController = [[LeveyTabBarController alloc] initWithViewControllers:ctrlArr imageArray:imgArr];
    [leveyTabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"bottom.png"]];
    [leveyTabBarController setTabBarTransparent:YES];

    [CacheManagement instance].leveyTabbarController = leveyTabBarController;
}

-(IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)chosselan:(id)sender
{
    UIButton* button = sender;
    NSInteger tag = button.tag;
    if (tag == 0) {
        SYSLanguage = CN;
    }
    else if (tag == 1)
    {
        SYSLanguage = EN;
    }
    
//    LoginViewController* vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
//    [self.navigationController pushViewController:vc animated:YES];
    [self PushTabbarVC];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
   
    [super dealloc];
}
    

    
- (void) getSelectedDate {
    
    NSDictionary *dic = @{@"Action":@"COMMENTDATE",@"account":[CacheManagement instance].currentDBUser.userName,@"ActionType":@"en"};
    
    HttpAPIClient *sharedClient = [[HttpAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kWebMobileHeadString]];
    
    sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    sharedClient.requestSerializer.timeoutInterval = 20;
    
    sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
    
    sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [sharedClient.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    
    [sharedClient GET:@"/DataSyncService.aspx?osType=iPhone" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if(![response JSONValue]){
            response = [AES128Util AES128Decrypt:response key:[CommonUtil getDecryKey:[CacheManagement instance].currentDBUser.userName]];
        }
        
        NSArray *dataAry = [response JSONValue];
        
        if (dataAry&&[dataAry count]) {
            
            [[[[CacheManagement instance]leveyTabbarController].tabBar viewWithTag:8888] setHidden:NO];
            [[[UIAlertView alloc] initWithTitle:SYSLanguage?@"Reminding":@"提示" message:SYSLanguage?@"You have new message(s) about ScoreCard Daily Visit,Please check up in Plan Module!":@"您的日常巡店有新的反馈,请到计划模块中查看!" delegate:NO cancelButtonTitle:nil otherButtonTitles:SYSLanguage?@"OK":@"确定", nil] show];
        }
        else {
            
            [[[[CacheManagement instance]leveyTabbarController].tabBar viewWithTag:8888] setHidden:YES];
            NSString* sql = [NSString stringWithFormat:@"SELECT * FROM NVM_FILE_LIST where USER_ID = '%@'",[CacheManagement instance].currentUser.UserId];
            FMDatabase* db = [[SqliteHelper shareCommonSqliteHelper]database];
            FMResultSet* rs = [db executeQuery:sql];
            int unUploadNum = 0 ;
            
            while ([rs next]) {
                
                unUploadNum ++;
            }
            
            if (unUploadNum > 0) {
                
                [[[UIAlertView alloc] initWithTitle:SYSLanguage?@"Reminding":@"提示" message:SYSLanguage?[NSString stringWithFormat:@"You still have %d reports that have not been uploaded.",unUploadNum]:[NSString stringWithFormat:@"您还有%d份报告尚未上传",unUploadNum] delegate:NO cancelButtonTitle:nil otherButtonTitles:SYSLanguage?@"OK":@"确定", nil] show];
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[[[CacheManagement instance]leveyTabbarController].tabBar viewWithTag:8888] setHidden:YES];
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM NVM_FILE_LIST where USER_ID = '%@'",[CacheManagement instance].currentUser.UserId];
        FMDatabase* db = [[SqliteHelper shareCommonSqliteHelper]database];
        FMResultSet* rs = [db executeQuery:sql];
        int unUploadNum = 0 ;
        
        while ([rs next]) {
            
            unUploadNum ++;
        }
        
        if (unUploadNum > 0) {
            
            [[[UIAlertView alloc] initWithTitle:SYSLanguage?@"Reminding":@"提示" message:SYSLanguage?[NSString stringWithFormat:@"You still have %d reports that have not been uploaded.",unUploadNum]:[NSString stringWithFormat:@"您还有%d份报告尚未上传",unUploadNum] delegate:NO cancelButtonTitle:nil otherButtonTitles:SYSLanguage?@"OK":@"确定", nil] show];
        }
    }];
}
    
    
@end




