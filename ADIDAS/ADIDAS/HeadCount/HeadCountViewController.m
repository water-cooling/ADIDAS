//
//  HeadCountViewController.m
//  MobileApp
//
//  Created by 桂康 on 2018/7/13.
//

#import "HeadCountViewController.h"
#import "CommonDefine.h"
#import "SqliteHelper.h"
#import "FrHeadCountChkItemEntity.h"
#import "XMLFileManagement.h"
#import "HeadCountCustomCell.h"
#import "FrHeadCountItemEntity.h"
#import "EditViewController.h"

@interface HeadCountViewController ()<InputDelegate,EditDelegate>

@end

@implementation HeadCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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

    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.waitView ];
    ((UILabel*)[self.waitView viewWithTag:88]).text = SYSLanguage?@"Processing,please wait …":@"请稍等,正在执行...";
    [self.waitView setHidden:YES];
    
    [Utilities createRightBarButton:self clichEvent:@selector(showUploadAlert) btnSize:CGSizeMake(50, 30) btnTitle:SYSLanguage?@"Upload":@"上传"];
    [Utilities createLeftBarButton:self clichEvent:@selector(back)];
    selectPosition = -1 ;
    selectLine = -1 ;
    [self UpdateNVM_IST_ISSUE_CHECK];
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    }
    self.title =SYSLanguage?@"Headcount Check": @"人数检查";
    
    self.dataSourceArray = [NSMutableArray array];
    [self GetCheckIssueFromDB];
    self.uploadManage = [[UploadManagement alloc] init];
    self.uploadManage.delegate = self;
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
    
    self.Issue_list_TableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, DEWIDTH,DEHEIGHT-64-40) style:UITableViewStylePlain];

    self.Issue_list_TableView.delegate = self;
    self.Issue_list_TableView.dataSource = self;
    [self.Issue_list_TableView setSectionHeaderHeight:0];
    self.Issue_list_TableView.tableFooterView = [[UIView alloc] init];
    [self.Issue_list_TableView setBackgroundColor:[UIColor whiteColor]];
    [self.Issue_list_TableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.view addSubview:self.Issue_list_TableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray*)checkNVM_IST_ISSUE_CHECK
{
    NSMutableArray* resultarr = [NSMutableArray array];
    NSString* storecode = [CacheManagement instance].currentStore.StoreCode;
    NSString* workmainID = [CacheManagement instance].currentWorkMainID;
    NSString* sql = [NSString stringWithFormat:@"select * from IST_FR_HEADCOUNT_CHK where WORK_MAIN_ID ='%@' and STORE_CODE= '%@'  ",workmainID,storecode];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        [resultarr addObject:[rs stringForColumnIndex:0]];
    }
    [rs close];
    
    return resultarr;
}


// 本地数据库读取见检查项
-(void)GetCheckIssueFromDB
{
    @try {
        
        FMDatabase* db = [[SqliteHelper shareCommonSqliteHelper]database];
        [self.dataSourceArray removeAllObjects];
        FMResultSet* rs = [db executeQuery:@"SELECT * FROM FR_HEADCOUNT_ITEM order by ITEM_NO"];
        while([rs next])
        {
            FrHeadCountItemEntity* checkEntity = [[FrHeadCountItemEntity alloc]initWithFMResultSet:rs];
            checkEntity.RESULT = @"" ;
            [self.dataSourceArray addObject:checkEntity];
        }
        
        NSString* sql = [NSString stringWithFormat:@"select * from IST_FR_HEADCOUNT_CHK_ITEM where FR_HEADCOUNT_CHK_ID = '%@' and RESULT <> '' ",[CacheManagement instance].currentVMCHKID];
        FMResultSet* rs_ = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
        NSMutableArray *dataArray = [NSMutableArray array];
        while ([rs_ next])
        {
            FrHeadCountChkItemEntity* Entity = [[FrHeadCountChkItemEntity alloc]initWithFMResultSet:rs_];
            [dataArray addObject:Entity];
        }
        
        for (FrHeadCountItemEntity *entity in self.dataSourceArray) {
            
            for (FrHeadCountChkItemEntity *check in dataArray) {
                
                if ([check.FR_HEADCOUNT_ITEM_ID isEqualToString:entity.FR_HEADCOUNT_ITEM_ID]) {
                    entity.RESULT = check.RESULT;
                    break ;
                }
            }
        }
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"ITEM_NO" ascending:YES];
        [self.dataSourceArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
        
        NSArray *testArr = [self.dataSourceArray  sortedArrayWithOptions:NSSortStable usingComparator:
                            ^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                                FrHeadCountItemEntity* checkEntity1 = obj1;
                                FrHeadCountItemEntity* checkEntity2 = obj2;
                                int value1 = [checkEntity1.ITEM_NO intValue];
                                int value2 = [checkEntity2.ITEM_NO intValue];
                                if (value1 > value2) {
                                    return NSOrderedDescending;
                                }else if (value1 == value2){
                                    return NSOrderedSame;
                                }else{
                                    return NSOrderedAscending;
                                }
                            }];
        
        self.dataSourceArray = [NSMutableArray array];
        for (int i = 0 ; i < [testArr count] ; i++) {
            FrHeadCountItemEntity *entity = [testArr objectAtIndex:i];
            [self.dataSourceArray addObject:entity];
            if ([entity.ITEM_TYPE isEqualToString:@"0"]&&[testArr count] > i+1) {
                FrHeadCountItemEntity *entitynext = [testArr objectAtIndex:i+1];
                if ([entitynext.ITEM_TYPE isEqualToString:@"1"]) {
                    if (i%3==0) {
                        [self.dataSourceArray addObject:@""];
                        [self.dataSourceArray addObject:@""];
                    }
                    if (i%3==1) {
                        [self.dataSourceArray addObject:@""];
                    }
                }
            } else if ([entity.ITEM_TYPE isEqualToString:@"1"]){
                [self.dataSourceArray addObject:@""];
                [self.dataSourceArray addObject:@""];
            }
        }
        testArr = nil;
    } @catch (NSException *exception) {
    }
}

