//
//  StoreListViewController.m
//  ADIDAS
//
//  Created by testing on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StoreListViewController.h"
#import "CacheManagement.h"
#import "Utilities.h"
#import "StoreEntity.h"
#import "CommonDefine.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "SqliteHelper.h"
#import "IssueDA.h"
#import "StoreListCell.h"
#import "VMSysSettingViewController.h"
#import "JSON.h" 
#import "NSString+filter.h"
#import "LeveyTabBarController.h"
#import "VMCheckINViewController.h"
#import "CommonUtil.h"

@implementation StoreListViewController
@synthesize storeListView;
@synthesize storeList=_storeList;


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
    if ([self isViewLoaded]&&[self.view window] == nil)
    {
        self.view = nil;
        self.storeListView = nil;
        self.searchbar = nil;
        self.storeList = nil;
    }
}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


#pragma mark - View lifecycle

- (void)createNavigationbar
{
    
}

- (void)backItemPressed:(id)sender
{
    [self textFieldShouldReturn:storeCodeField];//收起键盘
    [self.navigationController popViewControllerAnimated:YES];
}

//-(IBAction)AddStoreEvent:(id)sender
//{
//    [self textFieldShouldReturn:storeCodeField];//收起键盘
//    //页面跳转到CheckIn 页面
//    StoreAddViewController *storeaddviewcontroller = [[StoreAddViewController alloc] init];
//    [self.navigationController pushViewController:storeaddviewcontroller animated:YES];
//    [storeaddviewcontroller release];
//}

//刷新一下列表
-(IBAction)refreshPressed:(id)sender
{
    if (![APPDelegate checkNetWork])
    {
        ALERTVIEW(NO_NETWORK);
        return;
    }
    //友盟记录
//    [Utilities umengTracking:kUmAdidasGetStoreList userCode:nil];
    
    [HUD showUIBlockingIndicator];
    [_management getStoresServer];
//    [self textFieldShouldReturn:storeCodeField];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.titleView = [[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"adidas.png"]]autorelease] ;
    self.title = @"首页";
    if (SYSLanguage == 1)
    {
        self.title = @"Home";
        self.searchbar.placeholder = @"Search Store";
    }

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
#endif
    
    [CacheManagement instance].lastController = self; //缓存页面
    [self createNavigationbar];
    
    self.refreshcontrol = [[[UIRefreshControl alloc]init]autorelease];
    //    self.refreshControl.tintColor = [UIColor blueColor];
    self.refreshcontrol.attributedTitle = [[[NSAttributedString alloc]initWithString:SYSLanguage?@"refresh":@"下拉刷新"]autorelease];

    [self.refreshcontrol addTarget:self action:@selector(RefreshView:) forControlEvents:UIControlEventValueChanged];
    [self.storeListView addSubview:self.refreshcontrol];
    
    _management = [[StoreManagement alloc] init];
    _management.delegate = self;
    //启用等待提示框
    if (![APPDelegate checkNetWork])
    {
        ALERTVIEW(NO_NETWORK);
    }
    else
    {
        [HUD showUIBlockingIndicator];
        [_management getStoresServer];
    }
    //获取服务器StoreList
   
   
    
//    //从服务器获取Store信息
//    [_management getStoreByCodeServer:storeCodeField.text];
    //友盟记录
//    [Utilities umengTracking:kUmAdidasGetStoreList userCode:nil];
//    [self.view bringSubviewToFront:inputView];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closekeyBoard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    self.storeListView.delaysContentTouches = YES;
    self.storeListView.canCancelContentTouches = YES;
    self.storeListView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0) ;
    [tap release];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.leveyTabBarController.navigationController setNavigationBarHidden:YES animated:NO];
    [APPDelegate navController].navigationBarHidden = YES;
    [self.leveyTabBarController hidesTabBar:NO animated:YES];
//    [HUD hideUIBlockingIndicator];
}

-(void)RefreshView:(UIRefreshControl*)refresh
{
    refresh.attributedTitle = [[[NSAttributedString alloc]initWithString:@"更新数据中..."]autorelease];
    refresh.attributedTitle = [[[NSAttributedString alloc] initWithString: [Utilities DateTimeNow]] autorelease];

    if (![APPDelegate checkNetWork])
    {
        ALERTVIEW(NO_NETWORK);
        [refresh endRefreshing];
    }
    else
    {
        [self GetLocationMethod];
    }
}

-(void)closekeyBoard
{
    [self.searchbar resignFirstResponder];
}

