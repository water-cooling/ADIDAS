//
//  ScoreCardItemViewController.m
//  MobileApp
//
//  Created by 桂康 on 2017/10/25.
//

#import "ScoreCardItemViewController.h"
#import "UIView+SFAdditions.h"
#import "AppDelegate.h"
#import "Utilities.h"
#import "CommonDefine.h"
#import "XMLFileManagement.h"
#import "FMDatabase.h"
#import "SqliteHelper.h"
#import "CacheManagement.h"
#import "UIImage+resize.h"
#import "UIViewController+MJPopupViewController.h"
#import "WBGImageEditor.h"
#import "WBGMoreKeyboard.h"

@interface ScoreCardItemViewController ()<WBGImageEditorDelegate,WBGImageEditorDataSource>

@end

@implementation ScoreCardItemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
}

-(void)configUI
{
    [self.No_label setTitle:[NSString stringWithFormat:@"%d",(int)self.No] forState:UIControlStateNormal];
    self.pagetextfield.text = [NSString stringWithFormat:@"%d",(int)self.No];
    self.Item_textview.text = self.item_name;
    self.scorecardLabel.text = [NSString stringWithFormat:@"权重：%@",self.standard_score] ;
    NSInteger height =  [self heightForString:self.Item_textview.text fontSize:14 andWidth:DEVICE_WID-30];
    self.Item_textview.frame = CGRectMake(20, -6, DEVICE_WID-30, height+20);
    self.Remark_label.frame = CGRectMake(4, height + 15, DEWIDTH-10-8, 400);
    self.Remark_label.text = self.remark;
    self.Remark_label.numberOfLines = 0;
    [self.Remark_label sizeToFit];
    height = self.Item_textview.height + self.Remark_label.height;
    self.small_pageview.frame = CGRectMake(4, height , DEWIDTH-10-8, 369);
    self.comment_textview.text = self.CurrentmanageResultEntity.comment;
    self.scrollview.contentSize = CGSizeMake(10, height+390);
    
    if ([self.comment_textview.text length] > 0)
    {
        self.label.hidden = YES;
    }
    else {
        self.label.hidden = NO ;
    }
    

    self.picpath_1 = self.CurrentmanageResultEntity.picpath1;
    self.picpath_2 = self.CurrentmanageResultEntity.picpath2;
    
    if ([self.picpath_1 length]> 0)
    {
        NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[self.picpath_1 componentsSeparatedByString:@"/dataCaches"] lastObject]];
        self.photo_1.image = [UIImage imageWithContentsOfFile:newfile];
    }
    else
    {
        self.photo_1.image = [UIImage imageNamed:SYSLanguage?@"takepic_en_new.png":@"takepic_new.png"];
    }
    if ([self.picpath_2 length] > 0)
    {
        NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[self.picpath_2 componentsSeparatedByString:@"/dataCaches"] lastObject]];
        self.photo_2.image = [UIImage imageWithContentsOfFile:newfile];
    }
    else
    {
        self.photo_2.image = [UIImage imageNamed:SYSLanguage?@"takepic_en_new.png":@"takepic_new.png"];
    }
}

-(void)deletePic:(id)sender
{
    UILongPressGestureRecognizer* longpress = (UILongPressGestureRecognizer*)sender;
    self.view.tag = longpress.view.tag;
    if (longpress.state == UIGestureRecognizerStateBegan)
    {
        UIActionSheet* ac = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:SYSLanguage?@"Cancel": @"取消" destructiveButtonTitle:SYSLanguage?@"Delete": @"删除" otherButtonTitles:nil, nil];
        [ac showInView:self.view];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 100000 && buttonIndex != 2) {
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if (buttonIndex == 1) {//相册
            
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        self.photoPicker = [[UIImagePickerController alloc]init];
        self.photoPicker.sourceType = sourceType;
        self.photoPicker.delegate = self;
        self.iscamera = YES;
        [self presentViewController:self.photoPicker animated:YES completion:nil];
        
        return ;
    }
    
    if (actionSheet.title == nil)
    {
        if (buttonIndex == 0)
        {
            if (self.view.tag == 111)
            {
                [[NSFileManager defaultManager]removeItemAtPath:self.picpath_1 error:nil];
                self.picpath_1 = nil;
                self.photo_1.image = [UIImage imageNamed:SYSLanguage?@"takepic_en_new.png": @"takepic_new.png"];
            }
            else
            {
                [[NSFileManager defaultManager]removeItemAtPath:self.picpath_2 error:nil];
                self.picpath_2 = nil;
                self.photo_2.image = [UIImage imageNamed:SYSLanguage?@"takepic_en_new.png": @"takepic_new.png"];
            }
        }
    }
}

