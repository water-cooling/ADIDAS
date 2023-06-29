//
//  RailManageViewController.m
//  ADIDAS
//
//  Created by wendy on 14-4-23.
//
//

#import "RailManageViewController.h"
#import "SqliteHelper.h"
#import "FMDatabase.h"
#import "RailManageSingleIssueData.h"
#import "ManageScoreViewController.h"
#import "AppDelegate.h"
#import "Utilities.h"
#import "CacheManagement.h"
#import "CheckScoreEntity.h"
#import "XMLFileManagement.h"
#import "UploadManagement.h"
#import "CommonDefine.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSON.h"


@interface RailManageViewController ()

@end

@implementation RailManageViewController

@synthesize railmanageTableView;
@synthesize textlabel;
@synthesize uploadManage;
@synthesize totalScoreButton,YButton,NButton,NAButton;
@synthesize request;
@synthesize lastScoreArray;


-(CGFloat)getheight:(NSString*)str
{
    self.textlabel.frame = CGRectMake(0, 0, 240, 10000);
    self.textlabel.numberOfLines = 0;
    self.textlabel.font = [UIFont systemFontOfSize:13];
    self.textlabel.text = str;
    [self.textlabel sizeToFit];
    return self.textlabel.frame.size.height;
}

#pragma mark - tableview

//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    __autoreleasing NSArray* array = [NSArray arrayWithObjects:@"1",@"25",@"50",@"75",@"100", nil];
//    return array;
//}



-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [[[NSBundle mainBundle]loadNibNamed:@"RailManageHeadView" owner:self options:nil]objectAtIndex:0];

    for (UILabel* label in [view subviews])
    {
        if (label.tag == 0)
        {
            label.textColor = SYS_YELLOW;
            if (SYSLanguage == EN)
            {
                label.text = @"No.";
            }
        }
        if (label.tag == 1)
        {
            if (SYSLanguage == EN)
            {
                label.text = @"Name";
            }
        }
        if (label.tag == 2)
        {
            if (SYSLanguage == EN)
            {
                label.text = @"Score";
            }
        }
    }
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell* cell = [self tableView:railmanageTableView cellForRowAtIndexPath:indexPath];
//    return cell.frame.size.height + 20;
    CGFloat f = [self getheight:[[self.tableviewSourceArr objectAtIndex:indexPath.row]valueForKey:@"item_name_cn"]];
    
    return f+30;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableviewSourceArr count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RailManageTableViewCell* cell = (RailManageTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    ManageScoreViewController* msvc = [[ManageScoreViewController alloc]initWithNibName:@"ManageScoreViewController" bundle:nil];
    msvc.TOTAL_num = self.TOTAL_num;
    msvc.Y_num = self.Y_num;
    msvc.N_num = self.N_num;
    msvc.NA_num = self.NA_num;
    
    msvc.No = [cell.numLabel.text integerValue];
    msvc.item_name = cell.issueLabel.text;
    msvc.remark = cell.remark;
    msvc.scoreOption = cell.scoreOption;
    msvc.item_id = [[self.tableviewSourceArr objectAtIndex:indexPath.row] valueForKey:@"item_id"];
    msvc.reasonsArr = [cell.reasons componentsSeparatedByString:@"|"];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController pushViewController:msvc animated:YES];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"cell";
    RailManageTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RailManageTableViewCell" owner:self options:nil]objectAtIndex:0];
    }
