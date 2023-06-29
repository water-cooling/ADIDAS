//
//  VM_CHECK_ITEM_ViewController.m
//  VM
//
//  Created by leo.you on 14-7-21.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import "VM_CHECK_ITEM_ViewController.h"
#import "SqliteHelper.h"
#import "AppDelegate.h"
#import "VM_CHECK_ITEM_Entity.h"
#import "CacheManagement.h"
#import "VM_CHECK_ITEM_Cell.h"
#import "VMManageScoreViewController.h"
#import "XMLFileManagement.h"
#import "CommonDefine.h"
#import "VMCheckScoreEntity.h"
#import "VmCheckCategoryEntity.h"

@interface VM_CHECK_ITEM_ViewController ()

@end

@implementation VM_CHECK_ITEM_ViewController

@synthesize uploadManage,vm_check_item_TableView;

// 检查是否已存在

// 检查此次检查表是否存在
-(NSArray*)checkNVM_IST_CHECK_ID
{
    __autoreleasing NSMutableArray* resultarr = [[NSMutableArray alloc]init];
    NSString* storecode = [CacheManagement instance].currentStore.StoreCode;
    NSString* workmainID = [CacheManagement instance].currentWorkMainID;
    NSString* sql = [NSString stringWithFormat:@"select * from NVM_IST_VM_CHECK where WORK_MAIN_ID ='%@' and STORE_CODE= '%@'",workmainID,storecode];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        //			SyncParaVersionEntity * entity = [[SyncParaVersionEntity alloc] initWithFMResultSet:rs];
        [resultarr addObject:[rs stringForColumnIndex:0]];
    }
    [rs close];
	return resultarr;
    
}

// 更新本地数据库 IST_VM_CHECK表
-(void)UpdateNVM_IST_CHECK_ID
{
    NSArray* arr = [self checkNVM_IST_CHECK_ID];
    if ( arr.count > 0)
    {   // 存在列表
        [CacheManagement instance].currentVMCHKID = [arr objectAtIndex:0];
    }
    else
    {
        NSString* NVM_IST_VM_CHECK_ID =[Utilities GetUUID];
        [CacheManagement instance].currentVMCHKID = NVM_IST_VM_CHECK_ID;
        NSString* storeCode = [CacheManagement instance].currentStore.StoreCode;
        NSString* workdate = [Utilities DateNow];
        NSString* workstarttime = [Utilities DateTimeNow];
        NSString* workendtime = [Utilities DateTimeNow];
        NSString* userid = [CacheManagement instance].currentUser.UserId;
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_VM_CHECK (VM_CHK_ID,STORE_CODE,USER_ID,WORK_MAIN_ID,WORK_DATE,WORK_START_TIME,WORK_END_TIME,TOTAL_SCORE,USER_SUBMIT_TIME,CLIENT_UPLOAD_TIME,SERVER_INSERT_TIME) values (?,?,?,?,?,?,?,?,?,?,?)"];
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         NVM_IST_VM_CHECK_ID,
         storeCode,
         userid,
         [CacheManagement instance].currentWorkMainID,
         workdate,
         workstarttime,
         workendtime,
         @"0",
         workendtime, //  提交时间
         nil,
         nil];
    }
}

// 本地数据库读取见检查项

-(void)GetCheckIssueFromDB
{
    FMDatabase* db = [[SqliteHelper shareCommonSqliteHelper]database];
    [[APPDelegate VM_CHECK_ItemList] removeAllObjects];
    
    if (ISKIDS) {
        
        FMResultSet* rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM NVM_VM_CHECK_CATEGORY where DATA_SOURCE like '%%%@%%' ORDER BY ORDER_NO ASC",[CacheManagement instance].dataSource]];
        
        while([rs next])
        {
            VmCheckCategoryEntity* categoryEntity = [[VmCheckCategoryEntity alloc] initWithFMResultSet:rs];
            [[APPDelegate VM_CHECK_ItemList] addObject:categoryEntity];
        }
    }
    else {
        
        FMResultSet* rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM NVM_VM_CHECK_ITEM WHERE DATASOURCE like '%%%@%%' ",[CacheManagement instance].dataSource]];
        
        while([rs next])
        {
            VM_CHECK_ITEM_Entity* checkEntity = [[VM_CHECK_ITEM_Entity alloc]initWithFMResultSet:rs];
            [[APPDelegate VM_CHECK_ItemList] addObject:checkEntity];
            countString = [NSString stringWithFormat:@"%@",[[[rs stringForColumn:@"SCORE_OPTION"] componentsSeparatedByString:@","] firstObject]] ;
        }
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"ITEM_NO" ascending:YES];
        [[APPDelegate VM_CHECK_ItemList] sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    }
}

