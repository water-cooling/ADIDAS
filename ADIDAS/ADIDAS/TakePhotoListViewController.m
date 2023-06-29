//
//  TakePhotoListViewController.m
//  VM
//
//  Created by wendy on 14-7-17.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import "TakePhotoListViewController.h"
#import "SqliteHelper.h"
#import "CacheManagement.h"
#import "AppDelegate.h"
#import "TakePhotoListCell.h"
#import "NVM_STORE_PHOTO_ZONE_Entity.h"
#import "TakePhotoListCell.h"
#import "PhotoViewController.h"
#import "XMLFileManagement.h"
#import "CommonDefine.h"
#import "VisitStoreEntity.h"


@interface TakePhotoListViewController ()

@end

@implementation TakePhotoListViewController
@synthesize takePhoto_list_TableView;
@synthesize uploadManage;
@synthesize mustArr;

// 检查此次检查表是否存在
-(NSArray*)checkNVM_IST_STORE_TAKE_PHOTO
{
    __autoreleasing NSMutableArray* resultarr = [[NSMutableArray alloc]init];
    NSString* storecode = [CacheManagement instance].currentStore.StoreCode;
    NSString* workmainID = [CacheManagement instance].currentWorkMainID;
    NSString* sql = [NSString stringWithFormat:@"select * from NVM_IST_STORE_TAKE_PHOTO where WORK_MAIN_ID ='%@' and STORE_CODE= '%@'",workmainID,storecode];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        //			SyncParaVersionEntity * entity = [[SyncParaVersionEntity alloc] initWithFMResultSet:rs];
        [resultarr addObject:[rs stringForColumnIndex:0]];
    }
    [rs close];
	return resultarr;
}

// 更新本地数据库 NVM_IST_STORE_TAKE_PHOTO表
-(void)UpdateNVM_IST_STORE_TAKE_PHOTO
{
    NSArray* arr = [self checkNVM_IST_STORE_TAKE_PHOTO];
    if ( arr.count > 0)
    {
        // 存在列表
        [CacheManagement instance].currentTakeID = [arr objectAtIndex:0];
    }
    else
    {
        NSString* TAKE_ID = [CacheManagement instance].currentWorkMainID;
        [CacheManagement instance].currentTakeID = TAKE_ID;
        NSString* storeCode = [CacheManagement instance].currentStore.StoreCode;
        NSString* workdate = [Utilities DateNow];
        NSString* workstarttime = [Utilities DateTimeNow];
        NSString* workendtime = [Utilities DateTimeNow];
        NSString* userid = [CacheManagement instance].currentUser.UserId;
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_STORE_TAKE_PHOTO (TAKE_ID,STORE_CODE,USER_ID,WORK_MAIN_ID,WORK_DATE,WORK_START_TIME,WORK_END_TIME,USER_SUBMIT_TIME,CLIENT_UPLOAD_TIME,SERVER_INSERT_TIME) values (?,?,?,?,?,?,?,?,?,?)"];
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
         nil];
    }
}

// 更新本地NVM_IST_STORE_PHOTO_LIST表

-(void)UpdateNVM_IST_STORE_PHOTO_LIST:(NSString*)PHOTO_ZONE
{
    
    NSArray* arr = [self checkNVM_IST_STORE_PHOTO_LIST:PHOTO_ZONE];
    if ( arr.count > 0)
    {
        // 存在列表
        [CacheManagement instance].currentPhotoZone = PHOTO_ZONE;
    }
    else
    {
        [CacheManagement instance].currentPhotoZone = PHOTO_ZONE;
        NSString* TAKE_ID = [CacheManagement instance].currentTakeID;
        NSString* workendtime = [Utilities DateTimeNow];
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_STORE_PHOTO_LIST (IST_STORE_PHOTO_LIST_ID,TAKE_ID,STORE_ZONE,PHOTO_TYPE,INITIAL_PHOTO_PATH,COMPRESS_PHOTO_PATH,COMMENT,SERVER_INSERT_TIME,LAST_MODIFIED_BY,LAST_MODIFIED_TIME) values (?,?,?,?,?,?,?,?,?,?)"];
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         [Utilities GetUUID],
         TAKE_ID,
         PHOTO_ZONE,
         @"",
         @"0",
         @"0",
         @"",
         workendtime,
         nil,
         workendtime];
    }
}