//    if (indexPath.row%2 == 0)
//    {
//        cell.backgroundColor = [UIColor redColor];
//    }
//    else
//    {
//        cell.backgroundColor =[UIColor blueColor];
//    }
    cell.issueLabel.numberOfLines = 0;
    cell.arrowimageview.hidden = YES;
    cell.issueLabel.textColor = [UIColor darkGrayColor];
    cell.scoreLabel.textColor = [UIColor darkGrayColor];

    cell.numLabel.text = [NSString stringWithFormat:@"%d",((RailManageSingleIssueData*)[self.tableviewSourceArr objectAtIndex:indexPath.row]).item_NO];
    cell.issueLabel.text = [[self.tableviewSourceArr objectAtIndex:indexPath.row]valueForKey:SYSLanguage?@"item_name_en": @"item_name_cn"];
    cell.remark = [[self.tableviewSourceArr objectAtIndex:indexPath.row]valueForKey:SYSLanguage?@"remark_en":@"remark_cn"];
    cell.reasons = [[self.tableviewSourceArr objectAtIndex:indexPath.row]valueForKey:SYSLanguage?@"reason_en":@"reason_cn"];
    cell.scoreOption = [[self.tableviewSourceArr objectAtIndex:indexPath.row]valueForKey:@"score_option"];
    cell.itemID = [[self.tableviewSourceArr objectAtIndex:indexPath.row]valueForKey:@"item_id"];
    NSNumber* scorenumber = [self GetScorebyCHK_ID:[CacheManagement instance].currentCHKID andItemID:cell.itemID];
    // 取上次得分记录
    id obj = [self searchLastResult:cell.itemID];
    
    NSInteger lastscore = [[obj valueForKey:@"Score"]intValue];
    if ([scorenumber intValue] == 0)
    {
        cell.scoreLabel.text = @"N";
        if (lastscore == 1)
        {
            cell.arrowimageview.image = [UIImage imageNamed:@"down.png"];
            cell.arrowimageview.hidden = NO;
            cell.issueLabel.textColor = [UIColor colorWithRed:0.68 green:0.26 blue:0.18 alpha:1];
            cell.scoreLabel.textColor = [UIColor colorWithRed:0.68 green:0.26 blue:0.18 alpha:1];
        }
    }
    else if ([scorenumber intValue] == 1)
    {
        cell.scoreLabel.text = @"Y";
        if (lastscore == 0)
        {
            cell.arrowimageview.image = [UIImage imageNamed:@"up.png"];
            cell.arrowimageview.hidden = NO;
            cell.issueLabel.textColor = [UIColor colorWithRed:0.47 green:0.67 blue:0.074 alpha:1];
            cell.scoreLabel.textColor = [UIColor colorWithRed:0.47 green:0.67 blue:0.074 alpha:1];
    
        }
    }
    else if([scorenumber intValue] == -1)
    {
        cell.scoreLabel.text = @"N/A";
        cell.arrowimageview.hidden = YES;
        cell.issueLabel.textColor = [UIColor darkGrayColor];
        cell.scoreLabel.textColor = [UIColor darkGrayColor];
    }
    else
    {
        cell.scoreLabel.text = @"";
        cell.arrowimageview.hidden = YES;
        cell.issueLabel.textColor = [UIColor darkGrayColor];
        cell.scoreLabel.textColor = [UIColor darkGrayColor];
    }

    
    [cell configCellHeight:cell.issueLabel.text];
    return cell;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Data



-(NSNumber*)GetScorebyCHK_ID:(NSString*)currentCHK_ID andItemID:(NSString*)Item_ID
{
    NSString* sql = [NSString stringWithFormat:@"select * from IST_FR_ARMS_CHK_ITEM where FR_ARMS_CHK_ID ='%@' and FR_ARMS_ITEM_ID='%@'",currentCHK_ID,Item_ID];
    
    __autoreleasing NSMutableArray* result = [[NSMutableArray alloc]init];
    FMResultSet *rs = nil;
    rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        NSNumber* score = [NSNumber numberWithInt:[rs intForColumnIndex:3]];
        [result addObject:score];
        NSLog(@"Score %@",score);
    }
    [rs close];
    if ([result count] == 0)
    {
        return [NSNumber numberWithInt:3];
    }
    return [result objectAtIndex:0];
}

