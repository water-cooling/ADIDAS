//
//  ScoreCardViewController.m
//  MobileApp
//
//  Created by 桂康 on 2017/10/25.
//

#import "ScoreCardViewController.h"
#import "SqliteHelper.h"
#import "Utilities.h"
#import "AppDelegate.h"
#import "VmCheckCategoryEntity.h"
#import "CommonDefine.h"
#import "VmScoreCardEntity.h"
#import "VM_CHECK_ITEM_Cell.h"
#import "ScoreCardItemViewController.h"
#import "VMIstScoreCardEntity.h"
#import "XMLFileManagement.h"
#import "VMScoreCardPhotoEntity.h"
#import "VmScoreCardScoreEntity.h"
#import "VmScoreCardDetailEntity.h"
#import "ScoreCardAfterViewController.h"

@interface ScoreCardViewController ()

@end

@implementation ScoreCardViewController


// 检查此次检查表是否存在
-(NSArray*)checkNVM_IST_CHECK_ID
{
    __autoreleasing NSMutableArray* resultarr = [[NSMutableArray alloc]init];
    NSString* storecode = [CacheManagement instance].currentStore.StoreCode;
    NSString* workmainID = [CacheManagement instance].currentWorkMainID;
    NSString* sql = [NSString stringWithFormat:@"select * from NVM_IST_SCORECARD_CHECK where WORK_MAIN_ID ='%@' and STORE_CODE= '%@' and SCORE_CARD_TYPE='%@'",workmainID,storecode,self.type];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        //            SyncParaVersionEntity * entity = [[SyncParaVersionEntity alloc] initWithFMResultSet:rs];
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
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_SCORECARD_CHECK (SCORECARD_CHK_ID,STORE_CODE,USER_ID,WORK_MAIN_ID,WORK_DATE,WORK_START_TIME,WORK_END_TIME,USER_SUBMIT_TIME,CLIENT_UPLOAD_TIME,SERVER_INSERT_TIME,SCORE_CARD_TYPE) values (?,?,?,?,?,?,?,?,?,?,?)"];
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         NVM_IST_VM_CHECK_ID,
         storeCode,
         userid,
         [CacheManagement instance].currentWorkMainID,
         workdate,
         workstarttime,
         workendtime,
         workendtime, //  提交时间
         nil,
         nil,
         self.type];
    }
}

// 本地数据库读取见检查项

-(void)GetCheckIssueFromDB
{
    FMDatabase* db = [[SqliteHelper shareCommonSqliteHelper]database];
    [[APPDelegate VM_CHECK_ItemList] removeAllObjects];
    
    FMResultSet* rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM NVM_VM_SCORECARD_ITEM where IS_KIDS = '%d' order by ITEM_NO ",ISKIDS]];
    
    while([rs next])
    {
        VmScoreCardEntity* checkEntity = [[VmScoreCardEntity alloc] initWithFMResultSet:rs];
        [[APPDelegate VM_CHECK_ItemList] addObject:checkEntity];
    }
}

// 查找得分