// 查找得分

-(NSString*)GetScorebyCHK_ID:(NSString*)currentCHK_ID andItemID:(NSString*)Item_ID
{
    NSString* sql = [NSString stringWithFormat:@"select * from NVM_IST_VM_CHECK_ITEM where VM_CHK_ID ='%@' and ITEM_ID='%@'",currentCHK_ID,Item_ID];
    
    NSMutableArray* result = [[NSMutableArray alloc]init];
    FMResultSet *rs = nil;
    rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        [result addObject:[rs stringForColumnIndex:3]];
    }
    [rs close];
    if ([result count] == 0)
    {
        return @"3";
    }
    return [result objectAtIndex:0];
}

-(id)searchVMLastResult:(NSString*)item_id
{
    id obj_result;
    for ( id obj in [APPDelegate VMlastScoreArray])
    {
        if ([[obj objectForKey:@"ItemId"] isEqualToString:item_id])
        {
            obj_result = obj;
        }
    }
    return obj_result;
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
    NSString* sql  = [NSString stringWithFormat:@"select * from NVM_IST_VM_CHECK_ITEM where VM_CHK_ID = '%@'",[CacheManagement instance].currentVMCHKID];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
    int i = 0;
    BOOL finish = YES;
    while ([rs next])
    {
        if ([[rs stringForColumnIndex:3] isEqualToString:@"3"])
        {
            finish = NO;
            [rs close];
            break;
        }
        i++;
    }
    
    NSInteger total = [APPDelegate VM_CHECK_ItemList].count ;
    
    if (ISKIDS) {
        
        total = 0 ;
        
        for (VmCheckCategoryEntity *entity in [APPDelegate VM_CHECK_ItemList]) {
            
            NSString* sql  = [NSString stringWithFormat:@"SELECT VM_ITEM_ID FROM NVM_VM_CHECK_ITEM WHERE VM_CATEGORY_ID = '%@'",entity.VM_CATEGORY_ID] ;
            
            FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
            
            while([rs next])
            {
                
                total++ ;
            }
        }
    }
    
    if (i < total)
    {
        [rs close];
        finish = NO;
    }
    if (finish)
    {
        // 更新本地事项状态
//        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
//        NSString* sql_ = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET VMRAILCHECK = '%@' where WORKMAINID = '%@'",@"1",[CacheManagement instance].currentWorkMainID];
//        [db executeUpdate:sql_];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.multipleTouchEnabled = NO;
    self.waitView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEWIDTH, 480)];
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
//    UIImageWriteToSavedPhotosAlbum([UIImage imageNamed:@"ic.png"], nil, nil, nil);
    if (SYSLanguage == CN)
    {
        [Utilities createRightBarButton:self clichEvent:@selector(showUploadAlert) btnSize:CGSizeMake(50, 30) btnTitle:@"上传"];
    }
    else if (SYSLanguage == EN)
    {
        [Utilities createRightBarButton:self clichEvent:@selector(showUploadAlert) btnSize:CGSizeMake(50, 30) btnTitle:@"Submit"];
    }
    [Utilities createLeftBarButton:self clichEvent:@selector(back)];
    
    self.resultArr = [[NSMutableArray alloc]init];
    self.resultPicArr = [[NSMutableArray alloc]init];
    self.historyScoreArr = [APPDelegate lastScoreArray];
    [self UpdateNVM_IST_CHECK_ID];
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    }
    self.title = SYSLanguage?@"VM aRMS check":@"陈列检查";

