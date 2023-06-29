//
//  VMCheckINViewController.m
//  ADIDAS
//
//  Created by wendy on 14-8-28.
//
//

#import "VMCheckINViewController.h"
#import "CommonDefine.h"
#import "Utilities.h"
#import "ASIHTTPRequest.h"
#import "CacheManagement.h"
#import "NSString+SBJSON.h"
#import "StoreListViewController.h"
#import "VMStoreMenuViewController.h"
#import "PhotoViewController.h"
#import "SqliteHelper.h"
#import "CommonUtil.h"

@interface VMCheckINViewController ()

@end

@implementation VMCheckINViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)takeStorePic
{
//    if (self.hasStorePic == YES)
//    {
//        return;
//    }
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    self.photoPicker = [[UIImagePickerController alloc]init];
    self.photoPicker.sourceType = sourceType;
    self.photoPicker.delegate = self;
    self.photoPicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:self.photoPicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.storeimageview.image = image;
    NSString* picstring = [NSString stringWithFormat:@"%@.jpg",[CacheManagement instance].currentStore.StoreCode];
    NSString* path = [NSString stringWithFormat:@"%@/Library/Caches/images/%@", NSHomeDirectory(), picstring];
    
    NSFileManager* fileMannager = [NSFileManager defaultManager];
    if(![fileMannager fileExistsAtPath:path])
    {
        [fileMannager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }

    [Utilities saveImage:image imgPath:path];
    self.StorePicString = path;
    [self dismissViewControllerAnimated:YES completion:nil];
    [HUD showUIBlockingIndicator];
    [self uploadSignFile:path];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)uploadSignFile:(NSString* )picpath
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
      
        NSString* urlString = [NSString stringWithFormat:kUploadSignature,kWebDataString,[CacheManagement instance].userLoginName,@""];
        NSURL *url = [NSURL URLWithString:urlString];
        
        ASIFormDataRequest* _fileRequest = [ASIFormDataRequest requestWithURL:url];
        [_fileRequest setValidatesSecureCertificate:NO];
        [_fileRequest setRequestMethod:@"POST"];
        [_fileRequest addRequestHeader:@"Accept" value:@"application/json"];
        [_fileRequest addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];

        if ([CacheManagement instance].userEncode&&![[CacheManagement instance].userEncode isEqualToString:@""])
            [_fileRequest addRequestHeader:@"Authorization"
                                  value:[NSString stringWithFormat:@"Basic %@",[CacheManagement instance].userEncode]];
        
        [_fileRequest setTimeOutSeconds:200];
        NSFileManager* filemananger = [NSFileManager defaultManager];

        if ([filemananger fileExistsAtPath:picpath])
        {
            [_fileRequest setFile:picpath forKey:[[picpath componentsSeparatedByString:@"/"]lastObject]];
        }
        [_fileRequest startSynchronous];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = [_fileRequest error];
            NSString *response = nil;
            if (!error)
            {
                response = [_fileRequest responseString];
                if (![response JSONValue]) {
                    response = [AES128Util AES128Decrypt:[_fileRequest responseString] key:[CommonUtil getDecryKey:[CacheManagement instance].currentDBUser.userName]]  ;
                }
                if([[[response JSONValue]objectForKey:@"CheckError"]length] == 0)
                {
                    [HUD hideUIBlockingIndicator];
                }
                else
                {
                    [HUD hideUIBlockingIndicator];
                    [HUD showUIBlockingIndicatorWithText:[error description] withTimeout:2];
                }
            }
            else
            {
                [HUD hideUIBlockingIndicator];
                [HUD showUIBlockingIndicatorWithText:[error description] withTimeout:2];
            }
        });
    });
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [HUD showUIBlockingIndicator];
    [self signIn];
    
    self.hasStorePic = NO;
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(takeStorePic)];
    [self.storeimageview addGestureRecognizer:tap];
    
    NSString* imagePathString = [NSString stringWithFormat:@"%@/Library/Caches/images/%@.jpg", NSHomeDirectory(), [CacheManagement instance].currentStore.StoreCode];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePathString])
    {
        self.storeimageview.image = [UIImage imageWithContentsOfFile:imagePathString];
        [self getStorePicUrl];
    }
    
    self.title = @"签到";
    if (SYSLanguage == EN)
    {
        self.title = @"Check In";
        [self.checkInbtn setTitle:@"Check In" forState:UIControlStateNormal];
        self.codeTitle.text = @"POS";
        self.nameTitle.text = @"Store Name";
        self.addressTitle.text = @"Address";
        self.historyTitle.text = @"History of Check In";
    }
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    }
    //    [self.checkInbtn addTarget:self action:@selector(checkIn) forControlEvents:UIControlEventTouchUpInside];
    
    self.storecodeLabel.text = [CacheManagement instance].currentStore.StoreCode;
    self.storenameLabel.text = [CacheManagement instance].currentStore.StoreName;
    self.storeAddress.text   = [CacheManagement instance].currentStore.StoreAddress;
    [self getLastIssueTracking];
}

