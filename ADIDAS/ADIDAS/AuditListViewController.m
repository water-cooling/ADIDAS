//
//  AuditListViewController.m
//  VM
//
//  Created by leo.you on 14-7-21.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import "AuditListViewController.h"
#import "SqliteHelper.h"
#import "AppDelegate.h"
#import "NvmMstStoreAuditItemEntity.h"
#import "CacheManagement.h"
#import "VM_CHECK_ITEM_Cell.h"
#import "AuditDetailViewController.h"
#import "XMLFileManagement.h"
#import "CommonDefine.h"
#import "VMAuditScoreEntity.h"
#import "VMStoreAuditPhotoEntity.h"

@interface AuditListViewController ()

@end

@implementation AuditListViewController

@synthesize uploadManage,vm_check_item_TableView;

// 检查是否已存在

// 检查此次检查表是否存在
-(NSArray*)checkNVM_IST_CHECK_ID
{
    __autoreleasing NSMutableArray* resultarr = [[NSMutableArray alloc]init];
    NSString* storecode = [CacheManagement instance].currentStore.StoreCode;
    NSString* workmainID = [CacheManagement instance].currentWorkMainID;
    NSString* sql = [NSString stringWithFormat:@"select * from NVM_IST_STOREAUDIT_CHECK where WORK_MAIN_ID ='%@' and STORE_CODE= '%@'",workmainID,storecode];
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
        NSString* NVM_IST_STOREAUDIT_CHECK_ID =[Utilities GetUUID];
        [CacheManagement instance].currentVMCHKID = NVM_IST_STOREAUDIT_CHECK_ID;
        NSString* storeCode = [CacheManagement instance].currentStore.StoreCode;
        NSString* workdate = [Utilities DateNow];
        NSString* workstarttime = [Utilities DateTimeNow];
        NSString* workendtime = [Utilities DateTimeNow];
        NSString* userid = [CacheManagement instance].currentUser.UserId;
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_STOREAUDIT_CHECK (STOREAUDIT_CHECK_ID,STORE_CODE,USER_ID,WORK_MAIN_ID,WORK_DATE,WORK_START_TIME,WORK_END_TIME,TOTAL_SCORE,USER_SUBMIT_TIME,CLIENT_UPLOAD_TIME,SERVER_INSERT_TIME) values (?,?,?,?,?,?,?,?,?,?,?)"];
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         NVM_IST_STOREAUDIT_CHECK_ID,
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
- (void)GetCheckIssueFromDB {
    FMDatabase* db = [[SqliteHelper shareCommonSqliteHelper]database];
    [[APPDelegate VM_CHECK_ItemList] removeAllObjects];
    FMResultSet* rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM NVM_MST_STOREAUDIT_ITEM where instr(ITEM_ID,'_') = 0 order by PARENT_ITEM_NO,cast(ITEM_NO as int) asc "]];
    while([rs next]){
        NvmMstStoreAuditItemEntity* checkEntity = [[NvmMstStoreAuditItemEntity alloc]initWithFMResultSet:rs];
        [[APPDelegate VM_CHECK_ItemList] addObject:checkEntity];
    }
}

// 查找得分
- (void)GetScorebyCHK_ID {
    NSString* sql = [NSString stringWithFormat:@"select a.CHECK_RESULT,b.COMMENT,b.PHOTO_PATH,a.ITEM_ID,c.SCORE_OPTION,c.MUST_COMMENT,c.STANDARD_SCORE from NVM_IST_STOREAUDIT_CHECK_DETAIL a left join NVM_IST_STOREAUDIT_CHECK_PHOTO b on a.STOREAUDIT_CHECK_ID = b.STOREAUDIT_CHECK_ID and a.ITEM_ID = b.ITEM_ID left join NVM_MST_STOREAUDIT_ITEM c on c.ITEM_ID = a.ITEM_ID where a.STOREAUDIT_CHECK_ID ='%@' order by a.ITEM_ID desc",[CacheManagement instance].currentVMCHKID];
    NSMutableArray* result = [[NSMutableArray alloc]init];
    FMResultSet *rs = nil;
    rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next]){
        NSString *score = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"CHECK_RESULT"]];
        if ([score.lowercaseString containsString:@"null"])score = @"" ;
        
        NSString *comment = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"COMMENT"]];
        if ([comment.lowercaseString containsString:@"null"])comment = @"" ;
        
        NSString *mustComment = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"MUST_COMMENT"]];
        if ([mustComment.lowercaseString containsString:@"null"])mustComment = @"" ;
        
        NSString *photoPath = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"PHOTO_PATH"]];
        if ([photoPath.lowercaseString containsString:@"null"])photoPath = @"" ;
        
        NSString *itemId = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"ITEM_ID"]];
        if ([itemId.lowercaseString containsString:@"null"])itemId = @"" ;
        
        NSString *scoreOption = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"SCORE_OPTION"]];
        if ([scoreOption.lowercaseString containsString:@"null"])scoreOption = @"" ;
        
        NSString *standardScore = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"STANDARD_SCORE"]];
        if ([standardScore.lowercaseString containsString:@"null"])standardScore = @"" ;
        
        [result addObject:@{@"score":score,
                            @"comment":comment,
                            @"mustComment":mustComment,
                            @"path":photoPath,
                            @"itemId":itemId,
                            @"scoreOption":scoreOption,
                            @"standardScore":standardScore}];
    }
    [rs close];
    totalScoreArray = [NSArray arrayWithArray:result];
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)back {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad{
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
    [self UpdateNVM_IST_CHECK_ID];
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    }
    self.navigationItem.title = SYSLanguage?@"Store Audit":@"店铺检查";
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

    self.vm_check_item_TableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 104, DEWIDTH,DEVICE_HEIGHT-104) style:UITableViewStylePlain] ;
    self.vm_check_item_TableView.delegate = self;
    self.vm_check_item_TableView.dataSource = self;
    [self.vm_check_item_TableView setSectionHeaderHeight:0];
    self.vm_check_item_TableView.rowHeight = 65;
    [self.vm_check_item_TableView setBackgroundColor:[UIColor whiteColor]];
    [self.vm_check_item_TableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.vm_check_item_TableView];
    self.tableviewSourceArr = [APPDelegate VM_CHECK_ItemList];
}

