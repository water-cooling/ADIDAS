//
//  ModuleListViewController.m
//  MobileApp
//
//  Created by 桂康 on 2017/11/3.
//

#import "ModuleListViewController.h"
#import "HUD.h"
#import "HttpAPIClient.h"
#import "CacheManagement.h"
#import "JSON.h"
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
#import "StoreEntity.h"
#import "VmScoreCardScoreEntity.h"
#import "VmScoreCardDetailEntity.h"
#import "ScoreCardAfterViewController.h"
#import "CommonUtil.h"

@interface ModuleListViewController ()
{
    UILabel* locationlabel ;
}
@end

@implementation ModuleListViewController


- (void) getSelectedDate {
    
    [HUD showUIBlockingIndicator];

    NSDictionary *dic = @{@"workMainId":self.workmainid,@"Action":@"COMMENT",@"account":[CacheManagement instance].currentDBUser.userName,@"checkType":[self.type isEqualToString:@"M"]?@"1":@"0",@"ActionType":@"en"};
    
    HttpAPIClient *sharedClient = [[HttpAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kWebMobileHeadString]];
    
    sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    sharedClient.requestSerializer.timeoutInterval = 20;
    
    sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
    
    sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [sharedClient.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    
    [sharedClient GET:@"/DataSyncService.aspx?osType=iPhone" parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [HUD hideUIBlockingIndicator];
        
        NSString *response = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if(![response JSONValue]){
            response = [AES128Util AES128Decrypt:response key:[CommonUtil getDecryKey:[CacheManagement instance].currentDBUser.userName]];
        }
        NSDictionary *dataDic = [response JSONValue];
        
        if (dataDic&&[dataDic count] > 0) {
            
            NSDictionary *head = [[dataDic valueForKey:@"Header"] firstObject];
            
            locationlabel.text = [NSString stringWithFormat:@"%@",self.storename];

            self.commentDate = [head valueForKey:@"WORK_DATE"];
            self.commentInsertTimeForWorkMain = [[head valueForKey:@"CLIENT_UPLOAD_TIME"] stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
            
            self.commentDataArray = [NSArray arrayWithArray:[dataDic valueForKey:[self.type isEqualToString:@"M"]?@"MonthlyDetail":@"Detail"]];
            self.remarkDataArray = [NSArray arrayWithArray:[dataDic valueForKey:[self.type isEqualToString:@"M"]?@"MonthlyRemark":@"Remark"]];
            self.scoreArray = [dataDic valueForKey:@"Score"]?[NSArray arrayWithArray:[dataDic valueForKey:@"Score"]]:[NSArray array];
            self.MonthlyScore = [NSArray arrayWithArray:[dataDic valueForKey:@"MonthlyScore"]];
            
            StoreEntity  *ent = [[StoreEntity alloc] init] ;
            ent.StoreCode = [head objectForKey:@"STORE_CODE"];
            ent.StoreName = [NSString stringWithFormat:@"%@",self.storename];
            ent.StoreStatus = @"1" ;
            ent.StorePhone = @"" ;
            [CacheManagement instance].currentStore = ent;
            
            if ([self.type isEqualToString:@"D"]) {
                
                [self UpdateWorkMain:[CacheManagement instance].currentStore workmain:[head objectForKey:@"WORK_MAIN_ID"]];
                [CacheManagement instance].checkinTime = [Utilities DateTimeNow];
                
                [self UpdateNVM_IST_CHECK_ID:[head valueForKey:@"SCORECARD_CHK_ID"]];
            }
            
            if ([self.type isEqualToString:@"M"]) {
                
                [CacheManagement instance].currentWorkMainID = @"" ;
            }
            
            
            if ([self.scoreArray count]) {
                
                for (VmScoreCardEntity* checkEntity in self.tableviewSourceArr) {
                    
                    NSString* sql = [NSString stringWithFormat:@"select * from NVM_IST_SCORECARD_CHECK_PHOTO where SCORECARD_CHK_ID ='%@' and SCORECARD_ITEM_ID='%@' and SCORE_CARD_TYPE='%@'",[CacheManagement instance].currentVMCHKID,checkEntity.SCORECARD_ITEM_ID,self.type];
                    
                    NSString *SCORECARD_CHECK_PHOTO_ID = @"" ;
                    
                    FMResultSet *rs = nil;
                    rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
                    while ([rs next])
                    {
                        SCORECARD_CHECK_PHOTO_ID = [rs stringForColumnIndex:0] ;
                    }
                    FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
                    
                    if (!SCORECARD_CHECK_PHOTO_ID||[SCORECARD_CHECK_PHOTO_ID isEqual:[NSNull null]]||[SCORECARD_CHECK_PHOTO_ID isEqualToString:@""]) {
                        
                        NSString *sql = [NSString stringWithFormat:@"delete from NVM_IST_SCORECARD_CHECK_PHOTO where SCORECARD_ITEM_ID='%@' and SCORECARD_CHK_ID = '%@' and SCORE_CARD_TYPE = '%@'",checkEntity.SCORECARD_ITEM_ID,[CacheManagement instance].currentVMCHKID,self.type];
                        [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql];
                        
                        SCORECARD_CHECK_PHOTO_ID = [Utilities GetUUID] ;
                        
                        sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_SCORECARD_CHECK_PHOTO (SCORECARD_CHECK_PHOTO_ID,SCORECARD_CHK_ID,SCORECARD_ITEM_ID,COMMENT,PHOTO_PATH1,PHOTO_PATH2,LAST_MODIFIED_BY,LAST_MODIFIED_TIME,SCORE_CARD_TYPE) values (?,?,?,?,?,?,?,?,?)"];
                        
                        [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql,
                         SCORECARD_CHECK_PHOTO_ID,
                         [CacheManagement instance].currentVMCHKID,
                         checkEntity.SCORECARD_ITEM_ID,
                         @"",
                         @"",
                         @"",
                         [CacheManagement instance].currentDBUser.userName,
                         [Utilities DateTimeNow],
                         self.type];
                    }
                    
                    NSArray *allItem = [self getAllScoreItem:checkEntity.SCORECARD_ITEM_ID];
                    
                    for (VmScoreCardDetailEntity *itemdetail in allItem) {
                        
                        VmScoreCardScoreEntity *entity = nil ;
                        
                        NSString *sql = [NSString stringWithFormat:@"Select * FROM NVM_IST_SCORECARD_ITEM_DETAIL where SCORECARD_CHECK_PHOTO_ID = '%@' and SCORECARD_ITEM_DETAIL_ID = '%@' and SCORECARD_ITEM_ID = '%@' ",SCORECARD_CHECK_PHOTO_ID,itemdetail.SCORECARD_ITEM_DETAIL_ID,itemdetail.SCORECARD_ITEM_ID];
                        
                        FMResultSet *rs = nil;
                        @try
                        {
                            rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
                            while ([rs next])
                            {
                                entity = [[VmScoreCardScoreEntity alloc] initWithFMResultSet:rs];
                                break ;
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
                        
                        if (!entity) {
                            
                            NSString *score = @"" ;
                            NSString *comment = @"" ;
                            for (NSDictionary *dic in self.scoreArray) {
                                
                                if ([[NSString stringWithFormat:@"%@",[dic valueForKey:@"SCORECARD_ITEM_DETAIL_ID"]] isEqualToString:itemdetail.SCORECARD_ITEM_DETAIL_ID]) {
                                    score = [NSString stringWithFormat:@"%@",[dic valueForKey:@"SCORE"]];
                                    comment = [NSString stringWithFormat:@"%@",[dic valueForKey:@"COMMENT"]];
                                }
                            }
                            
                            NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_SCORECARD_ITEM_DETAIL (SCORECARD_CHECK_PHOTO_ID,SCORECARD_ITEM_DETAIL_ID,STANDARD_SCORE,REMARK,SCORECARD_ITEM_ID) values (?,?,?,?,?)"];
                            
                            [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
                             SCORECARD_CHECK_PHOTO_ID,
                             itemdetail.SCORECARD_ITEM_DETAIL_ID,
                             score,
                             comment,
                             itemdetail.SCORECARD_ITEM_ID];
                        }
                    }
                }
            }
            
            if ([self.type isEqualToString:@"D"]) {
                
                self.checkPhotoIdArray = [self getAllCheckPhotoId];
                
                if ([self.checkPhotoIdArray count]) {
                    
                    BOOL isShow = [self getAllPhoto];
                    
                    if (isShow) {
                        
                        if (![self checkIsExistAllPhoto]) {
                            
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
                            btn2.layer.cornerRadius = 3 ;
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
                            
                            UIButton *btn2 =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50 , 30)];
                            
                            [btn2 addTarget:self action:@selector(showUploadAlert) forControlEvents:UIControlEventTouchUpInside];
                            [btn2 setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                            [btn2 setTitle:SYSLanguage?@"Submit":@"上传" forState:UIControlStateNormal];
                            btn2.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
                            btn2.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
                            btn2.layer.borderWidth = 0.6 ;
                            btn2.layer.cornerRadius = 3 ;
                            btn2.layer.borderColor = [[Utilities colorWithHexString:@"#ffffff"] CGColor];
                            if (SYSLanguage == EN)
                            {
                                btn2.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
                            }
                            UIBarButtonItem *rightButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:btn2];
                            self.navigationItem.rightBarButtonItem = rightButtonItem2;
                        }
                        
                        
                        
                    }
                    else {
                        
                        UIButton *btn =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50 , 30)];
                        
                        [btn addTarget:self action:@selector(showAfter) forControlEvents:UIControlEventTouchUpInside];
                        [btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
                        [btn setTitle:@"After" forState:UIControlStateNormal];
                        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
                        btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
                        btn.layer.borderWidth = 0.6 ;
                        btn.layer.cornerRadius = 3 ;
                        btn.layer.borderColor = [[Utilities colorWithHexString:@"#ffffff"] CGColor];
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
                    btn2.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
                    if (SYSLanguage == EN)
                    {
                        btn2.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
                    }
                    UIBarButtonItem *rightButtonItem2 = [[UIBarButtonItem alloc] initWithCustomView:btn2];
                    self.navigationItem.rightBarButtonItem = rightButtonItem2;
                }
            }
            
            [self.scoreTableView reloadData] ;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [HUD hideUIBlockingIndicator];
    }];
}


// 检查此次检查表是否存在
-(NSArray*)checkNVM_IST_CHECK_ID
{
    __autoreleasing NSMutableArray* resultarr = [[NSMutableArray alloc]init];
    NSString* storecode = [CacheManagement instance].currentStore.StoreCode;
    NSString* workmainID = [CacheManagement instance].currentWorkMainID;
    NSString* sql = [NSString stringWithFormat:@"select * from NVM_IST_SCORECARD_CHECK where WORK_MAIN_ID ='%@' and STORE_CODE= '%@' and SCORE_CARD_TYPE='%@' ",workmainID,storecode,self.type];
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
-(void)UpdateNVM_IST_CHECK_ID:(NSString *)checkId
{
    NSArray* arr = [self checkNVM_IST_CHECK_ID];
    if ( arr.count > 0)
    {   // 存在列表
        [CacheManagement instance].currentVMCHKID = [arr objectAtIndex:0];
    }
    else
    {
        [CacheManagement instance].currentVMCHKID = checkId;
        NSString* storeCode = [CacheManagement instance].currentStore.StoreCode;
        NSString* workdate = [Utilities DateNow];
        NSString* workstarttime = [Utilities DateTimeNow];
        NSString* workendtime = [Utilities DateTimeNow];
        NSString* userid = [CacheManagement instance].currentUser.UserId;
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_SCORECARD_CHECK (SCORECARD_CHK_ID,STORE_CODE,USER_ID,WORK_MAIN_ID,WORK_DATE,WORK_START_TIME,WORK_END_TIME,USER_SUBMIT_TIME,CLIENT_UPLOAD_TIME,SERVER_INSERT_TIME,SCORE_CARD_TYPE) values (?,?,?,?,?,?,?,?,?,?,?)"];
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         checkId,
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
    
    FMResultSet* rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM NVM_VM_SCORECARD_ITEM  where IS_KIDS = '%d'  order by ITEM_NO",ISKIDS]];
    
    while([rs next])
    {
        VmScoreCardEntity* checkEntity = [[VmScoreCardEntity alloc] initWithFMResultSet:rs];
        [[APPDelegate VM_CHECK_ItemList] addObject:checkEntity];
    }
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

// 查找得分

-(NSString*)GetScorebyCHK_ID:(NSString*)currentCHK_ID andItemID:(NSString*)Item_ID
{
    NSArray *allItem = [self getAllScoreItem:Item_ID];
    
    NSString* sql = [NSString stringWithFormat:@"select * from NVM_IST_SCORECARD_CHECK_PHOTO where SCORECARD_CHK_ID ='%@' and SCORECARD_ITEM_ID='%@' and SCORE_CARD_TYPE='%@'",currentCHK_ID,Item_ID,self.type];
    
    NSString *SCORECARD_CHECK_PHOTO_ID = @"" ;
    
    FMResultSet *rs = nil;
    rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        SCORECARD_CHECK_PHOTO_ID = [rs stringForColumnIndex:0] ;
    }
    
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
            
            if ((!entity.STANDARD_SCORE||[entity.STANDARD_SCORE isEqual:[NSNull null]]||[entity.STANDARD_SCORE isEqualToString:@""])) {
                
                [rs close];
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
    
    if (count == [allItem count]) {
        
        return @"finished" ;
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



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.selectedDate  ;
    self.view.backgroundColor = [Utilities colorWithHexString:@"#f2f2f2"];
    [self getSelectedDate];
    
//    if ([self.type isEqualToString:@"D"]) {
//        
//        if (SYSLanguage == CN)
//        {
//            [Utilities createRightBarButton:self clichEvent:@selector(showUploadAlert) btnSize:CGSizeMake(50, 30) btnTitle:@"上传"];
//        }
//        else if (SYSLanguage == EN)
//        {
//            [Utilities createRightBarButton:self clichEvent:@selector(showUploadAlert) btnSize:CGSizeMake(50, 30) btnTitle:@"Submit"];
//        }
//    }
    
    self.resultArr = [[NSMutableArray alloc]init];
    self.resultPicArr = [[NSMutableArray alloc]init];
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    }
    
    self.uploadManage = [[UploadManagement alloc] init];
    self.uploadManage.delegate = self;
    
    [self GetCheckIssueFromDB];
    
    UIImageView* locationview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, DEWIDTH, 40)];
    locationview.image = [UIImage imageNamed:@"loactionbg.png"];
    locationlabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, DEWIDTH-30, 40)];
    locationlabel.numberOfLines = 2 ;
    locationlabel.backgroundColor =[UIColor clearColor];
    locationlabel.font = [UIFont systemFontOfSize:14];
    locationlabel.tag = 111;
    locationlabel.text = @"加载中";
    [locationview addSubview:locationlabel];
    [self.view addSubview:locationview];
    
    self.tableviewSourceArr = [APPDelegate VM_CHECK_ItemList];
    self.scoreTableView.contentInset = UIEdgeInsetsMake(45, 0, 30, 0) ;
    self.scoreTableView.dataSource = self ;
    self.scoreTableView.delegate = self ;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.scoreTableView reloadData];
    
    if ([self.type isEqualToString:@"D"]) {
        
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
                btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
                btn.layer.borderWidth = 0.6 ;
                btn.layer.cornerRadius = 3 ;
                btn.layer.borderColor = [[Utilities colorWithHexString:@"#ffffff"] CGColor];
                if (SYSLanguage == EN)
                {
                    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
                }
                UIBarButtonItem *rightButtonItem1 = [[UIBarButtonItem alloc] initWithCustomView:btn];
                
                self.navigationItem.rightBarButtonItem = rightButtonItem1;
            }
        }
        
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
    cell.backgroundColor = [UIColor clearColor];
    
    if (ISKIDS) {
        
        cell.arrow_imageview.image = [UIImage imageNamed:@"cellbg_arrow_kids.png"];
    }
    else {
        
        cell.arrow_imageview.image = [UIImage imageNamed:@"cellbg_arrow.png"];
    }
    
    VmScoreCardEntity* checkEntity = [self.tableviewSourceArr objectAtIndex:indexPath.row] ;
    
    cell.score_label.font = [UIFont systemFontOfSize:12];
    cell.score_label.hidden = YES ;
    cell.done_image.hidden = YES;
    cell.monthScoreLabel.hidden = YES ;
    
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
    
    for (NSDictionary *commDic in self.remarkDataArray) {
        
        if ([[commDic valueForKey:@"SCORECARD_ITEM_ID"] isEqualToString:[NSString stringWithFormat:@"%@",checkEntity.SCORECARD_ITEM_ID]]&&
            [commDic valueForKey:@"TRACK_COMMENT"]&&
            ![[commDic valueForKey:@"TRACK_COMMENT"] isEqual:[NSNull null]]&&
            ![[commDic valueForKey:@"TRACK_COMMENT"] isEqualToString:@""]) {
            
            cell.arrow_imageview.image = [UIImage imageNamed:@"cellbg_arrow_red.png"];
            break ;
        }
    }
    
    if ([self.type isEqualToString:@"D"]) {
        
        NSString *scorenumber = [self GetScorebyCHK_ID:[CacheManagement instance].currentVMCHKID andItemID:cell.item_ID];
        
        if ([scorenumber isEqualToString:@""])
        {
            cell.done_image.hidden = YES;
        }
        else {
            cell.done_image.hidden = NO;
        }
        
        //    if (cell.done_image.hidden) {
        //
        //        for (NSDictionary *itemD in self.scoreArray) {
        //
        //            if ([cell.item_ID isEqualToString:[NSString stringWithFormat:@"%@",[itemD valueForKey:@"SCORECARD_ITEM_ID"]]]) {
        //                cell.done_image.hidden = NO ;
        //                break ;
        //            }
        //        }
        //    }
        
        cell.score_label.textColor = [UIColor darkGrayColor];
        cell.history_score_label.hidden = YES;
        cell.done_image.frame = CGRectMake(DEVICE_WID - 10 - 25, 25, 10, 11) ;
    }
    
    if ([self.type isEqualToString:@"M"]) {
        
        cell.monthScoreLabel.hidden = NO ;
        
        for (NSDictionary *commDic in self.MonthlyScore) {
            
            if ([[commDic valueForKey:@"SCORECARD_ITEM_ID"] isEqualToString:[NSString stringWithFormat:@"%@",checkEntity.SCORECARD_ITEM_ID]]) {
                
                cell.monthScoreLabel.text = [NSString stringWithFormat:@"%@分",[commDic valueForKey:@"SCORE"]];
                break ;
            }
        }
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableviewSourceArr count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 65 ;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    msvc.commentData = self.commentDataArray ;
    msvc.commentDate = self.commentDate ;
    msvc.remarkData = self.remarkDataArray ;
    msvc.scoreData = self.scoreArray ;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController pushViewController:msvc animated:YES];
}

