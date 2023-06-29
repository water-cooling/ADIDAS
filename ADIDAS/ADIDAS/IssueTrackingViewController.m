//
//  IssueTrackingViewController.m
//  MobileApp
//
//  Created by 桂康 on 2020/12/2.
//

#import "IssueTrackingViewController.h"
#import "CommonUtil.h"
#import "IssueTrackingView.h"
#import "UIImageView+YYWebImage.h"
#import "UIViewController+MJPopupViewController.h"
#import "CommonDefine.h"
#import "Utilities.h"
#import "SqliteHelper.h"
#import "XMLFileManagement.h"

@interface IssueTrackingViewController ()<TapImageDelegate,UIScrollViewDelegate>

@end

@implementation IssueTrackingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    self.uploadManage = [[UploadManagement alloc] init];
    self.uploadManage.delegate = self;
    
    CGRect bfra = self.bgView.frame;
    bfra.origin.y = PHONE_WIDTH + 100;
    bfra.size.height = PHONE_HEIGHT - 90 ;
    self.bgView.frame = bfra;
    
    viewArrays = [NSMutableArray array];
    self.bgScrollView.contentSize = CGSizeMake(PHONE_WIDTH*[self getDataSource].count, 0);
    self.bgScrollView.delegate = self ;
    for (int x = 0 ; x < [[self getDataSource] count]; x++) {
        NSArray *nibarray = [[NSBundle mainBundle] loadNibNamed:@"IssueTrackingView" owner:self options:nil];
        IssueTrackingView *track = (IssueTrackingView *)nibarray.firstObject;
        track.trackingId = [NSString stringWithFormat:@"%@",[[[self getDataSource] objectAtIndex:x] valueForKey:@"IST_ISSUE_TRACKING_LIST_ID"]];
        track.delegate = self ;
        track.index = x;
        [track refreshView];
        [viewArrays addObject:track];
        
        CGRect frame = track.frame ;
        frame.origin.x = x*PHONE_WIDTH ;
        frame.origin.y = 0 ;
        frame.size.width = PHONE_WIDTH;
        frame.size.height = self.bgScrollView.frame.size.height;
        track.frame = frame ;
        [self.bgScrollView addSubview:track];
    }
    self.bottomPageControl.numberOfPages = [self getDataSource].count;
    
    CGRect iframe = self.imageBGView.frame ;
    iframe.size.width = PHONE_WIDTH;
    iframe.size.height = PHONE_HEIGHT;
    self.imageBGView.frame = iframe;
    
    statusDic = [NSMutableDictionary dictionaryWithDictionary:@{@"0":@"1"}];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    CGPoint contentPoint = scrollView.contentOffset ;
    self.bottomPageControl.currentPage = contentPoint.x/PHONE_WIDTH ;
    if (statusDic) {
        [statusDic setValue:@"1" forKey:[NSString stringWithFormat:@"%d",(int)self.bottomPageControl.currentPage]];
    }
}

- (NSArray *) getInitialData {
    
    NSString *sql = [NSString stringWithFormat:@"select * from NVM_IST_ISSUE_TRACKING_ITEM_LIST where ISSUE_TRACKING_CHECK_ID ='%@'",self.trackingCheckId];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    NSMutableArray *item_lists = [NSMutableArray array];
    while ([rs next])
    {
        NSMutableDictionary *item = [NSMutableDictionary dictionary];
        [item setValue:[NSString stringWithFormat:@"%@",[rs stringForColumn:@"IST_ISSUE_TRACKING_LIST_ID"]] forKey:@"IST_ISSUE_TRACKING_LIST_ID"];
        [item setValue:[NSString stringWithFormat:@"%@",[rs stringForColumn:@"ISSUE_TRACKING_CHECK_ID"]] forKey:@"ISSUE_TRACKING_CHECK_ID"];
        [item setValue:[NSString stringWithFormat:@"%@",[rs stringForColumn:@"COMMENT"]] forKey:@"COMMENT"];
        [item setValue:[NSString stringWithFormat:@"%@",[rs stringForColumn:@"INITIAL_PHOTO_PATH"]] forKey:@"INITIAL_PHOTO_PATH"];
        [item setValue:[NSString stringWithFormat:@"%@",[rs stringForColumn:@"ISSUE_TYPE"]] forKey:@"ISSUE_TYPE"];
        [item setValue:[NSString stringWithFormat:@"%@",[rs stringForColumn:@"IST_ISSUE_PHOTO_LIST_ID"]] forKey:@"IST_ISSUE_PHOTO_LIST_ID"];
        [item setValue:[NSString stringWithFormat:@"%@",[rs stringForColumn:@"STATUS"]] forKey:@"STATUS"];
        [item setValue:[NSString stringWithFormat:@"%@",[rs stringForColumn:@"TRACKING_COMMENT"]] forKey:@"TRACKING_COMMENT"];
        [item setValue:[NSString stringWithFormat:@"%@",[rs stringForColumn:@"TRACKING_STATUS"]] forKey:@"TRACKING_STATUS"];
        [item setValue:[NSString stringWithFormat:@"%@",[rs stringForColumn:@"TRACKING_TIME"]] forKey:@"TRACKING_TIME"];
        [item setValue:[NSString stringWithFormat:@"%@",[rs stringForColumn:@"USER_NAME_CN"]] forKey:@"USER_NAME_CN"];
        [item setValue:[NSString stringWithFormat:@"%@",[rs stringForColumn:@"REMARK"]] forKey:@"REMARK"];
        [item_lists addObject:item];
    }
    return item_lists;
}