-(void)takePic:(id)sender
{
    
    TapLongPressImageView* touchPhoto = (TapLongPressImageView*)sender;
    self.view.tag = touchPhoto.tag;
    
    if (ISFROMEHK) {
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:SYSLanguage?@"Choose Picture":@"选择照片" delegate:self cancelButtonTitle:SYSLanguage?@"Cancel":@"取消" destructiveButtonTitle:nil otherButtonTitles:SYSLanguage?@"Camera":@"拍照",SYSLanguage?@"Album":@"从手机相册选择",nil];
        sheet.tag = 100000 ;
        [sheet showInView:self.view];
    }
    else {
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        self.photoPicker = [[UIImagePickerController alloc]init];
        self.photoPicker.sourceType = sourceType;
        self.photoPicker.delegate = self;
        self.iscamera = YES;
        [self presentViewController:self.photoPicker animated:YES completion:nil];
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

#pragma mark - photo

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.leveyTabBarController hidesTabBar:YES animated:NO];
    
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
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    WBGImageEditor *editor = [[WBGImageEditor alloc] initWithImage:image delegate:self dataSource:self] ;
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

- (void)selectPicWith:(UIImage *)img {
    
    [self.photoPicker dismissViewControllerAnimated:YES completion:nil];
    [self.leveyTabBarController hidesTabBar:YES animated:NO];
    [self setImageValueWith:img];
    
    [Utilities saveToAlbumWithMetadata:nil imageData:UIImagePNGRepresentation(img) completionBlock:^
     {}
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
    
    if (self.view.tag == 111)
    {
        self.photo_1.image = [image scaleToSize:CGSizeMake(100, 100)];
        
        if (self.picpath_1 == nil)
        {
            self.picpath_1 = [NSString stringWithFormat:kVMPicturePathString,[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,@"SCORECARD",[NSString stringWithFormat:@"%d",(int)self.No]];
            
            NSFileManager* fileMannager = [NSFileManager defaultManager];
            if(![fileMannager fileExistsAtPath:self.picpath_1])
            {
                [fileMannager createDirectoryAtPath:self.picpath_1 withIntermediateDirectories:YES attributes:nil error:nil];
            }
        }
        [Utilities saveImage:image imgPath:self.picpath_1];
    }
    else
    {
        self.photo_2.image = [image scaleToSize:CGSizeMake(100, 100)];
        
        if (self.picpath_2 == nil)
        {
            self.picpath_2 = [NSString stringWithFormat:kVMPicturePathString,[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,@"SCORECARD",[NSString stringWithFormat:@"%d.1",(int)self.No]];
            NSFileManager* fileMannager = [NSFileManager defaultManager];
            if(![fileMannager fileExistsAtPath:self.picpath_2])
            {
                [fileMannager createDirectoryAtPath:self.picpath_2 withIntermediateDirectories:YES attributes:nil error:nil];
            }
            
        }
        [Utilities saveImage:image imgPath:self.picpath_2];
    }
    self.iscamera = NO;
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    self.iscamera = NO;
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.leveyTabBarController hidesTabBar:YES animated:NO];
}

#pragma mark - textview

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - ibaction

-(void)saveSingleResult
{
    self.CurrentmanageResultEntity.picpath1 = self.picpath_1;
    self.CurrentmanageResultEntity.picpath2 = self.picpath_2;
    self.CurrentmanageResultEntity.scorecard_item_id = self.item_id;
    self.CurrentmanageResultEntity.comment = [self.comment_textview.text getReplaceString];
    self.CurrentmanageResultEntity.scorecard_check_id = [CacheManagement instance].currentVMCHKID;
    self.CurrentmanageResultEntity.scorecard_check_photo_id = [Utilities GetUUID];
    self.CurrentmanageResultEntity.item_no = self.No;
    
    FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
    [db beginTransaction];
    // 删除原有数据
    BOOL result = YES;
    
    @try
    {
        [self deleteLocalArmsCHKItem:db];
        
        [self insertLocalArmsCHKItem:self.CurrentmanageResultEntity broker:db];
    }
    @catch (NSException *exception)
    {
        result = NO;
    }
    @finally
    {
        if (result == YES)
        {
            [db commit];
            // 将界面数据置为默认
            self.item_id = nil;
            [self.CurrentmanageResultEntity cleanScore];
            self.picpath_1 = nil;
            self.picpath_2 = nil;
        }
        else
        {
            [db rollback];
        }
    }
}


// 检查此次检查表是否存在
-(NSArray*)checkARMS_CheckID
{
    __autoreleasing NSMutableArray* resultarr = [[NSMutableArray alloc]init];
    NSString* storecode = [CacheManagement instance].currentStore.StoreCode;
    NSString* workmainID = [CacheManagement instance].currentWorkMainID;
    NSString* sql = [NSString stringWithFormat:@"select * from NVM_IST_SCORECARD_CHECK where WORK_MAIN_ID ='%@' and STORE_CODE= '%@'",workmainID,storecode];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        [resultarr addObject:[rs stringForColumnIndex:0]];
    }
    [rs close];
    
    return resultarr;
    
}

-(void)UpdateARMS_CheckID
{
    NSArray* arr = [self checkARMS_CheckID];
    if ( arr.count > 0)
    {
        // 存在列表
        [CacheManagement instance].currentVMCHKID = [arr objectAtIndex:0];
    }
    else
    {
        NSString* NVM_IST_VM_CHECK_ID =[Utilities GetUUID];
        [CacheManagement instance].currentVMCHKID = NVM_IST_VM_CHECK_ID;
        NSString* storeCode = [CacheManagement instance].currentStore.StoreCode;
        NSString* workdate = [Utilities DateNow];
        NSString* workstarttime = [Utilities DateTimeNow];
        NSString* workendtime = [Utilities DateTimeNow];
        NSString* userid = [CacheManagement instance].currentUser.UserId;
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_SCORECARD_CHECK (SCORECARD_CHK_ID,STORE_CODE,USER_ID,WORK_MAIN_ID,WORK_DATE,WORK_START_TIME,WORK_END_TIME,USER_SUBMIT_TIME,CLIENT_UPLOAD_TIME,SERVER_INSERT_TIME) values (?,?,?,?,?,?,?,?,?,?)"];
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         NVM_IST_VM_CHECK_ID,
         storeCode,
         userid,
         [CacheManagement instance].currentWorkMainID,
         workdate,
         workstarttime,
         workendtime,
         workendtime, //  提交时间
         nil,
         nil];
    }
}


