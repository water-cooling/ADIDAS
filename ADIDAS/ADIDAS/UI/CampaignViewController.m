//
//  CampaignViewController.m
//  ADIDAS
//
//  Created by wendy on 14-5-6.
//
//

#import "CampaignViewController.h"
#import "CampaignCell.h"
#import "JSON.h"
#import "Utilities.h"
#import "CampaignPopViewController.h"
#import "CacheManagement.h"
#import "CommonDefine.h"
#import "AppDelegate.h"
#import "SqliteHelper.h"

@interface CampaignViewController ()

@end

@implementation CampaignViewController
@synthesize campaignList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [Utilities createLeftBarButton:self clichEvent:@selector(back)];
    self.label.text = SYSLanguage?@"no campaign now":@"当前店铺无活动";
    self.view.backgroundColor = SYS_YELLOW;
    UILabel* label =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44) ];
    label.text = SYSLanguage?@"Campaign List":@"活动列表";
    label.backgroundColor = [UIColor clearColor];
    //    [Utilities createLeftBarButton:self.tabBarController  clichEvent:@selector(back)];
    label.textColor = SYS_YELLOW;
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    [self.navigationItem setTitleView:label];
    [self.tabBarController.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    
    UIImageView* locationview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, DEVICE_WID, 40)];
    locationview.image = [UIImage imageNamed:@"locationBarbg.png"];
 
    UILabel* locationlabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, DEVICE_WID-30, 40)];
    locationlabel.font = [UIFont systemFontOfSize:14];
    locationlabel.numberOfLines = 2 ;
    locationlabel.backgroundColor = [UIColor clearColor];
    locationlabel.tag = 111;
    [locationview addSubview:locationlabel];
    [self.view addSubview:locationview];
    locationlabel.text =  [CacheManagement instance].currentStore.StoreName;

    self.campaignList = [[NSMutableArray alloc]init];
    self.campaigntableview.delegate = self;
    self.campaigntableview.dataSource = self;
    self.campaigntableview.backgroundColor = [UIColor whiteColor];
    self.campaigntableview.separatorStyle = UITableViewCellSeparatorStyleNone;

    _management = [[StoreManagement alloc] init];
    _management.delegate = self;
    if (![APPDelegate checkNetWork])
    {
        ALERTVIEW(NO_NETWORK);
    }
    else
    {
        [HUD showUIBlockingIndicator];
        [_management getInstallList:self.storeCode];
    }
}