//    self.historyScoreArr = [[NSMutableArray alloc]init];
    self.uploadManage = [[UploadManagement alloc] init];
    self.uploadManage.delegate = self;
    
    [self GetCheckIssueFromDB];
    
    UIImageView* locationview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, DEWIDTH, 40)];
    locationview.image = [UIImage imageNamed:@"loactionbg.png"];
    UILabel* locationlabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, DEWIDTH-30, 40)];
    locationlabel.numberOfLines = 2 ;
    locationlabel.backgroundColor =[UIColor clearColor];
    locationlabel.font = [UIFont systemFontOfSize:14];
    locationlabel.tag = 111;
    locationlabel.text = [CacheManagement instance].currentStore.StoreName;
    [locationview addSubview:locationlabel];
    [self.view addSubview:locationview];

    self.vm_check_item_TableView = ISKIDS ? [[UITableView alloc]initWithFrame:CGRectMake(0, 104, DEWIDTH,DEVICE_HEIGHT-104) style:UITableViewStylePlain]:
    [[UITableView alloc]initWithFrame:CGRectMake(0, 144, DEWIDTH,DEVICE_HEIGHT-144) style:UITableViewStylePlain] ;
    self.vm_check_item_TableView.delegate = self;
    self.vm_check_item_TableView.dataSource = self;
    [self.vm_check_item_TableView setSectionHeaderHeight:0];
    self.vm_check_item_TableView.rowHeight = 65;
    [self.vm_check_item_TableView setBackgroundColor:[UIColor whiteColor]];
    [self.vm_check_item_TableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.vm_check_item_TableView];
    self.tableviewSourceArr = [APPDelegate VM_CHECK_ItemList];
    self.filterview = [[VMFilterView alloc]initWithFrame:CGRectMake(0, 104, DEWIDTH, 40)];
    self.filterview.userInteractionEnabled = YES;
    //    self.filterview.frame = CGRectMake(0, 60, 320, 40);
    self.filterview.countLabel.text = countString ;
    if (!ISKIDS) [self.view addSubview:self.filterview];
    
    [self.view bringSubviewToFront:self.filterview];
    self.totalScore = 0;
    for (id obj in [APPDelegate VMlastScoreArray])
    {
        if ([[obj valueForKey:@"Score"]intValue] == 0)
        {
            self.Zero_num++;
        }
        else if([[obj valueForKey:@"Score"]intValue]<0)
        {
            self.NA_num++;
        }
        else{
            
            self.Four_num++;
        }
        self.TOTAL_num = [[obj valueForKey:@"TotalScore"]intValue];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.vm_check_item_TableView reloadData];
    [self Statistics];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [APPDelegate CountUploadFileNum];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if (self.view.window == nil)
    {
        self.view = nil;
        self.resultArr = nil;
        self.resultPicArr = nil;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"cell";
    VM_CHECK_ITEM_Cell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"VM_CHECK_ITEM_Cell" owner:self options:nil]objectAtIndex:0];
    }
    
    cell.score_label.font = [UIFont systemFontOfSize:12];
    cell.scorecard_image.hidden = YES;
    
    if (ISKIDS) {
        cell.done_image.hidden = YES;
        VmCheckCategoryEntity *entity = [self.tableviewSourceArr objectAtIndex:indexPath.row];
        
        cell.VM_CATEGORY_ID = entity.VM_CATEGORY_ID ;
        cell.title_label.text = (SYSLanguage == EN) ? entity.NAME_EN : entity.NAME_CN ;
        cell.no_label.text = entity.ORDER_NO ;
        
        NSMutableArray *array = [NSMutableArray array];
        
        NSString* sql  = [NSString stringWithFormat:@"SELECT VM_ITEM_ID FROM NVM_VM_CHECK_ITEM WHERE VM_CATEGORY_ID = '%@'",entity.VM_CATEGORY_ID] ;
        
        FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
        
        while([rs next])
        {
            
            [array addObject:[rs stringForColumnIndex:0]] ;
        }
        
        BOOL isShow = YES ;
        
        for (NSString *str in array) {
            
            NSString *scorenumber = [self GetScorebyCHK_ID:[CacheManagement instance].currentVMCHKID andItemID:str];
            
            if ([scorenumber isEqualToString:@"3"]) {
                isShow = NO ;
                break ;
            }
        }
        
        [rs close];
        
        if ([array count]&&isShow) cell.scorecard_image.hidden = NO ;
        else cell.scorecard_image.hidden = YES;
        
        array = nil ;
    }
    else {
    
        cell.done_image.hidden = NO;
        cell.item_ID = [[self.tableviewSourceArr objectAtIndex:indexPath.row ]valueForKey:@"VM_ITEM_ID"];
        
        cell.title_label.text = [[self.tableviewSourceArr objectAtIndex:indexPath.row]valueForKey:@"ITEM_NAME_CN"];
        if (SYSLanguage == EN)
        {
            cell.title_label.text = [[self.tableviewSourceArr objectAtIndex:indexPath.row]valueForKey:@"ITEM_NAME_EN"];
        }
        
        cell.no_label.text =[[[self.tableviewSourceArr objectAtIndex:indexPath.row]valueForKey:@"ITEM_NO"]stringValue];
        
        NSString *scorenumber = [self GetScorebyCHK_ID:[CacheManagement instance].currentVMCHKID andItemID:cell.item_ID];
        
        if ([scorenumber isEqualToString:@"3"]) // 未评分
        {
            //        cell.score_label.text = @"0";
            cell.done_image.hidden = YES;
        }
        else if ([scorenumber isEqualToString:@"-1"])
        {
            cell.score_label.text = @"N/A";
            cell.score_label.font = [UIFont systemFontOfSize:9];
        }
        else
        {
            cell.score_label.text = scorenumber;
        }
        cell.score_label.textColor = [UIColor darkGrayColor];
        
        // 取上次得分记录
        id obj = [self searchVMLastResult:cell.item_ID];
        NSString *lastscore;
        
        if (obj) {
            lastscore = [NSString stringWithFormat:@"%.1f",[[obj valueForKey:@"Score"] floatValue]] ;
            cell.history_score_label.hidden = NO;
            if ([lastscore intValue] == -1)
            {
                cell.history_score_label.text = @"N/A";
                cell.history_score_label.font = [UIFont systemFontOfSize:9];
            }
            else
            {
                cell.history_score_label.text = lastscore;
                cell.history_score_label.font = [UIFont systemFontOfSize:12];
            }
            
        }
        
        if ([scorenumber intValue] == 0)
        {
            
            if ([lastscore isEqualToString:countString])
            {
                //            cell.arrowimageview.image = [UIImage imageNamed:@"down.png"];
                //            cell.arrowimageview.hidden = NO;
                //            cell.issueLabel.textColor = [UIColor colorWithRed:0.68 green:0.26 blue:0.18 alpha:1];
                cell.score_label.textColor = [UIColor colorWithRed:0.68 green:0.26 blue:0.18 alpha:1];
            }
        }
        else if ([scorenumber isEqualToString:countString])
        {
            cell.score_label.text = countString;
            if ([lastscore intValue] == 0)
            {
                //            cell.arrowimageview.image = [UIImage imageNamed:@"up.png"];
                //            cell.arrowimageview.hidden = NO;
                //            cell.issueLabel.textColor = [UIColor colorWithRed:0.47 green:0.67 blue:0.074 alpha:1];
                cell.score_label.textColor = [UIColor colorWithRed:0.47 green:0.67 blue:0.074 alpha:1];
            }
        }
        else if([scorenumber intValue] < 0)
        {
            cell.score_label.text = @"N/A";
            //        cell.arrowimageview.hidden = YES;
            //        cell.issueLabel.textColor = [UIColor darkGrayColor];
            cell.score_label.textColor = [UIColor darkGrayColor];
        }
        else
        {
            cell.score_label.text = @"";
            //        cell.arrowimageview.hidden = YES;
            //        cell.issueLabel.textColor = [UIColor darkGrayColor];
            cell.score_label.textColor = [UIColor darkGrayColor];
        }
    }

    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableviewSourceArr count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    VM_CHECK_ITEM_Cell* cell = (VM_CHECK_ITEM_Cell*)[tableView cellForRowAtIndexPath:indexPath];
    VMManageScoreViewController* msvc = [[VMManageScoreViewController alloc]initWithNibName:@"VMManageScoreViewController" bundle:nil];
    
    if (ISKIDS) {
        
        VmCheckCategoryEntity *entity = [self.tableviewSourceArr objectAtIndex:indexPath.row];

        msvc.No = [entity.ORDER_NO intValue] ;
        msvc.vmCategoryID = entity.VM_CATEGORY_ID ;
    }
    else {
    
        msvc.No = [[[self.tableviewSourceArr objectAtIndex:indexPath.row]valueForKey:@"ITEM_NO"]integerValue];
        msvc.item_name = [[self.tableviewSourceArr objectAtIndex:indexPath.row] valueForKey:@"ITEM_NAME_CN"];
        msvc.remark = [[self.tableviewSourceArr objectAtIndex:indexPath.row] valueForKey:@"REMARK_CN"];
        msvc.reasonsArr = [[[self.tableviewSourceArr objectAtIndex:indexPath.row] valueForKey:@"REASON_CN"]
                           componentsSeparatedByString:@"|"];
        msvc.maxScore = countString ;
        msvc.Y_num = self.Four_num;
        msvc.N_num = self.Zero_num;
        msvc.NA_num = self.NA_num;
        msvc.TOTAL_num = self.TOTAL_num;
        
        if (SYSLanguage == EN) {
            msvc.item_name = [[self.tableviewSourceArr objectAtIndex:indexPath.row] valueForKey:@"ITEM_NAME_EN"];
            msvc.remark = [[self.tableviewSourceArr objectAtIndex:indexPath.row] valueForKey:@"REMARK_EN"];
            msvc.reasonsArr = [[[self.tableviewSourceArr objectAtIndex:indexPath.row] valueForKey:@"REASON_EN"]componentsSeparatedByString:@"|"];
        }
        msvc.scoreOption = [[self.tableviewSourceArr objectAtIndex:indexPath.row] valueForKey:@"SCORE_OPTION"];
        msvc.item_id = [[self.tableviewSourceArr objectAtIndex:indexPath.row] valueForKey:@"VM_ITEM_ID"];
    }

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController pushViewController:msvc animated:YES];
}

