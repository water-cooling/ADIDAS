//
//  OnSiteFirstViewController.m
//  MobileApp
//
//  Created by 桂康 on 2021/3/26.
//

#import "OnSiteFirstViewController.h"
#import "CommonDefine.h"
#import "Utilities.h"
#import "SqliteHelper.h"
#import "OnSiteListViewController.h"
#import "NvmMstOnSitePhotoZoneEntity.h"
#import "OnSiteEntity.h"
#import "XMLFileManagement.h"

@interface OnSiteFirstViewController ()

@end

@implementation OnSiteFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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


    self.navigationItem.title = SYSLanguage?@"On Site":@"陈列调整";
    [Utilities createRightBarButton:self clichEvent:@selector(showUploadAlert) btnSize:CGSizeMake(50, 30) btnTitle:SYSLanguage?@"Submit":@"提交"];

    [self UpdateNVM_IST_ONSITE_CHECK];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)){
       self.navigationController.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    }

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

    self.takePhoto_list_TableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, DEWIDTH,DEHEIGHT-64-40) style:UITableViewStylePlain];
    self.takePhoto_list_TableView.delegate = self;
    self.takePhoto_list_TableView.dataSource = self;
    self.takePhoto_list_TableView.tableFooterView = [[UIView alloc] init];
    [self.takePhoto_list_TableView setSectionHeaderHeight:0];
    self.takePhoto_list_TableView.rowHeight = 46;
    [self.takePhoto_list_TableView setBackgroundColor:[UIColor whiteColor]];
    [self.takePhoto_list_TableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.view addSubview:self.takePhoto_list_TableView];
}

// 检查此次检查表是否存在
- (NSArray*)checkNVM_IST_ONSITE_CHECK {
    __autoreleasing NSMutableArray* resultarr = [[NSMutableArray alloc]init];
    NSString* storecode = [CacheManagement instance].currentStore.StoreCode;
    NSString* workmainID = [CacheManagement instance].currentWorkMainID;
    NSString* sql = [NSString stringWithFormat:@"select * from NVM_IST_ONSITE_CHECK where WORK_MAIN_ID ='%@' and STORE_CODE= '%@'",workmainID,storecode];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next]){
        [resultarr addObject:[rs stringForColumnIndex:0]];
    }
    [rs close];
    return resultarr;
}

// 更新本地数据库 NVM_IST_ONSITE_CHECK表
- (void)UpdateNVM_IST_ONSITE_CHECK {
    NSArray* arr = [self checkNVM_IST_ONSITE_CHECK];
    if ( arr.count > 0) {
        // 存在列表
        [CacheManagement instance].currentTakeID = [arr objectAtIndex:0];
    } else {
        NSString* TAKE_ID = [CacheManagement instance].currentWorkMainID;
        [CacheManagement instance].currentTakeID = TAKE_ID;
        NSString* storeCode = [CacheManagement instance].currentStore.StoreCode;
        NSString* workdate = [Utilities DateNow];
        NSString* workstarttime = [Utilities DateTimeNow];
        NSString* workendtime = [Utilities DateTimeNow];
        NSString* userid = [CacheManagement instance].currentUser.UserId;
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_ONSITE_CHECK (ONSITE_CHECK_ID,\
                         STORE_CODE,\
                         USER_ID,\
                         WORK_MAIN_ID,\
                         WORK_DATE,\
                         WORK_START_TIME,\
                         WORK_END_TIME,\
                         USER_SUBMIT_TIME,\
                         CLIENT_UPLOAD_TIME,\
                         SERVER_INSERT_TIME,\
                         ADJUSTMENT_MODE) values (?,?,?,?,?,?,?,?,?,?,?)"];
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         TAKE_ID,
         storeCode,
         userid,
         [CacheManagement instance].currentWorkMainID,
         workdate,
         workstarttime,
         workendtime,
         workendtime,   // 提交时间
         nil,
         nil,
         @""];
    }
}