-(NSArray*)checkNVM_IST_STORE_PHOTO_LIST:(NSString*)PHOTO_ZONE
{
    __autoreleasing NSMutableArray* resultarr = [[NSMutableArray alloc]init];
    NSString* TAKE_ID = [CacheManagement instance].currentTakeID;
    
    NSString* sql = [NSString stringWithFormat:@"select * from NVM_IST_STORE_PHOTO_LIST where TAKE_ID ='%@' and STORE_ZONE = '%@'",TAKE_ID,PHOTO_ZONE];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        //	SyncParaVersionEntity* entity = [[SyncParaVersionEntity alloc] initWithFMResultSet:rs];
        [resultarr addObject:[rs stringForColumnIndex:2]];
    }
    [rs close];
	return resultarr;
}


// 本地数据库读取见检查项

-(void)GetCheckIssueFromDB
{
    FMDatabase* db = [[SqliteHelper shareCommonSqliteHelper]database];
    [self.PhotoListArr removeAllObjects];
    {
        NSString *sql = [NSString stringWithFormat:@"Select distinct  a.* From  NVM_STORE_PHOTO_ZONE  a inner join nvm_ist_store_photo_list b on a.photo_zone_code=b.store_zone inner join nvm_ist_store_take_photo c on b. take_id=c.take_id where c.work_main_id='%@' and a.DATASOURCE like '%%%@%%' union Select  a.* From  NVM_STORE_PHOTO_ZONE  a left join ( select b.* from   nvm_ist_store_photo_list b inner join nvm_ist_store_take_photo c on b. take_id=c.take_id where c.work_main_id='%@' ) b  on a.photo_zone_code=b.store_zone where b.store_zone is null and a.order_no=%d and a.DATASOURCE like '%%%@%%'  order by a.zone_type,a.order_no",[CacheManagement instance].currentWorkMainID,[CacheManagement instance].dataSource,[CacheManagement instance].currentWorkMainID,1,[CacheManagement instance].dataSource] ;
        FMResultSet* rs = [db executeQuery:sql];
        
        while([rs next])
        {
            NVM_STORE_PHOTO_ZONE_Entity* checkEntity = [[NVM_STORE_PHOTO_ZONE_Entity alloc]initWithFMResultSet:rs];
          
            [self.PhotoListArr addObject:checkEntity] ;
            if (checkEntity.IS_MUST == 1)
            {
                [self.mustArr addObject:checkEntity];
            }
        }
        [rs close];
    }
//     NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"SortString" ascending:YES];
//    [self.PhotoListArr sortUsingDescriptors:[NSArray arrayWithObject:sort]];
//    [self.OriginStoreListArr sortUsingDescriptors:[NSArray arrayWithObject:sort]];
}



-(NSString*)checkNVM_IST_STORE_PHOTO_beforePath:(NSString*)PHOTO_ZONE
{
    NSMutableArray* resultarr = [[NSMutableArray alloc]init];
    NSString* TAKE_ID = [CacheManagement instance].currentTakeID;
    
    NSString* sql = [NSString stringWithFormat:@"select * from NVM_IST_STORE_PHOTO_LIST where TAKE_ID='%@' and STORE_ZONE= '%@'",TAKE_ID,PHOTO_ZONE];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        if ([rs stringForColumn:@"INITIAL_PHOTO_PATH"]) {
            
            [resultarr addObject:[rs stringForColumn:@"INITIAL_PHOTO_PATH"]];
        }
        else {
            [resultarr addObject:@"0"];
        }
    }
    [rs close];
    __autoreleasing NSString* path = [resultarr firstObject];
	return path;
}

-(NSString*)checkNVM_IST_STORE_PHOTO_afterPath:(NSString*)PHOTO_ZONE
{
    NSMutableArray* resultarr = [[NSMutableArray alloc]init];
    NSString* TAKE_ID = [CacheManagement instance].currentTakeID;
    
    NSString* sql = [NSString stringWithFormat:@"select * from NVM_IST_STORE_PHOTO_LIST where TAKE_ID='%@' and STORE_ZONE= '%@'",TAKE_ID,PHOTO_ZONE];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        if ([rs stringForColumn:@"COMPRESS_PHOTO_PATH"]) {
            
            [resultarr addObject:[rs stringForColumn:@"COMPRESS_PHOTO_PATH"]];
        }
        else {
            
            [resultarr addObject:@"0"];
        }
        
    }
    [rs close];
    __autoreleasing NSString* path = [resultarr firstObject];
	return path;
}

