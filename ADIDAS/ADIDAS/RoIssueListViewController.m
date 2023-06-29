//
//  RoIssueListViewController.m
//  MobileApp
//
//  Created by 桂康 on 2018/1/4.
//

#import "RoIssueListViewController.h"
#import "SqliteHelper.h"
#import "FMResultSet.h"
#import "CacheManagement.h"
#import "FrIssuePhotoZoneEntity.h"
#import "AppDelegate.h"
#import "TakePhotoListCell.h"
#import "RoIssuePhotoViewController.h"
#import "XMLFileManagement.h"
#import "CommonDefine.h"
#import "Utilities.h"
#import "RoIssuePhotoEntity.h"

@interface RoIssueListViewController ()

@end

@implementation RoIssueListViewController

@synthesize  uploadManage,Issue_list_TableView;

// 检查此次检查表是否存在
-(NSArray*)checkNVM_IST_ISSUE_CHECK
{
    __autoreleasing NSMutableArray* resultarr = [[NSMutableArray alloc]init];
    NSString* storecode = [CacheManagement instance].currentStore.StoreCode;
    NSString* workmainID = [CacheManagement instance].currentWorkMainID;
    NSString* sql = [NSString stringWithFormat:@"select * from IST_FR_ISSUE_CHECK where WORK_MAIN_ID ='%@' and STORE_CODE= '%@'",workmainID,storecode];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        //            SyncParaVersionEntity * entity = [[SyncParaVersionEntity alloc] initWithFMResultSet:rs];
        [resultarr addObject:[rs stringForColumnIndex:0]];
    }
    [rs close];
    
    return resultarr;
}

// 更新本地数据库 NVM_IST_STORE_TAKE_PHOTO表
-(void)UpdateNVM_IST_ISSUE_CHECK
{
    NSArray* arr = [self checkNVM_IST_ISSUE_CHECK];
    
    if ( arr.count > 0)
    {
        // 存在列表
        [CacheManagement instance].currentVMCHKID = [arr objectAtIndex:0];
    }
    else
    {
        NSString* CHK_ID = [CacheManagement instance].currentWorkMainID;
        [CacheManagement instance].currentVMCHKID = CHK_ID;
        NSString* storeCode = [CacheManagement instance].currentStore.StoreCode;
        NSString* workdate = [Utilities DateNow];
        NSString* workstarttime = [Utilities DateTimeNow];
        NSString* workendtime = [Utilities DateTimeNow];
        NSString* userid = [CacheManagement instance].currentUser.UserId;
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO IST_FR_ISSUE_CHECK (ISSUE_CHECK_ID,STORE_CODE,USER_ID,WORK_MAIN_ID,WORK_DATE,WORK_START_TIME,WORK_END_TIME,USER_SUBMIT_TIME,CLIENT_UPLOAD_TIME,SERVER_INSERT_TIME) values (?,?,?,?,?,?,?,?,?,?)"];
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         CHK_ID,
         storeCode,
         userid,
         [CacheManagement instance].currentWorkMainID,
         workdate,
         workstarttime,
         workendtime,
         workendtime,   // 提交时间
         nil,
         nil];
    }
}

// 更新本地NVM_IST_ISSUE_PHOTO_LIST表

-(void)UpdateNVM_IST_ISSUE_PHOTO_LIST:(NSString*)PHOTO_ZONE andZoneName:(NSString *)nameCn andZoneNameEn:(NSString *)nameEn
{
    NSArray* arr = [self checkNVM_IST_ISSUE_PHOTO_LIST:PHOTO_ZONE andZoneName:nameCn];
    if ( arr.count > 0)
    {
        // 存在列表
        [CacheManagement instance].currentPhotoZone = PHOTO_ZONE;
    }
    else
    {
        NSString* CHK_ID = [CacheManagement instance].currentVMCHKID;
        [CacheManagement instance].currentPhotoZone = PHOTO_ZONE;
        
        NSString* workendtime = [Utilities DateTimeNow];
        
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO IST_FR_ISSUE_PHOTO_LIST (IST_ISSUE_PHOTO_LIST_ID,ISSUE_CHECK_ID,ISSUE_ZONE_CODE,ISSUE_ZONE_NAME,PHOTO_PATH1,PHOTO_PATH2,COMMENT,SERVER_INSERT_TIME,LAST_MODIFIED_BY,LAST_MODIFIED_TIME,RESPONSIBLE_PERSON,COMPLETE_DATE,ISSUE_ZONE_NAME_EN,ISSUE_SOLUTION) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         [Utilities GetUUID],
         CHK_ID,
         PHOTO_ZONE,
         nameCn,
         @"0",
         @"0",
         @"",
         workendtime,
         @"",
         workendtime,
         @"",
         @"",
         nameEn,
         @""];
    }
}

