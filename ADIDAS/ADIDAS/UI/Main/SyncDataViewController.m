//
//  SyncDataViewController.m
//  ADIDAS
//
//  Created by testing on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SyncDataViewController.h"
#import "Utilities.h"
#import "JSON.h"
#import "StoreListViewController.h"
#import "AppDelegate.h"
#import "CacheManagement.h"
#import "PlanViewController.h"
#import "VMSysSettingViewController.h"
#import "AssistViewController.h"
#import "LanguageViewController.h"

@interface SyncDataViewController()

- (void) syncVersionMethod;
- (void)updateProgress;
@end

@implementation SyncDataViewController

@synthesize syncVersions;


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
    
    // Release any cached data, images, etc that aren't in use.
}

-(IBAction)PushTabbarVC
{
    LanguageViewController* languagevc = [[LanguageViewController alloc]initWithNibName:@"LanguageViewController" bundle:nil];
    [self.navigationController pushViewController:languagevc animated:YES];
    [languagevc release];
}
#pragma mark - View lifecycle
- (void)createNavigationBar {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.navigationItem.title=NSLocalizedString(@"titleSyncDataText", nil);
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
}


-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self syncVersionMethod];
    
}

//初始化
- (void)viewDidLoad
{
    [super viewDidLoad];
    _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    _progressView.frame = CGRectMake(10, 20, DEVICE_WID, 50);
    [self.view addSubview:_progressView];
    [_progressView setProgress:(amountDone = 0.0f)];
    tableCount = syncVersions.count;
    
    _progressText = [[UILabel alloc]initWithFrame:CGRectMake(DEVICE_WID - 70,40, 40, 25)];
    _progressText.textAlignment = NSTextAlignmentLeft;
    _progressText.text=@"0";
    _progressText.font = [UIFont boldSystemFontOfSize:18];
    _progressText.textColor = [Utilities GetCommomLableColor];    
    _progressText.backgroundColor = [UIColor clearColor];    
    [self.view addSubview:_progressText];

    UILabel * _progressText1 = [[UILabel alloc]initWithFrame:CGRectMake(DEVICE_WID - 30,40,30, 25)];
    _progressText1.textAlignment = NSTextAlignmentLeft;
    _progressText1.text=@"%";
    _progressText1.font = [UIFont boldSystemFontOfSize:18];
    _progressText1.textColor = [Utilities GetCommomLableColor];    
    _progressText1.backgroundColor = [UIColor clearColor];    
    [self.view addSubview:_progressText1];
    [_progressText1 release];
    
    
    [self createNavigationBar];
    [self.view setBackgroundColor:[UIColor darkGrayColor]];
    
    _management = [[IssueManagement alloc] init]; 
    _management.delegate = self;
    //开始同步数据
    [HUD showUIBlockingIndicator];
}

-(void) syncVersionMethod
{
    if(syncVersions.count>0)
    {
        currSyncData = [syncVersions objectAtIndex:0];
        [_management getTableDataServer:currSyncData.paraType];
    }
    else
    {
        [HUD hideUIBlockingIndicator];
        [self PushTabbarVC];
    }
}


-(void) completeDownloadServer:(NSString *)responseString CurrentError:(NSString *)error InterfaceName:(NSString *)interface {
    if (error)  {
        [syncVersions removeObject:currSyncData];
    } else {
        
        if (![currSyncData.paraType isEqualToString:@"SYS_PARAMETER"]) {
            NSArray *array = [responseString JSONValue];
            [_management saveLocalSyncVersion:currSyncData newIssueData:array];
        }
        [syncVersions removeObject:currSyncData];
        [self updateProgress];
    }
    [self syncVersionMethod];
}

- (void)updateProgress {
    amountDone += 1.0f;
    float proceValue= (amountDone / tableCount);
    [_progressText setText:[NSString stringWithFormat:@"%d",(int)roundf(proceValue*100)]]; 
    [_progressView setProgress: proceValue];
}

- (void)viewDidUnload
{
    [self setSyncVersions:nil];
    [super viewDidUnload];
}

- (void)dealloc {

    if(_progressView !=nil)
    {
        [_progressView release];
        _progressView=nil;
    }
    if(_progressText !=nil)
    {
        [_progressText release];
        _progressText=nil;
    }
    [super dealloc];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