-(void)downloadImage:(NSString*)string
{
    // 先判断本地是否有缓存
    NSString* imagePathString = [NSString stringWithFormat:@"%@/Library/Caches/images/%@", NSHomeDirectory(), [[string componentsSeparatedByString:@"/"] lastObject]];
   
        if ([[NSFileManager defaultManager] fileExistsAtPath:imagePathString])
        {// remove 0 size file
            NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:imagePathString error:nil];
            unsigned long long fileSize = [attributes fileSize];
            if (fileSize  == 0 ) {
                [[NSFileManager defaultManager] removeItemAtPath:imagePathString error:nil];
            } else {
                [self.storeimageview setImage:[UIImage imageWithContentsOfFile:imagePathString]];
                return;
            }
        }
    
    __block NSData* data;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString* urlstring = [NSString stringWithFormat:@"%@%@",kWebMobileHeadString,string];
        data = [self sendHttpRequest:urlstring];
        [[NSFileManager defaultManager] createDirectoryAtPath:imagePathString withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:imagePathString error:nil];
        
        [[NSFileManager defaultManager] createFileAtPath:imagePathString contents:data attributes:nil];
        dispatch_async(dispatch_get_main_queue(),^{
            if ([data length] > 1000) [self.storeimageview setImage:[UIImage imageWithData:data]];
        });
    });
}


-(NSData*) sendHttpRequest:(NSString *) urlString
{
    ASIHTTPRequest*  request = nil;
    NSString* urlstr = urlString;
    NSURL *url = [NSURL URLWithString:[urlstr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    
    request = [[ASIHTTPRequest alloc]initWithURL:url];
    [request setValidatesSecureCertificate:NO];
    
    //添加ISA 密文验证
    if ([CacheManagement instance].userEncode&&![[CacheManagement instance].userEncode isEqualToString:@""])
        [request addRequestHeader:@"Authorization"
                        value:[NSString stringWithFormat:@"Basic %@",[CacheManagement instance].userEncode]];
    
	[request startSynchronous];
    NSError *error = [request error];
    NSData *response = nil;
    if (!error) {
        response = [request responseData];
    }
    return response;
}

-(void)getStorePicUrl
{
    __block NSDictionary* response = nil;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString* urlString = [NSString stringWithFormat:kGetStorePic,kWebDataString,[CacheManagement instance].userLoginName,[CacheManagement instance].currentStore.StoreCode];
        NSURL* url = [NSURL URLWithString:urlString];
        ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
        [request setValidatesSecureCertificate:NO];
        [request setRequestMethod:@"GET"];
        [request addRequestHeader:@"Accept" value:@"application/json"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        
        //添加ISA 密文验证
        if ([CacheManagement instance].userEncode&&![[CacheManagement instance].userEncode isEqualToString:@""])
            [request addRequestHeader:@"Authorization"
                            value:[NSString stringWithFormat:@"Basic %@",[CacheManagement instance].userEncode]];
        [request setTimeOutSeconds:40];
        [request startSynchronous];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSError *error = [request error];
            if (!error) {
                
                if (![[request responseString] JSONValue]) {
                    NSString *aesString = [AES128Util AES128Decrypt:[request responseString] key:[CommonUtil getDecryKey:[CacheManagement instance].currentDBUser.userName]]  ;
                    response = [aesString JSONValue] ;
                }else {
                    response = [[request responseString] JSONValue];
                }

                if (![[response objectForKey:@"StorePic"] isKindOfClass:[NSNull class]]) {
                    
                    self.StorePicString = [response objectForKey:@"StorePic"];
                   
                    if ([self.StorePicString length] > 7) {
                        self.hasStorePic = YES;
                        [self downloadImage:self.StorePicString];
                    }
                }
                else {
                    
                    self.hasStorePic = NO;
                }
            }
        });
    });
}