-(void)upload
{
    
    for (VmScoreCardEntity* checkEntity in self.tableviewSourceArr) {
        
        NSString *scorenumber = [self GetScorebyCHK_ID:[CacheManagement instance].currentVMCHKID andItemID:[NSString stringWithFormat:@"%@",checkEntity.SCORECARD_ITEM_ID]];
        
        if ([scorenumber isEqualToString:@""]) {
            
            ALERTVIEW(SYSLanguage?@"Please finish all items then upload": @"还有未完成项，请继续填写");
            return ;
        }
    }
    
    NSString* sql = [NSString stringWithFormat:@"select * from NVM_IST_SCORECARD_CHECK_PHOTO where SCORECARD_CHK_ID = '%@' and SCORE_CARD_TYPE='%@' ORDER BY SCORECARD_CHECK_PHOTO_ID",[CacheManagement instance].currentVMCHKID,self.type];
    
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
        
        NSString* sql  = [NSString stringWithFormat:@"select * from NVM_IST_SCORECARD_PHOTO_ZONE %@ and SCORE_CARD_TYPE='%@'",where,self.type];
        
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
            
            if (checkScoreEntity.PHOTO_PATH1 != nil && ![checkScoreEntity.PHOTO_PATH1 isEqualToString:@""] && [checkScoreEntity.PHOTO_UPLOAD_PATH1 isEqualToString:@"0"])
            {
                [self.resultPicArr addObject:checkScoreEntity.PHOTO_PATH1];
            }
            
            
            if (checkScoreEntity.PHOTO_PATH2 != nil && ![checkScoreEntity.PHOTO_PATH2 isEqualToString:@""] && [checkScoreEntity.PHOTO_UPLOAD_PATH2 isEqualToString:@"0"])
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
                                                     checkType:@"Daily"
                                                    scoreArray:scoreArray
                                                  commentArray:cateArray
                                                    isAddWeb:YES
                                   ClientUploadTimeForWorkMain:self.commentInsertTimeForWorkMain];
    if ([CacheManagement instance].uploaddata == YES)
    {
        [self.uploadManage uploadVMRailCheckFileToServer:xmlString
                                                fileType:kVMXmlUploadScoreCard
                                          andfilePathArr:self.resultPicArr
                                              andxmlPath:[NSString stringWithFormat:@"%@/%@/%@",[Utilities SysDocumentPath],self.commentDate,[CacheManagement instance].currentStore.StoreCode]];
    }
    else if([CacheManagement instance].uploaddata == NO)
    {
        // 更新本地事项状态
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        NSString* sql_ = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET SCORECARD = '%@' where WORKMAINID = '%@'",@"1",[CacheManagement instance].currentWorkMainID];
        [db executeUpdate:sql_];
        
        NSString *CurrentDate = self.commentDate ;
        
        // 非几时上传 保存文件到本地
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM NVM_FILE_LIST WHERE STORE_CODE = '%@' AND CREATE_DATE = '%@' AND USER_ID = '%@'",[CacheManagement instance].currentStore.StoreCode,CurrentDate,[CacheManagement instance].currentUser.UserId];
        FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
        if ([rs next] == YES)
        {
            NSString* cachePath = [rs stringForColumn:@"SCORECARDDAILY_XML_PATH"];
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
            NSString* picpath = [NSString stringWithFormat:@"%@/%@/%@/%@",[Utilities SysDocumentPath],CurrentDate,[CacheManagement instance].currentStore.StoreCode,@"SCORECARD_D"];
            NSString* update_sql = [NSString stringWithFormat:@"UPDATE NVM_FILE_LIST SET SCORECARDDAILY_PIC_PATH = '%@',SCORECARDDAILY_XML_PATH='%@' WHERE STORE_CODE = '%@' AND CREATE_DATE = '%@' AND USER_ID = '%@'",picpath,cachePath,[CacheManagement instance].currentStore.StoreCode,CurrentDate,[CacheManagement instance].currentUser.UserId];
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
            NSString* picpath = [NSString stringWithFormat:@"%@/%@/%@/%@",[Utilities SysDocumentPath],CurrentDate,[CacheManagement instance].currentStore.StoreCode,@"SCORECARD_D"];
            NSString *insert_sql = [NSString stringWithFormat:@"INSERT INTO NVM_FILE_LIST (STORE_CODE,CREATE_DATE,SCORECARDDAILY_PIC_PATH,STORE_NAME,USER_ID,SCORECARDDAILY_XML_PATH) values (?,?,?,?,?,?)"];
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

-(void)showUploadAlert
{
    NSString* title = @"是否确定上传";
    if (SYSLanguage == EN) {
        title = @"Are you sure to upload ?";
    }
    
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:title message:nil delegate:self cancelButtonTitle:SYSLanguage?@"Cancel": @"取消" otherButtonTitles:SYSLanguage?@"Sure": @"确定", nil];
    [av show];
}


- (void)showAfter {
    
    ScoreCardAfterViewController *vc = [[ScoreCardAfterViewController alloc] initWithNibName:@"ScoreCardAfterViewController" bundle:nil];
    vc.commentDate = self.commentDate ;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item ;
    [self.navigationController pushViewController:vc animated:YES] ;
}

#pragma mark - db operation

-(NSArray*)checkWorkMainIsExit:(NSString *)workmain
{
    NSMutableArray* resultarr = [[NSMutableArray alloc]init];
    NSString* sql = [NSString stringWithFormat:@"select WORK_MAIN_ID from IST_WORK_MAIN where WORK_MAIN_ID ='%@' ",workmain];
    
    FMResultSet *rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        [resultarr addObject:[rs stringForColumnIndex:0]];
    }
    [rs close];
    
    return resultarr;
}



