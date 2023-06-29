//
//  IssuePhotoViewController.m
//  VM
//
//  Created by leo.you on 14-7-25.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import "IssuePhotoViewController.h"
#import "Utilities.h"
#import "CacheManagement.h"
#import "SqliteHelper.h"
#import "FMDatabase.h"
#import "CommonDefine.h"
#import "UIViewController+MJPopupViewController.h"
#import "WBGImageEditor.h"
#import "WBGMoreKeyboard.h"
#import "StoreManagement.h"
#import "JSON.h"

@interface IssuePhotoViewController ()<WBGImageEditorDelegate,WBGImageEditorDataSource>

@end

@implementation IssuePhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIImagePickerController *)imagePicker {

    if (self.picker == nil) {
        
        self.picker = [[UIImagePickerController alloc]init];
        self.picker.delegate = self;
        
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        else {
            self.picker.sourceType = UIImagePickerControllerSourceTypeCamera ;
        }
    }
    return self.picker ;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 100000 && buttonIndex != 2) {
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if (buttonIndex == 1) {//相册
            
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        self.picker.sourceType = sourceType;
        self.picker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:self.picker animated:YES completion:^{}];
    }
}

-(IBAction)beforePhoto
{
    [self imagePicker];
    self.picker.view.tag = 0;
   
    if (ISFROMEHK) {
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:SYSLanguage?@"Choose Picture":@"选择照片" delegate:self cancelButtonTitle:SYSLanguage?@"Cancel":@"取消" destructiveButtonTitle:nil otherButtonTitles:SYSLanguage?@"Camera":@"拍照",SYSLanguage?@"Album":@"从手机相册选择",nil];
        sheet.tag = 100000 ;
        [sheet showInView:self.view];
    }
    else {
        self.picker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:self.picker animated:YES completion:^{}];
    }
}

-(IBAction)afterPhtoto
{
    [self imagePicker];
    self.picker.view.tag = 1;
    
    if (ISFROMEHK) {
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:SYSLanguage?@"Choose Picture":@"选择照片" delegate:self cancelButtonTitle:SYSLanguage?@"Cancel":@"取消" destructiveButtonTitle:nil otherButtonTitles:SYSLanguage?@"Camera":@"拍照",SYSLanguage?@"Album":@"从手机相册选择",nil];
        sheet.tag = 100000 ;
        [sheet showInView:self.view];
    }
    else {
        self.picker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:self.picker animated:YES completion:^{}];
    }
}

- (void)saveImageToPhotos:(UIImage*)savedImage {
    
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    
    NSString *msg = nil ;
    if(error != nil){
        msg = [error localizedDescription] ;
    }else{
        
        msg = @"保存图片成功" ;
    }
    NSLog(@"保存图片结果: %@",msg) ;
}

#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [self.leveyTabBarController hidesTabBar:YES animated:YES];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    if (ISFROMEHK) {
        
        EditPicViewController *controller = [[EditPicViewController alloc] initWithNibName:@"EditPicViewController" bundle:nil];
        
        controller.delegate = self ;
        controller.selectedImage = image ;
        
        if ([[info allKeys] containsObject:@"UIImagePickerControllerReferenceURL"]) {
            
            [picker pushViewController:controller animated:YES];
        }
        else {
            
            [picker dismissViewControllerAnimated:YES completion:^{
                
                UIBarButtonItem *item = [[UIBarButtonItem alloc] init];
                [item setTitle:@""] ;
                self.navigationItem.backBarButtonItem = item ;
                
                controller.isPushFrom = YES ;
                [self.navigationController pushViewController:controller animated:YES];
            }];
        }
        
        return ;
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    WBGImageEditor *editor = [[WBGImageEditor alloc] initWithImage:image delegate:self dataSource:self] ;
    editor.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:editor animated:YES completion:nil];
}