-(void)upload
{
//    [HUD showUIBlockingIndicator];
    self.waitView.hidden = NO;
    self.totalScore = 0;
    int i = 0;
    
    
    NSString* sql  = [NSString stringWithFormat:@"select * from NVM_IST_VM_CHECK_ITEM where VM_CHK_ID = '%@' ORDER BY ITEM_NO",[CacheManagement instance].currentVMCHKID];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
    
    while ([rs next])
    {
        if ([[rs stringForColumnIndex:3] isEqualToString:@"3"])
        {
            [HUD hideUIBlockingIndicator];
            self.waitView.hidden = YES;
            ALERTVIEW(SYSLanguage?@"Please finish all items then upload": @"还有未完成项，请继续填写");
            [rs close];
            return;
        }
        
        i++;
    }
    
    NSInteger total = [APPDelegate VM_CHECK_ItemList].count ;

    if (ISKIDS) {
        
        total = 0 ;
        
        for (VmCheckCategoryEntity *entity in [APPDelegate VM_CHECK_ItemList]) {
            
            NSString* sql  = [NSString stringWithFormat:@"SELECT VM_ITEM_ID FROM NVM_VM_CHECK_ITEM WHERE VM_CATEGORY_ID = '%@'",entity.VM_CATEGORY_ID] ;
            
            FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
            
            while([rs next])
            {
                
                total++ ;
            }
        }
    }
    
    if (i < total)
    {
        ALERTVIEW(SYSLanguage?@"Please finish all items then upload": @"还有未完成项，请继续填写");

        [rs close];
        self.waitView.hidden = YES;
        return;
    }
    
    [self.resultArr removeAllObjects];
    [self.resultPicArr removeAllObjects];
    
    FMResultSet* rs_ = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
    
    while ([rs_ next])
    {
        VMCheckScoreEntity* checkScoreEntity = [[VMCheckScoreEntity alloc]initWithFMResultSet:rs_];
        [self.resultArr addObject:checkScoreEntity];
        if (checkScoreEntity.PHOTO_PATH1 != nil)
        {
            [self.resultPicArr addObject:checkScoreEntity.PHOTO_PATH1];
        }
        if (checkScoreEntity.PHOTO_PATH2 != nil)
        {
            [self.resultPicArr addObject:checkScoreEntity.PHOTO_PATH2];
        }
    }
    [rs_ close];
    // 制作xml 文件
    
    XMLFileManagement * xmlcon = [[XMLFileManagement alloc] init];
    NSString* xmlString =   [xmlcon CreateVMCheckString:self.resultArr
                                            WorkEndTime:[Utilities DateTimeNow]
                                              VM_CHK_ID:[CacheManagement instance].currentVMCHKID
                                          WorkStartTime:[Utilities DateTimeNow]
                                              StoreCode:[CacheManagement instance].currentStore.StoreCode
                                             submittime:[Utilities DateTimeNow]
                                               WorkDate:[Utilities DateNow]
                                             TotalScore:ISKIDS ? @"0" : self.filterview.totalScoreButton.currentTitle];
    if ([CacheManagement instance].uploaddata == YES)
    {
        [self.uploadManage uploadVMRailCheckFileToServer:xmlString
                                          fileType:kVMXmlUploadCHK
                                    andfilePathArr:self.resultPicArr
                                    andxmlPath:[NSString stringWithFormat:@"%@/%@/%@",[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode]];
    }
    else if([CacheManagement instance].uploaddata == NO)
    {
        // 更新本地事项状态
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        NSString* sql_ = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET VMRAILCHECK = '%@' where WORKMAINID = '%@'",@"1",[CacheManagement instance].currentWorkMainID];
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
        if ([rs next] == YES)
        {
            NSString* cachePath = [rs stringForColumn:@"CHECK_XML_PATH"];
            if ([cachePath length] < 10) {
                cachePath = [NSString stringWithFormat:kXmlPathString,[Utilities SysDocumentPath],CurrentDate,[CacheManagement instance].currentStore.StoreCode,[Utilities GetUUID]];
                NSFileManager* fileMannager = [NSFileManager defaultManager];
                if(![fileMannager fileExistsAtPath:cachePath])
                {
                    [fileMannager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
                }
            }
            else {
                
                NSString *newfi = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[cachePath componentsSeparatedByString:@"/dataCaches"] lastObject]];
                cachePath = newfi ;
            }
            NSFileManager* fileMannager = [NSFileManager defaultManager];
            [fileMannager removeItemAtPath:cachePath error:nil];
            NSData* xmlData = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
            [xmlData writeToFile:cachePath atomically:YES];
            // 数据库存在记录 update
            NSString* picpath = [NSString stringWithFormat:@"%@/%@/%@/%@",[Utilities SysDocumentPath],CurrentDate,[CacheManagement instance].currentStore.StoreCode,@"VM_CHECK"];
            NSString* update_sql = [NSString stringWithFormat:@"UPDATE NVM_FILE_LIST SET CHECK_PIC_PATH = '%@',CHECK_XML_PATH='%@' WHERE STORE_CODE = '%@' AND CREATE_DATE = '%@' AND USER_ID = '%@'",picpath,cachePath,[CacheManagement instance].currentStore.StoreCode,CurrentDate,[CacheManagement instance].currentUser.UserId];
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
            NSString* picpath = [NSString stringWithFormat:@"%@/%@/%@/%@",[Utilities SysDocumentPath],CurrentDate,[CacheManagement instance].currentStore.StoreCode,@"VM_CHECK"];
            NSString *insert_sql = [NSString stringWithFormat:@"INSERT INTO NVM_FILE_LIST (STORE_CODE,CREATE_DATE,CHECK_PIC_PATH,STORE_NAME,USER_ID,CHECK_XML_PATH) values (?,?,?,?,?,?)"];
            [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:insert_sql,[CacheManagement instance].currentStore.StoreCode,CurrentDate,picpath,[CacheManagement instance].currentStore.StoreName,[CacheManagement instance].currentUser.UserId,cachePath];
        }
        Uploadstatu = 1;
        self.waitView.hidden = YES;
        [self.navigationController popViewControllerAnimated:YES];

    }
    
}