-(void)UpdateWorkMain:(StoreEntity*)entity workmain:(NSString *)workmain{

    @try
    {
        NSArray* arr = [self checkWorkMainIsExit:workmain];
        
        if ( [arr count] > 0 )
        {
            [CacheManagement instance].currentWorkMainID = [arr objectAtIndex:0];
        }
        else
        {
            [self insertWorkMain:entity andWorkMain:workmain];
        }
    }
    @catch (NSException *exception)
    {
    }
    @finally
    {
    }
}


-(void)insertWorkMain:(StoreEntity*)entity andWorkMain:(NSString *)workmainid
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO IST_WORK_MAIN (WORK_MAIN_ID,STORE_CODE,STORE_NAME,OPERATE_USER,STORE_ADDRESS,CHECK_IN_TIME,CHECK_OUT_TIME,CHECKIN_LOCATION_X,CHECKIN_LOCATION_Y,CHECKOUT_LOCATION_X,CHECKOUT_LOCATION_Y,TIME_LENGTH,STATUS,REMARK,SER_INSERT_TIME,SELECT_STORE_MOTHED) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
    
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
     self.commentInsertTimeForWorkMain,
     @"1"
     ];
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
            
            if ([rs stringForColumn:@"PHOTO_PATH1"]&&![[rs stringForColumn:@"PHOTO_PATH1"] isEqualToString:@""]&&[[rs stringForColumn:@"PHOTO_PATH1"] length] > 5 &&(![rs stringForColumn:@"PHOTO_PATH2"]||[[rs stringForColumn:@"PHOTO_PATH2"] isEqualToString:@""]||[[rs stringForColumn:@"PHOTO_PATH2"] length] <= 5)&&(![rs stringForColumn:@"PHOTO_UPLOAD_PATH2"]||![[NSString stringWithFormat:@"%@",[rs stringForColumn:@"PHOTO_UPLOAD_PATH2"]] isEqualToString:@"1"])) {
                
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


- (BOOL)checkIsExistAllPhoto {
    
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
    BOOL isExist = YES ;
    FMResultSet *rs = nil;
    @try
    {
        rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
        while ([rs next])
        {
            isExist = NO ;
            
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

    return isExist ;
}

@end