#pragma mark - tableviewdelegate

-(void)openCamera:(UIImagePickerController *)picker  Cell:(id)cell
{
    //相机
    picker.view.tag = ((TakePhotoListCell*)cell).tag;
    [self UpdateNVM_IST_STORE_PHOTO_LIST:((TakePhotoListCell*)cell).entity.PHOTO_ZONE_CODE];
    picker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TakePhotoListCell* cell = (TakePhotoListCell*)[tableView cellForRowAtIndexPath:indexPath];
    //[self UpdateNVM_IST_STORE_PHOTO_LIST:cell.entity.PHOTO_ZONE_CODE];
    [CacheManagement instance].currentPhotoZone = cell.entity.PHOTO_ZONE_CODE ;
    PhotoViewController* photoVC = [[PhotoViewController alloc]initWithNibName:@"PhotoViewController" bundle:nil];
    photoVC.entity = cell.entity;
    [self.navigationController pushViewController:photoVC animated:YES];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:SYSLanguage?@"Back":@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.before.userInteractionEnabled = NO;
    cell.after.userInteractionEnabled = NO;
    cell.delegate = self;
    cell.doneImage.hidden = YES;
    cell.doneImage.image = [UIImage imageNamed:@"yes.png"];
    cell.entity = [self.PhotoListArr objectAtIndex:indexPath.row];
    
    if (cell.entity.IS_MUST == 1)
    {
        cell.doneImage.hidden = NO;
        if ([[[CacheManagement instance].dataSource lowercaseString] containsString:@"rbk"]) {
            cell.doneImage.image = [UIImage imageNamed:@"must_done.png"];
        } else {
            cell.doneImage.image = [UIImage imageNamed:@"must.png"];
        }
    }
    beforePath = [self checkNVM_IST_STORE_PHOTO_beforePath:cell.entity.PHOTO_ZONE_CODE];
    afterPath = [self checkNVM_IST_STORE_PHOTO_afterPath:cell.entity.PHOTO_ZONE_CODE];
    [cell.before setImage:[UIImage imageNamed:@"sbefore.png"]];
    [cell.after setImage:[UIImage imageNamed:@"safter.png"]];
    
    if ((![beforePath isEqualToString:@"0"])&&(beforePath != nil))
    {
        NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[beforePath componentsSeparatedByString:@"/dataCaches"] lastObject]];
        if ([UIImage imageWithContentsOfFile:newfile] != nil) {
            
            [cell.before setImage:[[UIImage imageWithContentsOfFile:newfile] scaleToSize:CGSizeMake(50, 50)]];
            if (![[[CacheManagement instance].dataSource lowercaseString] containsString:@"rbk"]) {
                cell.doneImage.hidden = NO;
                cell.doneImage.image = [UIImage imageNamed:@"yes.png"];
            }
        }
    }
    if ((![afterPath isEqualToString:@"0"])&&(afterPath != nil))
    {
        
        NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[afterPath componentsSeparatedByString:@"/dataCaches"] lastObject]];
        if ([UIImage imageWithContentsOfFile:newfile] != nil) {
            
            [cell.after setImage:[[UIImage imageWithContentsOfFile:newfile] scaleToSize:CGSizeMake(50, 50)]];
            if (![[[CacheManagement instance].dataSource lowercaseString] containsString:@"rbk"]) {
                cell.doneImage.hidden = NO;
                cell.doneImage.image = [UIImage imageNamed:@"yes.png"];
            }
        }
    }

    if ([[[CacheManagement instance].dataSource lowercaseString] containsString:@"rbk"]&&((![beforePath isEqualToString:@"0"])&&(beforePath != nil))&&((![afterPath isEqualToString:@"0"])&&(afterPath != nil)))
    {
        cell.doneImage.hidden = NO;
        cell.doneImage.image = [UIImage imageNamed:@"yes.png"];
    }
    cell.titleLabel.text = [[self.PhotoListArr objectAtIndex:indexPath.row]valueForKey:SYSLanguage?@"PHOTO_ZONE_NAME_EN": @"PHOTO_ZONE_NAME_CN"];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.PhotoListArr count];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)addNew:(id)cell {
    
    TakePhotoListCell *Cell = cell;
    NSMutableArray *ResultArray = [NSMutableArray array];
    FMDatabase* db = [[SqliteHelper shareCommonSqliteHelper]database];
    {
        NSString *sql = [NSString stringWithFormat:@"Select  a.* From  NVM_STORE_PHOTO_ZONE  a left join ( select b.* from   nvm_ist_store_photo_list b inner join nvm_ist_store_take_photo c on b. take_id=c.take_id where c.work_main_id='%@' ) b  on a.photo_zone_code=b.store_zone where b.store_zone is null and a.zone_type= %d and DATASOURCE like '%%%@%%' order by  a.order_no limit 1",[CacheManagement instance].currentWorkMainID,(int)Cell.entity.ZONE_TYPE,[CacheManagement instance].dataSource];
        
        FMResultSet* rs = [db executeQuery:sql];
        
        while([rs next])
        {
            NVM_STORE_PHOTO_ZONE_Entity* checkEntity = [[NVM_STORE_PHOTO_ZONE_Entity alloc]initWithFMResultSet:rs];
            [ResultArray addObject:checkEntity] ;
            
            if (checkEntity.IS_MUST == 1)
            {
                [self.mustArr addObject:checkEntity];
            }
        }
        [rs close];
    }
    
    if ([ResultArray count] == 0)
    {
        ALERTVIEW(SYSLanguage?@"Sorry,can not add":@"对不起,不能再添加了");
        return;
    }
    else {
        
        NVM_STORE_PHOTO_ZONE_Entity *newEntity = [ResultArray firstObject];
        [CacheManagement instance].currentPhotoZone = newEntity.PHOTO_ZONE_CODE ;
        
        if ([Cell.entity.PHOTO_ZONE_CODE isEqualToString:newEntity.PHOTO_ZONE_CODE]) {
            
            PhotoViewController* photoVC = [[PhotoViewController alloc]initWithNibName:@"PhotoViewController" bundle:nil];
            photoVC.entity = Cell.entity;
            [self.navigationController pushViewController:photoVC animated:YES];
        }
        else {
        
            PhotoViewController* photoVC = [[PhotoViewController alloc]initWithDelegate:self];
            photoVC.entity = newEntity;
            photoVC.IsNew = YES ;
            [self.navigationController pushViewController:photoVC animated:YES];
        }
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:SYSLanguage?@"Back":@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
        [self.navigationItem setBackBarButtonItem:item] ;
    }
}