#pragma mark - WBGImageEditorDelegate
- (void)imageEditor:(WBGImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image {
    [self setImageValueWith:image];
    [editor.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageEditorDidCancel:(WBGImageEditor *)editor {
    
}

- (NSArray<WBGMoreKeyboardItem *> *)imageItemsEditor:(WBGImageEditor *)editor {
    return @[];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
//    [self.leveyTabBarController.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectPicWith:(UIImage *)img {
    
    [self.picker dismissViewControllerAnimated:YES completion:nil];
    [self.leveyTabBarController hidesTabBar:YES animated:NO];
    [self setImageValueWith:img];
    
    [Utilities saveToAlbumWithMetadata:nil imageData:UIImagePNGRepresentation(img) completionBlock:^{}
                          failureBlock:^(NSError *error) {
         //处理添加失败的方法显示alert让它回到主线程执行，不然那个框框死活不肯弹出来
         dispatch_async(dispatch_get_main_queue(), ^{
             
             //添加失败一般是由用户不允许应用访问相册造成的，这边可以取出这种情况加以判断一下
             if([error.localizedDescription rangeOfString:@"User denied access"].location != NSNotFound ||[error.localizedDescription rangeOfString:@"用户拒绝访问"].location!=NSNotFound){
             }
         });
     }];
}

- (void)setImageValueWith:(UIImage *)image {

    if (self.picker.view.tag == 0)
    {
        //        NSString* cachePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Private Documents/Images/%@/%@",[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode]];
        
        if ((![self.beforePath isEqualToString:@"0"])&&(self.beforePath != nil)&&([UIImage imageWithContentsOfFile:self.beforePath] != nil))
        {
            [Utilities saveImage:image imgPath:self.beforePath];
            [self.beforeimage setImage:[UIImage imageWithContentsOfFile:self.beforePath]];
            FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
            //            NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_IST_ISSUE_PHOTO_LIST SET INITIAL_PHOTO_PATH='%@', ISSUE_TYPE = '%@' where ISSUE_CHECK_ID='%@' AND ISSUE_ZONE_CODE='%@' ",self.beforePath,self.entity.ISSUE_TYPE,[CacheManagement instance].currentVMCHKID,[CacheManagement instance].currentPhotoZone];
            NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_IST_ISSUE_PHOTO_LIST SET ORDER_NO = '%d', INITIAL_PHOTO_PATH='%@', ISSUE_TYPE = '%@',ISSUE_NEED_TRACKING='%@',TRACKING_USER_TYPE='%@' where ISSUE_CHECK_ID='%@' AND ISSUE_ZONE_CODE='%@' ",(int)self.entity.ORDER_NO, self.beforePath,self.entity.ISSUE_TYPE,isShow?@"Y":@"N",userType,[CacheManagement instance].currentVMCHKID,[CacheManagement instance].currentPhotoZone];
            [db executeUpdate:sql];
        }
        else
        {
            //            NSString* picName = [NSString stringWithFormat:@"%@%@",[Utilities DateTimeNowUpload],@".jpg"];
            //            NSString* picPath = [cachePath stringByAppendingPathComponent:picName];
            //            用order number 来做图片名
            
            NSString* cachePath = [NSString stringWithFormat:kVMPicturePathString,[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,@"VM_ISSUE",[NSString stringWithFormat:@"%d",(int)self.entity.ORDER_NO]];
            
            self.beforePath = cachePath;
            
            NSFileManager* fileMannager = [NSFileManager defaultManager];
            if(![fileMannager fileExistsAtPath:cachePath])
            {
                [fileMannager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSString* picPath = cachePath;
            [Utilities saveImage:image imgPath:picPath];
            [self.beforeimage setImage:[UIImage imageWithContentsOfFile:picPath]];
            FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
            //            NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_IST_ISSUE_PHOTO_LIST SET  INITIAL_PHOTO_PATH='%@', ISSUE_TYPE = '%@' where ISSUE_CHECK_ID='%@' AND ISSUE_ZONE_CODE='%@'",picPath,self.entity.ISSUE_TYPE,[CacheManagement instance].currentVMCHKID,[CacheManagement instance].currentPhotoZone];
            NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_IST_ISSUE_PHOTO_LIST SET ORDER_NO = '%d', INITIAL_PHOTO_PATH='%@', ISSUE_TYPE = '%@',ISSUE_NEED_TRACKING='%@',TRACKING_USER_TYPE='%@' where ISSUE_CHECK_ID='%@' AND ISSUE_ZONE_CODE='%@'",(int)self.entity.ORDER_NO, picPath,self.entity.ISSUE_TYPE,isShow?@"Y":@"N",userType,[CacheManagement instance].currentVMCHKID,[CacheManagement instance].currentPhotoZone];
            
            [db executeUpdate:sql];
        }
        self.delete1.hidden = NO;
        self.firButton.hidden = NO;
    }
    else if(self.picker.view.tag == 1)
    {
        if (([self.afterPath length] > 3)&&(self.afterPath != nil)&&([UIImage imageWithContentsOfFile:self.afterPath] != nil))
        {
            [Utilities saveImage:image imgPath:self.afterPath];
            [self.afterimage setImage:[UIImage imageWithContentsOfFile:self.afterPath]];
            FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
            NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_IST_ISSUE_PHOTO_LIST SET ORDER_NO = '%d', COMPRESS_PHOTO_PATH='%@', ISSUE_TYPE = '%@',ISSUE_NEED_TRACKING='%@',TRACKING_USER_TYPE='%@' where ISSUE_CHECK_ID='%@' AND ISSUE_ZONE_CODE='%@'",(int)self.entity.ORDER_NO, self.afterPath,self.entity.ISSUE_TYPE,isShow?@"Y":@"N",userType,[CacheManagement instance].currentVMCHKID,[CacheManagement instance].currentPhotoZone];
            [db executeUpdate:sql];
        }
        else
        {
            //            NSString* cachePath = [NSString stringWithFormat:kVMPicturePathString,[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,@"VM_ISSUE",[Utilities GetUUID]];
            NSString* cachePath = [NSString stringWithFormat:kVMPicturePathString,[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,@"VM_ISSUE",[NSString stringWithFormat:@"%d.1",(int)self.entity.ORDER_NO]];
            self.afterPath = cachePath;
            
            NSFileManager* fileMannager = [NSFileManager defaultManager];
            if(![fileMannager fileExistsAtPath:cachePath])
            {
                [fileMannager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSString* picPath = cachePath;
            [Utilities saveImage:image imgPath:picPath];
            [self.afterimage setImage:[UIImage imageWithContentsOfFile:picPath]];
            FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
            NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_IST_ISSUE_PHOTO_LIST SET ORDER_NO = '%d', COMPRESS_PHOTO_PATH='%@',ISSUE_TYPE = '%@',ISSUE_NEED_TRACKING='%@',TRACKING_USER_TYPE='%@' where ISSUE_CHECK_ID='%@' AND ISSUE_ZONE_CODE='%@'",(int)self.entity.ORDER_NO,picPath,self.entity.ISSUE_TYPE,isShow?@"Y":@"N",userType,[CacheManagement instance].currentVMCHKID,[CacheManagement instance].currentPhotoZone];
            [db executeUpdate:sql];
        }
        self.delete2.hidden = NO;
        self.secButton.hidden = NO;
    }
}

-(void)refreshUI
{
    FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM  NVM_IST_ISSUE_PHOTO_LIST where ISSUE_CHECK_ID='%@' AND ISSUE_ZONE_CODE ='%@'",[CacheManagement instance].currentVMCHKID,[CacheManagement instance].currentPhotoZone];
    
    FMResultSet* rs = [db executeQuery:sql];
    while([rs next])
    {
        self.beforePath = [rs stringForColumn:@"INITIAL_PHOTO_PATH"];
        self.afterPath = [rs stringForColumn:@"COMPRESS_PHOTO_PATH"];
        self.comment = [rs stringForColumn:@"COMMENT"];
    }
    [rs close];
    
    if ((![self.beforePath isEqualToString:@"0"])&&(self.beforePath != nil))
    {
        self.delete1.hidden = NO;
        self.firButton.hidden = NO;
        [self.beforeimage setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[self.beforePath componentsSeparatedByString:@"dataCaches"] lastObject]]]];
    }
    else
    {
        self.delete1.hidden = YES;
        self.firButton.hidden = YES;
        [self.beforeimage setImage:[UIImage imageNamed:SYSLanguage?@"Take-Picture.png":@"photo.png"]];
    }
    if ((![self.afterPath isEqualToString:@"0"])&&(self.afterPath!= nil))
    {
        self.delete2.hidden = NO;
        self.secButton.hidden = NO;
        [self.afterimage setImage:[UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[self.afterPath componentsSeparatedByString:@"dataCaches"] lastObject]]]];
    }
    else
    {
        self.delete2.hidden = YES;
        self.secButton.hidden = YES;
        [self.afterimage setImage:[UIImage imageNamed:SYSLanguage?@"Take-Picture.png":@"photo.png"]];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if (alertView.tag == 101)
        {
            [[NSFileManager defaultManager]removeItemAtPath:self.beforePath error:nil];
            FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
            NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_IST_ISSUE_PHOTO_LIST SET INITIAL_PHOTO_PATH='%@' ,ISSUE_TYPE = '%@',ISSUE_NEED_TRACKING='%@',TRACKING_USER_TYPE='%@' where ISSUE_CHECK_ID='%@' AND ISSUE_ZONE_CODE='%@'",@"0",self.entity.ISSUE_TYPE,isShow?@"Y":@"N",userType,[CacheManagement instance].currentVMCHKID,[CacheManagement instance].currentPhotoZone];
            [db executeUpdate:sql];
            [self refreshUI];
        }
        else if (alertView.tag == 102)
        {
            [[NSFileManager defaultManager]removeItemAtPath:self.afterPath error:nil];
            FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
            NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_IST_ISSUE_PHOTO_LIST SET COMPRESS_PHOTO_PATH='%@' ,ISSUE_TYPE = '%@',ISSUE_NEED_TRACKING='%@',TRACKING_USER_TYPE='%@' where ISSUE_CHECK_ID='%@' AND ISSUE_ZONE_CODE='%@'",@"0",self.entity.ISSUE_TYPE,isShow?@"Y":@"N",userType,[CacheManagement instance].currentVMCHKID,[CacheManagement instance].currentPhotoZone];
            [db executeUpdate:sql];
            [self refreshUI];
        }
    }
}

-(IBAction)deleteBefore
{
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:SYSLanguage?@"Are You Sure?":@"确定删除？" message:nil delegate:self cancelButtonTitle:SYSLanguage?@"NO":@"取消" otherButtonTitles:SYSLanguage?@"YES":@"确定", nil];
    av.tag = 101;
    [av show];
}

-(IBAction)deleteAfter
{
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:SYSLanguage?@"Are You Sure?":@"确定删除？" message:nil delegate:self cancelButtonTitle:SYSLanguage?@"NO":@"取消" otherButtonTitles:SYSLanguage?@"YES":@"确定", nil];
    av.tag = 102;
    [av show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [Utilities createLeftBarButton:self clichEvent:@selector(back)];
    
    UILabel *TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 43)];
    TitleLabel.numberOfLines = 2 ;
    TitleLabel.textColor = [UIColor whiteColor];
    TitleLabel.textAlignment = NSTextAlignmentCenter ;
    TitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    TitleLabel.text = SYSLanguage?self.entity.ISSUE_ZONE_NAME_EN:self.entity.ISSUE_ZONE_NAME_CN;
    [self.navigationItem setTitleView:TitleLabel] ;
    
    self.receiveButton.hidden = YES ;
    CGRect af = self.ImageBGView.frame ;
    af.size.width = DEWIDTH ;
    af.size.height = DEWIDTH/320.0*293.0;
    self.ImageBGView.frame = af ;
    self.label.text = SYSLanguage?@"Description":@"请输入说明";
    isShow = NO ;
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
    [self checkIsShow];
    [self.before setContentMode:UIViewContentModeCenter];
    [self.after setContentMode:UIViewContentModeCenter];
    
    FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM  NVM_IST_ISSUE_PHOTO_LIST where ISSUE_CHECK_ID='%@' AND ISSUE_ZONE_CODE ='%@'",[CacheManagement instance].currentVMCHKID,[CacheManagement instance].currentPhotoZone];
    NSString *newFileA = @"" ;
    NSString *newFileB = @"" ;
    FMResultSet* rs = [db executeQuery:sql];
    while([rs next])
    {
        newFileB = [rs stringForColumn:@"INITIAL_PHOTO_PATH"];
        newFileA = [rs stringForColumn:@"COMPRESS_PHOTO_PATH"];
        self.comment = [rs stringForColumn:@"COMMENT"];
        userType = [rs stringForColumn:@"TRACKING_USER_TYPE"];
    }
    [rs close];
    self.textview.text = self.comment;
    self.beforePath = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[newFileB componentsSeparatedByString:@"/dataCaches"] lastObject]];
    self.afterPath = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[newFileA componentsSeparatedByString:@"/dataCaches"] lastObject]];
    if (!userType || [userType isEqual:[NSNull null]] || [userType isEqualToString:@""]) {
        
        if ([[NSString stringWithFormat:@"%@",self.entity.ISSUE_ZONE_NAME_CN] containsString:@"货品"]||
            [[NSString stringWithFormat:@"%@",self.entity.ISSUE_ZONE_NAME_CN] containsString:@"硬件装修"]) {
            userType = @"RO" ;
        } else if ([[NSString stringWithFormat:@"%@",self.entity.ISSUE_ZONE_NAME_CN] containsString:@"陈列"]) {
            userType = @"VM/VMM" ;
        } else if ([[NSString stringWithFormat:@"%@",self.entity.ISSUE_ZONE_NAME_CN] containsString:@"ISC"]) {
            userType = @"RM" ;
        } else {
            userType = @"VM/VMM" ;
        }
    }
    
    if ([self.textview.text length] > 0)
    {
        self.label.hidden = YES;
    }
    if ((![self.beforePath isEqualToString:@"0"])&&(self.beforePath != nil)&&([UIImage imageWithContentsOfFile:self.beforePath] != nil))
    {
        [self.beforeimage setImage:[UIImage imageWithContentsOfFile:self.beforePath]];
        self.delete1.hidden = NO;
        self.firButton.hidden = NO;
    }
    else
    {
        [self.beforeimage setImage:[UIImage imageNamed:SYSLanguage?@"Take-Picture.png":@"photo.png"]];
        self.delete1.hidden = YES;
        self.firButton.hidden = YES;
    }
    if ((![self.afterPath isEqualToString:@"0"])&&!(self.beforePath == nil)&&([UIImage imageWithContentsOfFile:self.afterPath] != nil))
    {
       [self.afterimage setImage:[UIImage imageWithContentsOfFile:self.afterPath]];
       self.delete2.hidden = NO;
       self.secButton.hidden = NO;
    }
    else
    {
        [self.afterimage setImage:[UIImage imageNamed:SYSLanguage?@"Take-Picture.png":@"photo.png"]];
        self.delete2.hidden = YES;
        self.secButton.hidden = YES;
    }
}