//获取本地评分记录
- (NSMutableArray *) getLocalArmsCHKItemByItem_id
{
    NSString *sql = [NSString stringWithFormat:@"Select * FROM NVM_IST_SCORECARD_CHECK_PHOTO where SCORECARD_ITEM_ID = '%@' and SCORECARD_CHK_ID = '%@'",self.item_id,[CacheManagement instance].currentVMCHKID];
    __autoreleasing NSMutableArray *result = [[NSMutableArray alloc] init];
    
    FMResultSet *rs = nil;
    @try
    {
        rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
        while ([rs next])
        {
            VMManageCardEntity* data = [[VMManageCardEntity alloc]init];
            data.scorecard_check_photo_id = [rs stringForColumnIndex:0];
            data.scorecard_check_id = [rs stringForColumnIndex:1];
            data.scorecard_item_id = [rs stringForColumnIndex:2];;
            data.comment = [rs stringForColumnIndex:3];
            data.picpath1 = [rs stringForColumnIndex:4];
            data.picpath2 = [rs stringForColumnIndex:5];
            [result addObject:data];
        }
    }
    @catch (NSException *e)
    {
        @throw e;
    }
    @finally
    {
        if (rs)
        {
            [rs close];
        }
    }
    
    return result;
}

- (NSMutableArray *) getLocalArmsCHKItemBy:(NSString *)Item_id
{
    NSString *sql = [NSString stringWithFormat:@"Select * FROM NVM_IST_SCORECARD_CHECK_PHOTO where SCORECARD_ITEM_ID = '%@' and SCORECARD_CHK_ID = '%@'",Item_id,[CacheManagement instance].currentVMCHKID];
    __autoreleasing NSMutableArray *result = [[NSMutableArray alloc] init];
    
    FMResultSet *rs = nil;
    @try
    {
        rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
        while ([rs next])
        {
            VMManageCardEntity* data = [[VMManageCardEntity alloc]init];

            data.scorecard_check_photo_id = [rs stringForColumnIndex:0];
            data.scorecard_check_id = [rs stringForColumnIndex:1];
            data.scorecard_item_id = [rs stringForColumnIndex:2];;
            data.comment = [rs stringForColumnIndex:3];
            data.picpath1 = [rs stringForColumnIndex:4];
            data.picpath2 = [rs stringForColumnIndex:5];
            
            [result addObject:data];
        }
    }
    @catch (NSException *e)
    {
        @throw e;
    }
    @finally
    {
        if (rs)
        {
            [rs close];
        }
    }
    
    return result;
}