// 本地数据库读取见检查项
- (void)GetCheckIssueFromDB {
    FMDatabase* db = [[SqliteHelper shareCommonSqliteHelper]database];
    self.PhotoListArr = [[NSMutableArray alloc]init];
    {
        NSString *sql = @"select * from NVM_MST_ONSITE_PHOTOZONE order by ZONE_ORDER asc" ;
        FMResultSet* rs = [db executeQuery:sql];
        
        while([rs next])
        {
            NvmMstOnSitePhotoZoneEntity* checkEntity = [[NvmMstOnSitePhotoZoneEntity alloc] initWithFirstFMResultSet:rs];
            [self.PhotoListArr addObject:checkEntity] ;
        }
        [rs close];
    }
    
//    NSString *sql = [NSString stringWithFormat:@"Select ZONE_ID From  NVM_IST_ONSITE_CHECK_DETAIL where ((BEFORE_PHOTO_PATH is null or BEFORE_PHOTO_PATH = '' or BEFORE_PHOTO_PATH = '0') or ((BEFORE_PHOTO_PATH is not null and BEFORE_PHOTO_PATH != '' and BEFORE_PHOTO_PATH != '0') and ( AFTER_ADJUSTMENT_MODE is null or AFTER_ADJUSTMENT_MODE = '') and ( AFTER_PHOTO_PATH is null or AFTER_PHOTO_PATH = '' or AFTER_PHOTO_PATH = '0'))) and ( BEFORE_ADJUSTMENT_MODE is  null or BEFORE_ADJUSTMENT_MODE = '') and ONSITE_CHECK_ID = '%@' ",[CacheManagement instance].currentTakeID];
    NSString *sql = [NSString stringWithFormat:@"Select * From  NVM_IST_ONSITE_CHECK_DETAIL where ONSITE_CHECK_ID = '%@' ",[CacheManagement instance].currentTakeID];
    self.zoneIDArr = [[NSMutableArray alloc]init];
    FMResultSet *rs_ = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs_ next]) {
        NSString *zone = [NSString stringWithFormat:@"%@",[rs_ stringForColumn:@"ZONE_ID"]];
        NSString *beforePath = [NSString stringWithFormat:@"%@",[rs_ stringForColumn:@"BEFORE_PHOTO_PATH"]];
        NSString *afterPath = [NSString stringWithFormat:@"%@",[rs_ stringForColumn:@"AFTER_PHOTO_PATH"]];
        NSString *beforeMode = [NSString stringWithFormat:@"%@",[rs_ stringForColumn:@"BEFORE_ADJUSTMENT_MODE"]];
        NSString *afterMode = [NSString stringWithFormat:@"%@",[rs_ stringForColumn:@"AFTER_ADJUSTMENT_MODE"]];
        [self.zoneIDArr addObject:@{@"zone":zone,@"beforePath":beforePath,@"afterPath":afterPath,@"beforeMode":beforeMode,@"afterMode":afterMode}];
    }
    [rs_ close];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OnSiteListViewController* photoVC = [[OnSiteListViewController alloc]initWithNibName:@"OnSiteListViewController" bundle:nil];
    NvmMstOnSitePhotoZoneEntity *entity = [self.PhotoListArr objectAtIndex:indexPath.row];
    photoVC.currentEntity = entity;
    [self.navigationController pushViewController:photoVC animated:YES];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:SYSLanguage?@"Back":@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:item] ;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NvmMstOnSitePhotoZoneEntity *entity = [self.PhotoListArr objectAtIndex:indexPath.row];
    cell.textLabel.text = SYSLanguage?entity.ZONE_NAME_EN: entity.ZONE_NAME_CN;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    BOOL exist = NO ;
    for (NSDictionary *dic in self.zoneIDArr) {
        if ([entity.ZONE_ID isEqualToString:[[dic valueForKey:@"zone"] componentsSeparatedByString:@"_"].firstObject]) {
            exist = YES ;
        }
    }
    if (exist) {
        for (NSDictionary *dic in self.zoneIDArr) {
            if ([entity.ZONE_ID isEqualToString:[[dic valueForKey:@"zone"] componentsSeparatedByString:@"_"].firstObject]) {
                NSString *beforePath = [NSString stringWithFormat:@"%@",[dic valueForKey:@"beforePath"]];
                NSString *afterPath = [NSString stringWithFormat:@"%@",[dic valueForKey:@"afterPath"]];
                NSString *beforeMode = [NSString stringWithFormat:@"%@",[dic valueForKey:@"beforeMode"]];
                NSString *afterMode = [NSString stringWithFormat:@"%@",[dic valueForKey:@"afterMode"]];
                if (([beforeMode.lowercaseString containsString:@"null"]||[beforeMode isEqualToString:@""])&&
                    ((beforePath.length > 8&&afterPath.length < 8&&([afterMode.lowercaseString containsString:@"null"]||[afterMode isEqualToString:@""]))||beforePath.length < 8)) {
                    exist = NO ;
                }
            }
        }
        
        cell.tintColor = [UIColor systemBlueColor];
    }
    
    if (exist) {
        cell.tintColor = [Utilities colorWithHexString:@"#8eb72f"];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        cell.tintColor = [UIColor redColor];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.PhotoListArr count];
}