-(IBAction)SubmitEvent:(id)sender
{
    if(storeCodeField!=nil && storeCodeField.text.length >0)
    {
        //从服务器获取Store信息
        [HUD showUIBlockingIndicator];
        [_management getStoreByCodeServer:storeCodeField.text];
    }
    else
    {
        [Utilities alertMessage:NSLocalizedString(@"msgStoreCodeEmpty", nil)];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    [self.searchbar setShowsCancelButton:YES animated:YES];
    return YES ;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    self.searchbar.text = @"" ;
    [self.searchbar endEditing:YES];
    [self.searchbar setShowsCancelButton:NO animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    [HUD showUIBlockingIndicator];
    NSString *keyword = searchBar.text ;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString* result =[_management getStoreByCodeServerSyn:[keyword mk_urlEncodedString] ];
        NSArray* array = [result JSONValue];
        NSMutableArray* dictStores = [[[NSMutableArray alloc]init]autorelease];
        for (NSDictionary *dictionary  in array)
        {
            @autoreleasepool
            {
                StoreEntity *entity = [[[StoreEntity alloc] initWithDictionary:dictionary]autorelease];
                [dictStores addObject:entity];
            }
        }
        [CacheManagement instance].currStoreList = dictStores;
        self.storeList = [CacheManagement instance].currStoreList;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideUIBlockingIndicator];
            [self.storeListView reloadData];
            [self.refreshcontrol endRefreshing];
            
//            if ([entity.CheckFlag isEqual:@"0"])
//            {
//                UIAlertView* av = [[UIAlertView alloc]initWithTitle:nil message:[[result JSONValue] valueForKey:@"CheckError"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [av show];
//            }
//            else
//            {
//                [self UpdateWorkMain:[CacheManagement instance].currentStore];
//                [self openStoreMain];
//            }
        });
    });
}

-(void) completeGetStoreInfoServer:(NSString *)responseString CurrentError:(NSString *)error InterfaceName:(NSString *)interface
{
    
    [HUD hideUIBlockingIndicator];
    
    if (error)
    {
        if ([error isEqualToString:NSLocalizedString(@"msgConnectNetError", nil)]) 
        {
            [Utilities showNetworkErrorView];
        }
        else 
        {
            [Utilities alertMessage:error];
        }
        return;
    }
    
    if([interface isEqualToString:kFindNearStore2String])
    {
        self.storeList = [CacheManagement instance].currStoreList;
        [self.refreshcontrol endRefreshing];
        [storeListView reloadData];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return TRUE;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField;
{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//table list method

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView  
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.storeList count];
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    
    StoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"StoreListCell" owner:self options:nil]objectAtIndex:0];
		
        cell.nameLabel.backgroundColor = [UIColor clearColor];
		cell.nameLabel.tag = kPicLabelTag;
		cell.nameLabel.numberOfLines = 2;
	
        cell.remarkLabel.backgroundColor = [UIColor clearColor];
		cell.remarkLabel.tag = kRemarkLabelTag;
		cell.remarkLabel.numberOfLines = 1;
        cell.frame = CGRectMake(10, 0, 310, 60);
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    
    UILabel *podNameLabel = (UILabel *)[cell.contentView viewWithTag:kPicLabelTag];	
    UILabel *podRemarkLabel = (UILabel *)[cell.contentView viewWithTag:kRemarkLabelTag];
    cell.remindRedPotLabel.hidden = YES ;
    StoreEntity *ent =  [self.storeList objectAtIndex:indexPath.row];
    if (ent.IsCampaign&&![ent.IsCampaign isEqual:[NSNull null]]&&[ent.IsCampaign isEqualToString:@"Y"]) {
        cell.remindRedPotLabel.hidden = NO ;
    }
  	if([ent.CheckFlag isEqual:@"0"])
    {
        podNameLabel.text = ent.CheckError;
        podRemarkLabel.hidden = YES;
    }
    else
    {
        podRemarkLabel.hidden = NO;
        
        NSString *contentString = [NSString stringWithFormat:@"%@  %@",ent.StoreCode,ent.StoreName] ;
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:contentString];
        
        NSString *leftStr = [[contentString componentsSeparatedByString:@"  "] firstObject];
        
        NSRange r1 = NSMakeRange(0, [leftStr length]) ;
        NSRange r2 = NSMakeRange([leftStr length], [contentString length]-[leftStr length]) ;
        
        [attrText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:r1];
        [attrText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:r2];
        
        podNameLabel.attributedText = attrText ;
        podRemarkLabel.text = ent.StoreAddress;
        cell.currentstore = ent;
    }
    return cell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  60;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEWIDTH, 44)];
    headview.backgroundColor = [UIColor whiteColor];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 200, 44)];
    label.backgroundColor = [UIColor clearColor];