- (void)checkIsShow {
    
    NSString *CurrentDate = @"";
    @try {
        if (FromHistory == 1) {
            CurrentDate = [Utilities DateNow] ;
            NSString* DateSql  = [NSString stringWithFormat:@"select CHECK_IN_TIME from IST_WORK_MAIN where WORK_MAIN_ID = '%@'",[CacheManagement instance].currentWorkMainID];
            FMResultSet* DateResult = [[SqliteHelper shareCommonSqliteHelper] selectResult:DateSql];
            if ([DateResult next]) {
                CurrentDate = [[DateResult stringForColumn:@"CHECK_IN_TIME"] substringToIndex:10];
            }
        }
    } @catch (NSException *exception) {}
    
    [HUD showUIBlockingIndicator];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        StoreManagement *management = [[StoreManagement alloc] init];
        NSString* result = [management getStoreTrackingByCodeServerSyn:[CacheManagement instance].currentStore.StoreCode withCheckDate:CurrentDate];
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hideUIBlockingIndicator];
            if ([[NSString stringWithFormat:@"%@",result].lowercaseString isEqualToString:@"true"]) {
                isShow = YES ;
                if ([[NSString stringWithFormat:@"%@",self.entity.ISSUE_ZONE_NAME_CN] containsString:@"其他"]) {
                    self.receiveButton.hidden = NO ;
                    [self.receiveButton setTitle:userType forState:UIControlStateNormal];
                }
            } else {
                isShow = NO ;
            }
            [self saveCurrentData];
        });
    });
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
    NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_IST_ISSUE_PHOTO_LIST SET ORDER_NO = '%d', COMMENT='%@',ISSUE_NEED_TRACKING = '%@',TRACKING_USER_TYPE='%@' where ISSUE_CHECK_ID='%@' AND ISSUE_ZONE_CODE ='%@'",(int)self.entity.ORDER_NO,[textView.text getReplaceString],isShow?@"Y":@"N",userType,[CacheManagement instance].currentVMCHKID,[CacheManagement instance].currentPhotoZone];
    [db executeUpdate:sql];
    
    [textView resignFirstResponder];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.label.hidden = NO;
    }else{
        self.label.hidden = YES;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
//    if ([text isEqualToString:@"\x20"])
//    {
//        return NO;
//    }
    
//    if ([text length] > 0)
//    {
//        self.label.hidden= YES;
//    }
    
    return YES;
}