- (void)upload {
    
    for (NvmMstOnSitePhotoZoneEntity *entity in self.PhotoListArr) {
        BOOL exist = NO ;
        for (NSDictionary *dic in self.zoneIDArr) {
            if ([entity.ZONE_ID isEqualToString:[[dic valueForKey:@"zone"] componentsSeparatedByString:@"_"].firstObject]) {
                exist = YES ;
            }
        }
        
        if (!exist) {
            [HUD hideUIBlockingIndicator];
            self.waitView.hidden = YES;
            ALERTVIEW(SYSLanguage?@"Please finish all items": @"还有未完成项，请继续填写");
            return;
        }
        
        if (exist) {
            for (NSDictionary *dic in self.zoneIDArr) {
                if ([entity.ZONE_ID isEqualToString:[[dic valueForKey:@"zone"] componentsSeparatedByString:@"_"].firstObject]) {
                    NSString *beforePath = [NSString stringWithFormat:@"%@",[dic valueForKey:@"beforePath"]];
                    NSString *afterPath = [NSString stringWithFormat:@"%@",[dic valueForKey:@"afterPath"]];
                    NSString *beforeMode = [NSString stringWithFormat:@"%@",[dic valueForKey:@"beforeMode"]];
                    NSString *afterMode = [NSString stringWithFormat:@"%@",[dic valueForKey:@"afterMode"]];
                    if (([beforeMode.lowercaseString containsString:@"null"]||[beforeMode isEqualToString:@""])&&
                        ((beforePath.length > 8&&afterPath.length < 8&&([afterMode.lowercaseString containsString:@"null"]||[afterMode isEqualToString:@""]))||beforePath.length < 8)) {
                        [HUD hideUIBlockingIndicator];
                        self.waitView.hidden = YES;
//                        if (beforePath.length < 8) {
//                            ALERTVIEW(SYSLanguage?@"Please finish Before zone":@"Before区域未完成");
//                        } else {
//                            ALERTVIEW(SYSLanguage?@"The zone with Before-photo needs to be added an After-photo or an After-description":@"拍摄了Before照片的区域需要添加After照片或者After描述");
//                        }
                        ALERTVIEW(SYSLanguage?@"Please finish all items.": @"还有未完成项，请继续填写！");
                        return;
                    }
                }
            }
        }
    }
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:SYSLanguage?@"Reminding":@"提示" message:SYSLanguage?@"Select suggestions on store adjustment":@"选择店铺调整建议" preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString *btn in [SYSLanguage?[CacheManagement instance].currentUser.StoreAdjustModeEN:[CacheManagement instance].currentUser.StoreAdjustModeCN componentsSeparatedByString:@";"]) {
        UIAlertAction *ac1 = [UIAlertAction actionWithTitle:btn style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self submitFinalData:btn];
        }];
        [ac addAction:ac1];
    }
    UIAlertAction *ac2 = [UIAlertAction actionWithTitle:SYSLanguage?@"Cancel":@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [ac addAction:ac2];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)submitFinalData:(NSString *)adjust {
    
    NSString* sql_select  = [NSString stringWithFormat:@"select * from NVM_IST_ONSITE_CHECK_DETAIL where ONSITE_CHECK_ID = '%@'",[CacheManagement instance].currentTakeID];
    
    NSMutableArray *resultArr = [NSMutableArray array];
    NSMutableArray *resultPicArr = [NSMutableArray array];

    FMResultSet* rs_Select = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql_select];
    while ([rs_Select next]){
        OnSiteEntity* Entity = [[OnSiteEntity alloc] initWithFMResultSet:rs_Select];
        [resultArr addObject:Entity];
        [resultPicArr addObject:Entity.BEFORE_PHOTO_PATH];
        [resultPicArr addObject:Entity.AFTER_PHOTO_PATH];
    }
    [rs_Select close];

    // 制作xml 文件
    XMLFileManagement * xmlcon = [[XMLFileManagement alloc] init];
    NSString* xmlstring = [xmlcon CreateOnSiteString:resultArr
                                         WorkEndTime:[Utilities DateTimeNow]
                                             CheckID:[CacheManagement instance].currentWorkMainID
                                       WorkStartTime:[Utilities DateTimeNow]
                                           StoreCode:[CacheManagement instance].currentStore.StoreCode
                                          submittime:[Utilities DateTimeNow]
                                            WorkDate:[Utilities DateNow]
                                      AdjustmentMode:adjust];
    

    if ([CacheManagement instance].uploaddata == YES)
    {
        [self.waitView setHidden:NO];
        [self.uploadManage uploadVMRailCheckFileToServer:xmlstring
                                              fileType:kVMXmlUploadOnSite
                                        andfilePathArr:resultPicArr
                                            andxmlPath:[NSString stringWithFormat:@"%@/%@/%@",[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode]];
    }
    else if([CacheManagement instance].uploaddata == NO)
    {
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        NSString* sql__ = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET OnSiteCheck = '%@' where WORKMAINID = '%@'",@"1",[CacheManagement instance].currentWorkMainID];
        [db executeUpdate:sql__];
        
        
        NSString *CurrentDate = [Utilities DateNow] ;
        NSString* DateSql  = [NSString stringWithFormat:@"select CHECK_IN_TIME from IST_WORK_MAIN where WORK_MAIN_ID = '%@'",[CacheManagement instance].currentWorkMainID];
        FMResultSet* DateResult = [[SqliteHelper shareCommonSqliteHelper] selectResult:DateSql];
        if ([DateResult next]) {
            CurrentDate = [[DateResult stringForColumn:@"CHECK_IN_TIME"] substringToIndex:10];
        }
        
        // 非几时上传 保存文件到本地
        NSString* sql = [NSString stringWithFormat:@"SELECT * FROM NVM_FILE_LIST WHERE STORE_CODE = '%@' AND CREATE_DATE = '%@' AND USER_ID = '%@'",[CacheManagement instance].currentStore.StoreCode,CurrentDate,[CacheManagement instance].currentUser.UserId];
        FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
        
        if ([rs next]) {
            NSString* cachePath = [rs stringForColumn:@"ONSITE_XML_PATH"];
            if ([cachePath length] < 5){
                cachePath = [NSString stringWithFormat:kXmlPathString,[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,[Utilities GetUUID]];
                NSFileManager* fileMannager = [NSFileManager defaultManager];
                if(![fileMannager fileExistsAtPath:cachePath]) {
                    [fileMannager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
                }
            } else {
                NSString *newfi = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[cachePath componentsSeparatedByString:@"/dataCaches"] lastObject]];
                cachePath = newfi ;
            }
            
            NSFileManager* fileMannager = [NSFileManager defaultManager];
            [fileMannager removeItemAtPath:cachePath error:nil];
            NSData* xmlData = [xmlstring dataUsingEncoding:NSUTF8StringEncoding];
            [xmlData writeToFile:cachePath atomically:YES];
            // 数据库存在记录 update
            NSString* picpath = [NSString stringWithFormat:@"%@/%@/%@/%@",[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,@"OnSite"];
            NSString* update_sql = [NSString stringWithFormat:@"UPDATE NVM_FILE_LIST SET ONSITE_PIC_PATH = '%@',ONSITE_XML_PATH='%@' WHERE STORE_CODE = '%@' AND CREATE_DATE = '%@' AND USER_ID = '%@'",picpath,cachePath,[CacheManagement instance].currentStore.StoreCode,CurrentDate,[CacheManagement instance].currentUser.UserId];
            [db executeUpdate:update_sql];
            
        }
        else
        {
            // 写xml到本地
            NSString* cachePath = [NSString stringWithFormat:kXmlPathString,[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,[Utilities GetUUID]];
            NSFileManager* fileMannager = [NSFileManager defaultManager];
            if(![fileMannager fileExistsAtPath:cachePath])  {
                [fileMannager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            [fileMannager removeItemAtPath:cachePath error:nil];
            NSData* xmlData = [xmlstring dataUsingEncoding:NSUTF8StringEncoding];
            [xmlData writeToFile:cachePath atomically:YES];
            // 不存在记录 insert
            NSString* picpath = [NSString stringWithFormat:@"%@/%@/%@/%@",[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,@"OnSite"];
            NSString *insert_sql = [NSString stringWithFormat:@"INSERT INTO NVM_FILE_LIST (STORE_CODE,CREATE_DATE,ONSITE_PIC_PATH,STORE_NAME,USER_ID,ONSITE_XML_PATH) values (?,?,?,?,?,?)"];
            [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:insert_sql,[CacheManagement instance].currentStore.StoreCode,CurrentDate,picpath,[CacheManagement instance].currentStore.StoreName,[CacheManagement instance].currentUser.UserId,cachePath];
        }
        Uploadstatu = 1;
        [self.waitView setHidden:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)completeUploadServer:(NSString *)error {
    
    self.waitView.hidden = YES;
    if ([error length] == 0)
    {
        Uploadstatu = 1;
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET OnSiteCheck = '%@' where WORKMAINID = '%@'",@"2",[CacheManagement instance].currentWorkMainID];
        [db executeUpdate:sql];
    
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [HUD showUIBlockingIndicatorWithText:error withTimeout:2];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1)
    {
        [self upload];
    }
}

- (void)showUploadAlert {
    NSString* title = @"是否确定上传";
    if (SYSLanguage == EN) {
        title = @"Are you sure to upload ?";
    }
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:title message:nil delegate:self cancelButtonTitle:SYSLanguage?@"Cancel":@"取消" otherButtonTitles:SYSLanguage?@"OK":@"确定", nil];
    [av show];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self GetCheckIssueFromDB];
    [self.takePhoto_list_TableView reloadData];
}

@end