-(NSArray*)checkNVM_IST_ISSUE_PHOTO_LIST:(NSString*)PHOTO_ZONE andZoneName:(NSString *)zoneName
{
    NSMutableArray* resultarr = [[NSMutableArray alloc]init];
    NSString* CHK_ID = [CacheManagement instance].currentVMCHKID;
    
    NSString* sql = [NSString stringWithFormat:@"select * from IST_FR_ISSUE_PHOTO_LIST where ISSUE_CHECK_ID='%@' and ISSUE_ZONE_CODE= '%@' and ISSUE_ZONE_NAME = '%@'",CHK_ID,PHOTO_ZONE,zoneName];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        [resultarr addObject:[rs stringForColumn:@"ISSUE_ZONE_CODE"]];
    }
    [rs close];
    return resultarr;
}

-(NSString*)checkNVM_IST_ISSUE_PHOTO_beforePath:(NSString*)PHOTO_ZONE andZoneName:(NSString *)zoneName
{
    if ([PHOTO_ZONE length] == 0)
    {
        return nil;
    }
    NSMutableArray* resultarr = [[NSMutableArray alloc]init];
    NSString* CHK_ID = [CacheManagement instance].currentVMCHKID;
    NSString* sql = [NSString stringWithFormat:@"select * from IST_FR_ISSUE_PHOTO_LIST where ISSUE_CHECK_ID='%@' and ISSUE_ZONE_CODE= '%@' and ISSUE_ZONE_NAME = '%@' ",CHK_ID,PHOTO_ZONE,zoneName];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        //    SyncParaVersionEntity* entity = [[SyncParaVersionEntity alloc] initWithFMResultSet:rs];
        [resultarr addObject:[rs stringForColumn:@"PHOTO_PATH1"]];
    }
    [rs close];
    NSString* path = [resultarr firstObject];
    return path;
}

-(NSString*)checkNVM_IST_ISSUE_PHOTO_afterPath:(NSString*)PHOTO_ZONE andZoneName:(NSString *)zoneName
{
    if ([PHOTO_ZONE length] == 0)
    {
        return nil;
    }
    NSMutableArray* resultarr = [[NSMutableArray alloc]init];
    NSString* CHK_ID = [CacheManagement instance].currentVMCHKID;
    
    NSString* sql = [NSString stringWithFormat:@"select * from IST_FR_ISSUE_PHOTO_LIST where ISSUE_CHECK_ID='%@' and ISSUE_ZONE_CODE= '%@' and ISSUE_ZONE_NAME = '%@'",CHK_ID,PHOTO_ZONE,zoneName];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        [resultarr addObject:[rs stringForColumn:@"PHOTO_PATH2"]];
    }
    [rs close];
    NSString* path = [resultarr firstObject];
    return path;
}