// 插入本地评分表
-(void) insertLocalArmsCHKItem:(VMManageCardEntity*)data broker:(FMDatabase*)db
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_SCORECARD_CHECK_PHOTO (SCORECARD_CHECK_PHOTO_ID,SCORECARD_CHK_ID,SCORECARD_ITEM_ID,COMMENT,PHOTO_PATH1,PHOTO_PATH2,LAST_MODIFIED_BY,LAST_MODIFIED_TIME) values (?,?,?,?,?,?,?,?)"];
    //    FMDatabase *db = [[SqliteHelper shareCommonSqliteHelper] database];
    [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql,
     data.scorecard_check_photo_id,
     data.scorecard_check_id,
     data.scorecard_item_id,
     data.comment,
     data.picpath1,
     data.picpath2,
     [CacheManagement instance].currentUser.UserName,
     [Utilities DateTimeNow]];
}

//删除原有数据
-(void)deleteLocalArmsCHKItem:(FMDatabase*)db
{
    NSString *sql = [NSString stringWithFormat:@"delete from NVM_IST_SCORECARD_CHECK_PHOTO where SCORECARD_ITEM_ID='%@' and SCORECARD_CHK_ID = '%@'",self.item_id,[CacheManagement instance].currentVMCHKID];
    [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql];
}

//删除原有数据
-(void)deleteLocalArmsCHKItem:(FMDatabase*)db and:(NSString *)itemID
{
    NSString *sql = [NSString stringWithFormat:@"delete from NVM_IST_SCORECARD_CHECK_PHOTO where SCORECARD_ITEM_ID='%@' and SCORECARD_CHK_ID = '%@'",itemID,[CacheManagement instance].currentVMCHKID];
    [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql];
}

-(void)checkButton
{
    if (self.No == [APPDelegate VM_CHECK_ItemList].count)
    {
        // 下一页按钮无效
        self.nextBtn.hidden = YES;
    }
    else if(self.No == 1)
    {
        // 上一页按钮无效
        self.lastBtn.hidden = YES;
    }
    else
    {
        // 都有效
        self.nextBtn.hidden = NO;
        self.lastBtn.hidden = NO;
    }
    
}

-(IBAction)nextIssue
{
    [self.pagetextfield resignFirstResponder];
    // 进入下条之前保存当前结果入数据库
    [self saveSingleResult];
    self.No++ ;
    [self checkButton];
    
    // 读取下题内容
    self.remark = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"REMARK"];
    self.item_name = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_NAME_CN"];
    self.item_id = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"SCORECARD_ITEM_ID"];
    self.standard_score = [NSString stringWithFormat:@"%@",[[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"STANDARD_SCORE"]];
    if (SYSLanguage == EN)
    {
        self.remark = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"REMARK"];
        self.item_name = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_NAME_EN"];
    }
    
    // 根据当前chkid 和 itemid 取数据库中信息
    NSArray* arr = [self getLocalArmsCHKItemByItem_id];
    if ([arr count] > 0)
    {
        self.CurrentmanageResultEntity = [arr objectAtIndex:0];
        self.picpath_1=self.CurrentmanageResultEntity.picpath1;
        self.picpath_2=self.CurrentmanageResultEntity.picpath2;
    }
    else
    {
        [self.CurrentmanageResultEntity cleanScore];
    }
    [self configUI];
}

-(IBAction)lastIssue
{
    [self.pagetextfield resignFirstResponder];
    
    // 保存当前条目结果进数据库 评分如果未填 默认写入3
    [self saveSingleResult];
    
    self.No -- ;
    [self checkButton];
    
    // 读取条目检查说明信息
    self.remark = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"REMARK"];
    self.item_name = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_NAME_CN"];
    self.item_id = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"SCORECARD_ITEM_ID"];
     self.standard_score = [NSString stringWithFormat:@"%@",[[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"STANDARD_SCORE"]];
    if (SYSLanguage == EN)
    {
        self.remark = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"REMARK"];
        self.item_name = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_NAME_EN"];
    }
    
    //  根据当前 条目item id 以及当前 item id取数据库中信息
    NSArray* arr = [self getLocalArmsCHKItemByItem_id];
    if ([arr count] > 0)
    {
        self.CurrentmanageResultEntity = [arr objectAtIndex:0];
    }
    else
    {
        [self.CurrentmanageResultEntity cleanScore];
    }
    [self configUI];
}


-(void)closekeyboard
{
    [self.view endEditing:YES];
}