-(void)showMsg
{
    if (Uploadstatu == 1)
    {
        {
            if ([CacheManagement instance].uploaddata == NO)
            {
                [HUD showUIBlockingIndicatorWithText:SYSLanguage?@"Instant upload is closed,please upload data in system": @"即时上传功能已关闭，请到系统中手工上传数据" withTimeout:4] ;
            }
            else
            {
                [HUD showUIBlockingSuccessIndicatorWithText:SYSLanguage?@"Submit successfully": @"上传成功" withTimeout:4];
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

- (void)completeGetStoreInfoServer:(NSString *)responseString  CurrentError:(NSString *)error  InterfaceName:(NSString *)interface
{
    [HUD hideUIBlockingIndicator];
    if ([interface isEqualToString:kGetInstallList])
    {
        NSArray* array = [responseString JSONValue];
        NSMutableArray *activityID = [NSMutableArray array];
        
        [self.campaignList removeAllObjects];
        for (id obj in array)
        {
//            CampaignData* data  = [[CampaignData alloc]init];
        [self.campaignList addObject:obj];
            [activityID addObject:[obj valueForKey:@"CAMPAIGN_ID"]];
        }
        if (error == nil)
        {
             self.label.hidden = YES;
        }
        else if (error != nil)
        {
            self.label.hidden = YES;
        }
        self.campaigntableview.hidden = NO;
        [self.view setBackgroundColor:SYS_YELLOW];
        if (self.campaignList.count == 0)
        {
            self.label.hidden = NO;
            self.campaigntableview.hidden = YES;
            self.view.backgroundColor = [UIColor whiteColor];
        }
        else {
        
            NSMutableArray *outedActivity = [NSMutableArray array];
            NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:[Utilities SysDocumentPath] error:nil];
            for (NSString *str in files) {
                
                if (![activityID containsObject:str]&&
                   [[str componentsSeparatedByString:@"-"] count]>3) {
                    [outedActivity addObject:str];
                }
            }
            
            for (NSString *str in outedActivity) {
    
                NSString *path = [NSString stringWithFormat:@"%@/%@/%@",[Utilities SysDocumentPath],str,[CacheManagement instance].currentStore.StoreCode] ;
                NSFileManager *appFileManager = [NSFileManager defaultManager];
                NSError *err = nil ;
                if ([appFileManager fileExistsAtPath:path]){
                
                    [appFileManager removeItemAtPath:path error:&err] ;
                }
            }
         }
        [self.campaigntableview reloadData];
//        [HUD hideUIBlockingIndicator];
    }
    else if ([interface isEqualToString:kFindStoreByCodeString])
    {
        ((UILabel*)[self.view viewWithTag:111]).text =  [CacheManagement instance].currentStore.StoreName;
        if (error != nil)
        {
            [_management getInstallList:[CacheManagement instance].currentStore.StoreCode];

            return;
        }
        [_management getInstallList:self.storeCode];
    }
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [campaignList count];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WID, 45)];
    headview.backgroundColor = [UIColor whiteColor];
    UILabel* label1  = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 140, 45)];
    UILabel* label2 = [[UILabel alloc]initWithFrame:CGRectMake(DEVICE_WID-174, 0, 174 ,45)];
    label1.font = [UIFont systemFontOfSize:15];
    label2.font = [UIFont systemFontOfSize:14];
    label1.textAlignment = NSTextAlignmentLeft;
    label2.textAlignment = NSTextAlignmentCenter;
    label1.text = SYSLanguage?@"Campaign Name":@"推广活动名称";
    label2.text = SYSLanguage?@"Start Time/End Time": @"开始时间  /  结束时间";
    label1.textColor = SYS_YELLOW;
    label2.textColor = SYS_YELLOW;
    label1.backgroundColor = [UIColor clearColor];
    label2.backgroundColor = [UIColor clearColor];
    [headview addSubview:label1];
    [headview addSubview:label2];
    
    UIImageView* backimageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WID, 45)];
    backimageview.image = [UIImage imageNamed:@"headbg.png"];
    [headview addSubview:backimageview];
    [headview sendSubviewToBack:backimageview];
    return headview;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"cell";
    CampaignCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"CampaignCell" owner:self options:nil]objectAtIndex:0];
        cell.frame = CGRectMake(10,0 , 300, 60);
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    }
  
    cell.namelabel.text = [[campaignList objectAtIndex:indexPath.row] objectForKey:@"CAMPAIGN_NAME"];
    cell.campaignID =[[campaignList objectAtIndex:indexPath.row] objectForKey:@"CAMPAIGN_ID"];
    cell.startdatelabel.text = [[campaignList objectAtIndex:indexPath.row] objectForKey:@"CAMPAIGN_START_DATE"];
    cell.submitdatelabel.text = [[campaignList objectAtIndex:indexPath.row] objectForKey:@"REPORT_SUBMIT_DATE"];
    cell.installDate =  [[campaignList objectAtIndex:indexPath.row] objectForKey:@"INSTALL_DATE"];
    [CacheManagement instance].currentCAMPID = [[campaignList objectAtIndex:indexPath.row] objectForKey:@"CAMPAIGN_ID"];
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CampaignCell* cell = (CampaignCell*)[tableView cellForRowAtIndexPath:indexPath];
    [CacheManagement instance].currentCAMPID = cell.campaignID;
    CampaignPopViewController* campaignvc = [[CampaignPopViewController alloc]init];
    campaignvc.campaignID = cell.campaignID;
    campaignvc.title = cell.namelabel.text;
    NSString* datenow = [CacheManagement instance].currentDate;
    if (cell.installDate != nil)
    {
        NSMutableString* installdate = [[NSMutableString alloc]initWithString:cell.installDate];
        [installdate deleteCharactersInRange:NSMakeRange(7, 1)];
        [installdate deleteCharactersInRange:NSMakeRange(4, 1)];
        if ([datenow compare:installdate] == NSOrderedAscending)
        {
            campaignvc.isDelay = NO;
        }
        else if ([datenow compare:installdate] == NSOrderedDescending)
        {
            campaignvc.isDelay = YES;
        }
    }
    [tableView deselectRowAtIndexPath:indexPath  animated:YES];
    [self.navigationController pushViewController:campaignvc animated:YES];
}



@end
