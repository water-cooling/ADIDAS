//
//  PhotoViewController.m
//  VM
//
//  Created by wendy on 14-7-17.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import "PhotoViewController.h"
#import "Utilities.h"
#import "CacheManagement.h"
#import "SqliteHelper.h"
#import "FMDatabase.h"
#import "CommonDefine.h"
#import "VisitStoreEntity.h"
#import "UIViewController+MJPopupViewController.h"
#import "WBGImageEditor.h"
#import "WBGMoreKeyboard.h"
#import "WBGImageEditor.h"
#import "WBGMoreKeyboard.h"


@interface PhotoViewController ()<WBGImageEditorDelegate,WBGImageEditorDataSource>

@end

@implementation PhotoViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (void)setImageValueWith:(UIImage *)image {

    if (self.picker.view.tag == 0) {
        
        if ((![self.beforePath isEqualToString:@"0"])&&(self.beforePath != nil)&&([UIImage imageWithContentsOfFile:self.beforePath] != nil))
        {
            [Utilities saveImage:image imgPath:self.beforePath];
            [self.beforeimage setImage:[UIImage imageWithContentsOfFile:self.beforePath]];
            FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
            NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_IST_STORE_PHOTO_LIST SET INITIAL_PHOTO_PATH='%@',ORDER_NO = '%d' where TAKE_ID='%@' AND STORE_ZONE ='%@'",self.beforePath,(int)self.entity.ORDER_NO,[CacheManagement instance].currentTakeID,[CacheManagement instance].currentPhotoZone];
            [db executeUpdate:sql];
            
        }
        else
        {
            NSString* cachePath = [NSString stringWithFormat:kVM_Score_PicturePathString,[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,@"VM_PHOTO",self.entity.PHOTO_ZONE_CODE];
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
            NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_IST_STORE_PHOTO_LIST SET INITIAL_PHOTO_PATH='%@',ORDER_NO = '%d' where TAKE_ID='%@' AND STORE_ZONE ='%@'",picPath,self.entity.ORDER_NO,[CacheManagement instance].currentTakeID,[CacheManagement instance].currentPhotoZone];
            [db executeUpdate:sql];
        }
        self.delete1.hidden = NO;
        self.firButton.hidden = NO ;
    }
    else if(self.picker.view.tag == 1)
    {
        if ((![self.afterPath isEqualToString:@"0"])&&(self.afterPath != nil)&&([UIImage imageWithContentsOfFile:self.afterPath] != nil))
        {
            [Utilities saveImage:image imgPath:self.afterPath];
            [self.afterimage  setImage:[UIImage imageWithContentsOfFile:self.afterPath]];
            FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
            NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_IST_STORE_PHOTO_LIST SET INITIAL_PHOTO_PATH='%@',ORDER_NO = '%d' where TAKE_ID='%@' AND STORE_ZONE ='%@'",self.beforePath,self.entity.ORDER_NO,[CacheManagement instance].currentTakeID,[CacheManagement instance].currentPhotoZone];
            [db executeUpdate:sql];
        }
        else
        {
            NSString* cachePath = [NSString stringWithFormat:kVM_Score_PicturePathString,[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,@"VM_PHOTO",[NSString stringWithFormat:@"%@_1",self.entity.PHOTO_ZONE_CODE]];
            self.afterPath = cachePath;
            NSFileManager* fileMannager = [NSFileManager defaultManager];
            if(![fileMannager fileExistsAtPath:cachePath])
            {
                [fileMannager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSString* picPath = cachePath;
            [Utilities saveImage:image imgPath:picPath];
            [self.afterimage  setImage:[UIImage imageWithContentsOfFile:picPath]];
            FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
            NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_IST_STORE_PHOTO_LIST SET COMPRESS_PHOTO_PATH='%@',ORDER_NO = '%d' where TAKE_ID='%@' AND STORE_ZONE ='%@'",picPath,self.entity.ORDER_NO,[CacheManagement instance].currentTakeID,[CacheManagement instance].currentPhotoZone];
            [db executeUpdate:sql];
        }
        self.delete2.hidden = NO;
        self.secButton.hidden = NO ;
    }
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

- (id)initWithDelegate:(id)dgate {

    if (self = [super init]) {
        
        self.PhotoDelegate = dgate ;
    }
    
    return self ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 43)];
    TitleLabel.numberOfLines = 2 ;
    TitleLabel.textColor = [UIColor whiteColor];
    TitleLabel.textAlignment = NSTextAlignmentCenter ;
    TitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18];
    TitleLabel.text = SYSLanguage?self.entity.PHOTO_ZONE_NAME_EN:self.entity.PHOTO_ZONE_NAME_CN ;
    [self.navigationItem setTitleView:TitleLabel] ;
    CGRect af = self.BigBGView.frame ;
    af.size.width = DEWIDTH ;
    af.size.height = DEWIDTH/320.0*293.0;
    self.BigBGView.frame = af ;
    self.label.text = SYSLanguage?@"Add Remark":@"请输入备注";
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
    
    [self.before setContentMode:UIViewContentModeCenter];
    [self.after setContentMode:UIViewContentModeCenter];
    
    if (![self.entity.REMARK isEqualToString:@""]&&[[CacheManagement instance].dataSource containsString:@"RBK"]) {
        CGRect frame = self.picView.frame ;
        frame.origin.y = 225 ;
        self.picView.frame = frame ;
    }

    FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM  NVM_IST_STORE_PHOTO_LIST where TAKE_ID='%@' AND STORE_ZONE ='%@'",[CacheManagement instance].currentTakeID,[CacheManagement instance].currentPhotoZone];
    
    FMResultSet* rs = [db executeQuery:sql];
    while([rs next])
    {
        self.beforePath = [rs stringForColumn:@"INITIAL_PHOTO_PATH"];
        self.afterPath = [rs stringForColumn:@"COMPRESS_PHOTO_PATH"];
        self.comment = [rs stringForColumn:@"COMMENT"];
    }
    [rs close];
    self.textview.text = self.comment;
    if ([self.textview.text length] > 0)
    {
        self.label.hidden = YES;
    }
    if ((![self.beforePath isEqualToString:@"0"])&&(self.beforePath != nil))
    {
         NSString *newFile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[self.beforePath componentsSeparatedByString:@"/dataCaches"] lastObject]];
        if ([UIImage imageWithContentsOfFile:newFile] != nil) {
            
            self.beforePath = newFile ;
            [self.beforeimage setImage:[UIImage imageWithContentsOfFile:self.beforePath]];
            self.delete1.hidden = NO;
            self.firButton.hidden = NO ;

        }
        else {
            
            [self.beforeimage setImage:[UIImage imageNamed:SYSLanguage?@"Take-Picture.png":@"photo.png"]];
            self.delete1.hidden = YES;
            self.firButton.hidden = YES ;

        }
    }
    else
    {
        [self.beforeimage setImage:[UIImage imageNamed:SYSLanguage?@"Take-Picture.png":@"photo.png"]];
        self.delete1.hidden = YES;
        self.firButton.hidden = YES ;

    }
    if ((![self.afterPath isEqualToString:@"0"])&&(self.afterPath != nil))
    {
        NSString *newFile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[self.afterPath componentsSeparatedByString:@"/dataCaches"] lastObject]];
        if ([UIImage imageWithContentsOfFile:newFile] != nil) {
        
            self.afterPath = newFile ;
            [self.afterimage setImage:[UIImage imageWithContentsOfFile:self.afterPath]];
            self.delete2.hidden = NO;
            self.secButton.hidden = NO ;
        }
        else {
            [self.afterimage setImage:[UIImage imageNamed:SYSLanguage?@"Take-Picture.png":@"photo.png"]];
            self.delete2.hidden = YES;
            self.secButton.hidden = YES ;
        }
    }
    else
    {
        [self.afterimage setImage:[UIImage imageNamed:SYSLanguage?@"Take-Picture.png":@"photo.png"]];
        self.delete2.hidden = YES;
        self.secButton.hidden = YES ;
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}


