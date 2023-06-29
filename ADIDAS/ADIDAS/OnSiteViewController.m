//
//  OnSiteViewController.m
//  VM
//
//  Created by wendy on 14-7-17.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import "OnSiteViewController.h"
#import "Utilities.h"
#import "CacheManagement.h"
#import "SqliteHelper.h"
#import "FMDatabase.h"
#import "OnSiteEntity.h"
#import "UIViewController+MJPopupViewController.h"
#import "WBGImageEditor.h"
#import "WBGMoreKeyboard.h"
#import "WBGImageEditor.h"
#import "WBGMoreKeyboard.h"
#import "CommonDefine.h"

@interface OnSiteViewController ()<WBGImageEditorDelegate,WBGImageEditorDataSource>

@end

@implementation OnSiteViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
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

- (IBAction)beforePhoto {
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

- (IBAction)afterPhtoto {
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
        
        if (![self.beforePath isEqualToString:@"0"]&&
            ![self.beforePath.lowercaseString containsString:@"null"]&&
            self.beforePath.length > 8) {
            [Utilities saveImage:image imgPath:self.beforePath];
            [self.beforeimage setImage:[UIImage imageWithContentsOfFile:self.beforePath]];
        } else {
            NSString* cachePath = [NSString stringWithFormat:kVM_Score_PicturePathString,[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,@"OnSite",self.entity.ZONE_ID];
            self.beforePath = cachePath;
            NSFileManager* fileMannager = [NSFileManager defaultManager];
            if(![fileMannager fileExistsAtPath:cachePath]) {
                [fileMannager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            [Utilities saveImage:image imgPath:cachePath];
            [self.beforeimage setImage:[UIImage imageWithContentsOfFile:cachePath]];
        }
        self.delete1.hidden = NO;
        self.firButton.hidden = NO ;
    }
    
    if(self.picker.view.tag == 1) {
        
        if (![self.afterPath isEqualToString:@"0"]&&
            ![self.afterPath.lowercaseString containsString:@"null"]&&
            self.afterPath.length > 8) {
            [Utilities saveImage:image imgPath:self.afterPath];
            [self.afterimage  setImage:[UIImage imageWithContentsOfFile:self.afterPath]];
        } else {
            NSString* cachePath = [NSString stringWithFormat:kVM_Score_PicturePathString,[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,@"OnSite",[NSString stringWithFormat:@"%@_after",self.entity.ZONE_ID]];
            self.afterPath = cachePath;
            NSFileManager* fileMannager = [NSFileManager defaultManager];
            if(![fileMannager fileExistsAtPath:cachePath]) {
                [fileMannager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            [Utilities saveImage:image imgPath:cachePath];
            [self.afterimage  setImage:[UIImage imageWithContentsOfFile:cachePath]];
        }
        self.delete2.hidden = NO;
        self.secButton.hidden = NO ;
    }
}

- (void)selectPicWith:(UIImage *)img {
    
    [self.picker dismissViewControllerAnimated:YES completion:nil];
    [self.leveyTabBarController hidesTabBar:YES animated:NO];
    [self setImageValueWith:img];
    
    [Utilities saveToAlbumWithMetadata:nil imageData:UIImagePNGRepresentation(img) completionBlock:^{} failureBlock:^(NSError *error) {
         //处理添加失败的方法显示alert让它回到主线程执行，不然那个框框死活不肯弹出来
         dispatch_async(dispatch_get_main_queue(), ^{
             //添加失败一般是由用户不允许应用访问相册造成的，这边可以取出这种情况加以判断一下
             if([error.localizedDescription rangeOfString:@"User denied access"].location != NSNotFound ||[error.localizedDescription rangeOfString:@"用户拒绝访问"].location!=NSNotFound){
             }
         });
     }];
    
}

#pragma mark Camera View Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
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

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    self.addZoneLabel.text = SYSLanguage?@"Add Photo":@"增加照片";
    self.nextZoneLabel.text = SYSLanguage?@"Next Zone":@"下一区域";
    self.bgScrollView.contentSize = CGSizeMake(0, 580+65);
    
    [self.before setContentMode:UIViewContentModeCenter];
    [self.after setContentMode:UIViewContentModeCenter];
    [self configUI];
}

- (void)configUI {
    self.navigationItem.title = SYSLanguage?self.entity.ZONE_NAME_EN:self.entity.ZONE_NAME_CN ;
    self.beforePath = self.entity.BEFORE_PHOTO_PATH;
    self.afterPath = self.entity.AFTER_PHOTO_PATH;
    self.textview.text = @"" ;
    self.beforTextField.text = @"";
    self.afterTextField.text = @"";
    self.label.hidden = NO ;
    if (![self.entity.COMMENT.lowercaseString containsString:@"null"]&&![self.entity.COMMENT isEqualToString:@""]){
        self.label.hidden = YES;
        self.textview.text = self.entity.COMMENT;
    }
    
    self.beforTextField.placeholder = SYSLanguage?@"Choose store adjustment mode":@"请选择店铺调整方式";
    self.afterTextField.placeholder = SYSLanguage?@"Choose store adjustment mode":@"请选择店铺调整方式";

    if (![self.entity.BEFORE_ADJUSTMENT_MODE.lowercaseString containsString:@"null"]&&![self.entity.BEFORE_ADJUSTMENT_MODE isEqualToString:@""]){
        self.beforTextField.text = self.entity.BEFORE_ADJUSTMENT_MODE;
    }

    if (![self.entity.AFTER_ADJUSTMENT_MODE.lowercaseString containsString:@"null"]&&![self.entity.AFTER_ADJUSTMENT_MODE isEqualToString:@""]){
        self.afterTextField.text = self.entity.AFTER_ADJUSTMENT_MODE;
    }
    
    
    if ((![self.beforePath isEqualToString:@"0"])&&
        ![self.beforePath.lowercaseString containsString:@"null"]&&
        self.beforePath.length > 8){
         NSString *newFile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[self.beforePath componentsSeparatedByString:@"/dataCaches"] lastObject]];
        if ([UIImage imageWithContentsOfFile:newFile] != nil) {
            self.beforePath = newFile ;
            [self.beforeimage setImage:[UIImage imageWithContentsOfFile:self.beforePath]];
            self.delete1.hidden = NO;
            self.firButton.hidden = NO ;
        } else {
            [self.beforeimage setImage:[UIImage imageNamed:SYSLanguage?@"Take-Picture.png":@"photo.png"]];
            self.delete1.hidden = YES;
            self.firButton.hidden = YES ;
        }
    } else {
        [self.beforeimage setImage:[UIImage imageNamed:SYSLanguage?@"Take-Picture.png":@"photo.png"]];
        self.delete1.hidden = YES;
        self.firButton.hidden = YES ;

    }
    
    if ((![self.afterPath isEqualToString:@"0"])&&
        ![self.afterPath.lowercaseString containsString:@"null"]&&
        self.afterPath.length > 8) {
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

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.label.hidden = NO;
    }else{
        self.label.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    if ([self.navigationController.viewControllers indexOfObject:self] == NSNotFound){
        [self saveData];
    }
}

- (void)saveData {
    
    if (!self.beforePath || [self.beforePath.lowercaseString containsString:@"null"]) self.beforePath = @"0" ;
    if (!self.afterPath || [self.afterPath.lowercaseString containsString:@"null"]) self.afterPath = @"0" ;
        
    NSMutableArray *resultArr = [NSMutableArray array] ;
    NSString *sql_select = [NSString stringWithFormat:@"Select * From NVM_IST_ONSITE_CHECK_DETAIL where ONSITE_CHECK_ID ='%@' and ZONE_ID = '%@' ",[CacheManagement instance].currentTakeID,self.entity.ZONE_ID];
    FMResultSet* rs_Select = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql_select];
    while ([rs_Select next]){
        OnSiteEntity *entity = [[OnSiteEntity alloc] initWithFMResultSet:rs_Select];
        [resultArr addObject:entity];
    }
    [rs_Select close];
    
    if ([resultArr count] == 0) {
        NSString* workendtime = [Utilities DateTimeNow];
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_ONSITE_CHECK_DETAIL (ONSITE_CHECK_ID,ONSITE_CHECK_DETAIL_ID,ZONE_ID,BEFORE_PHOTO_PATH,AFTER_PHOTO_PATH,BEFORE_ADJUSTMENT_MODE,AFTER_ADJUSTMENT_MODE,COMMENT,LAST_MODIFIED_BY,LAST_MODIFIED_TIME) values (?,?,?,?,?,?,?,?,?,?)"];
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         [CacheManagement instance].currentTakeID,
         [Utilities GetUUID],
         self.entity.ZONE_ID,
         self.beforePath,
         self.afterPath,
         self.beforTextField.text,
         self.afterTextField.text,
         self.textview.text,
         [CacheManagement instance].currentDBUser.userName,
         workendtime];
    }
    else {
    
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_IST_ONSITE_CHECK_DETAIL SET BEFORE_PHOTO_PATH='%@',AFTER_PHOTO_PATH='%@',BEFORE_ADJUSTMENT_MODE='%@',AFTER_ADJUSTMENT_MODE='%@',COMMENT='%@' where ONSITE_CHECK_ID='%@' AND ZONE_ID ='%@'",self.beforePath,self.afterPath,self.beforTextField.text,self.afterTextField.text,self.textview.text,[CacheManagement instance].currentTakeID,self.entity.ZONE_ID];
        [db executeUpdate:sql];
    }
}

- (IBAction)showAlert:(id)sender {
    UIButton* button = sender;
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:SYSLanguage?@"Do you want to delete this image?":@"确定删除？" message:nil delegate:self cancelButtonTitle:SYSLanguage?@"NO":@"取消" otherButtonTitles:SYSLanguage?@"YES":@"确定", nil];
    av.tag = button.tag;
    [av show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        
        if (alertView.tag == 0) {
            [[NSFileManager defaultManager]removeItemAtPath:self.beforePath error:nil];
            self.beforePath = @"0" ;
            FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
            NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_IST_ONSITE_CHECK_DETAIL SET BEFORE_PHOTO_PATH ='%@' where ONSITE_CHECK_ID='%@' AND ZONE_ID ='%@'",@"0",[CacheManagement instance].currentTakeID,self.entity.ZONE_ID];
            [db executeUpdate:sql];
            self.delete1.hidden = YES;
            self.firButton.hidden = YES ;
            [self.beforeimage setImage:[UIImage imageNamed:SYSLanguage?@"Take-Picture.png":@"photo.png"]];
        }
        
        if (alertView.tag == 1) {
            [[NSFileManager defaultManager]removeItemAtPath:self.afterPath error:nil];
            self.afterPath = @"0" ;
            FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
            NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_IST_ONSITE_CHECK_DETAIL SET AFTER_PHOTO_PATH ='%@' where ONSITE_CHECK_ID='%@' AND ZONE_ID ='%@'",@"0",[CacheManagement instance].currentTakeID,self.entity.ZONE_ID];
            [db executeUpdate:sql];
            self.delete2.hidden = YES;
            self.secButton.hidden = YES ;
            [self.afterimage setImage:[UIImage imageNamed:SYSLanguage?@"Take-Picture.png":@"photo.png"]];
        }
    }
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

- (void)didReceiveMemoryWarning {
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

- (IBAction)beforeSelectAction:(id)sender {

    UIAlertController *ac = [UIAlertController alertControllerWithTitle:SYSLanguage?@"Reminding":@"提示" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString *btn in [SYSLanguage?[CacheManagement instance].currentUser.BeforeZoneAdjustModeEN:[CacheManagement instance].currentUser.BeforeZoneAdjustModeCN componentsSeparatedByString:@";"]) {
        UIAlertAction *ac1 = [UIAlertAction actionWithTitle:btn style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.beforTextField.text = btn;
        }];
        [ac addAction:ac1];
    }
    UIAlertAction *ac1 = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.beforTextField.text = @"";
    }];
    [ac addAction:ac1];
    UIAlertAction *ac2 = [UIAlertAction actionWithTitle:SYSLanguage?@"Cancel":@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [ac addAction:ac2];
    [self presentViewController:ac animated:YES completion:nil];
}

- (IBAction)afterSelectAction:(id)sender {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:SYSLanguage?@"Reminding":@"提示" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (NSString *btn in [SYSLanguage?[CacheManagement instance].currentUser.AfterZoneAdjustModeEN:[CacheManagement instance].currentUser.AfterZoneAdjustModeCN componentsSeparatedByString:@";"]) {
        UIAlertAction *ac1 = [UIAlertAction actionWithTitle:btn style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.afterTextField.text = btn;
        }];
        [ac addAction:ac1];
    }
    UIAlertAction *ac1 = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.afterTextField.text = @"";
    }];
    [ac addAction:ac1];
    UIAlertAction *ac2 = [UIAlertAction actionWithTitle:SYSLanguage?@"Cancel":@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [ac addAction:ac2];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)GetCheckIssueFromDB:(NSString *)zoneId {
    FMDatabase* db = [[SqliteHelper shareCommonSqliteHelper]database];
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    {
        NSString *sql = [NSString stringWithFormat:@"select b.ZONE_ID as ZONE_ID_NEW,a.*,b.BEFORE_PHOTO_PATH,b.AFTER_PHOTO_PATH,b.BEFORE_ADJUSTMENT_MODE,b.AFTER_ADJUSTMENT_MODE,b.COMMENT from NVM_MST_ONSITE_PHOTOZONE a left join NVM_IST_ONSITE_CHECK_DETAIL b on b.ZONE_ID like '%%'||a.ZONE_ID||'%%' and b.ONSITE_CHECK_ID = '%@' where a.ZONE_ID = '%@' order by a.ZONE_ORDER asc",[CacheManagement instance].currentTakeID,zoneId] ;
        FMResultSet* rs = [db executeQuery:sql];
        
        while([rs next])
        {
            NvmMstOnSitePhotoZoneEntity* checkEntity = [[NvmMstOnSitePhotoZoneEntity alloc]initWithFMResultSet:rs];
            [temp addObject:checkEntity] ;
        }
        [rs close];
    }
    self.PhotoListArr = [NSArray arrayWithArray:temp];
    [temp removeAllObjects];
    temp = nil;
}