- (void) getLastIssueTracking {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString* urlString = [NSString stringWithFormat:kIssueTrackingByStoreCode,kWebDataString,[CacheManagement instance].currentStore.StoreCode,[CacheManagement instance].userLoginName];
        NSURL* url = [NSURL URLWithString:urlString];
        ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
        [request setValidatesSecureCertificate:NO];
        [request setRequestMethod:@"GET"];
        [request addRequestHeader:@"Accept" value:@"application/json"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        [request setTimeOutSeconds:430];
        [request startSynchronous];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [HUD hideUIBlockingIndicator];
            NSError *error = [request error];
            NSString* response = nil;
            if (!error)
            {
                response = [request responseString];
                NSArray *resAry = nil ;
                if (![response JSONValue]) {
                    NSString *aesString = [AES128Util AES128Decrypt:response key:[CommonUtil getDecryKey:[CacheManagement instance].currentDBUser.userName]]  ;
                    resAry = [aesString JSONValue] ;
                }else {
                    resAry = [response JSONValue];
                }
                
                if (resAry&&[resAry count] > 0) {
                    NSString* sql = [NSString stringWithFormat:@"select * from NVM_IST_ISSUE_TRACKING_CHECK where STORE_CODE ='%@' and USER_ID= '%@'",[CacheManagement instance].currentStore.StoreCode,[CacheManagement instance].currentUser.UserId];
                    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
                    NSString *currentTrackId = [Utilities GetUUID];
                    if ([rs next]) {
                        currentTrackId = [rs stringForColumnIndex:0];
                        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
                        sql = [NSString stringWithFormat:@"select * from NVM_IST_ISSUE_TRACKING_ITEM_LIST where ISSUE_TRACKING_CHECK_ID ='%@'",currentTrackId];
                        FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
                        NSMutableArray *photo_list_ids = [NSMutableArray array];
                        while ([rs next])
                        {
                            [photo_list_ids addObject:[rs stringForColumn:@"IST_ISSUE_PHOTO_LIST_ID"]];
                        }
                        
                        [db beginTransaction];
                        
                        BOOL result = YES;
                        @try
                        {
                            NSMutableArray *exit_ids = [NSMutableArray array];
                            for (NSDictionary *dic in resAry) {
                                BOOL exist = false ;
                                for (NSString *photo_list_id in photo_list_ids) {
                                    if ([photo_list_id isEqualToString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"IST_ISSUE_PHOTO_LIST_ID"]]]) {
                                        NSString* sql_ = [NSString stringWithFormat:@"UPDATE NVM_IST_ISSUE_TRACKING_ITEM_LIST SET COMMENT='%@',INITIAL_PHOTO_PATH='%@',ISSUE_TYPE='%@',STATUS='%@',TRACKING_COMMENT='%@',TRACKING_TIME='%@',USER_NAME_CN='%@' where ISSUE_TRACKING_CHECK_ID = '%@' and IST_ISSUE_PHOTO_LIST_ID='%@' ",
                                                          [NSString stringWithFormat:@"%@",[dic valueForKey:@"COMMENT"]],
                                                          [NSString stringWithFormat:@"%@",[dic valueForKey:@"INITIAL_PHOTO_PATH"]],
                                                          [NSString stringWithFormat:@"%@",[dic valueForKey:@"ISSUE_TYPE"]],
                                                          [NSString stringWithFormat:@"%@",[dic valueForKey:@"STATUS"]],
                                                          [NSString stringWithFormat:@"%@",[dic valueForKey:@"TRACKING_COMMENT"]],
                                                          [NSString stringWithFormat:@"%@",[dic valueForKey:@"TRACKING_TIME"]],
                                                          [NSString stringWithFormat:@"%@",[dic valueForKey:@"USER_NAME_CN"]],
                                                          currentTrackId,
                                                          photo_list_id];
                                        [db executeUpdate:sql_];
                                        exist = true;
                                        [exit_ids addObject:photo_list_id];
                                        break;
                                    }
                                }
                                if (!exist) {
                                    NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_ISSUE_TRACKING_ITEM_LIST (IST_ISSUE_TRACKING_LIST_ID,ISSUE_TRACKING_CHECK_ID,COMMENT,INITIAL_PHOTO_PATH,ISSUE_TYPE,IST_ISSUE_PHOTO_LIST_ID,STATUS,TRACKING_COMMENT,TRACKING_STATUS,TRACKING_TIME,USER_NAME_CN,REMARK) values (?,?,?,?,?,?,?,?,?,?,?,?)"];
                                    [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql,
                                     [Utilities GetUUID],
                                     currentTrackId,
                                     [NSString stringWithFormat:@"%@",[dic valueForKey:@"COMMENT"]],
                                     [NSString stringWithFormat:@"%@",[dic valueForKey:@"INITIAL_PHOTO_PATH"]],
                                     [NSString stringWithFormat:@"%@",[dic valueForKey:@"ISSUE_TYPE"]],
                                     [NSString stringWithFormat:@"%@",[dic valueForKey:@"IST_ISSUE_PHOTO_LIST_ID"]],
                                     [NSString stringWithFormat:@"%@",[dic valueForKey:@"STATUS"]],
                                     [NSString stringWithFormat:@"%@",[dic valueForKey:@"TRACKING_COMMENT"]],
                                     [NSString stringWithFormat:@"%@",[dic valueForKey:@"TRACKING_STATUS"]],
                                     [NSString stringWithFormat:@"%@",[dic valueForKey:@"TRACKING_TIME"]],
                                     [NSString stringWithFormat:@"%@",[dic valueForKey:@"USER_NAME_CN"]],
                                     @""];
                                }
                            }
                            for (NSString *all_id in photo_list_ids) {
                                if (![exit_ids containsObject:all_id]) {
                                    NSString* sql_delete = [NSString stringWithFormat:@"delete from  NVM_IST_ISSUE_TRACKING_ITEM_LIST where ISSUE_TRACKING_CHECK_ID = '%@' or IST_ISSUE_PHOTO_LIST_ID = '%@'",currentTrackId,all_id];
                                    [[SqliteHelper shareCommonSqliteHelper] executeSQL:sql_delete];
                                }
                            }
                        }
                        @catch (NSException *e)
                        {
                            result = NO;
                        }
                        @finally
                        {
                            if(result==YES)
                            {
                                [db commit];
                            }
                            else
                            {
                                [db rollback];
                            }
                        }
                    }
                    else {
                        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
                        [db beginTransaction];
                        BOOL result = YES;
                        @try
                        {
                            NSString* storeCode = [CacheManagement instance].currentStore.StoreCode;
                            NSString* userid = [CacheManagement instance].currentUser.UserId;
                            NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_ISSUE_TRACKING_CHECK (ISSUE_TRACKING_CHECK_ID,STORE_CODE,STATUS,TRACKING_DATE,USER_ID) values (?,?,?,?,?)"];
                            [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
                             currentTrackId,
                             storeCode,
                             @"0",
                             @"",
                             userid];
                            
                            for (NSDictionary *dic in resAry) {
                                NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_ISSUE_TRACKING_ITEM_LIST (IST_ISSUE_TRACKING_LIST_ID,ISSUE_TRACKING_CHECK_ID,COMMENT,INITIAL_PHOTO_PATH,ISSUE_TYPE,IST_ISSUE_PHOTO_LIST_ID,STATUS,TRACKING_COMMENT,TRACKING_STATUS,TRACKING_TIME,USER_NAME_CN,REMARK) values (?,?,?,?,?,?,?,?,?,?,?,?)"];
                                [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql,
                                 [Utilities GetUUID],
                                 currentTrackId,
                                 [NSString stringWithFormat:@"%@",[dic valueForKey:@"COMMENT"]],
                                 [NSString stringWithFormat:@"%@",[dic valueForKey:@"INITIAL_PHOTO_PATH"]],
                                 [NSString stringWithFormat:@"%@",[dic valueForKey:@"ISSUE_TYPE"]],
                                 [NSString stringWithFormat:@"%@",[dic valueForKey:@"IST_ISSUE_PHOTO_LIST_ID"]],
                                 [NSString stringWithFormat:@"%@",[dic valueForKey:@"STATUS"]],
                                 [NSString stringWithFormat:@"%@",[dic valueForKey:@"TRACKING_COMMENT"]],
                                 [NSString stringWithFormat:@"%@",[dic valueForKey:@"TRACKING_STATUS"]],
                                 [NSString stringWithFormat:@"%@",[dic valueForKey:@"TRACKING_TIME"]],
                                 [NSString stringWithFormat:@"%@",[dic valueForKey:@"USER_NAME_CN"]],
                                 @""];
                            }
                        }
                        @catch (NSException *e)
                        {
                            result = NO;
                        }
                        @finally
                        {
                            if(result==YES)
                            {
                                [db commit];
                            }
                            else
                            {
                                [db rollback];
                            }
                        }
                    }
                    [rs close];
                }
            }
        });
    });
}