-(void)backandsave
{
    [self saveSingleResult];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.label.text = SYSLanguage?@"Please input remark":@"请输入说明";
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    }
    self.title = SYSLanguage?@"Score Card":@"Score Card";
    [self.lastBtn setBackgroundImage:[UIImage imageNamed:SYSLanguage?@"last_en.png": @"last.png"] forState:UIControlStateNormal];
    [self.nextBtn setBackgroundImage:[UIImage imageNamed:SYSLanguage?@"next_en.png":@"next.png"] forState:UIControlStateNormal];
    
    self.comment_textview.delegate = self ;
    self.pagetextfield.delegate = self;
    self.photo_1.delegate = self;
    self.photo_2.delegate = self;
    [self UpdateARMS_CheckID];
    [Utilities createLeftBarButton:self clichEvent:@selector(backandsave)];
    
    [self checkButton];
    self.CurrentmanageResultEntity = [VMManageCardEntity getinstance];
    
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
    
    [self.page_view setBackgroundColor:[UIColor clearColor]];

    [self.page_view addSubview:self.small_pageview];
    [self.page_view addSubview:self.Remark_label];
    
    NSArray* arr = [self getLocalArmsCHKItemByItem_id];
    
    if ([arr count] > 0)
    {
        self.CurrentmanageResultEntity = [arr objectAtIndex:0];
    }
    else
    {
        [self.CurrentmanageResultEntity cleanScore];
    }
    
    [self configUI];
    if ([self.comment_textview.text length] > 0)
    {
        self.label.hidden = YES;
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.leveyTabBarController hidesTabBar:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

-(IBAction)gotoPage:(id)sender
{
    // 进入下条之前保存当前结果入数据库
    [self saveSingleResult];
    
    [self.pagetextfield resignFirstResponder];
    NSInteger go_No = [self.pagetextfield.text integerValue];
    if ((go_No <= 0) ||(go_No > [APPDelegate VM_CHECK_ItemList].count))
    {
        ALERTVIEW(SYSLanguage?@"That does not exist":@"该项不存在");
        return;
    }
    else
    {
        self.No = go_No;
        // 首先检查根据 No找到itemid 和当前check id 去找到该数据是否有 ，若有 则读取本地
        self.remark = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"REMARK"];
        self.item_name = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_NAME_CN"];
        self.item_id = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"SCORECARD_ITEM_ID"];
         self.standard_score = [NSString stringWithFormat:@"%@",[[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"STANDARD_SCORE"]];
        if (SYSLanguage == EN)
        {
            self.remark = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"REMARK"];
            self.item_name = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_NAME_EN"];
        }
        // 取数据库中信息
        NSArray* arr = [self getLocalArmsCHKItemByItem_id];
        if ([arr count] > 0)
        {
            self.CurrentmanageResultEntity = [arr objectAtIndex:0];
        }
        else
        {
            [self.CurrentmanageResultEntity cleanScore];
        }
        [self configUI];
    }
    
}


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.25f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.view.frame = CGRectMake(0.0f, -228, DEVICE_WID, DEHEIGHT);
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.25f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.view.frame =CGRectMake(0, 0, DEVICE_WID, DEHEIGHT);
    [UIView commitAnimations];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.label.hidden = NO;
    }else{
        self.label.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPicpath_1:(NSString *)picpath_1 {
    
    _picpath_1 = picpath_1 ;
    if (picpath_1.length > 0) self.firButton.hidden = NO ;
    else self.firButton.hidden = YES ;
}

- (void)setPicpath_2:(NSString *)picpath_2 {
    _picpath_2 = picpath_2 ;
    if (picpath_2.length > 0) self.secButton.hidden = NO ;
    else self.secButton.hidden = YES ;
}

- (IBAction)leftPicDetailAction:(id)sender {
    
    if ([self.picpath_1 length]> 0) {
        
        NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[self.picpath_1 componentsSeparatedByString:@"/dataCaches"] lastObject]];
        [self.bigImage setImage:[UIImage imageWithContentsOfFile:newfile]] ;
        [self presentPopupView:self.ImageBGView];
    }
}

- (IBAction)rightPicDetailAction:(id)sender {
    
    if ([self.picpath_2 length]> 0) {
        
        NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[self.picpath_2 componentsSeparatedByString:@"/dataCaches"] lastObject]];
        [self.bigImage setImage:[UIImage imageWithContentsOfFile:self.picpath_2]] ;
        [self presentPopupView:self.ImageBGView];
    }
}

- (void)showBigImage:(NSString *)path {
    
    [self.bigImage setImage:[UIImage imageWithContentsOfFile:path]] ;
    [self presentPopupView:self.ImageBGView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    
}

@end