-(void)viewWillAppear:(BOOL)animated
{
    finish = YES ;
    [super viewWillAppear:animated];
    [self GetScorebyCHK_ID];
    [self.vm_check_item_TableView reloadData];
    
    @try {
        
        NSMutableArray *temp = [self getAllHeadCount];
        for (int x = 0 ; x < [temp count]; x++) {
            NvmMstStoreAuditItemEntity *entityTemp = [temp objectAtIndex:x];
            
            NSMutableArray *temp2 = [NSMutableArray array];
            for (NvmMstStoreAuditItemEntity *entity in self.tableviewSourceArr) {
                if ([entity.PARENT_ITEM_NO isEqualToString:entityTemp.PARENT_ITEM_NO]) {
                    [temp2 addObject:entity];
                }
            }
            
            for (int y = 0 ; y < [temp2 count]; y++) {
                entityTemp = [temp2 objectAtIndex:y];
                
                NSString *scorenumber = @"";
                BOOL notFinished = NO ;
                int totalPhoto = 0 ;
                if (!totalScoreArray) [self GetScorebyCHK_ID];
                for (NSDictionary *dic in totalScoreArray) {
                    if ([[dic valueForKey:@"itemId"] isEqualToString:entityTemp.ITEM_ID]) {
                        scorenumber = [dic valueForKey:@"score"];
                        NSString *path = [dic valueForKey:@"path"];
                        NSString *comment = [dic valueForKey:@"comment"];
                        NSString *mustComment = [dic valueForKey:@"mustComment"];
                        if (path.length > 8) {
                            if (comment.length == 0&&[mustComment isEqualToString:@"Y"]) {
                                notFinished = YES ;
                            }
                            totalPhoto += 1;
                        }
                    }
                }
                
                BOOL notFinish = NO;
                if ([scorenumber isEqualToString:@""]) {
                    for (NSDictionary *dic in totalScoreArray) {
                        if ([[dic valueForKey:@"itemId"] containsString:entityTemp.ITEM_ID]&&
                            ![[dic valueForKey:@"itemId"] isEqualToString:entityTemp.ITEM_ID]) {
                            if (![scorenumber isEqualToString:@"N"]) { //子项只要有1个是N 则为未完成
                                scorenumber = @"Y";
                            }
                            NSString *sc = [NSString stringWithFormat:@"%@",[dic valueForKey:@"score"]];
                            if ([sc isEqualToString:@""]) {
                                notFinish = YES ;//子项只要有1个没做 则为未完成
                            }
                            //单选项如果选中的分数项不等于总分，则视为此项N  （单选项所有的答案都是Y，故如果标题是N时候将答案改成N）
                            if ([@"N" isEqualToString:[dic valueForKey:@"scoreOption"]]&&![[dic valueForKey:@"standardScore"] isEqualToString:entityTemp.STANDARD_SCORE]) sc = @"N" ;
                            if ([sc isEqualToString:@"N"]||[sc isEqualToString:@"NA"]) { //子项只要有1个是N 则为未完成
                                scorenumber = @"N";
                            }
                        }
                    }
                }
                
                if (notFinish) scorenumber = @"";
                
                if ([scorenumber isEqualToString:@""]||(([scorenumber isEqualToString:@"N"]||[scorenumber isEqualToString:@"NA"])&&[entityTemp.PHOTO_NUM intValue] > 0&&(totalPhoto == 0 || notFinished))) {
                    finish = NO ;
                    break;
                }
            }
            
            if (!finish) break;
        }
        
    } @catch (NSException *exception) {
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

- (NSMutableArray *)getAllHeadCount {
    
    NSMutableArray *temp = [NSMutableArray array];
    for (NvmMstStoreAuditItemEntity *entity in self.tableviewSourceArr) {
        BOOL exist = false ;
        for (NvmMstStoreAuditItemEntity *entityTemp in temp) {
            if ([entity.PARENT_ITEM_NO isEqualToString:entityTemp.PARENT_ITEM_NO]) {
                exist = true ;
            }
        }
        if (!exist) {
            [temp addObject:entity];
        }
    }
    return temp ;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEWIDTH, 45)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, DEWIDTH-30, 45)];
    NSMutableArray *temp = [self getAllHeadCount];
    NvmMstStoreAuditItemEntity *entity = [temp objectAtIndex:section];
    label.text = entity.PARENT_ITEM_NAME_CN;
    if (SYSLanguage == EN) label.text = entity.PARENT_ITEM_NAME_EN;
    label.font = [UIFont systemFontOfSize:16];
    label.numberOfLines = 0 ;
    [view addSubview:label];
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 45;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSMutableArray *temp = [self getAllHeadCount];
    NSUInteger count = temp.count;
    [temp removeAllObjects];
    temp = nil ;
    return count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* identifier = @"cell";
    VM_CHECK_ITEM_Cell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"VM_CHECK_ITEM_Cell" owner:self options:nil]objectAtIndex:0];
    }
    
    cell.score_label.font = [UIFont systemFontOfSize:12];
    cell.scorecard_image.hidden = YES;
    cell.done_image.hidden = NO;
    cell.score_label.textColor = [UIColor darkGrayColor];
    cell.score_label.text = @"";
    
    NSMutableArray *temp = [self getAllHeadCount];
    NvmMstStoreAuditItemEntity *entityTemp = [temp objectAtIndex:indexPath.section];
    temp = [NSMutableArray array];
    for (NvmMstStoreAuditItemEntity *entity in self.tableviewSourceArr) {
        if ([entity.PARENT_ITEM_NO isEqualToString:entityTemp.PARENT_ITEM_NO]) {
            [temp addObject:entity];
        }
    }
    entityTemp = [temp objectAtIndex:indexPath.row];
    
    cell.item_ID = entityTemp.ITEM_ID;
    cell.title_label.text = entityTemp.ITEM_NAME_CN;
    if (SYSLanguage == EN) cell.title_label.text = entityTemp.ITEM_NAME_EN;
    cell.no_label.text = entityTemp.ITEM_NO;
    
    NSString *scorenumber = @"";
    BOOL notFinished = NO ;
    int totalPhoto = 0 ;
    if (!totalScoreArray) [self GetScorebyCHK_ID];
    for (NSDictionary *dic in totalScoreArray) {
        if ([[dic valueForKey:@"itemId"] isEqualToString:entityTemp.ITEM_ID]) {
            scorenumber = [dic valueForKey:@"score"];
            NSString *path = [dic valueForKey:@"path"];
            NSString *comment = [dic valueForKey:@"comment"];
            NSString *mustComment = [dic valueForKey:@"mustComment"];
            if (path.length > 8) {
                if (comment.length == 0&&[mustComment isEqualToString:@"Y"]) {
                    notFinished = YES ;
                }
                totalPhoto += 1;
            }
        }
    }
    
    BOOL exist = NO;
    BOOL notFinish = NO;
    if ([scorenumber isEqualToString:@""]) {
        for (NSDictionary *dic in totalScoreArray) {
            if ([[dic valueForKey:@"itemId"] containsString:entityTemp.ITEM_ID]&&
                ![[dic valueForKey:@"itemId"] isEqualToString:entityTemp.ITEM_ID]) {
                if (![scorenumber isEqualToString:@"N"]) { //子项只要有1个是N 则为未完成
                    scorenumber = @"Y";
                }
                NSString *sc = [NSString stringWithFormat:@"%@",[dic valueForKey:@"score"]];
                if ([sc isEqualToString:@""]) {
                    notFinish = YES ;//子项只要有1个没做 则为未完成
                }
                exist = YES;
                //单选项如果选中的分数项不等于总分，则视为此项N  （单选项所有的答案都是Y，故如果标题是N时候将答案改成N）
                if ([@"N" isEqualToString:[dic valueForKey:@"scoreOption"]]&&![[dic valueForKey:@"standardScore"] isEqualToString:entityTemp.STANDARD_SCORE]) sc = @"N" ;
                if ([sc isEqualToString:@"N"]||[sc isEqualToString:@"NA"]) { //子项只要有1个是N 则为未完成
                    scorenumber = @"N";
                }
            }
        }
    }
    
    if (notFinish) scorenumber = @"";
    
    if ([scorenumber isEqualToString:@""]||(([scorenumber isEqualToString:@"N"]||[scorenumber isEqualToString:@"NA"])&&[entityTemp.PHOTO_NUM intValue] > 0&&(totalPhoto == 0 || notFinished))) {
        cell.done_image.hidden = YES ;
        if ((([scorenumber isEqualToString:@"N"]||[scorenumber isEqualToString:@"NA"])&&[entityTemp.PHOTO_NUM intValue] > 0&&(totalPhoto == 0 || notFinished))||exist) {
            cell.scorecard_image.hidden = NO;
            cell.scorecard_image.image = [UIImage imageNamed:@"must_done.png"];
        }
        finish = NO ;
    } else {
        cell.score_label.textColor = [UIColor colorWithRed:0.47 green:0.67 blue:0.074 alpha:1];
        cell.score_label.text = scorenumber;
    }
    
    [temp removeAllObjects];
    temp = nil;
    
    CGRect frame1 = cell.score_label.frame ;
    frame1.origin.y = 22;
    cell.score_label.frame = frame1 ;
    
    CGRect frame2 = cell.done_image.frame ;
    frame2.origin.y = 25;
    cell.done_image.frame = frame2 ;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSMutableArray *temp = [self getAllHeadCount];
    NvmMstStoreAuditItemEntity *entityTemp = [temp objectAtIndex:section];
    temp = [NSMutableArray array];
    for (NvmMstStoreAuditItemEntity *entity in self.tableviewSourceArr) {
        if ([entity.PARENT_ITEM_NO isEqualToString:entityTemp.PARENT_ITEM_NO]) {
            [temp addObject:entity];
        }
    }
    NSUInteger count = temp.count;
    [temp removeAllObjects];
    temp = nil ;
    return count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AuditDetailViewController* msvc = [[AuditDetailViewController alloc]initWithNibName:@"AuditDetailViewController" bundle:nil];
    
    NSMutableArray *temp = [self getAllHeadCount];
    NvmMstStoreAuditItemEntity *entityTemp = [temp objectAtIndex:indexPath.section];
    temp = [NSMutableArray array];
    for (NvmMstStoreAuditItemEntity *entity in self.tableviewSourceArr) {
        if ([entity.PARENT_ITEM_NO isEqualToString:entityTemp.PARENT_ITEM_NO]) {
            [temp addObject:entity];
        }
    }
    entityTemp = [temp objectAtIndex:indexPath.row];
    
    
    int index = 1;
    for (NvmMstStoreAuditItemEntity *entity in self.tableviewSourceArr) {
        if ([entity.ITEM_ID isEqualToString:entityTemp.ITEM_ID])
            break;
        index += 1;
    }
    msvc.No = index;
    msvc.subTitleNo = entityTemp.ITEM_NO;
    msvc.item_id = entityTemp.ITEM_ID;
    msvc.item_name = entityTemp.ITEM_NAME_CN;
    msvc.isSpecial = entityTemp.DATA_SOURCE;
    msvc.item_description = entityTemp.ITEM_DESCRIPTION_CN;
    msvc.parentTitle = entityTemp.PARENT_ITEM_NAME_CN;
    msvc.maxPicCount = entityTemp.PHOTO_NUM;
    msvc.mustComment = entityTemp.MUST_COMMENT;
    msvc.standardScore = entityTemp.STANDARD_SCORE;
    if (SYSLanguage == EN) {
        msvc.item_name = entityTemp.ITEM_NAME_EN;
        msvc.parentTitle = entityTemp.PARENT_ITEM_NAME_EN;
        msvc.item_description = entityTemp.ITEM_DESCRIPTION_EN;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.navigationController pushViewController:msvc animated:YES];
    [temp removeAllObjects];
    temp = nil;
}