- (IBAction)addAction:(id)sender {
    
    if (((![self.beforePath isEqualToString:@"0"]&&self.beforePath.length > 8&&![self.beforePath.lowercaseString containsString:@"null"])&&
         ((![self.afterPath isEqualToString:@"0"]&&self.afterPath.length > 8&&![self.afterPath.lowercaseString containsString:@"null"])||
          ![self.afterTextField.text isEqualToString:@""]))||
        (![self.beforTextField.text isEqualToString:@""])) {
        [self saveData];
    } else {
        ALERTVIEW(SYSLanguage?@"Please complete this first":@"请先完成此项");
        return;
    }
    
    [self GetCheckIssueFromDB:[self.entity.ZONE_ID componentsSeparatedByString:@"_"].firstObject];
    int count = 0 ;
    for (NvmMstOnSitePhotoZoneEntity *entityTemp in self.PhotoListArr) {
        if ([[entityTemp.ZONE_ID componentsSeparatedByString:@"_"].firstObject isEqualToString:[self.entity.ZONE_ID componentsSeparatedByString:@"_"].firstObject]) {
            count += 1;
        }
    }
    if (count >= self.entity.PHOTO_NUM.intValue) {
        ALERTVIEW(SYSLanguage?@"Sorry,can not add":@"对不起,不能再添加了");
        return;
    }
    
    NvmMstOnSitePhotoZoneEntity *entityNEW = [[NvmMstOnSitePhotoZoneEntity alloc] init];
    entityNEW.ZONE_ID = [NSString stringWithFormat:@"%@_%d",[self.entity.ZONE_ID componentsSeparatedByString:@"_"].firstObject,count];
    entityNEW.ZONE_NAME_CN = [NSString stringWithFormat:@"%@_%d",[self.entity.ZONE_NAME_CN componentsSeparatedByString:@"_"].firstObject,count];
    entityNEW.ZONE_NAME_EN = [NSString stringWithFormat:@"%@_%d",[self.entity.ZONE_NAME_EN componentsSeparatedByString:@"_"].firstObject,count];
    entityNEW.PHOTO_NUM = self.entity.PHOTO_NUM;
    entityNEW.ZONE_ORDER = self.entity.ZONE_ORDER;
    entityNEW.ZONE_STATUS = self.entity.ZONE_STATUS;
    entityNEW.LAST_MODIFIED_BY = self.entity.LAST_MODIFIED_BY;
    entityNEW.LAST_MODIFIED_TIME = self.entity.LAST_MODIFIED_TIME;
    entityNEW.DATA_SOURCE = self.entity.DATA_SOURCE;
    entityNEW.BEFORE_PHOTO_PATH = @"0";
    entityNEW.AFTER_PHOTO_PATH = @"0";
    entityNEW.BEFORE_ADJUSTMENT_MODE = @"";
    entityNEW.AFTER_ADJUSTMENT_MODE = @"";
    entityNEW.COMMENT = @"";
    self.entity = entityNEW;
    [self configUI];
}