//    label.textColor = [UIColor colorWithRed:246 green:200 blue:11 alpha:1];
//    label.textColor = SYS_YELLOW;
    label.font = [UIFont systemFontOfSize:20];
    label.text = @"附近店铺列表";
    if (SYSLanguage == EN)
    {
        label.text = @"Store List";
    }
    
    UIImageView* backimageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEWIDTH, 44)];
    backimageview.image = [UIImage imageNamed:@"headbg.png"];
    [headview addSubview:backimageview];
    [backimageview release];
    [headview sendSubviewToBack:backimageview];
    
    UIImageView* imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12, 20, 20)];
    imageview.image = [UIImage imageNamed:@"Scope.png"];
    [headview addSubview:label];
    [headview addSubview:imageview];
    [label release];
    [imageview release];
    return [headview autorelease];
}

//打开拍照页面
-(void) openTakePhoneView
{

}

-(void)openMainViewController
{
    
}

-(void)openStoreMain {
    
    VMCheckINViewController* vmvc = [[[VMCheckINViewController alloc]initWithNibName:@"VMCheckINViewController" bundle:nil]autorelease];
    vmvc.superviewController = self;
    [self.navigationController pushViewController:vmvc animated:NO];
    [self.leveyTabBarController hidesTabBar:YES animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self textFieldShouldReturn:storeCodeField];//收起键盘
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    StoreEntity  *ent =  [self.storeList  objectAtIndex:indexPath.row];
    if([ent.CheckFlag isEqual:@"0"])
    {
        return;
    }
   
    [HUD showUIBlockingIndicator];
    [CacheManagement instance].currentStore = ent;
    NSString* storeCode = [CacheManagement instance].currentStore.StoreCode;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString *url =  [NSString stringWithFormat:kCanCheckIn,kWebDataString,[CacheManagement instance].userLoginName,storeCode];
        NSString *encodedUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        ASIHTTPRequest* _request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:encodedUrl]];
        [_request setValidatesSecureCertificate:NO];
        [_request setRequestMethod:@"GET"];
        [_request addRequestHeader:@"Accept" value:@"application/json"];
        [_request addRequestHeader:@"Content-Type" value:@"application/json"];
        
        //添加ISA 密文验证
        if ([CacheManagement instance].userEncode&&![[CacheManagement instance].userEncode isEqualToString:@""])
            [_request addRequestHeader:@"Authorization"
                             value:[NSString stringWithFormat:@"Basic %@",[CacheManagement instance].userEncode] ];
        
        [_request setTimeOutSeconds:600];
        [_request startSynchronous];
        NSError *error = [_request error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [HUD hideUIBlockingIndicator];
            if (!error) {
                
                NSString *response = [[_request responseString] mk_urlEncodedString__];
                NSString *aesString = [AES128Util AES128Decrypt:[_request responseString] key:[CommonUtil getDecryKey:[CacheManagement instance].currentDBUser.userName]]  ;
                if ([response isEqualToString:@"true%00"]||[aesString isEqualToString:@"true"]) {
                    
                    NSString* urlstring = [NSString stringWithFormat:kGetIgnoreItem,kWebDataString,[CacheManagement instance].userLoginName,storeCode];
                    NSURL* url = [NSURL URLWithString:urlstring];
                    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
                    [request setValidatesSecureCertificate:NO];
                    [request setRequestMethod:@"GET"];
                    [request addRequestHeader:@"Accept" value:@"application/json"];
                    if ([CacheManagement instance].userEncode&&![[CacheManagement instance].userEncode isEqualToString:@""])
                        [request addRequestHeader:@"Authorization"
                                        value:[NSString stringWithFormat:@"Basic %@",[CacheManagement instance].userEncode]];
                    
                    [request startSynchronous];
                    
                    NSError *error = [request error];
                    if (!error) {
                        
                        NSString *response = [request responseString];
                        NSArray *result = nil;
                        if (![response JSONValue]) {
                            NSString *aesString = [AES128Util AES128Decrypt:response key:[CommonUtil getDecryKey:[CacheManagement instance].currentDBUser.userName]]  ;
                            result = [aesString JSONValue] ;
                        }else {
                            result = [response JSONValue];
                        }
                        
                        [[APPDelegate Store_NA_List] removeAllObjects];
                        for (id obj in result) {
                            
                            [[APPDelegate Store_NA_List] addObject:obj];
                        }
                    }
                    [self openStoreMain];
                }
                else {
                    ALERTVIEW(SYSLanguage?@"Sorry,You do not have the permission":@"对不起,你没有权限");
                }
            }
        });
    });
}

#pragma mark - db operation

-(NSArray*)checkWorkMainIsExit:(StoreEntity*)entity
{
    NSMutableArray* resultarr = [[NSMutableArray alloc]init];
    NSString* sql = [NSString stringWithFormat:@"select WORK_MAIN_ID from IST_WORK_MAIN where OPERATE_USER ='%@' and STORE_CODE='%@' and date(ser_insert_time) = date('now','localtime')",[CacheManagement instance].currentUser.UserId,entity.StoreCode];
    
    FMResultSet *rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        [resultarr addObject:[rs stringForColumnIndex:0]];
    }
    [rs close];
    
	return [resultarr autorelease];
}