-(void)GetCheckIssueFromDB
{
    FMDatabase* db = [[SqliteHelper shareCommonSqliteHelper]database];
    [[APPDelegate railmanageIssueList] removeAllObjects];
    {
        FMResultSet* rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM FR_ARMS_ITEM WHERE DATASOURCE like '%%%@%%' ",[CacheManagement instance].dataSource]];
        while([rs next])
        {
            
            RailManageSingleIssueData* issuedata =  [[RailManageSingleIssueData alloc]init];
            issuedata.item_id = [rs stringForColumnIndex:0];
            issuedata.item_name_cn = [rs stringForColumnIndex:1];
            issuedata.item_name_en = [rs stringForColumnIndex:2];
            issuedata.item_NO = [rs intForColumnIndex:3];
            issuedata.score_option = [rs stringForColumnIndex:4];
            issuedata.isdelete = [rs intForColumnIndex:5];
            issuedata.remark_cn = [rs stringForColumnIndex:6];
            issuedata.remark_en = [rs stringForColumnIndex:7];
            issuedata.reason_cn = [rs stringForColumnIndex:8];
            issuedata.reason_en = [rs stringForColumnIndex:9];
            issuedata.last_modified_by = [rs stringForColumnIndex:10];
            issuedata.datetime = [rs stringForColumnIndex:11];
            [[APPDelegate railmanageIssueList] addObject:issuedata];
        }
    }
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"item_NO" ascending:YES];
    [[APPDelegate railmanageIssueList] sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    
}

//-(void)back
//{
//    [self.tabBarController.navigationController popViewControllerAnimated:YES];
//}