-(void)completeUploadServer:(NSString *)error
{
    self.waitView.hidden = YES;
    if ([error length] == 0)
    {
        Uploadstatu = 1;
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET VMRAILCHECK = '%@' where WORKMAINID = '%@'",@"2",[CacheManagement instance].currentWorkMainID];
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
}

-(void)showUploadAlert
{
    NSString* title = @"是否确定上传";
    if (SYSLanguage == EN) {
        title = @"Are you sure to upload ?";
    }

    UIAlertView* av = [[UIAlertView alloc]initWithTitle:title message:nil delegate:self cancelButtonTitle:SYSLanguage?@"Cancel": @"取消" otherButtonTitles:SYSLanguage?@"Sure": @"确定", nil];
    [av show];
}

-(void)Statistics // 统计结果
{
    if (ISKIDS) return ;
    
    NSString* sql  = [NSString stringWithFormat:@"select * from NVM_IST_VM_CHECK_ITEM where VM_CHK_ID = '%@'",[CacheManagement instance].currentVMCHKID];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
    
    double_t score = 0;
    
    double_t totalNumber = [APPDelegate VM_CHECK_ItemList].count;
    
    int Y = 0;
    int N = 0;
    int NA = 0;
    while ([rs next])
    {
        if ([[rs stringForColumnIndex:3] isEqualToString:countString])
        {
            score ++;
            Y ++;
        }
        if ([[rs stringForColumnIndex:3] isEqualToString:@"0"])
        {
            N ++;
        }
        if ([[rs stringForColumnIndex:3] isEqualToString:@"-1"])
        {
            totalNumber -- ;
            NA ++;
        }
    }
    [rs close];
    CGFloat totalScore = [countString floatValue]*Y;
    CGFloat totalScore_ = [countString floatValue]*totalNumber;
    
    
    
    NSString *allTotalScore = [NSString stringWithFormat:@"%.1f",(totalScore/totalScore_) * 100] ;
    if ([[CacheManagement instance].dataSource containsString:@"CN"]) {
        
        allTotalScore = [NSString stringWithFormat:@"%.f",(totalScore/totalScore_) * 100] ;
    }
    
    [self.filterview.totalScoreButton setTitle:allTotalScore forState:UIControlStateNormal];
    if ((totalScore/totalScore_) * 100 < self.TOTAL_num)
    {
        [self.filterview.totalScoreButton setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
    }
    else if ((totalScore/totalScore_) * 100 > self.TOTAL_num)
    {
        [self.filterview.totalScoreButton setBackgroundImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateNormal];
    }
    else if ((totalScore/totalScore_) * 100 == self.TOTAL_num)
    {
        [self.filterview.totalScoreButton setBackgroundImage:[UIImage imageNamed:@"yellow.png"] forState:UIControlStateNormal];
    }
    
    if (Y < self.Four_num)
    {
        [self.filterview.YButton setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
    }
    else if (Y > self.Four_num)
    {
        [self.filterview.YButton setBackgroundImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateNormal];
    }
    else if (Y == self.Four_num)
    {
        [self.filterview.YButton setBackgroundImage:[UIImage imageNamed:@"yellow.png"] forState:UIControlStateNormal];
    }
    
    if (N < self.Zero_num)
    {
        [self.filterview.NButton setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
    }
    else if (N > self.Zero_num)
    {
        [self.filterview.NButton setBackgroundImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateNormal];
    }
    else if (N == self.Zero_num)
    {
        [self.filterview.NButton setBackgroundImage:[UIImage imageNamed:@"yellow.png"] forState:UIControlStateNormal];
    }
    
    if (NA < self.NA_num)
    {
        [self.filterview.NAButton setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
    }
    else if (NA > self.NA_num)
    {
        [self.filterview.NAButton setBackgroundImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateNormal];
    }
    else if (NA == self.NA_num)
    {
        [self.filterview.NAButton setBackgroundImage:[UIImage imageNamed:@"yellow.png"] forState:UIControlStateNormal];
    }
    
    
    [self.filterview.YButton setTitle:[NSString stringWithFormat:@"%d",Y] forState:UIControlStateNormal];
    [self.filterview.NButton setTitle:[NSString stringWithFormat:@"%d",N] forState:UIControlStateNormal];
    [self.filterview.NAButton setTitle:[NSString stringWithFormat:@"%d",NA] forState:UIControlStateNormal];
}


@end