- (void)AddToDBWithCode:(NVM_STORE_PHOTO_ZONE_Entity *)newEntity {
    
    
    NVM_STORE_PHOTO_ZONE_Entity *CurrentEntity = [[NVM_STORE_PHOTO_ZONE_Entity alloc] init];
    
    for (NVM_STORE_PHOTO_ZONE_Entity *entity in self.PhotoListArr) {
        
        if (newEntity.ZONE_TYPE == entity.ZONE_TYPE) {
            
            CurrentEntity = entity ;
        }
    }
    
    int index = [self.PhotoListArr indexOfObject:CurrentEntity] ;
    [self.PhotoListArr insertObject:newEntity atIndex:index + 1] ;
    [self.takePhoto_list_TableView reloadData] ;
}

-(void)back
{
    NSString* sql  = [NSString stringWithFormat:@"select * from NVM_IST_STORE_PHOTO_LIST where TAKE_ID = '%@'",[CacheManagement instance].currentTakeID];
    [self.resultArr removeAllObjects];
    FMResultSet* rs_ = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
    while ([rs_ next])
    {
        VisitStoreEntity* Entity = [[VisitStoreEntity alloc]initWithFMResultSet:rs_];
        [self.resultArr addObject:Entity];
    }
    [rs_ close];
    // 检查必填项
    BOOL finished = NO;
    for (NVM_STORE_PHOTO_ZONE_Entity* entity in self.mustArr)
    {
        finished = NO;
        NSString* mustcode = entity.PHOTO_ZONE_CODE;
        for (VisitStoreEntity* entity in self.resultArr)
        {
            if ([entity.STORE_ZONE isEqualToString: mustcode])
            {
                finished = YES;
            }
        }
    }
    if (finished == YES)
    {
//        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
//        NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET TAKEPHOTO = '%@' where WORKMAINID = '%@'",@"1",[CacheManagement instance].currentWorkMainID];
//        [db executeUpdate:sql];
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

 
    if (SYSLanguage == EN)
    {
        self.title = @"Store Pictures";
        [Utilities createRightBarButton:self clichEvent:@selector(showUploadAlert) btnSize:CGSizeMake(50, 30) btnTitle:@"Submit"];
    }
    else if (SYSLanguage == CN)
    {
        self.title = @"巡店拍照";
        [Utilities createRightBarButton:self clichEvent:@selector(showUploadAlert) btnSize:CGSizeMake(50, 30) btnTitle:@"上传"];
    }
    
    
    [Utilities createLeftBarButton:self clichEvent:@selector(back)];
    
    self.resultArr = [[NSMutableArray alloc]init];
    self.resultPicArr = [[NSMutableArray alloc]init];
    self.resultPicNameArr = [[NSMutableArray alloc]init];
    self.mustArr = [[NSMutableArray alloc]init];
    
    [self UpdateNVM_IST_STORE_TAKE_PHOTO];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    }
    
    self.PhotoListArr = [[NSMutableArray alloc]init];
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
    
    self.takePhoto_list_TableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, DEWIDTH,DEVICE_HEIGHT-64-40) style:UITableViewStylePlain];
    self.takePhoto_list_TableView.delegate = self;
    self.takePhoto_list_TableView.dataSource = self;
    [self.takePhoto_list_TableView setSectionHeaderHeight:0];
    self.takePhoto_list_TableView.rowHeight = 78;
    [self.takePhoto_list_TableView setBackgroundColor:[UIColor whiteColor]];
    [self.takePhoto_list_TableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.view addSubview:self.takePhoto_list_TableView];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.takePhoto_list_TableView reloadData];
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
//    self.PhotoListArr = nil;
//    self.mustArr = nil;
//    self.resultArr = nil;
//    self.resultPicArr = nil;
//    self.resultPicNameArr = nil;
}