-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.label.hidden = NO;
    }else{
        self.label.hidden = YES;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound){
        
        if ((![self.beforePath isEqualToString:@"0"]&&self.beforePath != nil)||(![self.afterPath isEqualToString:@"0"]&&self.afterPath != nil)||(![self.textview.text isEqualToString:@""])) {
            
            if (!self.beforePath) {
                self.beforePath = @"0" ;
            }
            if (!self.afterPath) {
                self.afterPath = @"0" ;
            }
            
            NSString* sql_select  = [NSString stringWithFormat:@"\
                    Select a.* From  [NVM_IST_STORE_PHOTO_LIST]  a \
                    inner join nvm_ist_store_take_photo b  \
                    on a.[TAKE_ID]=b.[TAKE_ID]\
                    where b.[WORK_MAIN_ID]='%@'\
                    and a.[STORE_ZONE]='%@'",[CacheManagement instance].currentWorkMainID,[CacheManagement instance].currentPhotoZone];
            
            NSMutableArray *resultArr = [NSMutableArray array] ;
            FMResultSet* rs_Select = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql_select];
            while ([rs_Select next])
            {
                VisitStoreEntity *entity = [[VisitStoreEntity alloc] initWithFMResultSet:rs_Select];
                [resultArr addObject:entity];
            }
            
            [rs_Select close];
            
            if ([resultArr count] == 0) {
                
                NSString* workendtime = [Utilities DateTimeNow];
                NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_STORE_PHOTO_LIST (IST_STORE_PHOTO_LIST_ID,TAKE_ID,STORE_ZONE,PHOTO_TYPE,INITIAL_PHOTO_PATH,COMPRESS_PHOTO_PATH,COMMENT,SERVER_INSERT_TIME,LAST_MODIFIED_BY,LAST_MODIFIED_TIME) values (?,?,?,?,?,?,?,?,?,?)"];
                FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
                [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
                 [Utilities GetUUID],
                 [CacheManagement instance].currentTakeID,
                 [CacheManagement instance].currentPhotoZone,
                 @"",
                 self.beforePath,
                 self.afterPath,
                 self.textview.text,
                 workendtime,
                 nil,
                 workendtime];
            }
            else {
            
                FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
                NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_IST_STORE_PHOTO_LIST SET INITIAL_PHOTO_PATH='%@',COMPRESS_PHOTO_PATH='%@',ORDER_NO = '%d' , COMMENT = '%@' where TAKE_ID='%@' AND STORE_ZONE ='%@'",self.beforePath,self.afterPath,(int)self.entity.ORDER_NO,self.textview.text,[CacheManagement instance].currentTakeID,[CacheManagement instance].currentPhotoZone];
                [db executeUpdate:sql];
            }
            
           if (self.IsNew) {
                
                [self.PhotoDelegate AddToDBWithCode:self.entity] ;
            }
        }
       
    }
}