-(void)openCamera:(UIImagePickerController *)picker  Cell:(id)cell
{
    //相机
    picker.view.tag = ((TakePhotoListCell*)cell).tag;
    [self UpdateNVM_IST_ISSUE_PHOTO_LIST:((TakePhotoListCell*)cell).roIssueEntity.ISSUE_ZONE_CODE
                             andZoneName:((TakePhotoListCell*)cell).roIssueEntity.ISSUE_ZONE_NAME_CN
                           andZoneNameEn:((TakePhotoListCell*)cell).roIssueEntity.ISSUE_ZONE_NAME_EN];
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

-(void)addNew:(id)cell
{
    TakePhotoListCell *curCell = (TakePhotoListCell*)cell ;
    FrIssuePhotoZoneEntity* Entity = curCell.roIssueEntity ;
    
    int insertindex = 0 ;
    int count = 0 ;
    for (FrIssuePhotoZoneEntity* addedEntity in self.issueListArr) {
        
        if ([addedEntity.ISSUE_ZONE_CODE isEqualToString:Entity.ISSUE_ZONE_CODE]) {
            
            count += 1 ;
        }
        else if(count != 0) {
            
            break ;
        }
        
        insertindex+= 1 ;
    }
    
    if(count >= 10){
        
        ALERTVIEW(SYSLanguage?@"Sorry,can not add":@"对不起,不能再添加了");
        return;
    }
    
    @try {
        
        FrIssuePhotoZoneEntity * newEntity = [[FrIssuePhotoZoneEntity alloc] init] ;
        
        newEntity.ISSUE_ZONE_CODE = Entity.ISSUE_ZONE_CODE;
        newEntity.ISSUE_ZONE_NAME_CN = [NSString stringWithFormat:@"%@-%d",[[Entity.ISSUE_ZONE_NAME_CN componentsSeparatedByString:@"-"] firstObject],count];
        newEntity.ISSUE_ZONE_NAME_EN = [NSString stringWithFormat:@"%@-%d",[[Entity.ISSUE_ZONE_NAME_EN componentsSeparatedByString:@"-"] firstObject],count];
        newEntity.ORDER_NO = Entity.ORDER_NO;
        newEntity.REMARK = @"" ;
        newEntity.IS_DELETED = @"0" ;
        newEntity.IS_MUST = @"0";
        newEntity.ISSUE_TYPE = Entity.ORDER_NO;
        newEntity.LAST_MODIFIED_BY = @"";
        newEntity.LAST_MODIFIED_TIME = @"";
        
        [self.issueListArr insertObject:newEntity atIndex:insertindex];
        
        
        [self UpdateNVM_IST_ISSUE_PHOTO_LIST:Entity.ISSUE_ZONE_CODE
                                 andZoneName:newEntity.ISSUE_ZONE_NAME_CN
                               andZoneNameEn:newEntity.ISSUE_ZONE_NAME_EN];
        
        RoIssuePhotoViewController* photoVC = [[RoIssuePhotoViewController alloc]initWithNibName:@"RoIssuePhotoViewController" bundle:nil];
        photoVC.entity = newEntity;
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:SYSLanguage?@"Back":@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:item] ;
        
        [self.navigationController pushViewController:photoVC animated:YES];
        
    } @catch (NSException *exception) {
    }
}


-(void)GetCheckIssueFromDB_2
{
    NSMutableArray *zonecodeary = [NSMutableArray array];
    
    FMDatabase* db = [[SqliteHelper shareCommonSqliteHelper]database];

    {
        NSString* CHK_ID = [CacheManagement instance].currentVMCHKID;
        NSString* sql = [NSString stringWithFormat:@"select * from IST_FR_ISSUE_PHOTO_LIST where ISSUE_CHECK_ID='%@'",CHK_ID];
        FMResultSet* rs = [db executeQuery:sql];
        while([rs next])
        {
            [zonecodeary addObject:@{@"zonecode":[rs stringForColumn:@"ISSUE_ZONE_CODE"],
                                     @"zonename":[rs stringForColumn:@"ISSUE_ZONE_NAME"],
                                     @"zonenameen":[rs stringForColumn:@"ISSUE_ZONE_NAME_EN"]}];
        }
    }
    
    if ([zonecodeary count] > 0)
    {
        for (NSDictionary* obj in zonecodeary)
        {
            BOOL isExist = NO ;
            NSString *orderno = @"" ;
            for (FrIssuePhotoZoneEntity * entity in self.originissueListArr)
            {
                if ([[obj valueForKey:@"zonecode"] isEqualToString:entity.ISSUE_ZONE_CODE]) {
                    
                    if (![[obj valueForKey:@"zonename"] isEqualToString:entity.ISSUE_ZONE_NAME_CN]&&
                        ![[obj valueForKey:@"zonenameen"] isEqualToString:entity.ISSUE_ZONE_NAME_EN]) {
                        
                        isExist = YES ;
                    }
                }
                
                if ([[obj valueForKey:@"zonecode"] isEqualToString:entity.ISSUE_ZONE_CODE]) {
                    
                    orderno = entity.ORDER_NO ;
                }
            }
            
            if (isExist) {
                
                FrIssuePhotoZoneEntity * newEntity = [[FrIssuePhotoZoneEntity alloc] init] ;
                
                newEntity.ISSUE_ZONE_CODE = [obj valueForKey:@"zonecode"];
                newEntity.ISSUE_ZONE_NAME_CN = [obj valueForKey:@"zonename"];
                newEntity.ISSUE_ZONE_NAME_EN = [obj valueForKey:@"zonenameen"];
                newEntity.ORDER_NO = orderno ;
                newEntity.REMARK = @"" ;
                newEntity.IS_DELETED = @"0" ;
                newEntity.IS_MUST = @"0";
                newEntity.ISSUE_TYPE = [obj valueForKey:@"orderno"];
                newEntity.LAST_MODIFIED_BY = @"";
                newEntity.LAST_MODIFIED_TIME = @"";
                
                [self.issueListArr addObject:newEntity];
            }
        }
    }
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"ORDER_NO" ascending:YES];
    [self.issueListArr sortUsingDescriptors:[NSArray arrayWithObject:sort]];
   
}

