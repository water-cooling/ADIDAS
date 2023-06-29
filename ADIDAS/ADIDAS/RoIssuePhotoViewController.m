//
//  RoIssuePhotoViewController.m
//  MobileApp
//
//  Created by 桂康 on 2018/1/4.
//

#import "RoIssuePhotoViewController.h"
#import "Utilities.h"
#import "CacheManagement.h"
#import "SqliteHelper.h"
#import "FMDatabase.h"
#import "CommonDefine.h"
#import "UIViewController+MJPopupViewController.h"
#import "WBGImageEditor.h"
#import "WBGMoreKeyboard.h"



@interface RoIssuePhotoViewController ()<WBGImageEditorDelegate,WBGImageEditorDataSource,UITextFieldDelegate>

@end

@implementation RoIssuePhotoViewController

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
    [self.userTextField resignFirstResponder] ;
    [self.solutionTextField resignFirstResponder] ;
    [self.textview resignFirstResponder] ;
    
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
    [self.userTextField resignFirstResponder] ;
    [self.solutionTextField resignFirstResponder] ;
    [self.textview resignFirstResponder] ;
    
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
    
    [Utilities saveToAlbumWithMetadata:nil imageData:UIImagePNGRepresentation(img) completionBlock:^
     {
         
         
     }
                          failureBlock:^(NSError *error)
     {
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
        if ((![self.beforePath isEqualToString:@"0"])&&(self.beforePath != nil)&&([UIImage imageWithContentsOfFile:self.beforePath] != nil))
        {
            [Utilities saveImage:image imgPath:self.beforePath];
            [self.beforeimage setImage:[UIImage imageWithContentsOfFile:self.beforePath]];
            FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
            
            NSString* sql = [NSString stringWithFormat:@"UPDATE IST_FR_ISSUE_PHOTO_LIST SET  PHOTO_PATH1='%@' where ISSUE_CHECK_ID='%@' AND ISSUE_ZONE_CODE='%@' AND ISSUE_ZONE_NAME='%@' ", self.beforePath,[CacheManagement instance].currentVMCHKID,[CacheManagement instance].currentPhotoZone,self.entity.ISSUE_ZONE_NAME_CN];
            [db executeUpdate:sql];
        }
        else
        {
            //            NSString* picName = [NSString stringWithFormat:@"%@%@",[Utilities DateTimeNowUpload],@".jpg"];
            //            NSString* picPath = [cachePath stringByAppendingPathComponent:picName];
            //            用order number 来做图片名
            
            NSString* cachePath = [NSString stringWithFormat:kVMPicturePathString,[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,@"RO_ISSUE",[Utilities GetUUID]];
            
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
            
            NSString* sql = [NSString stringWithFormat:@"UPDATE IST_FR_ISSUE_PHOTO_LIST SET  PHOTO_PATH1='%@' where ISSUE_CHECK_ID='%@' AND ISSUE_ZONE_CODE='%@'  AND ISSUE_ZONE_NAME='%@'",picPath,[CacheManagement instance].currentVMCHKID,[CacheManagement instance].currentPhotoZone,self.entity.ISSUE_ZONE_NAME_CN];
            
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
            NSString* sql = [NSString stringWithFormat:@"UPDATE IST_FR_ISSUE_PHOTO_LIST SET  PHOTO_PATH2='%@' where ISSUE_CHECK_ID='%@' AND ISSUE_ZONE_CODE='%@'  AND ISSUE_ZONE_NAME='%@' ", self.afterPath,[CacheManagement instance].currentVMCHKID,[CacheManagement instance].currentPhotoZone,self.entity.ISSUE_ZONE_NAME_CN];
            [db executeUpdate:sql];
        }
        else
        {
            
            NSString* cachePath = [NSString stringWithFormat:kVMPicturePathString,[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,@"RO_ISSUE",[Utilities GetUUID]];
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
            NSString* sql = [NSString stringWithFormat:@"UPDATE IST_FR_ISSUE_PHOTO_LIST SET PHOTO_PATH2='%@' where ISSUE_CHECK_ID='%@' AND ISSUE_ZONE_CODE='%@' AND ISSUE_ZONE_NAME='%@' ",picPath,[CacheManagement instance].currentVMCHKID,[CacheManagement instance].currentPhotoZone,self.entity.ISSUE_ZONE_NAME_CN];
            [db executeUpdate:sql];
        }
        self.delete2.hidden = NO;
        self.secButton.hidden = NO;
    }
}

-(void)refreshUI
{
    FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM  IST_FR_ISSUE_PHOTO_LIST where ISSUE_CHECK_ID='%@' AND ISSUE_ZONE_CODE ='%@' AND ISSUE_ZONE_NAME ='%@'",[CacheManagement instance].currentVMCHKID,[CacheManagement instance].currentPhotoZone,self.entity.ISSUE_ZONE_NAME_CN];
    
    FMResultSet* rs = [db executeQuery:sql];
    while([rs next])
    {
        self.beforePath = [rs stringForColumn:@"PHOTO_PATH1"];
        self.afterPath = [rs stringForColumn:@"PHOTO_PATH2"];
        self.comment = [rs stringForColumn:@"COMMENT"];
    }
    [rs close];
    
    if ((![self.beforePath isEqualToString:@"0"])&&(self.beforePath != nil))
    {
        self.delete1.hidden = NO;
        self.firButton.hidden = NO;
        [self.beforeimage setImage:[UIImage imageWithContentsOfFile:self.beforePath]];
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
        [self.afterimage setImage:[UIImage imageWithContentsOfFile:self.afterPath]];
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
            NSString* sql = [NSString stringWithFormat:@"UPDATE IST_FR_ISSUE_PHOTO_LIST SET PHOTO_PATH1='%@' where ISSUE_CHECK_ID='%@' AND ISSUE_ZONE_CODE='%@' AND ISSUE_ZONE_NAME='%@' ",@"0",[CacheManagement instance].currentVMCHKID,[CacheManagement instance].currentPhotoZone,self.entity.ISSUE_ZONE_NAME_CN];
            [db executeUpdate:sql];
            [self refreshUI];
        }
        else if (alertView.tag == 102)
        {
            [[NSFileManager defaultManager]removeItemAtPath:self.afterPath error:nil];
            FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
            NSString* sql = [NSString stringWithFormat:@"UPDATE IST_FR_ISSUE_PHOTO_LIST SET COMPRESS_PHOTO_PATH='%@' where ISSUE_CHECK_ID='%@' AND ISSUE_ZONE_CODE='%@' AND ISSUE_ZONE_NAME='%@' ",@"0",[CacheManagement instance].currentVMCHKID,[CacheManagement instance].currentPhotoZone,self.entity.ISSUE_ZONE_NAME_CN];
            [db executeUpdate:sql];
            [self refreshUI];
        }
    }
}

-(IBAction)deleteBefore
{
    [self.userTextField resignFirstResponder] ;
    [self.solutionTextField resignFirstResponder] ;
    [self.textview resignFirstResponder] ;
    
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:SYSLanguage?@"Are You Sure?":@"确定删除？" message:nil delegate:self cancelButtonTitle:SYSLanguage?@"NO":@"取消" otherButtonTitles:SYSLanguage?@"YES":@"确定", nil];
    av.tag = 101;
    [av show];
}