-(void)upload
{
    NSString *sql = [NSString stringWithFormat:@"Select a.* From  NVM_STORE_PHOTO_ZONE a left join ( select b.* from   nvm_ist_store_photo_list b inner join nvm_ist_store_take_photo c on b.take_id=c.take_id where c.work_main_id='%@' ) b on a.photo_zone_code=b.store_zone where b.store_zone is null and a.is_must=1  and DATASOURCE like '%%%@%%'  limit 1",[CacheManagement instance].currentWorkMainID,[CacheManagement instance].dataSource];

    NVM_STORE_PHOTO_ZONE_Entity *entity ;
    FMResultSet *rs_ = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];

    while ([rs_ next]) {

        entity = [[NVM_STORE_PHOTO_ZONE_Entity alloc]initWithFMResultSet:rs_];
    }
    [rs_ close];


    if (entity)
    {
        [HUD hideUIBlockingIndicator];
        self.waitView.hidden = YES;
        ALERTVIEW(SYSLanguage?@"Please finish all items then upload": @"还有未完成项，请继续填写");
        return;
    }
    
    
    NSString* sql_select  = [NSString stringWithFormat:@"select * from NVM_IST_STORE_PHOTO_LIST where TAKE_ID = '%@' ORDER BY ORDER_NO",[CacheManagement instance].currentTakeID];
    [self.resultArr removeAllObjects];
    [self.resultPicArr removeAllObjects];
    [self.resultPicNameArr removeAllObjects];
    FMResultSet* rs_Select = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql_select];
    BOOL existNoComplete = NO ;
    while ([rs_Select next])
    {
        VisitStoreEntity* Entity = [[VisitStoreEntity alloc]initWithFMResultSet:rs_Select];
        if (((Entity.INITIAL_PHOTO_PATH != nil) && ([Entity.INITIAL_PHOTO_PATH length]>2)) || ((Entity.COMPRESS_PHOTO_PATH != nil)&&([Entity.COMPRESS_PHOTO_PATH length]>2)) || ![Entity.COMMENT isEqualToString:@""])
        {
            [self.resultArr addObject:Entity];
        }
        
        BOOL exist1 = NO ;
        BOOL exist2 = NO ;
        if ((Entity.INITIAL_PHOTO_PATH != nil) && ([Entity.INITIAL_PHOTO_PATH length]>2))
        {
            [self.resultPicArr addObject:Entity.INITIAL_PHOTO_PATH];
            exist1 = YES ;
        }
        if ((Entity.COMPRESS_PHOTO_PATH != nil)&&([Entity.COMPRESS_PHOTO_PATH length]>2))
        {
            [self.resultPicArr addObject:Entity.COMPRESS_PHOTO_PATH];
            exist2 = YES ;
        }
        
        if ([[[CacheManagement instance].dataSource lowercaseString] containsString:@"rbk"]) {
            if (exist1 != exist2) {
                existNoComplete = YES ;
                break ;
            }
        }
    }
    
    [rs_Select close];

    if ([[[CacheManagement instance].dataSource lowercaseString] containsString:@"rbk"]&&existNoComplete) {
        ALERTVIEW(SYSLanguage?@"Before and After photos need be corresponding": @"Before和After照片必须保持对应");
        return;
    }
    
    // 制作xml 文件
    XMLFileManagement * xmlcon = [[XMLFileManagement alloc] init];
    NSString* xmlstring = [xmlcon CreateVisteStoreString:self.resultArr     
                                             WorkEndTime:[Utilities DateTimeNow]
                                                 TAKE_ID:[CacheManagement instance].currentWorkMainID
                                           WorkStartTime:[Utilities DateTimeNow]
                                               StoreCode:[CacheManagement instance].currentStore.StoreCode
                                              submittime:[Utilities DateTimeNow]
                                                WorkDate:[Utilities DateNow]];

    if ([CacheManagement instance].uploaddata == YES)
    {
        [self.waitView setHidden:NO];
        [self.uploadManage uploadVMRailCheckFileToServer:xmlstring
                                              fileType:kVMXmlUploadStore
                                        andfilePathArr:self.resultPicArr
                                            andxmlPath:[NSString stringWithFormat:@"%@/%@/%@",[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode]];
    }
    else if([CacheManagement instance].uploaddata == NO)
    {
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        NSString* sql__ = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET TAKEPHOTO = '%@' where WORKMAINID = '%@'",@"1",[CacheManagement instance].currentWorkMainID];
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
        
        if ([rs next])
        {
            NSString* cachePath = [rs stringForColumn:@"PHOTO_XML_PATH"];
            if ([cachePath length] < 5) //过滤返回 0 的路径
            {
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
            NSData* xmlData = [xmlstring dataUsingEncoding:NSUTF8StringEncoding];
            [xmlData writeToFile:cachePath atomically:YES];
            // 数据库存在记录 update
            NSString* picpath = [NSString stringWithFormat:@"%@/%@/%@/%@",[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,@"VM_PHOTO"];
            NSString* update_sql = [NSString stringWithFormat:@"UPDATE NVM_FILE_LIST SET PHOTO_PIC_PATH = '%@',PHOTO_XML_PATH='%@' WHERE STORE_CODE = '%@' AND CREATE_DATE = '%@' AND USER_ID = '%@'",picpath,cachePath,[CacheManagement instance].currentStore.StoreCode,CurrentDate,[CacheManagement instance].currentUser.UserId];
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
            NSData* xmlData = [xmlstring dataUsingEncoding:NSUTF8StringEncoding];
            [xmlData writeToFile:cachePath atomically:YES];
            // 不存在记录 insert
            NSString* picpath = [NSString stringWithFormat:@"%@/%@/%@/%@",[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,@"VM_PHOTO"];
            NSString *insert_sql = [NSString stringWithFormat:@"INSERT INTO NVM_FILE_LIST (STORE_CODE,CREATE_DATE,PHOTO_PIC_PATH,STORE_NAME,USER_ID,PHOTO_XML_PATH) values (?,?,?,?,?,?)"];
            [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:insert_sql,[CacheManagement instance].currentStore.StoreCode,CurrentDate,picpath,[CacheManagement instance].currentStore.StoreName,[CacheManagement instance].currentUser.UserId,cachePath];
        }
        Uploadstatu = 1;
        [self.waitView setHidden:YES];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)completeUploadServer:(NSString *)error
{
//    [HUD hideUIBlockingIndicator];
    
    self.waitView.hidden = YES;
    if ([error length] == 0)
    {
        Uploadstatu = 1;
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET TAKEPHOTO = '%@' where WORKMAINID = '%@'",@"2",[CacheManagement instance].currentWorkMainID];
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
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:title message:nil delegate:self cancelButtonTitle:SYSLanguage?@"Cancel":@"取消" otherButtonTitles:SYSLanguage?@"OK":@"确定", nil];
    [av show];
}

@end
