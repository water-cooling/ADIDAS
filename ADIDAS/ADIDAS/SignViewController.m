//
//  SignViewController.m
//  VM
//
//  Created by leo.you on 14-7-31.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import "SignViewController.h"
#import "AppDelegate.h"
#import "Utilities.h"
#import "CommonDefine.h"
#import "ASIFormDataRequest.h"
#import "CacheManagement.h"
#import "NSString+SBJSON.h"
#import "SSZipArchive.h"
#import "SqliteHelper.h"
#import "CommonUtil.h"

@interface SignViewController ()

@end

@implementation SignViewController
#define degreesToRadians(x) (M_PI*(x)/180.0)

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)Back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)clear
{
    [self.signView clearStroks];
}

-(void)uploadSignFile:(NSString* )picpath
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //里面有中文。需要转化为NSUTF8StringEncoding
        NSString* urlString = [NSString stringWithFormat:kUploadSignature,kWebDataString,[CacheManagement instance].userLoginName,[CacheManagement instance].currentWorkMainID];
        if (self.isFromRailManage) {
            urlString = [NSString stringWithFormat:kUploadArsmSignature,kWebDataString,[CacheManagement instance].userLoginName,[CacheManagement instance].currentWorkMainID];
        }

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
        
        NSString* signname = [NSString stringWithFormat:@"%@_%@.jpg",[CacheManagement instance].currentWorkMainID,[Utilities DateTimeNowUpload]];
        if ([filemananger fileExistsAtPath:picpath])
        {
            [_fileRequest setFile:picpath forKey:signname];
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
                    Uploadstatu = 1;
                    FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
                    
                    NSString *columnName = @"SIGN" ;
                    
                    if (self.isFromRailManage) {
                        
                        columnName = @"ARSMSIGN" ;
                    }
                    
                    
                    NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET %@ = '2' where WORKMAINID = '%@'",columnName,[CacheManagement instance].currentWorkMainID];
                    [db executeUpdate:sql];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                else
                {
                    [HUD hideUIBlockingIndicator];
                    [HUD showUIBlockingIndicatorWithText:SYSLanguage?@"上传失败":@"Upload Failed" withTimeout:2];
                }
            }
            else
            {
                [HUD hideUIBlockingIndicator];
                [HUD showUIBlockingIndicatorWithText:SYSLanguage?@"Upload Failed":@"上传失败" withTimeout:2];
            }
        });
    });
}