- (void)upload {

    self.waitView.hidden = NO;
    [self.resultArr removeAllObjects];
    [self.resultPicArr removeAllObjects];
    
    NSString *sql = [NSString stringWithFormat:@"select a.*,c.PHOTO_NUM,c.ITEM_NAME_EN,c.SCORE_OPTION,(select count(1) from nvm_ist_storeaudit_CHECK_PHOTO b  where b.storeaudit_CHECK_ID = a.STOREAUDIT_CHECK_ID and b.item_ID = a.iteM_ID) TOTAL from NVM_IST_STOREAUDIT_CHECK_DETAIL a left join nvm_mst_storeAUDIT_ITEM c on a.item_ID = c.item_ID  where a.STOREAUDIT_CHECK_ID = '%@' and a.ITEM_ID in (select ITEM_ID from nvm_mst_storeAUDIT_ITEM) ORDER BY a.ITEM_NO",[CacheManagement instance].currentVMCHKID];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
    
    while ([rs next]){
        VMAuditScoreEntity* checkScoreEntity = [[VMAuditScoreEntity alloc]initWithFMResultSet:rs];
        [self.resultArr addObject:checkScoreEntity];
    }
    [rs close];
    
    
    for (VMAuditScoreEntity* checkScoreEntity in self.resultArr) {
        
        NSString* sql  = [NSString stringWithFormat:@"select a.PHOTO_PATH,a.COMMENT,b.MUST_COMMENT from NVM_IST_STOREAUDIT_CHECK_PHOTO a left join NVM_MST_STOREAUDIT_ITEM b on a.ITEM_ID = b.ITEM_ID where a.STOREAUDIT_CHECK_ID = '%@' and a.ITEM_ID = '%@' ",checkScoreEntity.STOREAUDIT_CHECK_ID,checkScoreEntity.ITEM_ID];
        FMResultSet* rs2 = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
        NSMutableArray *temp = [NSMutableArray array];
        while ([rs2 next]) {
            NSString *path = [NSString stringWithFormat:@"%@",[rs2 stringForColumn:@"PHOTO_PATH"]];
            NSString *comment = [NSString stringWithFormat:@"%@",[rs2 stringForColumn:@"COMMENT"]];
            if (![path.lowercaseString containsString:@"null"]&&path.length > 8) {
                VMStoreAuditPhotoEntity *entity = [[VMStoreAuditPhotoEntity alloc] init];
                entity.photoComment = comment;
                entity.photoPath = path;
                [self.resultPicArr addObject:path];
                [temp addObject:entity];
            }
        }
        checkScoreEntity.PHOTO_PATHS = [NSArray arrayWithArray:temp];
        [rs2 close];
    }
    
    // 制作xml 文件
    XMLFileManagement * xmlcon = [[XMLFileManagement alloc] init];
    NSString *extractedExpr = [xmlcon CreateStoreAuditCheckString:self.resultArr
                                                      WorkEndTime:[Utilities DateTimeNow]
                                              STOREAUDIT_CHECK_ID:[CacheManagement instance].currentVMCHKID
                                                    WorkStartTime:[Utilities DateTimeNow]
                                                        StoreCode:[CacheManagement instance].currentStore.StoreCode
                                                       submittime:[Utilities DateTimeNow]
                                                         WorkDate:[Utilities DateNow]
                                                       TotalScore:@""];
    NSString* xmlString =   extractedExpr;
    if ([CacheManagement instance].uploaddata == YES)
    {
        [self.uploadManage uploadVMRailCheckFileToServer:xmlString
                                          fileType:kVMXmlUploadAudit
                                    andfilePathArr:self.resultPicArr
                                    andxmlPath:[NSString stringWithFormat:@"%@/%@/%@",[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode]];
    }
    else if([CacheManagement instance].uploaddata == NO)
    {
        // 更新本地事项状态
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        NSString* sql_ = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET STOREAUDITCHECK = '%@' where WORKMAINID = '%@'",@"1",[CacheManagement instance].currentWorkMainID];
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
            NSString* cachePath = [rs stringForColumn:@"AUDIT_XML_PATH"];
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
            NSString* picpath = [NSString stringWithFormat:@"%@/%@/%@/%@",[Utilities SysDocumentPath],CurrentDate,[CacheManagement instance].currentStore.StoreCode,@"StoreAudit"];
            NSString* update_sql = [NSString stringWithFormat:@"UPDATE NVM_FILE_LIST SET AUDIT_PIC_PATH = '%@',AUDIT_XML_PATH='%@' WHERE STORE_CODE = '%@' AND CREATE_DATE = '%@' AND USER_ID = '%@'",picpath,cachePath,[CacheManagement instance].currentStore.StoreCode,CurrentDate,[CacheManagement instance].currentUser.UserId];
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
            NSString* picpath = [NSString stringWithFormat:@"%@/%@/%@/%@",[Utilities SysDocumentPath],CurrentDate,[CacheManagement instance].currentStore.StoreCode,@"StoreAudit"];
            NSString *insert_sql = [NSString stringWithFormat:@"INSERT INTO NVM_FILE_LIST (STORE_CODE,CREATE_DATE,AUDIT_PIC_PATH,STORE_NAME,USER_ID,AUDIT_XML_PATH) values (?,?,?,?,?,?)"];
            [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:insert_sql,[CacheManagement instance].currentStore.StoreCode,CurrentDate,picpath,[CacheManagement instance].currentStore.StoreName,[CacheManagement instance].currentUser.UserId,cachePath];
        }
        Uploadstatu = 1;
        self.waitView.hidden = YES;
        [self.navigationController popViewControllerAnimated:YES];

    }
    
}

- (void)completeUploadServer:(NSString *)error {
    self.waitView.hidden = YES;
    if ([error length] == 0)
    {
        Uploadstatu = 1;
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET STOREAUDITCHECK = '%@' where WORKMAINID = '%@'",@"2",[CacheManagement instance].currentWorkMainID];
        [db executeUpdate:sql];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [HUD showUIBlockingIndicatorWithText:error withTimeout:2];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self upload];
    }
}

- (void)showUploadAlert {
    
    if (!finish) {
        ALERTVIEW(SYSLanguage?@"Please finish all items": @"还有未完成项，请继续填写");
        return;
    }
    
    NSString* title = @"是否确定上传";
    if (SYSLanguage == EN) {
        title = @"Are you sure to upload ?";
    }

    UIAlertView* av = [[UIAlertView alloc]initWithTitle:title message:nil delegate:self cancelButtonTitle:SYSLanguage?@"Cancel": @"取消" otherButtonTitles:SYSLanguage?@"Sure": @"确定", nil];
    [av show];
}


@end