// 本地数据库读取见检查项
-(void)GetCheckIssueFromDB
{
    FMDatabase* db = [[SqliteHelper shareCommonSqliteHelper]database];
    [self.issueListArr removeAllObjects];
    {
        FMResultSet* rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM FR_ISSUE_PHOTO_ZONE WHERE DATASOURCE like '%%%@%%' ",[CacheManagement instance].dataSource]];
        while([rs next])
        {
            FrIssuePhotoZoneEntity* checkEntity = [[FrIssuePhotoZoneEntity alloc]initWithFMResultSet:rs];
            
            [self.issueListArr addObject:checkEntity];
            [self.originissueListArr addObject:checkEntity];
        }
    }
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"ORDER_NO" ascending:YES];
    [self.issueListArr sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    [self.originissueListArr sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    [self GetCheckIssueFromDB_2];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TakePhotoListCell* cell = (TakePhotoListCell*)[tableView cellForRowAtIndexPath:indexPath];
    [self UpdateNVM_IST_ISSUE_PHOTO_LIST:cell.roIssueEntity.ISSUE_ZONE_CODE
                             andZoneName:cell.roIssueEntity.ISSUE_ZONE_NAME_CN
                           andZoneNameEn:cell.roIssueEntity.ISSUE_ZONE_NAME_EN];
    RoIssuePhotoViewController* photoVC = [[RoIssuePhotoViewController alloc]initWithNibName:@"RoIssuePhotoViewController" bundle:nil];
    photoVC.entity = cell.roIssueEntity;
    self.refreshIndexPath = indexPath;
    [self.navigationController pushViewController:photoVC animated:YES];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:SYSLanguage?@"Back":@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:item] ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"cell";
    NSString* beforePath = nil;
    NSString* afterPath = nil;
    TakePhotoListCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"TakePhotoListCell" owner:self options:nil]objectAtIndex:0];
    }
    cell.tag = indexPath.row;
    cell.before.userInteractionEnabled = NO;
    cell.after.userInteractionEnabled = NO;
    cell.delegate = self;
    cell.doneImage.hidden = YES;
    cell.doneImage.image = nil;
    cell.roIssueEntity = [self.issueListArr objectAtIndex:indexPath.row];
    cell.titleLabel.text = [[self.issueListArr objectAtIndex:indexPath.row]valueForKey:SYSLanguage?@"ISSUE_ZONE_NAME_EN": @"ISSUE_ZONE_NAME_CN"];
    [cell.before setImage:[UIImage imageNamed:SYSLanguage?@"Take-Pictures.png":@"takepic.png"]];
    [cell.after setImage:[UIImage imageNamed:SYSLanguage?@"Take-Pictures.png":@"takepic.png"]];
    
    beforePath = [self checkNVM_IST_ISSUE_PHOTO_beforePath:cell.roIssueEntity.ISSUE_ZONE_CODE andZoneName:cell.roIssueEntity.ISSUE_ZONE_NAME_CN];
    afterPath = [self checkNVM_IST_ISSUE_PHOTO_afterPath:cell.roIssueEntity.ISSUE_ZONE_CODE andZoneName:cell.roIssueEntity.ISSUE_ZONE_NAME_CN];
    
    
    if ((![beforePath isEqualToString:@"0"])&&(beforePath != nil))
    {
        NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[beforePath componentsSeparatedByString:@"/dataCaches"] lastObject]];
        
        if ([UIImage imageWithContentsOfFile:newfile] != nil) {
            
            [cell.before setImage:[[UIImage imageWithContentsOfFile:newfile]scaleToSize:CGSizeMake(50, 50)] ];
        }
    }
    if ((![afterPath isEqualToString:@"0"])&&(afterPath != nil))
    {
        NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[afterPath componentsSeparatedByString:@"/dataCaches"] lastObject]];
        if ([UIImage imageWithContentsOfFile:newfile] != nil) {
            
            [cell.after setImage:[[UIImage imageWithContentsOfFile:newfile] scaleToSize:CGSizeMake(50, 50)]];
        }
    }
    
    cell.doneImage.hidden= YES;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.issueListArr count];
}


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
    self.view.multipleTouchEnabled = NO;
    self.waitView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    UIImageView* imageview = [[UIImageView alloc]initWithFrame:CGRectMake(60, 176, 200, 108)];
    imageview.image = [UIImage imageNamed:@"waiting.png"];
    [self.waitView addSubview:imageview];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(60, 245, 200, 21)];
    label.tag = 88;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    [self.waitView addSubview:label];
    UIActivityIndicatorView* acview = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [acview startAnimating];
    acview.frame = CGRectMake(142, 193, 37, 37);
    [self.waitView addSubview:acview];
    
    //    self.waitView .backgroundColor = [UIColor blackColor];
    //    self.waitView .alpha = 0.5;
    //    [self.view addSubview:view];
    //    [self.view bringSubviewToFront:view];
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.waitView ];
    //    [[UIApplication sharedApplication].keyWindow.rootViewController.view  bringSubviewToFront:self.waitView];
    ((UILabel*)[self.waitView viewWithTag:88]).text = SYSLanguage?@"Processing,please wait …":@"请稍等,正在执行...";
    [self.waitView setHidden:YES];
    
    self.refreshIndexPath = nil;
    [Utilities createRightBarButton:self clichEvent:@selector(showUploadAlert) btnSize:CGSizeMake(50, 30) btnTitle:SYSLanguage?@"Upload":@"上传"];
    [Utilities createLeftBarButton:self clichEvent:@selector(back)];
    self.resultArr = [[NSMutableArray alloc]init];
    self.resultPicArr = [[NSMutableArray alloc]init];
    self.resultPicNameArr = [[NSMutableArray alloc]init];
    self.originissueListArr = [NSMutableArray new];
    
    [self UpdateNVM_IST_ISSUE_CHECK];
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    }
    self.title =SYSLanguage?@"Issue List": @"问题列表";
    
    self.issueListArr = [[NSMutableArray alloc]init];
    [self GetCheckIssueFromDB];
    self.uploadManage = [[UploadManagement alloc] init];
    self.uploadManage.delegate = self;
    UIImageView* locationview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, DEVICE_WID, 40)];
    locationview.image = [UIImage imageNamed:@"loactionbg.png"];
    UILabel* locationlabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, DEVICE_WID-30, 40)];
    locationlabel.numberOfLines = 2 ;
    locationlabel.backgroundColor =[UIColor clearColor];
    locationlabel.font = [UIFont systemFontOfSize:14];
    locationlabel.tag = 111;
    locationlabel.text = [CacheManagement instance].currentStore.StoreName;
    [locationview addSubview:locationlabel];
    [self.view addSubview:locationview];
    
    self.Issue_list_TableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, DEVICE_WID,DEVICE_HEIGHT-64-40) style:UITableViewStylePlain];
    self.Issue_list_TableView.canCancelContentTouches = YES;
    self.Issue_list_TableView.delaysContentTouches = YES;
    self.Issue_list_TableView.delegate = self;
    self.Issue_list_TableView.dataSource = self;
    [self.Issue_list_TableView setSectionHeaderHeight:0];
    self.Issue_list_TableView.rowHeight = 78;
    self.Issue_list_TableView.tableFooterView = [[UIView alloc] init];
    [self.Issue_list_TableView setBackgroundColor:[UIColor whiteColor]];
    [self.Issue_list_TableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.view addSubview:self.Issue_list_TableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.leveyTabBarController hidesTabBar:YES animated:NO];
    
    //    if (self.refreshIndexPath != nil)
    //    {
    //        [self.Issue_list_TableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:self.refreshIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    //    }
    [self.Issue_list_TableView reloadData];
    [self.Issue_list_TableView scrollToRowAtIndexPath:self.refreshIndexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [APPDelegate CountUploadFileNum];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //    self.issueListArr = nil;
    //    self.originissueListArr = nil;
    //    self.resultArr = nil;
    //    self.resultPicArr = nil;
    //    self.resultPicNameArr = nil;
    //    self.zone_codeArr = nil;
}