- (IBAction)secPicAction:(id)sender {
    
    self.bigImageView.image = [UIImage imageWithContentsOfFile:self.afterPath];
    [self presentPopupView:self.ImageBGView];
}


- (IBAction)firPicAction:(id)sender {
    
    self.bigImageView.image = [UIImage imageWithContentsOfFile:self.beforePath];
    [self presentPopupView:self.ImageBGView];
}

- (IBAction)selectAction:(id)sender {
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:@"请选择接收人" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *ac1 = [UIAlertAction actionWithTitle:@"RO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.receiveButton setTitle:@"RO" forState:UIControlStateNormal];
        userType = @"RO";
        [self saveCurrentData];
    }];
    UIAlertAction *ac2 = [UIAlertAction actionWithTitle:@"VM/VMM" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.receiveButton setTitle:@"VM/VMM" forState:UIControlStateNormal];
        userType = @"VM/VMM";
        [self saveCurrentData];
    }];
    UIAlertAction *ac3 = [UIAlertAction actionWithTitle:@"RM" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.receiveButton setTitle:@"RM" forState:UIControlStateNormal];
        userType = @"RM";
        [self saveCurrentData];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [ac addAction:ac1];[ac addAction:ac2];[ac addAction:ac3];[ac addAction:cancel];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)saveCurrentData {
    
    @try {
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_IST_ISSUE_PHOTO_LIST SET ORDER_NO = '%d', COMMENT='%@',ISSUE_NEED_TRACKING = '%@',TRACKING_USER_TYPE='%@' where ISSUE_CHECK_ID='%@' AND ISSUE_ZONE_CODE ='%@'",(int)self.entity.ORDER_NO,[self.textview.text getReplaceString],isShow?@"Y":@"N",userType,[CacheManagement instance].currentVMCHKID,[CacheManagement instance].currentPhotoZone];
        [db executeUpdate:sql];
    } @catch (NSException *exception) {
    }
}

@end