-(IBAction)deleteAfter
{
    [self.userTextField resignFirstResponder] ;
    [self.solutionTextField resignFirstResponder] ;
    [self.textview resignFirstResponder] ;
    
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:SYSLanguage?@"Are You Sure?":@"确定删除？" message:nil delegate:self cancelButtonTitle:SYSLanguage?@"NO":@"取消" otherButtonTitles:SYSLanguage?@"YES":@"确定", nil];
    av.tag = 102;
    [av show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    UILabel *TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 43)];
    TitleLabel.numberOfLines = 2 ;
    TitleLabel.textColor = [UIColor whiteColor];
    TitleLabel.textAlignment = NSTextAlignmentCenter ;
    TitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    TitleLabel.text = SYSLanguage?self.entity.ISSUE_ZONE_NAME_EN:self.entity.ISSUE_ZONE_NAME_CN;
    [self.navigationItem setTitleView:TitleLabel] ;
    self.peopleLeftLabel.text = SYSLanguage?@"Responsible Person:":@"跟进人:" ;
    self.dateLeftLabel.text = SYSLanguage?@"Complete Date:":@"完成日期:" ;
    self.label.text = SYSLanguage?@"Issue Description":@"请输入问题说明";
    self.solutionLabel.text = SYSLanguage?@"Action Plan":@"请输入行动方案";
    self.dateLeftLabel.adjustsFontSizeToFitWidth = YES ;
    self.peopleLeftLabel.adjustsFontSizeToFitWidth = YES ;
    [Utilities createLeftBarButton:self clichEvent:@selector(back)];
    CGRect af = self.ImageBGView.frame ;
    af.size.width = DEWIDTH ;
    af.size.height = DEWIDTH/320.0*293.0;
    self.ImageBGView.frame = af ;
    if (SYSLanguage) {
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];//设置为英文显示
        self.selectDatePicker.locale = locale;
    }
    else {
        NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示
        self.selectDatePicker.locale = locale;
    }
    
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
    self.textview.delegate = self ;
    [self.before setContentMode:UIViewContentModeCenter];
    [self.after setContentMode:UIViewContentModeCenter];
    self.userTextField.delegate = self ;
    self.solutionTextField.delegate = self ;
    self.userTextField.placeholder = SYSLanguage?@"Please input responsible person":@"请输入跟进人" ;
    FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM  IST_FR_ISSUE_PHOTO_LIST where ISSUE_CHECK_ID='%@' AND ISSUE_ZONE_CODE ='%@' AND ISSUE_ZONE_NAME ='%@'",[CacheManagement instance].currentVMCHKID,[CacheManagement instance].currentPhotoZone,self.entity.ISSUE_ZONE_NAME_CN];
    NSString *newFileA = @"" ;
    NSString *newFileB = @"" ;
    FMResultSet* rs = [db executeQuery:sql];
    while([rs next])
    {
        newFileB = [rs stringForColumn:@"PHOTO_PATH1"];
        newFileA = [rs stringForColumn:@"PHOTO_PATH2"];
        self.comment = [rs stringForColumn:@"COMMENT"];
        self.dateLabel.text = [rs stringForColumn:@"COMPLETE_DATE"];
        self.userTextField.text = [rs stringForColumn:@"RESPONSIBLE_PERSON"];
        self.solutionTextField.text = [rs stringForColumn:@"ISSUE_SOLUTION"];
    }
    [rs close];
    self.textview.text = self.comment;
    
    self.beforePath = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[newFileB componentsSeparatedByString:@"/dataCaches"] lastObject]];
    
    self.afterPath = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[newFileA componentsSeparatedByString:@"/dataCaches"] lastObject]];
    
    if ([self.solutionTextField.text length] > 0)
    {
        self.solutionLabel.hidden = YES;
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
    
    self.bgScrollView.contentSize = CGSizeMake(0, 610) ;
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
    if (textView == self.textview) {
        
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        NSString* sql = [NSString stringWithFormat:@"UPDATE IST_FR_ISSUE_PHOTO_LIST SET COMMENT='%@' where ISSUE_CHECK_ID='%@' AND ISSUE_ZONE_CODE ='%@' AND ISSUE_ZONE_NAME ='%@'",[textView.text getReplaceString],[CacheManagement instance].currentVMCHKID,[CacheManagement instance].currentPhotoZone,self.entity.ISSUE_ZONE_NAME_CN];
        [db executeUpdate:sql];
    }
    
    if (textView == self.solutionTextField) {
        
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        NSString* sql = [NSString stringWithFormat:@"UPDATE IST_FR_ISSUE_PHOTO_LIST SET ISSUE_SOLUTION='%@' where ISSUE_CHECK_ID='%@' AND ISSUE_ZONE_CODE ='%@' AND ISSUE_ZONE_NAME ='%@'",[textView.text getReplaceString],[CacheManagement instance].currentVMCHKID,[CacheManagement instance].currentPhotoZone,self.entity.ISSUE_ZONE_NAME_CN];
        [db executeUpdate:sql];
    }
    
    [textView resignFirstResponder];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView == self.textview) {
        
        if (textView.text.length == 0) {
            self.label.hidden = NO;
        }else{
            self.label.hidden = YES;
        }
    }
    
    if (textView == self.solutionTextField) {
        
        if (textView.text.length == 0) {
            self.solutionLabel.hidden = NO;
        }else{
            self.solutionLabel.hidden = YES;
        }
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
    
    [self.userTextField resignFirstResponder] ;
    [self.solutionTextField resignFirstResponder] ;
    [self.textview resignFirstResponder] ;
    self.bigImageView.image = [UIImage imageWithContentsOfFile:self.afterPath];
    [self presentPopupView:self.ImageBGView];
}