-(void)upload
{
    NSString* sql = [NSString stringWithFormat:@"select * from IST_FR_ISSUE_PHOTO_LIST where ISSUE_CHECK_ID = '%@' ",[CacheManagement instance].currentVMCHKID];
    [self.resultArr removeAllObjects];
    [self.resultPicArr removeAllObjects];
    [self.resultPicNameArr removeAllObjects];
    FMResultSet* rs_ = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
    while ([rs_ next])
    {
        RoIssuePhotoEntity* Entity = [[RoIssuePhotoEntity alloc]initWithFMResultSet:rs_];
        [self.resultArr addObject:Entity];
        
        if (Entity.PHOTO_PATH1 != nil)
        {
            [self.resultPicArr addObject:Entity.PHOTO_PATH1];
        }
        if (Entity.PHOTO_PATH2 != nil)
        {
            [self.resultPicArr addObject:Entity.PHOTO_PATH2];
        }
    }

    [rs_ close];
    
    if ([self.resultArr count] == 0)
    {
         ALERTVIEW(SYSLanguage?@"Sorry,not exist data!":@"上传失败,请至少填写一组数据！");
        return;
    }
    
    
    // 制作xml 文件
    XMLFileManagement * xmlcon = [[XMLFileManagement alloc] init];
    NSString* xmlString =   [xmlcon CreateROIssuePhotoString:self.resultArr
                                               WorkEndTime:[Utilities DateTimeNow]
                                                  CHECK_ID:[CacheManagement instance].currentVMCHKID
                                             WorkStartTime:[Utilities DateTimeNow]
                                                 StoreCode:[CacheManagement instance].currentStore.StoreCode
                                                submittime:[Utilities DateTimeNow]
                                                  WorkDate:[Utilities DateNow]];
    
    if ([CacheManagement instance].uploaddata == YES)
    {
        self.waitView.hidden = NO;
        
        [self.uploadManage uploadVMRailCheckFileToServer:xmlString
                                                fileType:kFrXmlIssuePhoto
                                          andfilePathArr:self.resultPicArr
                                              andxmlPath:[NSString stringWithFormat:@"%@/%@/%@",[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode]];
    }
    else if([CacheManagement instance].uploaddata == NO)
    {
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        NSString* sql_ = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET ROISSUECHECK = '%@' where WORKMAINID = '%@'",@"1",[CacheManagement instance].currentWorkMainID];
        [db executeUpdate:sql_];
        
        NSString *CurrentDate = [Utilities DateNow] ;
        NSString* DateSql  = [NSString stringWithFormat:@"select CHECK_IN_TIME from IST_WORK_MAIN where WORK_MAIN_ID = '%@'",[CacheManagement instance].currentWorkMainID];
        FMResultSet* DateResult = [[SqliteHelper shareCommonSqliteHelper] selectResult:DateSql];
        if ([DateResult next]) {
            
            CurrentDate = [[DateResult stringForColumn:@"CHECK_IN_TIME"] substringToIndex:10];
        }
        
        
        // 非几时上传 保存文件到本地
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM NVM_FILE_LIST WHERE STORE_CODE = '%@' AND CREATE_DATE = '%@' AND USER_ID = '%@'",[CacheManagement instance].currentStore.StoreCode,CurrentDate,[CacheManagement instance].currentUser.UserId];
        FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
        if ([rs next])
        {
            
            NSString* cachePath = [rs stringForColumn:@"RO_ISSUE_XML_PATH"];
            NSFileManager* fileMannager = [NSFileManager defaultManager];
            if ([cachePath length] < 5) {
                cachePath = [NSString stringWithFormat:kXmlPathString,[Utilities SysDocumentPath],CurrentDate,[CacheManagement instance].currentStore.StoreCode,[Utilities GetUUID]];
                if(![fileMannager fileExistsAtPath:cachePath])
                {
                    [fileMannager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
                }
            }
            else {
                
                NSString *newfi = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[cachePath componentsSeparatedByString:@"/dataCaches"] lastObject]];
                cachePath = newfi ;
            }
            [fileMannager removeItemAtPath:cachePath error:nil];
            NSData* xmlData = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
            [xmlData writeToFile:cachePath atomically:YES];
            // 数据库存在记录 update
            NSString* picpath = [NSString stringWithFormat:@"%@/%@/%@/%@",[Utilities SysDocumentPath],CurrentDate,[CacheManagement instance].currentStore.StoreCode,@"RO_ISSUE"];
            NSString* update_sql = [NSString stringWithFormat:@"UPDATE NVM_FILE_LIST SET RO_ISSUE_PIC_PATH = '%@',RO_ISSUE_XML_PATH='%@' WHERE STORE_CODE = '%@' AND CREATE_DATE = '%@' AND USER_ID = '%@'",picpath,cachePath,[CacheManagement instance].currentStore.StoreCode,CurrentDate,[CacheManagement instance].currentUser.UserId];
            FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
            [db executeUpdate:update_sql];
        }
        else
        {
            // 写xml到本地
            NSString* cachePath = [NSString stringWithFormat:kXmlPathString,[Utilities SysDocumentPath],CurrentDate,[CacheManagement instance].currentStore.StoreCode,[Utilities GetUUID]];
            NSFileManager* fileMannager = [NSFileManager defaultManager];
            if(![fileMannager fileExistsAtPath:cachePath])
            {
                [fileMannager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            [fileMannager removeItemAtPath:cachePath error:nil];
            NSData* xmlData = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
            [xmlData writeToFile:cachePath atomically:YES];
            
            // 不存在记录 insert
            NSString* picpath = [NSString stringWithFormat:@"%@/%@/%@/%@",[Utilities SysDocumentPath],CurrentDate,[CacheManagement instance].currentStore.StoreCode,@"RO_ISSUE"];
            NSString *insert_sql = [NSString stringWithFormat:@"INSERT INTO NVM_FILE_LIST (STORE_CODE,CREATE_DATE,RO_ISSUE_PIC_PATH,STORE_NAME,USER_ID,RO_ISSUE_XML_PATH) values (?,?,?,?,?,?)"];
            FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
            [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:insert_sql,[CacheManagement instance].currentStore.StoreCode,CurrentDate,picpath,[CacheManagement instance].currentStore.StoreName,[CacheManagement instance].currentUser.UserId,cachePath];
        }
        Uploadstatu = 1;
        [self.waitView removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void)completeUploadServer:(NSString *)error
{
    //     [HUD hideUIBlockingIndicator];
    
    [self.waitView removeFromSuperview];
    if ([error length] == 0)
    {
        Uploadstatu = 1;
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET ROISSUECHECK = '%@' where WORKMAINID = '%@'",@"1",[CacheManagement instance].currentWorkMainID];
        [db executeUpdate:sql];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [HUD showUIBlockingIndicatorWithText:error withTimeout:2];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [self upload];
    }
    //    class_addMethod()
}

-(void)showUploadAlert
{
    
    NSString* title = @"是否确定上传";
    if (SYSLanguage == EN) {
        title = @"Are you sure to upload ?";
    }
    
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:title message:nil delegate:self cancelButtonTitle:SYSLanguage?@"Cancel":@"取消" otherButtonTitles:SYSLanguage?@"OK":@"确定", nil];
    [av show];
}



@end