-(IBAction)done
{
    if (!self.signView.isInputView) {
        
        [Utilities alertMessage:@"请输入签名!"];
        return ;
    }
    
    NSString *columnName = @"SIGN" ;
    NSString *filelist_columnName = @"SIGN_PATH" ;
    
    if (self.isFromRailManage) {
        
        columnName = @"ARSMSIGN" ;
        filelist_columnName = @"ARSMSIGN_PATH" ;
    }
    
    int Hlength = 65 ;
    
    if (DEVICE_WID == 320) {
        
        Hlength = 15 ;
    }
    
    if (DEVICE_WID == 414) {
     
        Hlength = 100 ;
    }
 
    
//    UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
    
    if ([CacheManagement instance].uploaddata == YES)
    {
        if (!ISFROMEHK) {
            
            NSFileManager* filemanager = [NSFileManager defaultManager];
            NSString* cachePath = [NSString stringWithFormat:@"%@/%@/%@/%@",[Utilities SysDocumentPath],UseCurrentDate,[CacheManagement instance].currentStore.StoreCode,columnName];

            if (!self.picImageView.image){
                
                [Utilities alertMessage:@"请拍摄合照照片!"];
                return ;
            }
            
            self.picImageView.hidden = YES ;
            
            [HUD showUIBlockingIndicator];
            
            UIGraphicsBeginImageContext(CGSizeMake(self.signView.frame.size.width+40,self.signView.frame.size.height+Hlength));
            [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            NSString* signpath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.jpg",[CacheManagement instance].currentWorkMainID,type_path]];
            
            if (![filemanager fileExistsAtPath:signpath])
            {
                [filemanager createDirectoryAtPath:signpath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            [filemanager removeItemAtPath:signpath error:nil];
            [UIImageJPEGRepresentation(viewImage, 1.0f) writeToFile:signpath atomically:YES];
            [self uploadSignFileNew:signpath];
        }
        else {
        
            [HUD showUIBlockingIndicator];
            
            UIGraphicsBeginImageContext(CGSizeMake(self.signView.frame.size.width+40,self.signView.frame.size.height+Hlength));
            [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            NSString* cachePath = [NSString stringWithFormat:@"%@/%@/%@",[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode];
            NSString* signpath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.jpg",[CacheManagement instance].currentWorkMainID,type_path]];
            
            NSFileManager* filemanager = [NSFileManager defaultManager];
            if (![filemanager fileExistsAtPath:signpath])
            {
                [filemanager createDirectoryAtPath:signpath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            [filemanager removeItemAtPath:signpath error:nil];
            [UIImageJPEGRepresentation(viewImage, 1.0f) writeToFile:signpath atomically:YES];
            [self uploadSignFile:signpath];
        }
    }
    else if([CacheManagement instance].uploaddata == NO)
    {
        if (!ISFROMEHK) {
            
            FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
            
            // 非几时上传 保存文件到本地
            NSString* sql_ = [NSString stringWithFormat:@"SELECT * FROM NVM_FILE_LIST WHERE STORE_CODE = '%@' AND CREATE_DATE = '%@' AND USER_ID = '%@'",[CacheManagement instance].currentStore.StoreCode,UseCurrentDate,[CacheManagement instance].currentUser.UserId];
            FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql_];
            if ([rs next] == YES)
            {
                NSString* signpath = [rs stringForColumn:filelist_columnName];
                if ([signpath length] < 10)
                {
                    NSString* cachePath = [NSString stringWithFormat:@"%@/%@/%@/%@",[Utilities SysDocumentPath],UseCurrentDate,[CacheManagement instance].currentStore.StoreCode,columnName];
                    signpath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.jpg",[CacheManagement instance].currentWorkMainID,type_path]];
                    
                }
                
                NSFileManager* filemanager = [NSFileManager defaultManager];

                if (!self.picImageView.image) {
                    
                    [Utilities alertMessage:@"请拍摄合照照片!"];
                    return ;
                }
                
                self.picImageView.hidden = YES ;
                
                NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET %@ = '%@' where WORKMAINID = '%@'",columnName,@"1",[CacheManagement instance].currentWorkMainID];
                [db executeUpdate:sql];
                
                if (![filemanager fileExistsAtPath:signpath])
                {
                    [filemanager createDirectoryAtPath:signpath withIntermediateDirectories:YES attributes:nil error:nil];
                }
                [filemanager removeItemAtPath:signpath error:nil];
                
                UIGraphicsBeginImageContext(CGSizeMake(self.signView.frame.size.width+40,self.signView.frame.size.height+Hlength));
                [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
                UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                [UIImageJPEGRepresentation(viewImage, 1.0f) writeToFile:signpath atomically:YES];
                
                // 数据库存在记录 update
                NSString* update_sql = [NSString stringWithFormat:@"UPDATE NVM_FILE_LIST SET %@ = '%@' WHERE STORE_CODE = '%@' AND CREATE_DATE = '%@' AND USER_ID = '%@'",filelist_columnName,signpath,[CacheManagement instance].currentStore.StoreCode,UseCurrentDate,[CacheManagement instance].currentUser.UserId];
                [db executeUpdate:update_sql];
                
            }
            else
            {
                NSString* cachePath = [NSString stringWithFormat:@"%@/%@/%@/%@",[Utilities SysDocumentPath],UseCurrentDate,[CacheManagement instance].currentStore.StoreCode,columnName];
                NSString* signpath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.jpg",[CacheManagement instance].currentWorkMainID,type_path]];
                NSFileManager* fileMannager = [NSFileManager defaultManager];
                
                
                if (!self.picImageView.image) {
                    
                    [Utilities alertMessage:@"请拍摄合照照片!"];
                    return ;
                }
                
                self.picImageView.hidden = YES ;
                
                NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET %@ = '%@' where WORKMAINID = '%@'",columnName,@"1",[CacheManagement instance].currentWorkMainID];
                [db executeUpdate:sql];
                
                
                if(![fileMannager fileExistsAtPath:signpath])
                {
                    [fileMannager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
                }
                [fileMannager removeItemAtPath:signpath error:nil];
                
                UIGraphicsBeginImageContext(CGSizeMake(self.signView.frame.size.width+40,self.signView.frame.size.height+Hlength));
                [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
                UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                [UIImageJPEGRepresentation(viewImage, 1.0f) writeToFile:signpath atomically:YES];
                // 不存在记录 insert
                NSString *insert_sql = [NSString stringWithFormat:@"INSERT INTO NVM_FILE_LIST (STORE_CODE,CREATE_DATE,STORE_NAME,USER_ID,%@) values (?,?,?,?,?)",filelist_columnName];
                [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:insert_sql,[CacheManagement instance].currentStore.StoreCode,UseCurrentDate,[CacheManagement instance].currentStore.StoreName,[CacheManagement instance].currentUser.UserId,signpath];
            }
            Uploadstatu = 1;
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
        
            UIGraphicsBeginImageContext(CGSizeMake(self.signView.frame.size.width+40,self.signView.frame.size.height+Hlength));
            [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
            UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
            NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET %@ = '%@' where WORKMAINID = '%@'",columnName,@"1",[CacheManagement instance].currentWorkMainID];
            [db executeUpdate:sql];
            
            NSString *CurrentDate = [Utilities DateNow] ;
            NSString* DateSql  = [NSString stringWithFormat:@"select CHECK_IN_TIME from IST_WORK_MAIN where WORK_MAIN_ID = '%@'",[CacheManagement instance].currentWorkMainID];
            
            
            FMResultSet* DateResult = [[SqliteHelper shareCommonSqliteHelper] selectResult:DateSql];
            if ([DateResult next]) {
                
                CurrentDate = [[DateResult stringForColumn:@"CHECK_IN_TIME"] substringToIndex:10];
            }
            
            
            // 非几时上传 保存文件到本地
            NSString* sql_ = [NSString stringWithFormat:@"SELECT * FROM NVM_FILE_LIST WHERE STORE_CODE = '%@' AND CREATE_DATE = '%@' AND USER_ID = '%@'",[CacheManagement instance].currentStore.StoreCode,CurrentDate,[CacheManagement instance].currentUser.UserId];
            FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql_];
            if ([rs next] == YES)
            {
                NSString* signpath = [rs stringForColumn:filelist_columnName];
                if ([signpath length] < 10)
                {
                    NSString* cachePath = [NSString stringWithFormat:@"%@/%@/%@",[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode];
                    signpath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.jpg",[CacheManagement instance].currentWorkMainID,type_path]];
                    
                }
                //            if ([cachePath length] < 10) {
                //                cachePath = [NSString stringWithFormat:kXmlPathString,[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,[Utilities GetUUID]];
                //                NSFileManager* fileMannager = [NSFileManager defaultManager];
                //                if(![fileMannager fileExistsAtPath:cachePath])
                //                {
                //                    [fileMannager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
                //                }
                //            }
                NSFileManager* filemanager = [NSFileManager defaultManager];
                if (![filemanager fileExistsAtPath:signpath])
                {
                    [filemanager createDirectoryAtPath:signpath withIntermediateDirectories:YES attributes:nil error:nil];
                }
                [filemanager removeItemAtPath:signpath error:nil];
                [UIImageJPEGRepresentation(viewImage, 1.0f) writeToFile:signpath atomically:YES];
                
                // 数据库存在记录 update
                NSString* update_sql = [NSString stringWithFormat:@"UPDATE NVM_FILE_LIST SET %@ = '%@' WHERE STORE_CODE = '%@' AND CREATE_DATE = '%@' AND USER_ID = '%@'",filelist_columnName,signpath,[CacheManagement instance].currentStore.StoreCode,CurrentDate,[CacheManagement instance].currentUser.UserId];
                [db executeUpdate:update_sql];
                
            }
            else
            {
                NSString* cachePath = [NSString stringWithFormat:@"%@/%@/%@",[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode];
                NSString* signpath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.jpg",[CacheManagement instance].currentWorkMainID,type_path]];
                NSFileManager* fileMannager = [NSFileManager defaultManager];
                if(![fileMannager fileExistsAtPath:signpath])
                {
                    [fileMannager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
                }
                [fileMannager removeItemAtPath:signpath error:nil];
                [UIImageJPEGRepresentation(viewImage, 1.0f) writeToFile:signpath atomically:YES];
                // 不存在记录 insert
                NSString *insert_sql = [NSString stringWithFormat:@"INSERT INTO NVM_FILE_LIST (STORE_CODE,CREATE_DATE,STORE_NAME,USER_ID,%@) values (?,?,?,?,?)",filelist_columnName];
                [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:insert_sql,[CacheManagement instance].currentStore.StoreCode,CurrentDate,[CacheManagement instance].currentStore.StoreName,[CacheManagement instance].currentUser.UserId,signpath];
            }
            Uploadstatu = 1;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (SYSLanguage == EN) {
        [self.clearButton setImage:[UIImage imageNamed:@"clearSign_en.png"] forState:UIControlStateNormal];
        [self.doneButton setImage:[UIImage imageNamed:@"uploadSign_en.png"] forState:UIControlStateNormal];
        [self.picButton setTitle:@"Take Photo" forState:UIControlStateNormal] ;
    }
    if (IOSVersion>=7.0)
    {
        self.signView = [[DrawTouchPointView alloc]initWithFrame:CGRectMake(20, 20, DEVICE_HEIGHT-40, 264)];
//        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    else
    {
        self.signView = [[DrawTouchPointView alloc]initWithFrame:CGRectMake(15, 15, DEVICE_HEIGHT-20, 264)];
//        self.bgimageview.frame = CGRectMake(-20, -20, DEVICE_HEIGHT, 320);
    }
    
    if (self.isFromRailManage) type_path = @"ARSMpath" ;
    else type_path = @"NORpath" ;
    
    if (!ISFROMEHK) {
        
        UseCurrentDate = [Utilities DateNow] ;
        NSString* DateSql  = [NSString stringWithFormat:@"select CHECK_IN_TIME from IST_WORK_MAIN where WORK_MAIN_ID = '%@'",[CacheManagement instance].currentWorkMainID];
        
        FMResultSet* DateResult = [[SqliteHelper shareCommonSqliteHelper] selectResult:DateSql];
        if ([DateResult next]) {
            
            UseCurrentDate = [[DateResult stringForColumn:@"CHECK_IN_TIME"] substringToIndex:10];
        }
        
        self.picImageView.hidden = NO ;
        self.picButton.hidden = NO ;
        
//        NSString *columnName = @"SIGN" ;
//        
//        if (self.isFromRailManage) columnName = @"ARSMSIGN" ;
//        
//        NSString* cachePath = [NSString stringWithFormat:@"%@/%@/%@/%@",[Utilities SysDocumentPath],UseCurrentDate,[CacheManagement instance].currentStore.StoreCode,columnName];
//        NSString *signpath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@_GroupPhoto.jpg",[CacheManagement instance].currentWorkMainID,type_path]];
//        
//        if ([[NSFileManager defaultManager] fileExistsAtPath:signpath]) self.picImageView.image = [UIImage imageWithContentsOfFile:signpath];
    }
   
    self.backButton.frame = CGRectMake(677/414.0*DEWIDTH, 10/736.0*DEHEIGHT, 48, 48);
    self.clearButton.frame = CGRectMake(471/414.0*DEWIDTH, 368/736.0*DEHEIGHT, 93, 30);
    self.doneButton.frame = CGRectMake(592/414.0*DEWIDTH, 368/736.0*DEHEIGHT, 93, 30);
    self.picButton.frame = CGRectMake(350/414.0*DEWIDTH, 368/736.0*DEHEIGHT, 93, 30);
    self.picImageView.frame = CGRectMake(39/320.0*DEWIDTH, 56/568.0*DEHEIGHT, 170, 170);
    self.signtextLabel.frame = CGRectMake(37/414.0*DEWIDTH, 270/736.0*DEHEIGHT, 422, 54);
    
    [self.picButton setBackgroundColor:[Utilities colorWithHexString:@"#ae5642"]] ;
    self.picButton.layer.cornerRadius = 2 ;
    
    [self.view addSubview:self.signView];
    self.view.transform = CGAffineTransformIdentity;
    self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(90));
    if (IOSVersion>= 7.0)
    {
        self.view.bounds = CGRectMake(0.0, 0.0, DEVICE_HEIGHT, 320.0);
    }
    else
    {
        self.view.bounds = CGRectMake(0, 0, DEVICE_HEIGHT, 320);
//        self.view.backgroundColor = [UIColor redColor];
    }

    [self.view bringSubviewToFront:self.backButton];
    
    self.signtextLabel.text = [CacheManagement instance].SignatureText;
    if (self.isFromRailManage) {
        
        self.signtextLabel.text = [CacheManagement instance].SignOffText ;
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    @try {
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDarkContent];
    } @catch (NSException *exception) { }
}

//- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
//
//        self.view.transform = CGAffineTransformIdentity;
//        self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(0));
//        self.view.bounds = CGRectMake(0.0, 0.0, 320.0, 460.0);
//    } else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
////        self.view = self.landscape;
//        self.view.transform = CGAffineTransformIdentity;
//        self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(-90));
//        self.view.bounds = CGRectMake(0.0, 0.0, 480.0, 300.0);
//    } else if(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
////        self.view = self.landscape;
//        self.view.transform = CGAffineTransformIdentity;
//        self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(90));
//        self.view.bounds = CGRectMake(0.0, 0.0, 480.0, 300.0);
//    }
//}


- (IBAction)takePic:(id)sender {
    
    if (!ISFROMEHK) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        else {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera ;
        }
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:picker animated:YES completion:^{}];
    }
}

#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.leveyTabBarController hidesTabBar:YES animated:YES];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.picImageView.image = image ;

    NSString *columnName = @"SIGN" ;
    
    if (self.isFromRailManage) {
        
        columnName = @"ARSMSIGN" ;
    }
    
    NSString* cachePath = [NSString stringWithFormat:@"%@/%@/%@/%@",[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,columnName];
    NSString *signpath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@_GroupPhoto.jpg",[CacheManagement instance].currentWorkMainID,type_path]];


    NSFileManager* filemanager = [NSFileManager defaultManager];
    if (![filemanager fileExistsAtPath:signpath])
    {
        [filemanager createDirectoryAtPath:signpath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [filemanager removeItemAtPath:signpath error:nil];
    
    [Utilities saveImage:image imgPath:signpath];
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}



-(void)uploadSignFileNew:(NSString* )picpath {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //里面有中文。需要转化为NSUTF8StringEncoding
        NSString* urlString = [NSString stringWithFormat:kUploadSignature,kWebDataString,[CacheManagement instance].userLoginName,[CacheManagement instance].currentWorkMainID];
        NSString *columnName = @"SIGN" ;

        if (self.isFromRailManage) {
            columnName = @"ARSMSIGN" ;
            urlString = [NSString stringWithFormat:kUploadArsmSignature,kWebDataString,[CacheManagement instance].userLoginName,[CacheManagement instance].currentWorkMainID];
        }
        
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
        
        NSMutableArray *zipObjectArray = [NSMutableArray array] ;
        
        if ([filemananger fileExistsAtPath:picpath])
        {
            [zipObjectArray addObject:picpath];
        }
        

        NSString* cachePath = [NSString stringWithFormat:@"%@/%@/%@/%@",[Utilities SysDocumentPath],UseCurrentDate,[CacheManagement instance].currentStore.StoreCode,columnName];
        NSString *picpath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@_GroupPhoto.jpg",[CacheManagement instance].currentWorkMainID,type_path]];
        
        if ([filemananger fileExistsAtPath:picpath])
        {
            [zipObjectArray addObject:picpath];
        }
        
        NSString *signpath = [[picpath componentsSeparatedByString:@".jp"] firstObject] ;
        
        BOOL result = [SSZipArchive createZipFileAtPath:[NSString stringWithFormat:@"%@.zip",signpath] withFilesAtPaths:zipObjectArray];
        
        if (result) {
            
            [_fileRequest setFile:[NSString stringWithFormat:@"%@.zip",signpath] forKey:@"zipfile"];
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
                        Uploadstatu = 1;
                        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
                        
                        NSString *columnName = @"SIGN" ;
                        
                        if (self.isFromRailManage) {
                            
                            columnName = @"ARSMSIGN" ;
                        }
                        
                        NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET %@ = '2' where WORKMAINID = '%@'",columnName,[CacheManagement instance].currentWorkMainID];
                        [db executeUpdate:sql];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                    else
                    {
                        [HUD hideUIBlockingIndicator];
                        [HUD showUIBlockingIndicatorWithText:SYSLanguage?@"上传失败":@"Upload Failed" withTimeout:2];
                    }
                }
                else
                {
                    [HUD hideUIBlockingIndicator];
                    [HUD showUIBlockingIndicatorWithText:SYSLanguage?@"Upload Failed":@"上传失败" withTimeout:2];
                }
            });
        }
        else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [HUD hideUIBlockingIndicator];
                [HUD showUIBlockingIndicatorWithText:SYSLanguage?@"Upload Failed":@"上传失败" withTimeout:2];
            });
        }
    });
}



@end