- (IBAction)firPicAction:(id)sender {
    
    [self.userTextField resignFirstResponder] ;
    [self.solutionTextField resignFirstResponder] ;
    [self.textview resignFirstResponder] ;
    self.bigImageView.image = [UIImage imageWithContentsOfFile:self.beforePath];
    [self presentPopupView:self.ImageBGView];
}

- (IBAction)SelectDateAction:(id)sender {
    
    [self saveSelectDate];
}

- (IBAction)TapBGAction:(id)sender {
    [self.userTextField resignFirstResponder] ;
    [self.solutionTextField resignFirstResponder] ;
    [self.textview resignFirstResponder] ;
    [self presentPopupView:self.datePickerView];
    
    [self saveSelectDate];
}

- (void)saveSelectDate {
    
    @try {
        
        self.dateLabel.text = [[self stringFromDate:self.selectDatePicker.date] substringToIndex:10] ;
        
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        NSString* sql = [NSString stringWithFormat:@"UPDATE IST_FR_ISSUE_PHOTO_LIST SET COMPLETE_DATE='%@' where ISSUE_CHECK_ID='%@' AND ISSUE_ZONE_CODE ='%@' AND ISSUE_ZONE_NAME ='%@'",[self.dateLabel.text getReplaceString],[CacheManagement instance].currentVMCHKID,[CacheManagement instance].currentPhotoZone,self.entity.ISSUE_ZONE_NAME_CN];
        [db executeUpdate:sql];
        
    } @catch (NSException *exception) {
    }
}

- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss zzz"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder] ;
    return YES ;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
    NSString* sql = [NSString stringWithFormat:@"UPDATE IST_FR_ISSUE_PHOTO_LIST SET RESPONSIBLE_PERSON='%@' where ISSUE_CHECK_ID='%@' AND ISSUE_ZONE_CODE ='%@' AND ISSUE_ZONE_NAME ='%@'",[textField.text getReplaceString],[CacheManagement instance].currentVMCHKID,[CacheManagement instance].currentPhotoZone,self.entity.ISSUE_ZONE_NAME_CN];
    [db executeUpdate:sql];
}

- (void)back {
    
    [self.userTextField resignFirstResponder] ;
    [self.solutionTextField resignFirstResponder] ;
    [self.textview resignFirstResponder] ;
    
    if (([self.beforePath isEqualToString:@"0"]||self.beforePath == nil||![[NSFileManager defaultManager] fileExistsAtPath:self.beforePath])&&
        ([self.afterPath isEqualToString:@"0"]||self.afterPath == nil||![[NSFileManager defaultManager] fileExistsAtPath:self.afterPath])&&
        [self.textview.text isEqualToString:@""]&&[self.solutionTextField.text isEqualToString:@""]&&[self.userTextField.text isEqualToString:@""]&&
        [self.dateLabel.text isEqualToString:@""]) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        
        if ([self.textview.text isEqualToString:@""]) {
            
            ALERTVIEW(SYSLanguage?@"Please input remark":@"请输入问题说明");
            return ;
        }
        
        if ([self.solutionTextField.text isEqualToString:@""]) {
            
            ALERTVIEW(SYSLanguage?@"Please input solution":@"请输入行动方案");
            return ;
        }
        
        if ([self.userTextField.text isEqualToString:@""]) {
            
            ALERTVIEW(SYSLanguage?@"Please input charge people":@"请输入跟进人");
            return ;
        }
        
        if ([self.dateLabel.text isEqualToString:@""]) {
            
            ALERTVIEW(SYSLanguage?@"Please select complete date":@"请输入完成日期");
            return ;
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end