-(void)Statistics // 统计结果
{
    [self.FilterArrY removeAllObjects];
    [self.FilterArrN removeAllObjects];
    [self.FilterArrNA removeAllObjects];
    
    NSString* sql  = [NSString stringWithFormat:@"select * from IST_FR_ARMS_CHK_ITEM where FR_ARMS_CHK_ID = '%@'",[CacheManagement instance].currentCHKID];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
    
    double_t score = 0;
    double_t totalNumber = [APPDelegate railmanageIssueList].count;
    int Y = 0;
    int N = 0;
    int NA = 0;
    while ([rs next])
    {
        if ([rs intForColumnIndex:3] == 1)
        {
            score ++;
            Y ++;
            for (RailManageSingleIssueData* object in [APPDelegate railmanageIssueList])
            {
                if ([object.item_id isEqualToString:[rs stringForColumnIndex:2]])
                {
                    [self.FilterArrY addObject: object];
                    break;
                }
            }
        }
        if (([rs intForColumnIndex:3] == 0))
        {
            N ++;
            for (RailManageSingleIssueData* object in [APPDelegate railmanageIssueList])
            {
                if ([object.item_id isEqualToString:[rs stringForColumnIndex:2]])
                {
                    [self.FilterArrN addObject:object];
                    break;
                }
            }
        }
        if (([rs intForColumnIndex:3] == -1))
        {
            totalNumber -- ;
            NA ++;
            for (RailManageSingleIssueData* object in [APPDelegate railmanageIssueList])
            {
                if ([object.item_id isEqualToString:[rs stringForColumnIndex:2]])
                {
                    [self.FilterArrNA addObject: object];
                    break;
                }
            }
        }
    }
    [rs close];
    int totalScore = score/totalNumber * 100;
    
    if (totalScore < self.TOTAL_num)
    {
        [self.filterview.totalScoreButton setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
    }
    else if (totalScore > self.TOTAL_num)
    {
        [self.filterview.totalScoreButton setBackgroundImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateNormal];
    }
    else if (totalScore == self.TOTAL_num)
    {
        [self.filterview.totalScoreButton setBackgroundImage:[UIImage imageNamed:@"yellow.png"] forState:UIControlStateNormal];
    }
    
    if (Y < self.Y_num)
    {
        [self.filterview.YButton setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
    }
    else if (Y > self.Y_num)
    {
        [self.filterview.YButton setBackgroundImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateNormal];
    }
    else if (Y == self.Y_num)
    {
        [self.filterview.YButton setBackgroundImage:[UIImage imageNamed:@"yellow.png"] forState:UIControlStateNormal];
    }
    
    if (N < self.N_num)
    {
        [self.filterview.NButton setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
    }
    else if (N > self.N_num)
    {
        [self.filterview.NButton setBackgroundImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateNormal];
    }
    else if (N == self.N_num)
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
    [self.filterview.totalScoreButton setTitle:[NSString stringWithFormat:@"%d",totalScore] forState:UIControlStateNormal];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"item_NO" ascending:YES];
    [self.FilterArrY sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    [self.FilterArrN sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    [self.FilterArrNA sortUsingDescriptors:[NSArray arrayWithObject:sort]];
}


-(void)upload
{
   
    self.totalScore = 0;
    NSString* sql  = [NSString stringWithFormat:@"select * from IST_FR_ARMS_CHK_ITEM where FR_ARMS_CHK_ID = '%@' ORDER BY ITEM_NO",[CacheManagement instance].currentCHKID];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
    int i = 0;
    while ([rs next])
    {
        if ([rs intForColumnIndex:3] == 3)
        {
            [HUD hideUIBlockingIndicator];
            ALERTVIEW(SYSLanguage?@"Please finish all items then upload": @"还有未完成项，请继续填写");
            [rs close];
            return;
        }
        i++;
    }
    if (i < [APPDelegate railmanageIssueList].count)
    {
        [HUD hideUIBlockingIndicator];
        ALERTVIEW(SYSLanguage?@"Please finish all items then upload": @"还有未完成项，请继续填写");
        [rs close];
        return;
    }
    [self.resultArr removeAllObjects];
    [self.resultPicArr removeAllObjects];
    [self.resultPicNameArr removeAllObjects];
    FMResultSet* rs_ = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
    while ([rs_ next])
    {
        CheckScoreEntity* checkScoreEntity = [[CheckScoreEntity alloc]initWithFMResultSet:rs_];
        [self.resultArr addObject:checkScoreEntity];
        if (checkScoreEntity.photo_path1 != nil)
        {
            [self.resultPicArr addObject:checkScoreEntity.photo_path1];
            NSString* photoName_1 = [NSString stringWithFormat:@"%@_%@1.jpg",checkScoreEntity.FR_ARMS_CHK_ITEM_ID,[Utilities DateTimeNowUpload]];
            [self.resultPicNameArr addObject:photoName_1];
        }
        if (checkScoreEntity.photo_path2 != nil)
        {
            [self.resultPicArr addObject:checkScoreEntity.photo_path2];
            NSString* photoName_2 = [NSString stringWithFormat:@"%@_%@2.jpg",checkScoreEntity.FR_ARMS_CHK_ITEM_ID,[Utilities DateTimeNowUpload]];
            [self.resultPicNameArr addObject:photoName_2];

        }
    }
    [rs_ close];
    // 制作xml 文件
    
    
    XMLFileManagement * xmlcon = [[XMLFileManagement alloc] init];
    NSString* xmlString = [xmlcon CreateRailcheckString:self.resultArr
                                              WorkEndTime:[Utilities DateTimeNow]
                                             FR_ARMSchkID:[CacheManagement instance].currentCHKID
                                            WorkStartTime:[Utilities DateTimeNow]
                                                StoreCode:[CacheManagement instance].currentStore.StoreCode
                                               submittime:[Utilities DateTimeNow]
                                                 WorkDate:[Utilities DateNow]
                                               TotalScore:[NSString stringWithFormat:@"%d",(int)self.totalScore]];
    if ([CacheManagement instance].uploaddata == YES)
    {
        [HUD showUIBlockingIndicator];
        [self.uploadManage uploadVMRailCheckFileToServer:xmlString
                                                fileType:kXmlUploadCHK
                                          andfilePathArr:self.resultPicArr
                                              andxmlPath:[NSString stringWithFormat:@"%@/%@/%@",[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode]];
    }
    else if([CacheManagement instance].uploaddata == NO)
    {
        // 更新本地事项状态
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        NSString* sql_ = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET RAILCHECK = '%@' where WORKMAINID = '%@'",@"1",[CacheManagement instance].currentWorkMainID];
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
            NSString* cachePath = [rs stringForColumn:@"RAILCHECK_XML_PATH"];
            if ([cachePath length] < 10) {
                cachePath = [NSString stringWithFormat:kXmlPathString,[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,[Utilities GetUUID]];
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
            NSString* picpath = [NSString stringWithFormat:@"%@/%@/%@/%@",[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,@"RAIL_CHECK"];
            NSString* update_sql = [NSString stringWithFormat:@"UPDATE NVM_FILE_LIST SET RAILCHECK_PIC_PATH = '%@',RAILCHECK_XML_PATH='%@' WHERE STORE_CODE = '%@' AND CREATE_DATE = '%@' AND USER_ID = '%@' ",picpath,cachePath,[CacheManagement instance].currentStore.StoreCode,CurrentDate,[CacheManagement instance].currentUser.UserId];
            [db executeUpdate:update_sql];
            
        }
        else
        {
            // 写xml到本地
            NSString* cachePath = [NSString stringWithFormat:kXmlPathString,[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,[Utilities GetUUID]];
            NSFileManager* fileMannager = [NSFileManager defaultManager];
            if(![fileMannager fileExistsAtPath:cachePath])
            {
                [fileMannager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            [fileMannager removeItemAtPath:cachePath error:nil];
            NSData* xmlData = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
            [xmlData writeToFile:cachePath atomically:YES];
            // 不存在记录 insert
            NSString* picpath = [NSString stringWithFormat:@"%@/%@/%@/%@",[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,@"RAIL_CHECK"];
            NSString *insert_sql = [NSString stringWithFormat:@"INSERT INTO NVM_FILE_LIST (STORE_CODE,CREATE_DATE,RAILCHECK_PIC_PATH,STORE_NAME,USER_ID,RAILCHECK_XML_PATH) values (?,?,?,?,?,?)"];
            [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:insert_sql,[CacheManagement instance].currentStore.StoreCode,CurrentDate,picpath,[CacheManagement instance].currentStore.StoreName,[CacheManagement instance].currentUser.UserId,cachePath];
        }
        Uploadstatu = 1;
//        self.waitView.hidden = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)completeUploadServer:(NSString *)error
{
    
    [HUD hideUIBlockingIndicator];
    if (error == nil)
    {
        Uploadstatu = 1;
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        NSString* sql_ = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET RAILCHECK = '%@' where WORKMAINID = '%@'",@"1",[CacheManagement instance].currentWorkMainID];
        [db executeUpdate:sql_];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [HUD showUIBlockingIndicatorWithText:error withTimeout:2];
    }
}

-(IBAction)filter:(id)sender
{
//    [Utilities showWaiting];
//    CFRunLoopRun();
    UIButton* button = (UIButton*)sender;
    NSInteger tag = button.tag;
    self.tableviewSourceArr = nil;
    if (tag == 1)
    {
        self.tableviewSourceArr = self.FilterArrY;
    }
    else if(tag == 0)
    {
        self.tableviewSourceArr = self.FilterArrN;
    }
    
    else if(tag == 2)
    {
        self.tableviewSourceArr = self.FilterArrNA;
    }
    else if(tag == 3)
    {
        self.tableviewSourceArr = [APPDelegate railmanageIssueList];
    }
   
//    sleep(1);
    [self.railmanageTableView reloadData];
   
}

-(id)searchLastResult:(NSString*)item_id
{
    id obj_result;
    for ( id obj in self.lastScoreArray)
    {
        if ([[obj objectForKey:@"ItemId"] isEqualToString:item_id])
        {
            obj_result = obj;
        }
    }
    return obj_result;
}

-(void)loadView
{
    [super loadView];
    UIView* view_ = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view_.userInteractionEnabled = YES;
    view_.backgroundColor = [UIColor redColor];
    self.view =view_;
}

// 检查此次检查表是否存在
-(NSArray*)checkARMS_CheckID
{
    __autoreleasing NSMutableArray* resultarr = [[NSMutableArray alloc]init];
    NSString* storecode = [CacheManagement instance].currentStore.StoreCode;
    NSString* workmainID = [CacheManagement instance].currentWorkMainID;
    NSString* sql = [NSString stringWithFormat:@"select * from IST_FR_ARMS_CHK where WORK_MAIN_ID ='%@' and STORE_CODE= '%@'",workmainID,storecode];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        //			SyncParaVersionEntity * entity = [[SyncParaVersionEntity alloc] initWithFMResultSet:rs];
        [resultarr addObject:[rs stringForColumnIndex:0]];
    }
    [rs close];
    
	return resultarr;
    
}

-(void)UpdateARMS_CheckID
{
    NSArray* arr = [self checkARMS_CheckID];
    if ( arr.count > 0)
    {
        // 存在列表
        [CacheManagement instance].currentCHKID = [arr objectAtIndex:0];
    }
    else
    {
        NSString* FR_ARMS_CHK_ID =[Utilities GetUUID];  [CacheManagement instance].currentCHKID = FR_ARMS_CHK_ID;
        NSString* storeCode = [CacheManagement instance].currentStore.StoreCode;
        NSString* workdate = [Utilities DateNow];
        NSString* workstarttime = [Utilities DateTimeNow];
        NSString* workendtime = [Utilities DateTimeNow];
        NSString* userid = [CacheManagement instance].currentUser.UserId;
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO IST_FR_ARMS_CHK (FR_ARMS_CHK_ID,STORE_CODE,WORK_MAIN_ID,WORK_DATE,WORK_START_TIME,WORK_END_TIME,TOTAL_SCORE,USER_SUBMIT_TIME,CLIENT_UPLOAD_TIME,SERVER_INSERT_TIME,USER_ID) values (?,?,?,?,?,?,?,?,?,?,?)"];
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         FR_ARMS_CHK_ID,
         storeCode,
         [CacheManagement instance].currentWorkMainID,
         workdate,
         workstarttime,
         workendtime,
         @"0",
         workendtime, //  提交时间
         nil,
         nil,
         userid];
    }
}


// 插入本地评分表
-(void) insertLocalArmsCHKItem:(ManageScoreEntity*)data broker:(FMDatabase*)db
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO IST_FR_ARMS_CHK_ITEM (FR_ARMS_CHK_ITEM_ID,FR_ARMS_CHK_ID,FR_ARMS_ITEM_ID,SCORE,REASON,COMMENT,PHOTO_PATH1,PHOTO_PATH2) values (?,?,?,?,?,?,?,?)"];
    //    FMDatabase *db = [[SqliteHelper shareCommonSqliteHelper] database];
    [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql,
     data.check_item_id,
     data.check_id,
     data.item_id,
     [NSNumber numberWithInteger:data.score ],
     data.reason,
     data.comment,
     data.picpath1,
     data.picpath2];
}

//删除原有数据
-(void)deleteLocalArmsCHKItem:(FMDatabase*)db
{
    NSString *sql = [NSString stringWithFormat:@"delete from IST_FR_ARMS_CHK_ITEM where FR_ARMS_ITEM_ID='%@' and FR_ARMS_CHK_ID = '%@'",self.item_id,[CacheManagement instance].currentCHKID];
    [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql];
}

-(void)saveSingleResult
{
    self.CurrentmanageResultEntity.score = -1;
    self.CurrentmanageResultEntity.reason = @"经销商店铺可忽略";
    self.CurrentmanageResultEntity.picpath1 = nil;
    self.CurrentmanageResultEntity.picpath2 = nil;
    self.CurrentmanageResultEntity.item_id = self.item_id;
    self.CurrentmanageResultEntity.comment = nil;
    self.CurrentmanageResultEntity.check_id = [CacheManagement instance].currentCHKID;
    self.CurrentmanageResultEntity.check_item_id = [Utilities GetUUID];
    
    FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
    [db beginTransaction];
    // 删除原有数据
    BOOL result = YES;
    
    @try
    {
        [self deleteLocalArmsCHKItem:db];
        
        [self insertLocalArmsCHKItem:self.CurrentmanageResultEntity broker:db];
    }
    @catch (NSException *exception)
    {
        result = NO;
    }
    @finally
    {
        if (result == YES)
        {
            [db commit];
        }
        else
        {
            [db rollback];
        }
    }
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [Utilities createLeftBarButton:self clichEvent:@selector(back)];
   
    self.Y_num = 0;
    self.N_num = 0;
    self.NA_num = 0;
    self.TOTAL_num = 0;
    
    [self UpdateARMS_CheckID];
    self.CurrentmanageResultEntity = [[ManageScoreEntity alloc]init];
    
    self.resultArr = [[NSMutableArray alloc]init];
    self.FilterArrY = [[NSMutableArray alloc]init];
     self.FilterArrN = [[NSMutableArray alloc]init];
     self.FilterArrNA = [[NSMutableArray alloc]init];
    self.resultPicArr = [[NSMutableArray alloc]init];
    self.resultPicNameArr = [[NSMutableArray alloc]init];
    self.uploadManage = [[UploadManagement alloc] init];
    self.uploadManage.delegate = self;
    [self GetCheckIssueFromDB];
    
    for (id obj in [APPDelegate Store_NA_List])
    {
        NSLog(@"%@",obj);
        self.item_id = [obj valueForKey:@"FrArmsItemId"];
        [self saveSingleResult];
    }
    self.lastScoreArray = [APPDelegate lastScoreArray];
    for (id obj in self.lastScoreArray)
    {
        if ([[obj valueForKey:@"Score"]intValue] == 0)
        {
            self.N_num++;
        }
        else if([[obj valueForKey:@"Score"]intValue] == 1)
        {
            self.Y_num++;
        }
        else if([[obj valueForKey:@"Score"]intValue] == -1)
        {
            self.NA_num++;
        }
        self.TOTAL_num = [[obj valueForKey:@"TotalScore"]intValue];
    }
    [self Statistics];

    if (SYSLanguage == CN) {
        [Utilities createRightBarButton:self clichEvent:@selector(upload) btnSize:CGSizeMake(50, 30)
                               btnTitle:@"上传"];
    }
    else if (SYSLanguage == EN)
    {
        [Utilities createRightBarButton:self clichEvent:@selector(upload) btnSize:CGSizeMake(60, 30)
                               btnTitle:@"Upload"];
    }
    UILabel* label =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44) ];
    label.text = @"零售管理标准检查";
    if (SYSLanguage == EN) {
        label.text = @"aRMS";
    }
    label.backgroundColor  =[UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    [self.navigationItem setTitleView:label];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    UIImageView* locationview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, DEWIDTH, 40)];
    locationview.image = [UIImage imageNamed:@"locationBarbg.png"];
    UILabel* locationlabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, DEWIDTH-30, 40)];
    locationlabel.numberOfLines = 2 ;
    locationlabel.backgroundColor =[UIColor clearColor];
    locationlabel.font = [UIFont systemFontOfSize:14];
    locationlabel.tag = 111;
    locationlabel.text = [CacheManagement instance].currentStore.StoreName;
    [locationview addSubview:locationlabel];
    [self.view addSubview:locationview];

    self.filterview = [[FilterView alloc]initWithFrame:CGRectMake(0, 104, DEWIDTH, 40)];
    self.filterview.userInteractionEnabled = YES;
    //    self.filterview.frame = CGRectMake(0, 60, 320, 40);
    [self.view addSubview:self.filterview];
    
//    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:button];
//    [button addTarget:self action:@selector(filter:) forControlEvents:UIControlEventTouchUpInside];
//    button.frame = CGRectMake(0, 0, 50, 40);
    
//
    [self.filterview AddActionToButtonWithView:self
                                           and:@selector(filter:)
                                           and:@selector(filter:)
                                           and:@selector(filter:)
                                           and:@selector(filter:)];
    
    self.textlabel = [[UILabel alloc]init];
    
    self.railmanageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 144, DEWIDTH,DEVICE_HEIGHT-64-80) style:UITableViewStylePlain];
    self.railmanageTableView.delegate = self;
    self.railmanageTableView.dataSource = self;
//    self.railmanageTableView.backgroundView  = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"tablebg.png"]];

    [self.railmanageTableView setSectionHeaderHeight:40];
    [self.railmanageTableView setBackgroundColor:[UIColor whiteColor]];
    [self.railmanageTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.railmanageTableView];
    // Do any additional setup after loading the view.
    self.tableviewSourceArr = [APPDelegate railmanageIssueList];
    [self.view bringSubviewToFront:self.filterview];
    self.totalScore = 0;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self Statistics];
    [self.railmanageTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