- (NSArray *) getDataSource {
    
    if (!dataSourceArray || dataSourceArray.count == 0) {
        dataSourceArray = [NSArray arrayWithArray:[self getInitialData]];
    }
    return dataSourceArray;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [UIView animateWithDuration:0.4 animations:^{
        CGRect bfra = self.bgView.frame;
        bfra.origin.y = PHONE_HEIGHT - bfra.size.height;
        self.bgView.frame = bfra;
    } completion:^(BOOL finished) {
    }];
}

- (void)showDetailImageView:(NSString *)path {
    if (path&&![path isEqual:[NSNull null]]) {
        [self.detailImageView yy_setImageWithURL:[NSURL URLWithString:path] placeholder:nil] ;
        [self presentPopupView:self.imageBGView];
    }
}

- (void)inputNewRemarkWithIndex:(NSUInteger)index {
    dataSourceArray = nil;
    if ([self getDataSource].count > index) {
        UIAlertController *others = [UIAlertController alertControllerWithTitle:nil message:@"请输入最新备注" preferredStyle:UIAlertControllerStyleAlert];
        [others addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入备注";
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            NSDictionary *dic = [[self getDataSource] objectAtIndex:index];
            textField.text = [dic valueForKey:@"REMARK"]?[NSString stringWithFormat:@"%@",[dic valueForKey:@"REMARK"]]:@"";
        }];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (others.textFields.count && others.textFields.firstObject.text.length > 0) {
                NSDictionary *selectedDic = [[self getDataSource] objectAtIndex:index];
                NSString *photo_list_id = [NSString stringWithFormat:@"%@",[selectedDic valueForKey:@"IST_ISSUE_TRACKING_LIST_ID"]];
                NSString *sql = [NSString stringWithFormat:@"update NVM_IST_ISSUE_TRACKING_ITEM_LIST set remark = '%@' where IST_ISSUE_TRACKING_LIST_ID ='%@' ",others.textFields.firstObject.text,photo_list_id];
                FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
                [db executeUpdate:sql];
                IssueTrackingView *view = [viewArrays objectAtIndex:index];
                [view refreshView];
            } else {
                 ALERTVIEW(@"请输入备注");
            }
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [others addAction:cancel];[others addAction:ok];
        [self presentViewController:others animated:YES completion:nil];
    }
}