-(NSString*)GetScorebyCHK_ID:(NSString*)currentCHK_ID andItemID:(NSString*)Item_ID
{
    
    NSString* sql = [NSString stringWithFormat:@"select * from NVM_IST_SCORECARD_CHECK_PHOTO where SCORECARD_CHK_ID ='%@' and SCORECARD_ITEM_ID='%@' and SCORE_CARD_TYPE='%@'",currentCHK_ID,Item_ID,self.type];

    NSString *SCORECARD_CHECK_PHOTO_ID = @"" ;
    NSString *comment = @"" ;
    FMResultSet *rs = nil;
    rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        SCORECARD_CHECK_PHOTO_ID = [rs stringForColumnIndex:0] ;
        comment = [rs stringForColumnIndex:3];
    }
    [rs close];
    
    
    if ([self.type isEqualToString:@"M"]) {
        
        if (comment&&![comment isEqual:[NSNull null]]&&![comment isEqualToString:@""]) {
            
            return @"finished" ;
        }
        
        NSString *sql = [NSString stringWithFormat:@"Select * FROM NVM_IST_SCORECARD_PHOTO_ZONE where SCORECARD_CHECK_PHOTO_ID = '%@' and SCORE_CARD_TYPE = '%@'",SCORECARD_CHECK_PHOTO_ID,self.type];
        
        FMResultSet *rs = nil;
        @try
        {
            rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
            while ([rs next])
            {
                NSString *PHOTO_WEB_PATH1 = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"PHOTO_PATH1"]];
                
                if (PHOTO_WEB_PATH1&&![PHOTO_WEB_PATH1 isEqual:[NSNull null]]&&PHOTO_WEB_PATH1.length > 5) {
                    
                    [rs close];
                    return @"finished" ;
                }
            }
        }
        @catch (NSException *e)
        {
            @throw e;
        }
        @finally
        {
            if (rs)[rs close];
        }
    }
    
    if ([self.type isEqualToString:@"D"]) {
        
        NSString *sql2 = [NSString stringWithFormat:@"Select * FROM NVM_IST_SCORECARD_ITEM_DETAIL where SCORECARD_CHECK_PHOTO_ID = '%@' and SCORECARD_ITEM_ID = '%@'",SCORECARD_CHECK_PHOTO_ID,Item_ID];
        int count = 0 ;
        FMResultSet *rs2 = nil;
        
        @try
        {
            rs2 = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql2];
            while ([rs2 next])
            {
                count += 1 ;
                VmScoreCardScoreEntity *entity = [[VmScoreCardScoreEntity alloc] initWithFMResultSet:rs2];
                
                if (!entity.STANDARD_SCORE||[entity.STANDARD_SCORE isEqual:[NSNull null]]||[entity.STANDARD_SCORE isEqualToString:@""]) {
                    
                    [rs2 close];
                    return @"" ;
                }
            }
        }
        @catch (NSException *e)
        {
            @throw e;
        }
        @finally
        {
            if (rs2)[rs2 close];
        }
        
        if (count == [[self getAllScoreItem:Item_ID] count]) {
            
            return @"finished" ;
        }
    }
    
    return @"" ;
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
    
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.waitView ];

    ((UILabel*)[self.waitView viewWithTag:88]).text = SYSLanguage?@"Processing,please wait …":@"请稍等,正在执行...";
    [self.waitView setHidden:YES];

    
    [Utilities createLeftBarButton:self clichEvent:@selector(back)];
    
    self.resultArr = [[NSMutableArray alloc]init];
    self.resultPicArr = [[NSMutableArray alloc]init];
  
    [self UpdateNVM_IST_CHECK_ID];
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    }
    
    if ([self.type isEqualToString:@"D"]) {
        
        self.title = SYSLanguage?@"Daily Visit":@"日常巡店";
    }
    
    if ([self.type isEqualToString:@"M"]) {
        
        self.title = SYSLanguage?@"Monthly Report":@"月度报告";
    }
    
    self.scoreTableView.contentInset = UIEdgeInsetsMake(42, 0, 0, 0) ;
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
    
    self.tableviewSourceArr = [APPDelegate VM_CHECK_ItemList];
    
    self.scoreTableView.dataSource = self ;
    self.scoreTableView.delegate = self ;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.scoreTableView reloadData];
    self.checkPhotoIdArray = [self getAllCheckPhotoId];
    
    if ([self.checkPhotoIdArray count]) {
        
        BOOL isShow = [self getAllPhoto];
        
        if (isShow) {
            
            UIButton *btn =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45 , 30)];
            
            [btn addTarget:self action:@selector(showAfter) forControlEvents:UIControlEventTouchUpInside];
            [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [btn setTitle:@"After" forState:UIControlStateNormal];
            btn.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
            btn.layer.borderWidth = 0.6 ;
            btn.layer.cornerRadius = 3 ;
            btn.layer.borderColor = [[Utilities colorWithHexString:@"#ffffff"] CGColor];
            if (SYSLanguage == EN)
            {
                btn.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
            }
            
            
            UIButton *btn2 =[[UIButton alloc] initWithFrame:CGRectMake(50, 0, 45 , 30)];
            
            [btn2 addTarget:self action:@selector(showUploadAlert) forControlEvents:UIControlEventTouchUpInside];
            [btn2 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [btn2 setTitle:SYSLanguage?@"Submit":@"上传" forState:UIControlStateNormal];
            btn2.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
            btn2.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
            btn2.layer.borderWidth = 0.6 ;
            btn2.layer.cornerRadius = 2 ;
            btn2.layer.borderColor = [[Utilities colorWithHexString:@"#ffffff"] CGColor];
            if (SYSLanguage == EN)
            {
                btn2.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
            }
            
            UIView *viewbtn = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 85, 30)];
            viewbtn.backgroundColor = [UIColor clearColor] ;
            [viewbtn addSubview:btn];
            [viewbtn addSubview:btn2];
            
            UIBarButtonItem *rightButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:viewbtn];
            self.navigationItem.rightBarButtonItem = rightButtonItem1;

        }
        else {
            
            UIButton *btn =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50 , 30)];
            
            [btn addTarget:self action:@selector(showAfter) forControlEvents:UIControlEventTouchUpInside];
            [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            [btn setTitle:@"After" forState:UIControlStateNormal];
            btn.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
            btn.layer.borderWidth = 0.6 ;
            btn.layer.cornerRadius = 3 ;
            btn.layer.borderColor = [[Utilities colorWithHexString:@"#ffffff"] CGColor];
            btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
            if (SYSLanguage == EN)
            {
                btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
            }
            UIBarButtonItem *rightButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
            self.navigationItem.rightBarButtonItem = rightButtonItem1;
        }
    }
    else {

        UIButton *btn2 =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50 , 30)];
        
        [btn2 addTarget:self action:@selector(showUploadAlert) forControlEvents:UIControlEventTouchUpInside];
        [btn2 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [btn2 setTitle:SYSLanguage?@"Submit":@"上传" forState:UIControlStateNormal];
        btn2.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        btn2.layer.borderWidth = 0.6 ;
        btn2.layer.cornerRadius = 3 ;
        btn2.layer.borderColor = [[Utilities colorWithHexString:@"#ffffff"] CGColor];
        btn2.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        if (SYSLanguage == EN)
        {
            btn2.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
        }
        UIBarButtonItem *rightButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:btn2];
        self.navigationItem.rightBarButtonItem = rightButtonItem2;
    }
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
    
    if (ISKIDS) {
        
        cell.arrow_imageview.image = [UIImage imageNamed:@"cellbg_arrow_kids.png"];
    }
    
    VmScoreCardEntity* checkEntity = [self.tableviewSourceArr objectAtIndex:indexPath.row] ;
    cell.done_image.hidden = YES;
    cell.score_label.font = [UIFont systemFontOfSize:12];
    cell.score_label.hidden = YES ;
    
    @try {
        
        cell.item_ID = [NSString stringWithFormat:@"%@",checkEntity.SCORECARD_ITEM_ID];
        
    } @catch (NSException *exception) {
        
        NSLog(@"%@",exception) ;
    }
    
    cell.title_label.text = [NSString stringWithFormat:@"%@(%@%%)",checkEntity.ITEM_NAME_CN,checkEntity.STANDARD_SCORE];
    if (SYSLanguage == EN)
    {
        cell.title_label.text = [NSString stringWithFormat:@"%@(%@%%)",checkEntity.ITEM_NAME_EN,checkEntity.STANDARD_SCORE];
    }
    
    cell.no_label.text = [NSString stringWithFormat:@"%@",checkEntity.ITEM_NO];
    
    NSString *scorenumber = [self GetScorebyCHK_ID:[CacheManagement instance].currentVMCHKID andItemID:cell.item_ID];
    
    if ([scorenumber isEqualToString:@""])
    {
        cell.scorecard_image.hidden = YES;
    }
    else {
        cell.scorecard_image.hidden = NO;
    }
    
    cell.score_label.textColor = [UIColor darkGrayColor];
    cell.history_score_label.hidden = YES;
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableviewSourceArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 65 ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ScoreCardItemViewController* msvc = [[ScoreCardItemViewController alloc]initWithNibName:@"ScoreCardItemViewController" bundle:nil];
    msvc.type = self.type ;
    msvc.No = [[[self.tableviewSourceArr objectAtIndex:indexPath.row]valueForKey:@"ITEM_NO"] integerValue];
    msvc.item_name = [[self.tableviewSourceArr objectAtIndex:indexPath.row] valueForKey:@"ITEM_NAME_CN"];
    msvc.remark = [[self.tableviewSourceArr objectAtIndex:indexPath.row] valueForKey:@"REMARK_CN"];
    msvc.standard_score = [NSString stringWithFormat:@"%@",[[self.tableviewSourceArr objectAtIndex:indexPath.row] valueForKey:@"STANDARD_SCORE"]];
    if (SYSLanguage == EN) {
        msvc.item_name = [[self.tableviewSourceArr objectAtIndex:indexPath.row] valueForKey:@"ITEM_NAME_EN"];
        msvc.remark = [[self.tableviewSourceArr objectAtIndex:indexPath.row] valueForKey:@"REMARK_EN"];
    }
    msvc.item_id = [[self.tableviewSourceArr objectAtIndex:indexPath.row] valueForKey:@"SCORECARD_ITEM_ID"];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController pushViewController:msvc animated:YES];
}