-(void)signIn {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString* urlString = [NSString stringWithFormat:kStoreSignIn,kWebDataString,[CacheManagement instance].userLoginName,[CacheManagement instance].currentStore.StoreCode];
        NSURL* url = [NSURL URLWithString:urlString];
        ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
        [request setValidatesSecureCertificate:NO];
        [request setRequestMethod:@"GET"];
        [request addRequestHeader:@"Accept" value:@"application/json"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        
        //添加ISA 密文验证
        if ([CacheManagement instance].userEncode&&![[CacheManagement instance].userEncode isEqualToString:@""])
            [request addRequestHeader:@"Authorization"
                            value:[NSString stringWithFormat:@"Basic %@",[CacheManagement instance].userEncode]];
        [request setTimeOutSeconds:430];
        [request startSynchronous];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [HUD hideUIBlockingIndicator];
            NSError *error = [request error];
            NSString* response = nil;
            if (!error)
            {
                response = [request responseString];
                
                if (![response JSONValue]) {
                    NSString *aesString = [AES128Util AES128Decrypt:response key:[CommonUtil getDecryKey:[CacheManagement instance].currentDBUser.userName]]  ;
                    self.returnArray = [aesString JSONValue] ;
                }else {
                    self.returnArray = [response JSONValue];
                }
                int j = (int)[self.returnArray count];
                
                int k = (j>5)?5:j;
                for (int i = 0; i<k;i ++)
                {
                    [self.view viewWithTag:i+1].hidden = NO;
                    ((UILabel*)[self.view viewWithTag:i+11]).text  = [[self.returnArray objectAtIndex:i]objectForKey:@"CHECK_IN_TIME"];
                }
            }
        });
    });
}