-(void)UpdateNVM_IST_ISSUE_CHECK
{
    NSArray* arr = [self checkNVM_IST_ISSUE_CHECK];
    
    if ( arr.count > 0)
    {
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
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO IST_FR_HEADCOUNT_CHK (FR_HEADCOUNT_CHK_ID,STORE_CODE,USER_ID,WORK_MAIN_ID,WORK_DATE,WORK_START_TIME,WORK_END_TIME,USER_SUBMIT_TIME,CLIENT_UPLOAD_TIME,SERVER_INSERT_TIME) values (?,?,?,?,?,?,?,?,?,?)"];
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

-(void)showUploadAlert
{
    
    NSString* title = @"是否确定上传";
    if (SYSLanguage == EN) {
        title = @"Are you sure to upload ?";
    }
    
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:title message:nil delegate:self cancelButtonTitle:SYSLanguage?@"Cancel":@"取消" otherButtonTitles:SYSLanguage?@"OK":@"确定", nil];
    [av show];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)upload
{
    NSString* sql = [NSString stringWithFormat:@"select * from IST_FR_HEADCOUNT_CHK_ITEM where FR_HEADCOUNT_CHK_ID = '%@' and RESULT <> '' ",[CacheManagement instance].currentVMCHKID];
    FMResultSet* rs_ = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
    NSMutableArray *dataArray = [NSMutableArray array];
    BOOL isExistNotInput = NO ;
    while ([rs_ next])
    {
        FrHeadCountChkItemEntity* Entity = [[FrHeadCountChkItemEntity alloc]initWithFMResultSet:rs_];
        [dataArray addObject:Entity];
    }
    
    [rs_ close];
    
    if ([dataArray count] == 0 )
    {
        ALERTVIEW(SYSLanguage?@"Please fill in at least one field!":@"请至少填写一项!");
        return;
    }
    
    for (int i = 0 ; i<[self.dataSourceArray count]; i++) {
        if ([[self.dataSourceArray objectAtIndex:i] isKindOfClass:[FrHeadCountItemEntity class]]) {
            FrHeadCountItemEntity* entity = [self.dataSourceArray objectAtIndex:i] ;
            if ([entity.RESULT isEqual:[NSNull null]]||[entity.RESULT isEqualToString:@""]) {
                if ([entity.IS_MUST isEqualToString:@"1"]&&[entity.ITEM_TYPE isEqualToString:@"1"]) {
                    isExistNotInput = YES ;
                    break ;
                }
            }
        }
    }
    
    if ( isExistNotInput)
    {
        ALERTVIEW(SYSLanguage?@"Please make sure all the mandatory fields are filled!":@"上传失败,请填写必填项!");
        return;
    }
    
    {NSMutableArray *needSumaryArray = [NSMutableArray array];
    for (int i = 0 ; i<[self.dataSourceArray count]; i++) {
        if ([[self.dataSourceArray objectAtIndex:i] isKindOfClass:[FrHeadCountItemEntity class]]) {
            FrHeadCountItemEntity* entity = [self.dataSourceArray objectAtIndex:i] ;
            if (entity.SUMMARY_ITEM&&![entity.SUMMARY_ITEM isEqualToString:@""]) {
                [needSumaryArray addObject:entity];
            }
        }
    }
    
    for (FrHeadCountItemEntity *entity in needSumaryArray) {
        NSArray *subitem = [entity.SUMMARY_ITEM componentsSeparatedByString:@","];
        int total = 0 ;
        for (NSString *str in subitem) {
            for (int i = 0 ; i<[self.dataSourceArray count]; i++) {
                if ([[self.dataSourceArray objectAtIndex:i] isKindOfClass:[FrHeadCountItemEntity class]]) {
                    FrHeadCountItemEntity* entity_ = [self.dataSourceArray objectAtIndex:i] ;
                    if ([entity_.ITEM_NO isEqualToString:str]) {
                        total += [entity_.RESULT intValue];
                    }
                }
            }
        }
        if (total != [entity.RESULT intValue]) {
            ALERTVIEW((SYSLanguage?[NSString stringWithFormat:@"Sorry,%@ Validation Failure!",entity.ITEM_NAME_EN]:[NSString stringWithFormat:@"上传失败,%@验证失败!",entity.ITEM_NAME_CN]));
            return ;
        }
    }}
    
    {NSMutableArray *needSumaryArray = [NSMutableArray array];
    for (int i = 0 ; i<[self.dataSourceArray count]; i++) {
        if ([[self.dataSourceArray objectAtIndex:i] isKindOfClass:[FrHeadCountItemEntity class]]) {
            FrHeadCountItemEntity* entity = [self.dataSourceArray objectAtIndex:i] ;
            if (entity.VALIDATION&&![entity.VALIDATION isEqualToString:@""]) {
                [needSumaryArray addObject:entity];
            }
        }
    }
    
    for (FrHeadCountItemEntity *entity in needSumaryArray) {
        NSArray *subitem = [entity.VALIDATION componentsSeparatedByString:@","];
        int total = 0 ;
        for (NSString *str in subitem) {
            for (int i = 0 ; i<[self.dataSourceArray count]; i++) {
                if ([[self.dataSourceArray objectAtIndex:i] isKindOfClass:[FrHeadCountItemEntity class]]) {
                    FrHeadCountItemEntity* entity_ = [self.dataSourceArray objectAtIndex:i] ;
                    if ([entity_.ITEM_NO isEqualToString:str]) {
                        total += [entity_.RESULT intValue];
                    }
                }
            }
        }
        if (total != [entity.RESULT intValue]) {
            ALERTVIEW(SYSLanguage?@"Sorry,Please check that # of FTHC = Total On Floor + # of On Leave + # of Vacancy":@"校验失败，请确保 # of FTHC = Total On Floor + # of On Leave + # of Vacancy");
            return ;
        }
    }}
    
    
    // 制作xml 文件
    XMLFileManagement * xmlcon = [[XMLFileManagement alloc] init];
    NSString* xmlString =   [xmlcon CreateHeadCountString:dataArray
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
                                                fileType:kFrXmlHeadCount
                                          andfilePathArr:[NSArray array]
                                              andxmlPath:[NSString stringWithFormat:@"%@/%@/%@",[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode]];
    }
    else if([CacheManagement instance].uploaddata == NO)
    {
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        NSString* sql_ = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET HEADCOUNT = '%@' where WORKMAINID = '%@'",@"1",[CacheManagement instance].currentWorkMainID];
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
            NSString* cachePath = [rs stringForColumn:@"HEADCOUNT_XML_PATH"];
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
            
            NSString* update_sql = [NSString stringWithFormat:@"UPDATE NVM_FILE_LIST SET HEADCOUNT_XML_PATH='%@' WHERE STORE_CODE = '%@' AND CREATE_DATE = '%@' AND USER_ID = '%@'",cachePath,[CacheManagement instance].currentStore.StoreCode,CurrentDate,[CacheManagement instance].currentUser.UserId];
            FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
            [db executeUpdate:update_sql];
        }
        else {
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
            
            NSString *insert_sql = [NSString stringWithFormat:@"INSERT INTO NVM_FILE_LIST (STORE_CODE,CREATE_DATE,STORE_NAME,USER_ID,HEADCOUNT_XML_PATH) values (?,?,?,?,?)"];
            FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
            [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:insert_sql,[CacheManagement instance].currentStore.StoreCode,CurrentDate,[CacheManagement instance].currentStore.StoreName,[CacheManagement instance].currentUser.UserId,cachePath];
        }
        Uploadstatu = 1;
        [self.waitView removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)completeUploadServer:(NSString *)error
{
    [self.waitView removeFromSuperview];
    if ([error length] == 0)
    {
        Uploadstatu = 1;
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET HEADCOUNT = '%@' where WORKMAINID = '%@'",@"1",[CacheManagement instance].currentWorkMainID];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.dataSourceArray count]%3 == 0) return [self.dataSourceArray count]/3 ;
    else return [self.dataSourceArray count]/3 + 1 ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell" ;
    HeadCountCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nibAry = [[NSBundle mainBundle] loadNibNamed:@"HeadCountCustomCell" owner:self options:nil];
        for (UIView *view in nibAry) {
            if ([view isKindOfClass:[HeadCountCustomCell class]]) {
                cell = (HeadCountCustomCell *)view ;
                break ;
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    @try {
        cell.delegate = self;
        cell.index = (int)indexPath.row;
        cell.leftStarLabel.hidden = YES ;
        cell.rightStarLabel.hidden = YES ;
        cell.thirdStarLabel.hidden = YES ;
        
        CGRect frame = cell.leftInputLabel.frame ;
        frame.size.width = DEWIDTH/3.0 - 11 ;
        cell.leftInputLabel.frame = frame ;

        frame = cell.leftBtn.frame ;
        frame.size.width = DEWIDTH/3.0 ;
        cell.leftBtn.frame = frame ;
        
        if ([self.dataSourceArray count] > indexPath.row*3) {
            
            FrHeadCountItemEntity* checkEntityLeft = [self.dataSourceArray objectAtIndex:indexPath.row*3] ;
            cell.leftTitleLabel.text = SYSLanguage?checkEntityLeft.ITEM_NAME_EN:checkEntityLeft.ITEM_NAME_CN;
            cell.leftInputLabel.text = [NSString stringWithFormat:@"  %@",checkEntityLeft.RESULT] ;
            if ([@"1" isEqualToString:checkEntityLeft.IS_MUST]&&[@"1" isEqualToString:checkEntityLeft.ITEM_TYPE]) {
                cell.leftStarLabel.hidden = NO ;
            }
            if ([@"1" isEqualToString:checkEntityLeft.ITEM_TYPE]&&
                [[self.dataSourceArray objectAtIndex:(indexPath.row*3+1)] isKindOfClass:[NSString class]]){
                CGRect frame = cell.leftInputLabel.frame ;
                frame.size.width = DEWIDTH - 16 ;
                cell.leftInputLabel.frame = frame ;
                
                frame = cell.leftBtn.frame ;
                frame.size.width = DEWIDTH ;
                cell.leftBtn.frame = frame ;
                
                cell.bgImageView.hidden = YES;
                cell.rightImageView.hidden = YES ;
            }
            
            if (![@"" isEqualToString:checkEntityLeft.SUMMARY_ITEM]&&[[checkEntityLeft.SUMMARY_ITEM componentsSeparatedByString:@","] count] > 0) {
                cell.leftInputLabel.backgroundColor = [CommonUtil colorWithHexString:@"#e9e9e9"];
            } else {
                cell.leftInputLabel.backgroundColor = [UIColor whiteColor];
            }
        }
        
        if ([self.dataSourceArray count] > (indexPath.row*3+1)) {
            
            if ([[self.dataSourceArray objectAtIndex:(indexPath.row*3+1)] isKindOfClass:[FrHeadCountItemEntity class]]) {
                FrHeadCountItemEntity* checkEntityRight = [self.dataSourceArray objectAtIndex:(indexPath.row*3+1)] ;
                cell.rightTitleLabel.text = SYSLanguage?checkEntityRight.ITEM_NAME_EN:checkEntityRight.ITEM_NAME_CN;
                cell.rightInputLabel.text = [NSString stringWithFormat:@"  %@",checkEntityRight.RESULT] ;
                if ([@"1" isEqualToString:checkEntityRight.IS_MUST]&&[@"1" isEqualToString:checkEntityRight.ITEM_TYPE]) {
                    cell.rightStarLabel.hidden = NO ;
                }
                if (![@"" isEqualToString:checkEntityRight.SUMMARY_ITEM]&&[[checkEntityRight.SUMMARY_ITEM componentsSeparatedByString:@","] count] > 0) {
                    cell.rightInputLabel.backgroundColor = [CommonUtil colorWithHexString:@"#e9e9e9"];
                } else {
                    cell.rightInputLabel.backgroundColor = [UIColor whiteColor];
                }
            } else {
                cell.rightInputLabel.hidden = YES ;
                cell.rightTitleLabel.hidden = YES ;
                cell.rightBtn.hidden = YES ;
            }
        } else {
            cell.rightInputLabel.hidden = YES ;
            cell.rightTitleLabel.hidden = YES ;
            cell.rightBtn.hidden = YES ;
        }
        
        if ([self.dataSourceArray count] > (indexPath.row*3+2)) {
            
            if ([[self.dataSourceArray objectAtIndex:(indexPath.row*3+2)] isKindOfClass:[FrHeadCountItemEntity class]]) {
                FrHeadCountItemEntity* checkEntityRight = [self.dataSourceArray objectAtIndex:(indexPath.row*3+2)] ;
                cell.thirdTitleLabel.text = SYSLanguage?checkEntityRight.ITEM_NAME_EN:checkEntityRight.ITEM_NAME_CN;
                cell.thirdInputLabel.text = [NSString stringWithFormat:@"  %@",checkEntityRight.RESULT] ;
                if ([@"1" isEqualToString:checkEntityRight.IS_MUST]&&[@"1" isEqualToString:checkEntityRight.ITEM_TYPE]) {
                    cell.thirdStarLabel.hidden = NO ;
                }
                if (![@"" isEqualToString:checkEntityRight.SUMMARY_ITEM]&&[[checkEntityRight.SUMMARY_ITEM componentsSeparatedByString:@","] count] > 0) {
                    cell.thirdInputLabel.backgroundColor = [CommonUtil colorWithHexString:@"#e9e9e9"];
                } else {
                    cell.thirdInputLabel.backgroundColor = [UIColor whiteColor];
                }
            } else {
                cell.thirdInputLabel.hidden = YES ;
                cell.thirdTitleLabel.hidden = YES ;
                cell.thirdBtn.hidden = YES ;
            }
        } else {
            cell.thirdInputLabel.hidden = YES ;
            cell.thirdTitleLabel.hidden = YES ;
            cell.thirdBtn.hidden = YES ;
        }
        
        cell.leftInputLabel.layer.borderColor = [[Utilities colorWithHexString:@"#dddddd"] CGColor];
        cell.rightInputLabel.layer.borderColor = [[Utilities colorWithHexString:@"#dddddd"] CGColor];
        cell.thirdInputLabel.layer.borderColor = [[Utilities colorWithHexString:@"#dddddd"] CGColor];
        
        if (indexPath.row == selectLine) {
            if (selectPosition == 10) {
                cell.leftInputLabel.layer.borderColor = [[Utilities colorWithHexString:@"#76d2f9"] CGColor];
            }
            if (selectPosition == 20) {
                cell.rightInputLabel.layer.borderColor = [[Utilities colorWithHexString:@"#76d2f9"] CGColor];
            }
            if (selectPosition == 30) {
                cell.thirdInputLabel.layer.borderColor = [[Utilities colorWithHexString:@"#76d2f9"] CGColor];
            }
        }
    } @catch (NSException *exception) {
    }
    
    return cell ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 84 ;
}

- (void)tapInputLabel:(int)index labelType:(int)type {
    
    @try {
        FrHeadCountItemEntity* checkEntity = nil ;
        if (type == 10 && [self.dataSourceArray count] > index*3) {
            checkEntity = [self.dataSourceArray objectAtIndex:index*3] ;
        }
        
        if (type == 20 && [self.dataSourceArray count] > (index*3+1)) {
            checkEntity = [self.dataSourceArray objectAtIndex:(index*3+1)] ;
        }
        
        if (type == 30 && [self.dataSourceArray count] > (index*3+2)) {
            checkEntity = [self.dataSourceArray objectAtIndex:(index*3+2)] ;
        }
        
        if (![@"" isEqualToString:checkEntity.SUMMARY_ITEM]&&[[checkEntity.SUMMARY_ITEM componentsSeparatedByString:@","] count] > 0) {
            ALERTVIEW(SYSLanguage?@"Auto filled Field":@"自动填充项，无需填写")
            return ;
        }
        
        selectPosition = type ;
        selectLine = index ;
        [self.Issue_list_TableView reloadData];
        
        if (checkEntity) {
            EditViewController *recommandVC = [[EditViewController alloc] initWithNibName:@"EditViewController" bundle:nil] ;
            recommandVC.delegate = self ;
            recommandVC.type = checkEntity.ITEM_TYPE ;
            recommandVC.index = index;
            recommandVC.textVal = checkEntity.RESULT;
            recommandVC.position = type ;
            recommandVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:recommandVC animated:NO completion:^{}];
        }
    } @catch (NSException *exception) {
    }
}

- (void)FinishEditWith:(NSString *)text andIndex:(NSInteger)index andPosition:(int)position{
    selectPosition = -1 ;
    selectLine = -1 ;
    FrHeadCountItemEntity* checkEntity = nil ;
    if (position == 10 && [self.dataSourceArray count] > index*3) {
        checkEntity = [self.dataSourceArray objectAtIndex:index*3] ;
    }
    
    if (position == 20 && [self.dataSourceArray count] > (index*3+1)) {
        checkEntity = [self.dataSourceArray objectAtIndex:(index*3+1)] ;
    }
    
    if (position == 30 && [self.dataSourceArray count] > (index*3+2)) {
        checkEntity = [self.dataSourceArray objectAtIndex:(index*3+2)] ;
    }
    
    checkEntity.RESULT = text;
    
    NSMutableArray *needSumaryArray = [NSMutableArray array];
    for (int i = 0 ; i<[self.dataSourceArray count]; i++) {
        if ([[self.dataSourceArray objectAtIndex:i] isKindOfClass:[FrHeadCountItemEntity class]]) {
            FrHeadCountItemEntity* entity = [self.dataSourceArray objectAtIndex:i] ;
            if (entity.SUMMARY_ITEM&&![entity.SUMMARY_ITEM isEqualToString:@""]) {
                [needSumaryArray addObject:entity];
            }
        }
    }
    
    for (FrHeadCountItemEntity *entity in needSumaryArray) {
        NSArray *subitem = [entity.SUMMARY_ITEM componentsSeparatedByString:@","];
        int total = 0 ;
        for (NSString *str in subitem) {
            for (int i = 0 ; i<[self.dataSourceArray count]; i++) {
                if ([[self.dataSourceArray objectAtIndex:i] isKindOfClass:[FrHeadCountItemEntity class]]) {
                    FrHeadCountItemEntity* entity_ = [self.dataSourceArray objectAtIndex:i] ;
                    if ([entity_.ITEM_NO isEqualToString:str]) {
                        total += [entity_.RESULT intValue];
                    }
                }
            }
        }
        entity.RESULT = [NSString stringWithFormat:@"%d",total];
    }
    
    [self.Issue_list_TableView reloadData];
    
    [needSumaryArray addObject:checkEntity];
    
    for (FrHeadCountItemEntity *checkEntity in needSumaryArray) {
        
        NSString *sql = [NSString stringWithFormat:@"select count(FR_HEADCOUNT_CHK_ITEM_ID) AS TotalCount from IST_FR_HEADCOUNT_CHK_ITEM where FR_HEADCOUNT_CHK_ID = '%@' and FR_HEADCOUNT_ITEM_ID = '%@' ",[CacheManagement instance].currentVMCHKID,checkEntity.FR_HEADCOUNT_ITEM_ID];
        FMResultSet* rs_ = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
        
        int totalcount = 0 ;
        while ([rs_ next]) {
            totalcount = [rs_ intForColumn:@"TotalCount"];
        }
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        if (totalcount>0) {
            sql = [NSString stringWithFormat:@"UPDATE IST_FR_HEADCOUNT_CHK_ITEM SET RESULT='%@' where FR_HEADCOUNT_CHK_ID='%@' AND FR_HEADCOUNT_ITEM_ID ='%@' ",checkEntity.RESULT,[CacheManagement instance].currentVMCHKID,checkEntity.FR_HEADCOUNT_ITEM_ID];
            [db executeUpdate:sql];
        } else {
            sql = [NSString stringWithFormat:@"INSERT INTO IST_FR_HEADCOUNT_CHK_ITEM (FR_HEADCOUNT_CHK_ITEM_ID,FR_HEADCOUNT_CHK_ID,FR_HEADCOUNT_ITEM_ID,RESULT) values (?,?,?,?)"];
            [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
             [Utilities GetUUID],
             [CacheManagement instance].currentVMCHKID,
             checkEntity.FR_HEADCOUNT_ITEM_ID,
             checkEntity.RESULT];
        }
    }
}

@end