-(void)upload
{
    
    if ([self.type isEqualToString:@"D"]) {
        
        for (VmScoreCardEntity* checkEntity in self.tableviewSourceArr) {
            
            NSString *scorenumber = [self GetScorebyCHK_ID:[CacheManagement instance].currentVMCHKID andItemID:[NSString stringWithFormat:@"%@",checkEntity.SCORECARD_ITEM_ID]];
            
            if ([scorenumber isEqualToString:@""]) {
                
                ALERTVIEW(SYSLanguage?@"Please finish all items then upload": @"还有未完成项，请继续填写");
                return ;
            }
        }
    }

    
    NSString *checktype = @"" ;
    if([self.type isEqualToString:@"M"]) checktype = @"Monthly" ;
    if([self.type isEqualToString:@"D"]) checktype = @"Daily" ;
    
    NSString* sql  = [NSString stringWithFormat:@"select * from NVM_IST_SCORECARD_CHECK_PHOTO where SCORECARD_CHK_ID = '%@' and SCORE_CARD_TYPE = '%@' ORDER BY SCORECARD_CHECK_PHOTO_ID",[CacheManagement instance].currentVMCHKID,self.type];
    
    NSMutableArray *cateArray = [NSMutableArray array];
    
    FMResultSet* rs_ = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
    
    while ([rs_ next])
    {
        VMIstScoreCardEntity* checkScoreEntity = [[VMIstScoreCardEntity alloc]initWithFMResultSet:rs_];
        
        [cateArray addObject:checkScoreEntity];
    }
    
    [rs_ close];
    
    NSString *where = @"" ;
    
    for (VMIstScoreCardEntity* checkScoreEntity in cateArray) {
        
        if ([where isEqualToString:@""]) {
            
            where = [NSString stringWithFormat:@" where SCORECARD_CHECK_PHOTO_ID = '%@' ",checkScoreEntity.SCORECARD_CHECK_PHOTO_ID] ;
        }
        else {
            
            where = [NSString stringWithFormat:@" %@ or SCORECARD_CHECK_PHOTO_ID = '%@' ",where,checkScoreEntity.SCORECARD_CHECK_PHOTO_ID] ;
        }
    }
    
    [self.resultArr removeAllObjects];
    [self.resultPicArr removeAllObjects];
    
    if (![where isEqualToString:@""]) {
        
        NSString *where1 = [NSString stringWithFormat:@" %@ and SCORE_CARD_TYPE = '%@' ",where,self.type] ;
        
        NSString* sql  = [NSString stringWithFormat:@"select * from NVM_IST_SCORECARD_PHOTO_ZONE %@",where1];
        
        FMResultSet* rs2 = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
        
        while ([rs2 next])
        {
            VMScoreCardPhotoEntity* checkScoreEntity = [[VMScoreCardPhotoEntity alloc]initWithFMResultSet:rs2];
            
            for (VMIstScoreCardEntity* card in cateArray) {
                
                if ([card.SCORECARD_CHECK_PHOTO_ID isEqualToString:checkScoreEntity.SCORECARD_CHECK_PHOTO_ID]) {
                    
                    checkScoreEntity.COMMENT = card.COMMENT ;
                    checkScoreEntity.SCORECARD_CHK_ID = card.SCORECARD_CHK_ID ;
                    checkScoreEntity.SCORECARD_ITEM_ID = card.SCORECARD_ITEM_ID ;
                    break ;
                }
            }
            
            [self.resultArr addObject:checkScoreEntity];
            
            if (checkScoreEntity.PHOTO_PATH1 != nil && ![checkScoreEntity.PHOTO_PATH1 isEqualToString:@""])
            {
                [self.resultPicArr addObject:checkScoreEntity.PHOTO_PATH1];
            }
            
            if ([checktype isEqualToString:@"Daily"]&&checkScoreEntity.PHOTO_PATH2 != nil && ![checkScoreEntity.PHOTO_PATH2 isEqualToString:@""])
            {
                [self.resultPicArr addObject:checkScoreEntity.PHOTO_PATH2];
            }
            
        }
        
        [rs2 close] ;
    }
    
    if ([self.resultPicArr count] == 0) {
        
        ALERTVIEW(SYSLanguage?@"Sorry,not exist image!":@"上传失败,没有照片,请至少拍摄一组照片！");
        return ;
    }
    
    NSMutableArray *scoreArray = [NSMutableArray array];
    
    if ([checktype isEqualToString:@"Daily"]) {
        
        if (![where isEqualToString:@""]) {
            
            NSString* sql  = [NSString stringWithFormat:@"select * from NVM_IST_SCORECARD_ITEM_DETAIL %@",where];
            
            FMResultSet* rs2 = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
            
            while ([rs2 next])
            {
                VmScoreCardScoreEntity* checkScoreEntity = [[VmScoreCardScoreEntity alloc] initWithFMResultSet:rs2];
                [scoreArray addObject:checkScoreEntity] ;
            }
            
            [rs2 close] ;
        }
    }
    
    self.waitView.hidden = NO;
    
    // 制作xml 文件
    
    XMLFileManagement * xmlcon = [[XMLFileManagement alloc] init];
    NSString* xmlString =   [xmlcon CreateScoreCardCheckString:self.resultArr
                                            WorkEndTime:[Utilities DateTimeNow]
                                         ScoreCardChkId:[CacheManagement instance].currentVMCHKID
                                          WorkStartTime:[Utilities DateTimeNow]
                                              StoreCode:[CacheManagement instance].currentStore.StoreCode
                                             submittime:[Utilities DateTimeNow]
                                               WorkDate:[Utilities DateNow]
                                              checkType:checktype
                                             scoreArray:scoreArray
                                           commentArray:cateArray
                                               isAddWeb:NO
                            ClientUploadTimeForWorkMain:[CacheManagement instance].checkinTime];
    if ([CacheManagement instance].uploaddata == YES)
    {
        [self.uploadManage uploadVMRailCheckFileToServer:xmlString
                                                fileType:kVMXmlUploadScoreCard
                                          andfilePathArr:self.resultPicArr
                                              andxmlPath:[NSString stringWithFormat:@"%@/%@/%@",[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode]];
    }
    else if([CacheManagement instance].uploaddata == NO)
    {
        // 更新本地事项状态
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        NSString* sql_ = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET SCORECARD = '%@' where WORKMAINID = '%@'",@"1",[CacheManagement instance].currentWorkMainID];
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
            NSString* cachePath = [rs stringForColumn:@"SCORECARD_XML_PATH"];
            
            if ([self.type isEqualToString:@"D"]) {
                
                cachePath = [rs stringForColumn:@"SCORECARDDAILY_XML_PATH"];
            }
            
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
            NSString* picpath = [NSString stringWithFormat:@"%@/%@/%@/%@",[Utilities SysDocumentPath],CurrentDate,[CacheManagement instance].currentStore.StoreCode,[NSString stringWithFormat:@"SCORECARD_%@",self.type]];
            NSString* update_sql = [NSString stringWithFormat:@"UPDATE NVM_FILE_LIST SET SCORECARD_PIC_PATH = '%@',SCORECARD_XML_PATH='%@' WHERE STORE_CODE = '%@' AND CREATE_DATE = '%@' AND USER_ID = '%@'",picpath,cachePath,[CacheManagement instance].currentStore.StoreCode,CurrentDate,[CacheManagement instance].currentUser.UserId];
            
            if ([self.type isEqualToString:@"D"]) {
                
                update_sql = [NSString stringWithFormat:@"UPDATE NVM_FILE_LIST SET SCORECARDDAILY_PIC_PATH = '%@',SCORECARDDAILY_XML_PATH='%@' WHERE STORE_CODE = '%@' AND CREATE_DATE = '%@' AND USER_ID = '%@'",picpath,cachePath,[CacheManagement instance].currentStore.StoreCode,CurrentDate,[CacheManagement instance].currentUser.UserId];
            }
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
            NSString* picpath = [NSString stringWithFormat:@"%@/%@/%@/%@",[Utilities SysDocumentPath],CurrentDate,[CacheManagement instance].currentStore.StoreCode,[NSString stringWithFormat:@"SCORECARD_%@",self.type]];
            NSString *insert_sql = [NSString stringWithFormat:@"INSERT INTO NVM_FILE_LIST (STORE_CODE,CREATE_DATE,SCORECARD_PIC_PATH,STORE_NAME,USER_ID,SCORECARD_XML_PATH) values (?,?,?,?,?,?)"];
            
            if ([self.type isEqualToString:@"D"]) {
                
                insert_sql = [NSString stringWithFormat:@"INSERT INTO NVM_FILE_LIST (STORE_CODE,CREATE_DATE,SCORECARDDAILY_PIC_PATH,STORE_NAME,USER_ID,SCORECARDDAILY_XML_PATH) values (?,?,?,?,?,?)"] ;
            }
            
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
        NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET SCORECARD = '%@' where WORKMAINID = '%@'",@"2",[CacheManagement instance].currentWorkMainID];
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

- (void)showAfter {
    
    ScoreCardAfterViewController *vc = [[ScoreCardAfterViewController alloc] initWithNibName:@"ScoreCardAfterViewController" bundle:nil];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item ;
    [self.navigationController pushViewController:vc animated:YES] ;
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

- (NSArray *)getAllScoreItem:(NSString *)itemid {
    
    NSMutableArray* resultarr = [[NSMutableArray alloc]init];
    NSString* sql = [NSString stringWithFormat:@"select * from NVM_VM_SCORECARD_ITEM_DETAIL where SCORECARD_ITEM_ID ='%@' ",itemid];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        VmScoreCardDetailEntity *entity = [[VmScoreCardDetailEntity alloc] initWithFMResultSet:rs];
        [resultarr addObject:entity];
    }
    [rs close];
    
    return resultarr;
}


- (NSArray *)getAllCheckPhotoId {
    
    NSString* sql  = [NSString stringWithFormat:@"select * from NVM_IST_SCORECARD_CHECK_PHOTO where SCORECARD_CHK_ID = '%@' and SCORE_CARD_TYPE = 'D' ORDER BY SCORECARD_CHECK_PHOTO_ID",[CacheManagement instance].currentVMCHKID];
    
    NSMutableArray *cateArray = [NSMutableArray array];
    
    FMResultSet* rs_ = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
    
    while ([rs_ next])
    {
        VMIstScoreCardEntity* checkScoreEntity = [[VMIstScoreCardEntity alloc]initWithFMResultSet:rs_];
        
        [cateArray addObject:checkScoreEntity];
    }
    
    [rs_ close];
    
    return cateArray ;
}

- (BOOL)getAllPhoto {
    
    NSString *where = @"" ;
    
    for (VMIstScoreCardEntity* checkScoreEntity in self.checkPhotoIdArray) {
        
        if ([where isEqualToString:@""]) {
            
            where = [NSString stringWithFormat:@"'%@'",checkScoreEntity.SCORECARD_CHECK_PHOTO_ID];
        }
        else {
            
            where = [NSString stringWithFormat:@"%@,'%@'",where,checkScoreEntity.SCORECARD_CHECK_PHOTO_ID];
        }
    }
    
    NSString *sql = [NSString stringWithFormat:@"Select * FROM NVM_IST_SCORECARD_PHOTO_ZONE where SCORECARD_CHECK_PHOTO_ID in (%@) and SCORE_CARD_TYPE = 'D'",where];
    
    FMResultSet *rs = nil;
    @try
    {
        rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
        while ([rs next])
        {
//            NSDictionary *result = @{@"PHOTO_PATH1":[rs stringForColumn:@"PHOTO_PATH1"]?[rs stringForColumn:@"PHOTO_PATH1"]:@"",
//                                     @"PHOTO_PATH2":[rs stringForColumn:@"PHOTO_PATH2"]?[rs stringForColumn:@"PHOTO_PATH2"]:@"",
//                                     @"PHOTO_WEB_PATH1":[rs stringForColumn:@"PHOTO_WEB_PATH1"]?[rs stringForColumn:@"PHOTO_WEB_PATH1"]:@"",
//                                     @"PHOTO_WEB_PATH2":[rs stringForColumn:@"PHOTO_WEB_PATH2"]?[rs stringForColumn:@"PHOTO_WEB_PATH2"]:@"",
//                                     @"PHOTO_UPLOAD_PATH1":[rs stringForColumn:@"PHOTO_UPLOAD_PATH1"]?[rs stringForColumn:@"PHOTO_UPLOAD_PATH1"]:@"",
//                                     @"PHOTO_UPLOAD_PATH2":[rs stringForColumn:@"PHOTO_UPLOAD_PATH2"]?[rs stringForColumn:@"PHOTO_UPLOAD_PATH2"]:@"",
//                                     @"PHOTO_ZONE_NAME_CN":[rs stringForColumn:@"PHOTO_ZONE_NAME_CN"]?[rs stringForColumn:@"PHOTO_ZONE_NAME_CN"]:@"",
//                                     @"SCORECARD_CHECK_PHOTO_ID":[rs stringForColumn:@"SCORECARD_CHECK_PHOTO_ID"]?[rs stringForColumn:@"SCORECARD_CHECK_PHOTO_ID"]:@""} ;
            
            if ([rs stringForColumn:@"PHOTO_PATH1"]&&![[rs stringForColumn:@"PHOTO_PATH1"] isEqualToString:@""]&&[[rs stringForColumn:@"PHOTO_PATH1"] length] > 5 && (![rs stringForColumn:@"PHOTO_PATH2"]||[[rs stringForColumn:@"PHOTO_PATH2"] isEqualToString:@""]||[[rs stringForColumn:@"PHOTO_PATH2"] length] <= 5)) {
                
                if (rs)[rs close];
                return NO ;
            }
        }
    }
    @catch (NSException *e)
    {
        @throw e;
    }
    @finally
    {
        if (rs)[rs close];
    }
    
    return YES ;
}


@end