-(NSArray*)checkSTATUSIsExit
{
    NSMutableArray* resultarr = [[NSMutableArray alloc]init];
    NSString* sql = [NSString stringWithFormat:@"select * from NVM_STATUS where WORKMAINID = '%@'",[CacheManagement instance].currentWorkMainID];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        [resultarr addObject:rs];
    }
    [rs close];
    return  [resultarr autorelease];
}

-(void)UpdateWorkMain:(StoreEntity*) entity
{
//    [self deleteOutTimeWorkMain:entity];
    FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
    @try
    {
        NSArray* arr = [self checkWorkMainIsExit:entity];
        if ( [arr count] > 0 )
        {
            [CacheManagement instance].currentWorkMainID = [arr objectAtIndex:0];
        }
        else
        {
            [self insertWorkMain:entity];
        }
        NSArray* arr_ = [self checkSTATUSIsExit];
        if ([arr_ count] == 0)
        {
            [self insertSTATUS];
        }
    }
    @catch (NSException *exception)
    {
        NSString* sql = [NSString stringWithFormat:@"delete from NVM_STATUS where WORKMAINID = '%@'",[CacheManagement instance].currentWorkMainID];
//        NSString* sql_ = [NSString stringWithFormat:@"delete from NVM_IST_WORK_MAIN where WORK_MAIN_ID = '%@'",[CacheManagement instance].currentWorkMainID];
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql];
//        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql_];
    }
    @finally
    {
    }
}

-(void)insertSTATUS
{
    NSString* sql = [NSString stringWithFormat:@"INSERT INTO NVM_STATUS (WORKMAINID,RAILCHECK,TAKEPHOTO,ISSUECHECK,SIGN) values (?,?,?,?,?)"];
    NSString* workmainid = [CacheManagement instance].currentWorkMainID;
    FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
    [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,workmainid,@"0",@"0",@"0",@"0"];
}

-(void)insertWorkMain:(StoreEntity*)entity
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO IST_WORK_MAIN (WORK_MAIN_ID,STORE_CODE,STORE_NAME,OPERATE_USER,STORE_ADDRESS,CHECK_IN_TIME,CHECK_OUT_TIME,CHECKIN_LOCATION_X,CHECKIN_LOCATION_Y,CHECKOUT_LOCATION_X,CHECKOUT_LOCATION_Y,TIME_LENGTH,STATUS,REMARK,SER_INSERT_TIME,SELECT_STORE_MOTHED) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
    NSString* workmainid = [Utilities GetUUID];
    [CacheManagement instance].currentWorkMainID = workmainid;
    FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
    [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql,
     workmainid,
     entity.StoreCode,
     entity.StoreName,
     [CacheManagement instance].currentUser.UserId,
      entity.StoreAddress,
     [Utilities DateTimeNow],
     [Utilities DateTimeNow], // check out time 在签出之后记录
     [CacheManagement instance].currentLocation.locationX, // 签入位置X
     [CacheManagement instance].currentLocation.locationY, // 签入位置Y
     [CacheManagement instance].currentLocation.locationX, // 签出位置X
     [CacheManagement instance].currentLocation.locationY, // 签出位置Y
     @"1",       //
     @"1",    // 状态
     @"remark",// remark
     [Utilities DateTimeNow],
     @"1"
     ];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [_management release];
    [storeListView release];
    [_storeList release];

    [super dealloc];
}

- (void) GetLocationMethod {
    //获取坐标信息
    
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
    [self finishSearchLoation];
    
    //弹出错误信息
    if (![CLLocationManager locationServicesEnabled])
    {
        if (SYSLanguage == EN) {
            [HUD showUIBlockingIndicatorWithText:@"" withTimeout:2];
        }
        else
        {
            [HUD showUIBlockingIndicatorWithText:@"定位失败" withTimeout:2];
        }
    }
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location
{
    LocationEntity * currLoc = [[LocationEntity alloc] init];
    currLoc.locationX=[NSString stringWithFormat:@"%f", location.coordinate.longitude];
    currLoc.locationY=[NSString stringWithFormat:@"%f", location.coordinate.latitude];

    [CacheManagement instance].currentLocation=currLoc; //**************先用模拟器测试
    [_management getStoresServer];
    [self finishSearchLoation];
}

- (void)finishSearchLoation
{
    [self.refreshcontrol endRefreshing];
    [self.locationManager stopUpdatingLocation];
    self.locationManager.delegate = nil;
}


@end
