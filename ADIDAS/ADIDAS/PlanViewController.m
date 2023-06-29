//
//  PlanViewController.m
//  VM
//
//  Created by wendy on 14-7-14.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import "PlanViewController.h"
#import "AppDelegate.h"
#import "Utilities.h"
#import "CacheManagement.h"
#import "SqliteHelper.h"
#import "CommonDefine.h"
#import "NSString+SBJSON.h"
#import "PlanEntity.h"
#import "NSString+filter.h"
#import "PlanDetailViewController.h"
#import "LeveyTabBarController.h"
#import "StoreEntity.h"
@interface PlanViewController ()

@end

@implementation PlanViewController

-(BOOL)isNull:(id)string
{
    if([string isEqual:[NSNull null]])
    {
        return YES;
    }
    return NO;
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
    
    //
    
    if([interface isEqualToString:kGetVisitPlan])
    {
        [self.planListArray removeAllObjects];
        for (id obj in [responseString JSONValue])
        {
            PlanEntity* entity = [[PlanEntity alloc]init];
            entity.LastModifiedBy = [obj objectForKey:@"LastModifiedBy"];
            entity.Remark = [obj objectForKey:@"Remark"];
            entity.TaskName = [obj objectForKey:@"TaskName"];
            if([self isNull:entity.TaskName])
            {
                entity.TaskName = @"";
            }
//            if ([entity.TaskName isBlankString])
//            {
//                entity.TaskName = @"";
//            }
            entity.TaskType = [obj objectForKey:@"TaskType"];
            entity.VisitDate = [obj objectForKey:@"VisitDate"];
            entity.VisitPlanMainId = [obj objectForKey:@"VisitPlanMainId"];
            entity.lstStoreInfo = [obj objectForKey:@"lstStoreInfo"];
            if([self isNull:entity.lstStoreInfo])
            {
                entity.lstStoreInfo = nil;
            }
            [self.planListArray addObject:entity];

        }
//        [self.planListArray addObjectsFromArray:[responseString JSONValue]];
          [self.refreshcontrol endRefreshing];
    }
    if ([self.planListArray count] == 0)
    {
        self.label.text = SYSLanguage?@"There is no Plan":@"当前无巡店计划";
        self.label.hidden = NO;
    }
    else
    {
        self.label.hidden = YES;
    }
    [self.planTableView reloadData];
}

#pragma  mark- tableview

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [self.planListArray count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"cell";
    PlanListCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"PlanListCell" owner:self options:nil]objectAtIndex:0];
    }
    
    cell.eventLabel.text = ((PlanEntity*)[self.planListArray objectAtIndex:indexPath.row]).TaskName;
    cell.timeLabel.text = ((PlanEntity*)[self.planListArray objectAtIndex:indexPath.row]).VisitDate;
    cell.planentity = [self.planListArray objectAtIndex:indexPath.row];
    NSMutableString* storelist = [[NSMutableString alloc]init];
    for (id obj in cell.planentity.
         lstStoreInfo)
    {
        NSString* store = [NSString stringWithFormat:@"%@ %@",[obj objectForKey:@"StoreCode"],[obj objectForKey:SYSLanguage?@"StoreNameEN": @"StoreNameCN"]];
        [storelist appendString:store];
        [storelist appendString:@"\n"];
    }
    cell.storelistlabel.text = storelist;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PlanListCell* cell = (PlanListCell*)[tableView cellForRowAtIndexPath:indexPath];
    PlanDetailViewController* planDetail = [[PlanDetailViewController alloc]initWithNibName:@"PlanDetailViewController" bundle:nil];
    planDetail.superViewController = self;
