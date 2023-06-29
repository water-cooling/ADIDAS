    //
//  LoadingViewController.m
//  WSE
//
//  Created by testing on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoadingViewController.h"
#import "LoginViewController.h"
#import "ChangePasswordController.h"
#import "CommonTestController.h"
#import "AppDelegate.h"
#import <AMapFoundationKit/AMapServices.h>
#import "AregmentView.h"
@implementation LoadingViewController
@synthesize loadingImage;


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

//-(void) viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    //隐藏navigation bar
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
//}

- (void) GetLocationMethod {
    //获取坐标信息
    self.locManager = [[CLLocationManager alloc] init];
    if (![CLLocationManager locationServicesEnabled])
	{
        if (SYSLanguage == EN) {
            [HUD showUIBlockingIndicatorWithText:@"Please turn on LBS" withTimeout:2];
        }
        else
        {
            [HUD showUIBlockingIndicatorWithText:@"请开启手机定位功能" withTimeout:2];
        }
        return;
	}
    if (IOSVersion >= 8.0)
    {
        int _status=[CLLocationManager authorizationStatus];
        if( _status<3){
            //请求权限
            [self.locManager requestWhenInUseAuthorization];
        }
    }
    
	[self configLocationManager];
}

- (void)finishSearchLoation
{
    [self InitializeFinished];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [AMapServices sharedServices].apiKey = @"4fae6dd8b79dec53e96a68e83d897659" ;
    UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WID, DEVICE_HEIGHT)];
    imageView.image=[UIImage imageNamed:@"Default.png"];
    imageView.userInteractionEnabled = YES;
    if (DEVICE_HEIGHT >= 568)
    {
        imageView.image = [UIImage imageNamed:@"Default-568h.png"];
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(UesrClicked:)];
    [imageView addGestureRecognizer:singleTap];
    [singleTap release];
    [self.view addSubview:imageView];
    [imageView release];
    
    isClosed=NO;
    
    //Loading 图标
    UIActivityIndicatorView* progressInd = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(DEVICE_WID/2-20, DEVICE_HEIGHT/2-20, 40, 40)];
    [progressInd startAnimating];
    progressInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.view addSubview:progressInd];
    [progressInd release];
    [self GetLocationMethod];
    
//    [NSThread detachNewThreadSelector:@selector(InitializeTask) toTarget:self withObject:nil];
}

- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =2;
    
    [self.locationManager setDelegate:self];
    
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    
    [self.locationManager startUpdatingLocation];
}


- (void)stopSerialLocation
{
    //停止定位
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
}

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error
{
    //定位错误
    NSLog(@"%s, amapLocationManager = %@, error = %@", __func__, [manager class], error);
    
    [self finishSearchLoation];
    //弹出错误信息
    if (![CLLocationManager locationServicesEnabled])
    {
        if (SYSLanguage == EN) {
            [HUD showUIBlockingIndicatorWithText:@"Located Failed" withTimeout:2];
        }
        else
        {
            [HUD showUIBlockingIndicatorWithText:@"定位失败" withTimeout:2];
        }
    }
    [self stopSerialLocation];
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    //定位结果
    NSLog(@"location:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    LocationEntity * currLoc = [[[LocationEntity alloc] init]autorelease];
    currLoc.locationX=[NSString stringWithFormat:@"%f", location.coordinate.longitude];
    currLoc.locationY=[NSString stringWithFormat:@"%f", location.coordinate.latitude];
    
    [CacheManagement instance].currentLocation=currLoc;
    [self stopSerialLocation];
    [self finishSearchLoation];
}

-(IBAction)UesrClicked:(id)sender
{
    [self InitializeFinished];
}


- (void)InitializeTask {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	//系统初始化 TODO...
    [NSThread sleepForTimeInterval:2]; //线程暂停1秒
	[self performSelectorOnMainThread:@selector(InitializeFinished) withObject:nil waitUntilDone:NO];
    [pool release];
}

- (void) InitializeFinished
{
    if(isClosed == YES)
    {
        return;
    }
    
    AregmentView *alerView = [[AregmentView alloc]initAlerShoeView];
    [alerView show];
    alerView.sureBlock = ^{
        isClosed=YES;
        LoginViewController *mainController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        [self.navigationController pushViewController:mainController animated:YES];
        [mainController release];
    };
    alerView.cancelBlock = ^{
        exit(0);
    };
    
    
//    LoginViewController *mainController = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
//	[self.navigationController pushViewController:mainController animated:YES];
//	[mainController release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setLoadingImage:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
}

- (void)dealloc {
    [loadingImage release];
    [super dealloc];
}
@end