- (IBAction)cancelAction:(id)sender {
    
    [UIView animateWithDuration:0.4 animations:^{
        CGRect bfra = self.bgView.frame;
        bfra.origin.y = PHONE_HEIGHT;
        self.bgView.frame = bfra;
    } completion:^(BOOL finished) {
        [self dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (IBAction)submitAction:(id)sender {
    
    NSString *showMsg = @"提交后不可再更改，是否确认提交?" ;
    if (statusDic&&[[statusDic allKeys] count] != [[self getDataSource] count]) {
        showMsg = @"当前没有完整查看每个页面，提交后不可再更改，是否确认提交?" ;
    }
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:showMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [UIView animateWithDuration:0.4 animations:^{
            CGRect bfra = self.bgView.frame;
            bfra.origin.y = PHONE_HEIGHT;
            self.bgView.frame = bfra;
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:NO completion:nil];
        }];
        
        NSString *sql = [NSString stringWithFormat:@"update NVM_IST_ISSUE_TRACKING_CHECK set STATUS = '1' where ISSUE_TRACKING_CHECK_ID ='%@' ",self.trackingCheckId];
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        [db executeUpdate:sql];
        [self createXMLData];
    }];
    [ac addAction:cancel];
    [ac addAction:action];
    [self presentViewController:ac animated:YES completion:nil];
}

- (IBAction)disappearView:(id)sender {
    [self cancelAction:nil];
}

- (void)createXMLData {
    
    XMLFileManagement * xmlcon = [[XMLFileManagement alloc] init];
    NSString* xmlString = [xmlcon CreateIssueTarckingWithItems:[self getInitialData]];
    
    if ([CacheManagement instance].uploaddata == YES)
    {
        [HUD showUIBlockingIndicatorWithText:SYSLanguage?@"submitting...":@"上传中"];
        [self.uploadManage uploadVMRailCheckFileToServer:xmlString
                                              fileType:kIssueTrackingConfirm
                                        andfilePathArr:@[]
                                            andxmlPath:[NSString stringWithFormat:@"%@/%@/%@",[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode]];
        return;
    }
    
    
    
    NSString *CurrentDate = [Utilities DateNow] ;
    NSString* DateSql  = [NSString stringWithFormat:@"select CHECK_IN_TIME from IST_WORK_MAIN where WORK_MAIN_ID = '%@'",[CacheManagement instance].currentWorkMainID];
    FMResultSet* DateResult = [[SqliteHelper shareCommonSqliteHelper] selectResult:DateSql];
    if ([DateResult next]) {
        CurrentDate = [[DateResult stringForColumn:@"CHECK_IN_TIME"] substringToIndex:10];
    }
    
    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM NVM_FILE_LIST WHERE STORE_CODE = '%@' AND CREATE_DATE = '%@' AND USER_ID = '%@'",[CacheManagement instance].currentStore.StoreCode,CurrentDate,[CacheManagement instance].currentUser.UserId];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
    if ([rs next]) {
        NSString* cachePath = [rs stringForColumn:@"ISSUE_TRACKING_XML_PATH"];
        NSFileManager* fileMannager = [NSFileManager defaultManager];
        if ([cachePath length] < 5) {
            cachePath = [NSString stringWithFormat:kXmlPathString,[Utilities SysDocumentPath],CurrentDate,[CacheManagement instance].currentStore.StoreCode,[Utilities GetUUID]];
            if(![fileMannager fileExistsAtPath:cachePath])
            {
                [fileMannager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
        } else {
            NSString *newfi = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[cachePath componentsSeparatedByString:@"/dataCaches"] lastObject]];
            cachePath = newfi ;
        }
        [fileMannager removeItemAtPath:cachePath error:nil];
        NSData* xmlData = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
        [xmlData writeToFile:cachePath atomically:YES];
        // 数据库存在记录 update
        NSString* update_sql = [NSString stringWithFormat:@"UPDATE NVM_FILE_LIST SET ISSUE_TRACKING_XML_PATH='%@' WHERE STORE_CODE = '%@' AND CREATE_DATE = '%@' AND USER_ID = '%@'",cachePath,[CacheManagement instance].currentStore.StoreCode,CurrentDate,[CacheManagement instance].currentUser.UserId];
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        [db executeUpdate:update_sql];
    } else {
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
        NSString *insert_sql = [NSString stringWithFormat:@"INSERT INTO NVM_FILE_LIST (STORE_CODE,CREATE_DATE,STORE_NAME,USER_ID,ISSUE_TRACKING_XML_PATH) values (?,?,?,?,?)"];
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:insert_sql,[CacheManagement instance].currentStore.StoreCode,CurrentDate,[CacheManagement instance].currentStore.StoreName,[CacheManagement instance].currentUser.UserId,cachePath];
    }
}

- (void)completeUploadServer:(NSString *)error {
    if ([error length] == 0) {
        [HUD showUIBlockingSuccessIndicatorWithText:@"上传成功" withTimeout:2.5];
        NSString* sql = [NSString stringWithFormat:@"select * from NVM_IST_ISSUE_TRACKING_CHECK where STORE_CODE ='%@' and USER_ID= '%@' and STATUS = '1'",[CacheManagement instance].currentStore.StoreCode,[CacheManagement instance].currentUser.UserId];
        FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
        NSString *check_id = @"" ;
        if ([rs next]) {
            check_id = [rs stringForColumn:@"ISSUE_TRACKING_CHECK_ID"];
        }
        [rs close];
        if (check_id&&![check_id isEqual:[NSNull null]]&&![check_id isEqualToString:@""]) {
            FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
            [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:[NSString stringWithFormat:@"DELETE FROM NVM_IST_ISSUE_TRACKING_CHECK WHERE ISSUE_TRACKING_CHECK_ID = '%@'",check_id]];
            [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:[NSString stringWithFormat:@"DELETE FROM NVM_IST_ISSUE_TRACKING_ITEM_LIST WHERE ISSUE_TRACKING_CHECK_ID = '%@'",check_id]];
        }
    } else {
        [HUD showUIBlockingIndicatorWithText:error withTimeout:2];
    }
}

@end