//    planDetail.planentity = cell.planentity;
    planDetail.planentity = [PlanEntity new];
    planDetail.planentity.LastModifiedBy = cell.planentity.LastModifiedBy;
    planDetail.planentity.Remark = cell.planentity.Remark;
    planDetail.planentity.TaskName = cell.planentity.TaskName;
    planDetail.planentity.TaskType = cell.planentity.TaskType;
    planDetail.planentity.VisitDate = cell.planentity.VisitDate;
    planDetail.planentity.VisitPlanMainId = cell.planentity.VisitPlanMainId;
    planDetail.planentity.lstStoreInfo = cell.planentity.lstStoreInfo;
    
    for (NSDictionary* obj in  cell.planentity.lstStoreInfo)
    {
        StoreEntity* entity = [[StoreEntity alloc]initWithDictionary3:obj];
        [planDetail.storelist addObject:entity];
    }
    [self.navigationController pushViewController:planDetail animated:YES];
    [self.leveyTabBarController hidesTabBar:YES animated:YES];

}

-(void)RefreshView:(UIRefreshControl*)refresh
{
    refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"更新数据中..."];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString: [Utilities DateTimeNow]];
    
//    if (![APPDelegate checkNetWork])
//    {
//        ALERTVIEW(NO_NETWORK);
//        [refresh endRefreshing];
//    }
//    else
    {
        [HUD showUIBlockingIndicator];
        [_management getPlanList];
    }
    //获取服务器StoreList
    
    
    
    //    //从服务器获取Store信息
    //    [_management getStoreByCodeServer:storeCodeField.text];
    //友盟记录
//    [Utilities umengTracking:kUmAdidasGetStoreList userCode:nil];
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
    self.planListArray = [[NSMutableArray alloc]init];
    self.eventArray = [[NSMutableArray alloc]init];
    [HUD showUIBlockingIndicator];
    [self checkEvent];
    _management = [[StoreManagement alloc]init];
    _management.delegate = self;
    

    self.refreshcontrol = [[UIRefreshControl alloc]init];
    //    self.refreshControl.tintColor = [UIColor blueColor];
    self.refreshcontrol.attributedTitle = [[NSAttributedString alloc]initWithString:SYSLanguage?@"refresh":@"下拉刷新"];
    [self.refreshcontrol addTarget:self action:@selector(RefreshView:) forControlEvents:UIControlEventValueChanged];
    [self.planTableView addSubview:self.refreshcontrol];
    //启用等待提示框
//    if (![APPDelegate checkNetWork])
//    {
//        ALERTVIEW(NO_NETWORK);
//    }
//    else
    {
//        [HUD showUIBlockingIndicator];
//        [_management getPlanList];
    }

    if(IOSVersion>=7.0)
    {
        self.navigationController.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    }
    self.title = @"巡店计划";
    if (SYSLanguage == EN) {
        self.title = @"Visit Plan";
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.leveyTabBarController hidesTabBar:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && [self.view window] == nil)
    {
        self.view = nil;
        self.planListArray = nil;
        self.eventArray = nil;
    }
    // Dispose of any resources that can be recreated.
}

//判断是否需要下载数据
-(void) checkEvent
{
    _issueManagement = [[IssueManagement alloc] init];
    _issueManagement.delegate = self;
    
    //获取Issue表信息
    [_issueManagement getTableDataServer:@"SYS_PARAMETER"];
}

-(void)completeDownloadServer:(NSString *)responseString CurrentError:(NSString *)error InterfaceName:(NSString *)interface
{
    NSArray* arr = [responseString JSONValue];
    for (id obj in arr)
    {
        if([[obj objectForKey:@"PARAMETER_TYPE"]isEqualToString:SYSLanguage?@"VisitTypeEN": @"VisitType"])
            [self.eventArray addObject: [obj valueForKey:@"PARAMETER_NAME"]];
    }
    [[CacheManagement instance].eventArr removeAllObjects];
    [[CacheManagement instance].eventArr addObjectsFromArray:self.eventArray];
//    if (self.eventArray.count > 0)
//    {
//        [[NSUserDefaults standardUserDefaults]setObject:self.eventArray forKey:@"event"];
//        [[NSUserDefaults standardUserDefaults]synchronize];
//    }
//    [HUD showUIBlockingIndicator];
    [_management getPlanList];

}


@end