-(IBAction)checkIn {
    
    [self.superviewController UpdateWorkMain:[CacheManagement instance].currentStore];
    [CacheManagement instance].checkinTime = [Utilities DateTimeNow];
    
    [self tapCheckIn];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)tapCheckIn {
    
    [HUD showUIBlockingIndicator];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSString* urlString = [NSString stringWithFormat:@"%@Action=CheckIn&checkInTime=%@&workMainId=%@&account=%@&storeCode=%@&locationX=%@&locationY=%@&ActionType=en",kWebDataString,[CacheManagement instance].checkinTime,[CacheManagement instance].currentWorkMainID,[CacheManagement instance].userLoginName,[CacheManagement instance].currentStore.StoreCode,[CacheManagement instance].currentLocation.locationX,[CacheManagement instance].currentLocation.locationY];
        NSURL* url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
        [request setValidatesSecureCertificate:NO];
        [request setRequestMethod:@"GET"];
        [request addRequestHeader:@"Accept" value:@"application/json"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        
        //添加ISA 密文验证
       if ([CacheManagement instance].userEncode&&![[CacheManagement instance].userEncode isEqualToString:@""])
           [request addRequestHeader:@"Authorization"
                            value:[NSString stringWithFormat:@"Basic %@",[CacheManagement instance].userEncode]];
        [request setTimeOutSeconds:430];
        [request startSynchronous];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [HUD hideUIBlockingIndicator];
            NSError *error = [request error];
            NSString* response = nil;
            if (!error)
            {
                response = [request responseString];
                NSDictionary *result = nil;
                if (![response JSONValue]) {
                    NSString *aesString = [AES128Util AES128Decrypt:response key:[CommonUtil getDecryKey:[CacheManagement instance].currentDBUser.userName]]  ;
                    result = [aesString JSONValue] ;
                }else {
                    result = [response JSONValue];
                }
                
                if ([[result valueForKey:@"CheckFlag"] intValue] == 1) {
                    
                    NSString *pathStore = [NSString stringWithFormat:@"%@/storetypeforkid.plist",[Utilities SysDocumentPath]] ;
                    NSMutableDictionary *storeType = [NSMutableDictionary dictionaryWithContentsOfFile:pathStore];
                    if (!storeType) {
                        
                        storeType = [NSMutableDictionary dictionary];
                    }
                    
                    [storeType setValue:[[result valueForKey:@"DataSource"] isEqual:[NSNull null]]?@"":[result valueForKey:@"DataSource"] forKey:[CacheManagement instance].currentStore.StoreCode] ;
                    [storeType setValue:[[result valueForKey:@"ScoreCard"] isEqual:[NSNull null]]?@"":[result valueForKey:@"ScoreCard"] forKey:[NSString stringWithFormat:@"%@_ScoreCard",[CacheManagement instance].currentStore.StoreCode]] ;
                    [storeType writeToFile:pathStore atomically:YES];
                    
                    [CacheManagement instance].showScoreCard = [NSString stringWithFormat:@"%@",[result valueForKey:@"ScoreCard"]];
                    [CacheManagement instance].dataSource = [NSString stringWithFormat:@"%@",[result valueForKey:@"DataSource"]] ;
                    NSString* urlString = [NSString stringWithFormat:kStoreCheckOutSave,kWebDataString,
                                           [CacheManagement instance].currentStore.StoreCode,
                                           [CacheManagement instance].currentLocation.locationX,
                                           [CacheManagement instance].currentLocation.locationY,
                                           [CacheManagement instance].checkinTime,
                                           [CacheManagement instance].currentWorkMainID,
                                           [CacheManagement instance].userLoginName] ;
                    
                    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                    [ud setObject:urlString forKey:kSOLUTIONWORKMAINID] ;
                    [ud synchronize];
                    
                    AppDelegate *dele = (AppDelegate*)[UIApplication sharedApplication].delegate ;
                    [dele.SaveTimer setFireDate:[NSDate date]] ;
                    
                    VMStoreMenuViewController* storemvc = [[VMStoreMenuViewController alloc]initWithNibName:@"VMStoreMenuViewController" bundle:nil];
                    FromHistory = 0 ;
                    [self.navigationController pushViewController:storemvc animated:NO];
                }
                else {
                
                    [[[UIAlertView alloc] initWithTitle:@"提示" message:@"签入失败!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil] show];
                }
            }
        });
    });
}

@end