- (IBAction)nextZoneAction:(id)sender {
    
    if (!allZoneArray) [self allZoneList];
    for (int x = 0; x < allZoneArray.count; x++) {
        NvmMstOnSitePhotoZoneEntity* checkEntity = [allZoneArray objectAtIndex:x];
        if ([checkEntity.ZONE_ID isEqualToString:[self.entity.ZONE_ID componentsSeparatedByString:@"_"].firstObject]) {
            [self saveData];
            if ([allZoneArray count] > x+1) {
                NvmMstOnSitePhotoZoneEntity* checkEntityNext = [allZoneArray objectAtIndex:x+1];
                [self GetCheckIssueFromDB:checkEntityNext.ZONE_ID];
                if (self.PhotoListArr.count >= 1) {
                    NvmMstOnSitePhotoZoneEntity *entityTemp = self.PhotoListArr.firstObject;
                    
                    int count = 0 ;
                    for (NvmMstOnSitePhotoZoneEntity *onsite in self.PhotoListArr) {
                        if ([[onsite.ZONE_ID componentsSeparatedByString:@"_"].firstObject isEqualToString:[entityTemp.ZONE_ID componentsSeparatedByString:@"_"].firstObject]) {
                            count += 1;
                        }
                    }
                    if (count >= entityTemp.PHOTO_NUM.intValue) {
                        ALERTVIEW(SYSLanguage?@"Sorry,can not add":@"对不起,不能再添加了");
                        return;
                    }
                    
                    
                    if (!entityTemp.ZONE_ID_NEW||[entityTemp.ZONE_ID_NEW isEqual:[NSNull null]]||[entityTemp.ZONE_ID_NEW isEqualToString:@""]) {
                        self.entity = entityTemp;
                    } else {
                        NvmMstOnSitePhotoZoneEntity *entityNEW = [[NvmMstOnSitePhotoZoneEntity alloc] init];
                        entityNEW.ZONE_ID = [NSString stringWithFormat:@"%@_%d",[entityTemp.ZONE_ID componentsSeparatedByString:@"_"].firstObject,count];
                        entityNEW.ZONE_NAME_CN = [NSString stringWithFormat:@"%@_%d",[entityTemp.ZONE_NAME_CN componentsSeparatedByString:@"_"].firstObject,count];
                        entityNEW.ZONE_NAME_EN = [NSString stringWithFormat:@"%@_%d",[entityTemp.ZONE_NAME_EN componentsSeparatedByString:@"_"].firstObject,count];
                        entityNEW.PHOTO_NUM = entityTemp.PHOTO_NUM;
                        entityNEW.ZONE_ORDER = entityTemp.ZONE_ORDER;
                        entityNEW.ZONE_STATUS = entityTemp.ZONE_STATUS;
                        entityNEW.LAST_MODIFIED_BY = entityTemp.LAST_MODIFIED_BY;
                        entityNEW.LAST_MODIFIED_TIME = entityTemp.LAST_MODIFIED_TIME;
                        entityNEW.DATA_SOURCE = entityTemp.DATA_SOURCE;
                        entityNEW.BEFORE_PHOTO_PATH = @"0";
                        entityNEW.AFTER_PHOTO_PATH = @"0";
                        entityNEW.BEFORE_ADJUSTMENT_MODE = @"";
                        entityNEW.AFTER_ADJUSTMENT_MODE = @"";
                        entityNEW.COMMENT = @"";
                        self.entity = entityNEW;
                    }
                    [self configUI];
                }
            } else {
                ALERTVIEW(SYSLanguage?@"Last zone Already":@"已经是最后一个区域");
                return;
            }
            break;
        }
    }
}

- (void)allZoneList {
    
    FMDatabase* db = [[SqliteHelper shareCommonSqliteHelper]database];
    NSMutableArray *temp = [[NSMutableArray alloc]init];
    {
        NSString *sql = @"select * from NVM_MST_ONSITE_PHOTOZONE order by ZONE_ORDER asc" ;
        FMResultSet* rs = [db executeQuery:sql];
        
        while([rs next])
        {
            NvmMstOnSitePhotoZoneEntity* checkEntity = [[NvmMstOnSitePhotoZoneEntity alloc] initWithFirstFMResultSet:rs];
            [temp addObject:checkEntity] ;
        }
        [rs close];
    }
    allZoneArray = [NSArray arrayWithArray:temp];
}

@end