-(void)refreshUI
{
    FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM  NVM_IST_STORE_PHOTO_LIST where TAKE_ID='%@' AND STORE_ZONE ='%@'",[CacheManagement instance].currentTakeID,[CacheManagement instance].currentPhotoZone];
    
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
        self.firButton.hidden = NO ;

        [self.beforeimage setImage:[UIImage imageWithContentsOfFile:self.beforePath]];
    }
    else
    {
        self.delete1.hidden = YES;
        self.firButton.hidden = YES ;

        [self.beforeimage setImage:[UIImage imageNamed:SYSLanguage?@"Take-Picture.png":@"photo.png"]];
    }
    if ((![self.afterPath isEqualToString:@"0"])&&(self.afterPath!= nil))
    {
        self.delete2.hidden = NO;
        self.secButton.hidden = NO ;

        [self.afterimage setImage:[UIImage imageWithContentsOfFile:self.afterPath]];
    }
    else
    {
        self.delete2.hidden = YES;
        self.secButton.hidden = YES ;
        [self.afterimage setImage:[UIImage imageNamed:SYSLanguage?@"Take-Picture.png":@"photo.png"]];
    }
}

-(IBAction)showAlert:(id)sender
{
    UIButton* button = sender;
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:SYSLanguage?@"Are You Sure?":@"确定删除？" message:nil delegate:self cancelButtonTitle:SYSLanguage?@"NO":@"取消" otherButtonTitles:SYSLanguage?@"YES":@"确定", nil];
    av.tag = button.tag;
    [av show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if (alertView.tag == 0)
        {
            [self deleteBefore];
        }
        else if (alertView.tag == 1)
        {
            [self deleteAfter];
        }
    }
}

-(IBAction)deleteBefore
{
    [[NSFileManager defaultManager]removeItemAtPath:self.beforePath error:nil];
    self.beforePath = @"0" ;
    FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
    NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_IST_STORE_PHOTO_LIST SET INITIAL_PHOTO_PATH ='%@' where TAKE_ID='%@' AND STORE_ZONE ='%@'",@"0",[CacheManagement instance].currentTakeID,[CacheManagement instance].currentPhotoZone];
    [db executeUpdate:sql];
    [self refreshUI];
}

-(IBAction)deleteAfter
{
    [[NSFileManager defaultManager]removeItemAtPath:self.afterPath error:nil];
    self.afterPath = @"0" ;
    FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
    NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_IST_STORE_PHOTO_LIST SET COMPRESS_PHOTO_PATH ='%@' where TAKE_ID='%@' AND STORE_ZONE ='%@'",@"0",[CacheManagement instance].currentTakeID,[CacheManagement instance].currentPhotoZone];
    [db executeUpdate:sql];
    [self refreshUI];
}

- (UIImagePickerController *)imagePicker {

    if (self.picker == nil) {
        
        self.picker = [[UIImagePickerController alloc] init]  ;
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)firBigPicAction:(id)sender {
    
    self.BigImageView.image = [UIImage imageWithContentsOfFile:self.beforePath];
    [self presentPopupView:self.BigBGView];
}

- (IBAction)secBigPicAction:(id)sender {
    
    self.BigImageView.image = [UIImage imageWithContentsOfFile:self.afterPath];
    [self presentPopupView:self.BigBGView];
}

@end
