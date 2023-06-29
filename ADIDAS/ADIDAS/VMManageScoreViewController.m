//
//  ManageScoreViewController.m
//  ADIDAS
//
//  Created by wendy on 14-4-24.
//
//

#import "VMManageScoreViewController.h"
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
#import "VM_CHECK_ITEM_Entity.h"
#import "kidDetailView.h"
#import "WBGImageEditor.h"
#import "WBGMoreKeyboard.h"

@interface VMManageScoreViewController ()<KidDelegate,WBGImageEditorDelegate,WBGImageEditorDataSource>
@end

@implementation VMManageScoreViewController



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

-(void)Statistics // 统计结果
{
    NSString* sql  = [NSString stringWithFormat:@"select * from NVM_IST_VM_CHECK_ITEM where VM_CHK_ID = '%@'",[CacheManagement instance].currentVMCHKID];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
    
    double_t score = 0;
    double_t totalNumber = [APPDelegate VM_CHECK_ItemList].count;
    int Y = 0;
    int N = 0;
    int NA = 0;
    while ([rs next])
    {
        if ([[rs stringForColumnIndex:3] isEqualToString:self.maxScore])
        {
            score ++;
            Y ++;
        }
        if ([[rs stringForColumnIndex:3] isEqualToString:@"0"])
        {
            N ++;
        }
        if ([[rs stringForColumnIndex:3] isEqualToString:@"-1"])
        {
            totalNumber -- ;
            NA ++;
        }
    }
    [rs close];
    CGFloat totalScore = [self.maxScore floatValue]*Y;
    CGFloat totalScore_ = [self.maxScore floatValue]*totalNumber;

    NSString *allTotalScore = [NSString stringWithFormat:@"%.1f",(totalScore/totalScore_) * 100];
    if ([[CacheManagement instance].dataSource containsString:@"CN"]) {
        
        allTotalScore = [NSString stringWithFormat:@"%.f",(totalScore/totalScore_) * 100] ;
    }
    
    [self.filterview.totalScoreButton setTitle:allTotalScore forState:UIControlStateNormal];
    if ((totalScore/totalScore_) * 100 < self.TOTAL_num)
    {
        [self.filterview.totalScoreButton setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
    }
    else if ((totalScore/totalScore_) * 100 > self.TOTAL_num)
    {
        [self.filterview.totalScoreButton setBackgroundImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateNormal];
    }
    else if ((totalScore/totalScore_) * 100 == self.TOTAL_num)
    {
        [self.filterview.totalScoreButton setBackgroundImage:[UIImage imageNamed:@"yellow.png"] forState:UIControlStateNormal];
    }
    
    if (Y < self.Y_num)
    {
        [self.filterview.YButton setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
    }
    else if (Y > self.Y_num)
    {
        [self.filterview.YButton setBackgroundImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateNormal];
    }
    else if (Y == self.Y_num)
    {
        [self.filterview.YButton setBackgroundImage:[UIImage imageNamed:@"yellow.png"] forState:UIControlStateNormal];
    }
    
    if (N < self.N_num)
    {
        [self.filterview.NButton setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
    }
    else if (N > self.N_num)
    {
        [self.filterview.NButton setBackgroundImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateNormal];
    }
    else if (N == self.N_num)
    {
        [self.filterview.NButton setBackgroundImage:[UIImage imageNamed:@"yellow.png"] forState:UIControlStateNormal];
    }
    
    if (NA < self.NA_num)
    {
        [self.filterview.NAButton setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
    }
    else if (NA > self.NA_num)
    {
        [self.filterview.NAButton setBackgroundImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateNormal];
    }
    else if (NA == self.NA_num)
    {
        [self.filterview.NAButton setBackgroundImage:[UIImage imageNamed:@"yellow.png"] forState:UIControlStateNormal];
    }


    [self.filterview.YButton setTitle:[NSString stringWithFormat:@"%d",Y] forState:UIControlStateNormal];
    [self.filterview.NButton setTitle:[NSString stringWithFormat:@"%d",N] forState:UIControlStateNormal];
    [self.filterview.NAButton setTitle:[NSString stringWithFormat:@"%d",NA] forState:UIControlStateNormal];

}


-(void)configUI
{
//    for (id obj in [APPDelegate Store_NA_List])
//    {
//        NSLog(@"%@",obj);
//        if ([[obj valueForKey:@"FrArmsItemId"] isEqualToString:self.item_id])
//        {
//            self.CurrentmanageResultEntity.score = -1;
//            self.CurrentmanageResultEntity.reason = @"经销商店铺可忽略";
//        }
//    }
    
    NSArray* ar = [self.scoreOption componentsSeparatedByString:@","];
    if (ar.count == 2)
    {
        self.NA_btn.hidden = YES;
        self.NA_label.hidden = YES;
    }
    else
    {
        self.NA_btn.hidden = NO;
        self.NA_label.hidden = NO;
    }
    [self.No_label setTitle:[NSString stringWithFormat:@"%d",(int)self.No] forState:UIControlStateNormal];
    self.pagetextfield.text = [NSString stringWithFormat:@"%d",(int)self.No];
    self.Item_textview.text = self.item_name;
  
    NSInteger height =  [self heightForString:self.Item_textview.text fontSize:14 andWidth:DEVICE_WID-30];
    self.Item_textview.frame = CGRectMake(20, -6, DEVICE_WID-30, height+20);
    self.Remark_label.frame = CGRectMake(4, height + 15, DEWIDTH-10-8, 400);
    self.Remark_label.text = self.remark;
    self.Remark_label.numberOfLines = 0;
    [self.Remark_label sizeToFit];
    height = self.Item_textview.height + self.Remark_label.height;
    self.small_pageview.frame = CGRectMake(4, height + 15 , DEWIDTH-10-8, 380);
    self.comment_textview.text = self.CurrentmanageResultEntity.comment;
    self.scrollview.contentSize = CGSizeMake(DEWIDTH, height+470);
    
    if ([self.comment_textview.text length] > 0)
    {
        self.label.hidden = YES;
    }
    else {
        self.label.hidden = NO ;
    }
    
    self.picpath_1 = self.CurrentmanageResultEntity.picpath1;
    self.picpath_2 = self.CurrentmanageResultEntity.picpath2;
    if ([self.picpath_1 length]> 0) {
        
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

    
    if (!self.CurrentmanageResultEntity.score) {
        
        self.scoreResult = @"3" ;
    }
    else {
    
        self.scoreResult = self.CurrentmanageResultEntity.score;
    }
    
    self.reason = self.CurrentmanageResultEntity.reason;
    
    CGRect secondpageview = CGRectMake(0, 57, DEVICE_WID-10-8, 286) ;
    
    if ([self.scoreResult isEqualToString:self.maxScore])
    {
        self.reasonBtn.hidden = YES;
        secondpageview.origin.y = 57 ;
        [self.Yes_btn setBackgroundImage:[UIImage imageNamed:@"form2.png"] forState:UIControlStateNormal];
        [self.No_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        [self.NA_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
      
    }
    else if([self.scoreResult isEqualToString:@"0"])
    {
        self.reasonBtn.hidden = YES;
        secondpageview.origin.y = 57 ;
        [self.Yes_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        [self.No_btn setBackgroundImage:[UIImage imageNamed:@"form2.png"] forState:UIControlStateNormal];
        [self.NA_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
    }
    else if([self.scoreResult isEqualToString:@"-1"])
    {
        self.reasonBtn.hidden = NO;
        self.reason = self.CurrentmanageResultEntity.reason;
        [self.reasonBtn setTitle:self.reason forState:UIControlStateNormal];
        secondpageview.origin.y = 90 ;
        [self.Yes_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        [self.No_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        [self.NA_btn setBackgroundImage:[UIImage imageNamed:@"form2.png"] forState:UIControlStateNormal];
    }
    else if ([self.scoreResult isEqualToString:@"3"])
    {
        self.reasonBtn.hidden = YES;
        self.secondpageview.frame = CGRectMake(0, 57, DEVICE_WID-10-8, 286);
        [self.Yes_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        [self.No_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        [self.NA_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
    }
    else if ([self.reasonsArr count] == 0)
    {
        self.reasonBtn.hidden = YES;
    }
    self.secondpageview.frame = secondpageview ;
    [self Statistics];
    
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
        self.photoPicker.modalPresentationStyle = UIModalPresentationFullScreen;
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
    else if ([actionSheet.title isEqualToString: SYSLanguage?@"Choose reason": @"选择原因"])
    {
        self.reason = [self.reasonsArr objectAtIndex:buttonIndex];
        [self.reasonBtn setTitle:self.reason forState:UIControlStateNormal];
    }
    if ([self.reason isEqualToString:SYSLanguage?@"Other reason":@"其他原因"] || [self.reason isEqualToString:SYSLanguage?@"Other reason":@"其他"])
    {
        [self.comment_textview becomeFirstResponder];
       
    }
    else
    {
        [self.comment_textview resignFirstResponder];
      
    }
}

-(void)takePic:(id)sender
{
    if ([self.scoreResult isEqualToString:@"3"])
    {
        UIAlertView* av = [[UIAlertView alloc]initWithTitle:nil message:SYSLanguage?@"Can not scoring can not take pictures": @"未打分不能拍照" delegate:self cancelButtonTitle:SYSLanguage?@"OK": @"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
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
        self.photoPicker.modalPresentationStyle = UIModalPresentationFullScreen;
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

- (void)selectPicWith:(UIImage *)img {

    [self.photoPicker dismissViewControllerAnimated:YES completion:nil];
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
    
    if (self.view.tag == 111)
    {
        self.photo_1.image = [image scaleToSize:CGSizeMake(100, 100)];
        
        //        NSString* cachePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Private Documents/Images/%@/%@",[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode]];
        if (self.picpath_1 == nil)
        {
            self.picpath_1 = [NSString stringWithFormat:kVMPicturePathString,[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,@"VM_CHECK",[NSString stringWithFormat:@"%d",(int)self.No]];
            
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
            self.picpath_2 = [NSString stringWithFormat:kVMPicturePathString,[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,@"VM_CHECK",[NSString stringWithFormat:@"%d.1",(int)self.No]];
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
//    if ([text isEqualToString:@"\x20"])
//    {
//        return NO;
//    }
    return YES;
}

#pragma mark - ibaction

-(void)saveSingleResult
{
    
    if (ISKIDS) {
        
        for (kidDetailView *view in self.viewArray) {
            
            self.CurrentmanageResultEntity.score = view.scoreResult;
            self.CurrentmanageResultEntity.reason = view.reason;
            self.CurrentmanageResultEntity.picpath1 = view.picpath_1;
            self.CurrentmanageResultEntity.picpath2 = view.picpath_2;
            self.CurrentmanageResultEntity.item_id = view.item_id;
            
            self.CurrentmanageResultEntity.comment = [view.comment_textview.text getReplaceString];
            self.CurrentmanageResultEntity.check_id = [CacheManagement instance].currentVMCHKID;
            self.CurrentmanageResultEntity.check_item_id = [Utilities GetUUID];
            self.CurrentmanageResultEntity.item_no = view.No;
            
            FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
            [db beginTransaction];
            // 删除原有数据
            BOOL result = YES;
            
            @try
            {
                [self deleteLocalArmsCHKItem:db and:view.item_id];
                
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
                    
                    view.reason = nil;
                    [view.reasonBtn setTitle:@"请选择原因" forState:UIControlStateNormal];
                    view.item_id = nil;
                    [self.CurrentmanageResultEntity cleanScore];
                    view.scoreResult = @"3";
                    view.picpath_1 = nil;
                    view.picpath_2 = nil;
                }
                else
                {
                    [db rollback];
                }
            }
        }
    }
    else {
    
        self.CurrentmanageResultEntity.score = self.scoreResult;
        self.CurrentmanageResultEntity.reason = self.reason;
        self.CurrentmanageResultEntity.picpath1 = self.picpath_1;
        self.CurrentmanageResultEntity.picpath2 = self.picpath_2;
        self.CurrentmanageResultEntity.item_id = self.item_id;
        
        self.CurrentmanageResultEntity.comment = [self.comment_textview.text getReplaceString];
        self.CurrentmanageResultEntity.check_id = [CacheManagement instance].currentVMCHKID;
        self.CurrentmanageResultEntity.check_item_id = [Utilities GetUUID];
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
                
                self.reason = nil;
                [self.reasonBtn setTitle:@"请选择原因" forState:UIControlStateNormal];
                self.item_id = nil;
                [self.CurrentmanageResultEntity cleanScore];
                self.scoreResult = @"3";
                self.picpath_1 = nil;
                self.picpath_2 = nil;
            }
            else
            {
                [db rollback];
            }
        }
    }
}


// 检查此次检查表是否存在
-(NSArray*)checkARMS_CheckID
{
    __autoreleasing NSMutableArray* resultarr = [[NSMutableArray alloc]init];
    NSString* storecode = [CacheManagement instance].currentStore.StoreCode;
    NSString* workmainID = [CacheManagement instance].currentWorkMainID;
    NSString* sql = [NSString stringWithFormat:@"select * from NVM_IST_VM_CHECK where WORK_MAIN_ID ='%@' and STORE_CODE= '%@'",workmainID,storecode];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        //			SyncParaVersionEntity * entity = [[SyncParaVersionEntity alloc] initWithFMResultSet:rs];
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
        NSString* NVM_IST_VM_CHECK_ID =[Utilities GetUUID];  [CacheManagement instance].currentVMCHKID = NVM_IST_VM_CHECK_ID;
        NSString* storeCode = [CacheManagement instance].currentStore.StoreCode;
        NSString* workdate = [Utilities DateNow];
        NSString* workstarttime = [Utilities DateTimeNow];
        NSString* workendtime = [Utilities DateTimeNow];
        NSString* userid = [CacheManagement instance].currentUser.UserId;
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_VM_CHECK (VM_CHK_ID,STORE_CODE,USER_ID,WORK_MAIN_ID,WORK_DATE,WORK_START_TIME,WORK_END_TIME,TOTAL_SCORE,USER_SUBMIT_TIME,CLIENT_UPLOAD_TIME,SERVER_INSERT_TIME) values (?,?,?,?,?,?,?,?,?,?,?)"];
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         NVM_IST_VM_CHECK_ID,
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


//获取本地评分记录
- (NSMutableArray *) getLocalArmsCHKItemByItem_id
{
	NSString *sql = [NSString stringWithFormat:@"Select * FROM NVM_IST_VM_CHECK_ITEM where ITEM_ID = '%@' and VM_CHK_ID = '%@'",self.item_id,[CacheManagement instance].currentVMCHKID];
	__autoreleasing NSMutableArray *result = [[NSMutableArray alloc] init];
	
	FMResultSet *rs = nil;
	@try
    {
        rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
		while ([rs next])
        {
            VMManageScoreEntity* data = [[VMManageScoreEntity alloc]init];
            data.check_item_id = [rs stringForColumnIndex:0];
            data.check_id = [rs stringForColumnIndex:1];
            data.item_id = [rs stringForColumnIndex:2];
            data.score = [rs stringForColumnIndex:3];
            data.reason = [rs stringForColumnIndex:4];
            data.comment = [rs stringForColumnIndex:5];
            data.picpath1 = [rs stringForColumnIndex:6];
            data.picpath2 = [rs stringForColumnIndex:7];
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
    NSString *sql = [NSString stringWithFormat:@"Select * FROM NVM_IST_VM_CHECK_ITEM where ITEM_ID = '%@' and VM_CHK_ID = '%@'",Item_id,[CacheManagement instance].currentVMCHKID];
    __autoreleasing NSMutableArray *result = [[NSMutableArray alloc] init];
    
    FMResultSet *rs = nil;
    @try
    {
        rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
        while ([rs next])
        {
            VMManageScoreEntity* data = [[VMManageScoreEntity alloc]init];
            data.check_item_id = [rs stringForColumnIndex:0];
            data.check_id = [rs stringForColumnIndex:1];
            data.item_id = [rs stringForColumnIndex:2];
            data.score = [rs stringForColumnIndex:3];
            data.reason = [rs stringForColumnIndex:4];
            data.comment = [rs stringForColumnIndex:5];
            data.picpath1 = [rs stringForColumnIndex:6];
            data.picpath2 = [rs stringForColumnIndex:7];
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
-(void) insertLocalArmsCHKItem:(VMManageScoreEntity*)data broker:(FMDatabase*)db
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_VM_CHECK_ITEM (VM_CHK_ITEM_ID,VM_CHK_ID,ITEM_ID,SCORE,REASON,COMMENT,PHOTO_PATH1,PHOTO_PATH2,LAST_MODIFIED_BY,LAST_MODIFIED_TIME,ITEM_NO) values (?,?,?,?,?,?,?,?,?,?,?)"];
//    FMDatabase *db = [[SqliteHelper shareCommonSqliteHelper] database];
    [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql,
                                                            data.check_item_id,
                                                            data.check_id,
                                                            data.item_id,
                                                            data.score,
                                                            data.reason,
                                                            data.comment,
                                                            data.picpath1,
                                                            data.picpath2,
                                                            [CacheManagement instance].currentDBUser.userName,
                                                            [Utilities DateTimeNow],
                                                           [NSNumber numberWithInteger:data.item_no]];
}

//删除原有数据
-(void)deleteLocalArmsCHKItem:(FMDatabase*)db
{
    NSString *sql = [NSString stringWithFormat:@"delete from NVM_IST_VM_CHECK_ITEM where ITEM_ID='%@' and VM_CHK_ID = '%@'",self.item_id,[CacheManagement instance].currentVMCHKID];
    [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql];
}

//删除原有数据
-(void)deleteLocalArmsCHKItem:(FMDatabase*)db and:(NSString *)itemID
{
    NSString *sql = [NSString stringWithFormat:@"delete from NVM_IST_VM_CHECK_ITEM where ITEM_ID='%@' and VM_CHK_ID = '%@'",itemID,[CacheManagement instance].currentVMCHKID];
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

-(IBAction)selectreason
{
    self.ac = [[UIActionSheet alloc]initWithTitle:SYSLanguage?@"Choose reason": @"选择原因" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
   
    for (NSString* title in self.reasonsArr)
    {
        [self.ac addButtonWithTitle:title];
    }
    [self.ac showInView:self.view];
}


-(IBAction)nextIssue
{
  
    [self.pagetextfield resignFirstResponder];
    
    if (ISKIDS) {
        
        int index = 0 ;
        
        for (kidDetailView *view in self.viewArray) {
            
            // 配置页面检查问答数据
            if ([view.scoreResult isEqualToString:@"0"] || [view.reason isEqualToString:@"其他原因"]||[view.reason isEqualToString:SYSLanguage?@"other":@"其他"]) {
                if ([view.comment_textview.text length] == 0)
                {
                    NSString *showStr = [NSString stringWithFormat:@"第%d项请填写说明",index+1] ;
                    if (SYSLanguage) showStr = [NSString stringWithFormat:@"Please input remark at %d",index+1] ;
                    
                    ALERTVIEW(showStr);
                    return;
                }
                
                if ([[[CacheManagement instance].dataSource lowercaseString] containsString:@"rbk"]) {
                    
                    NSString *pic1 = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[self.picpath_1 componentsSeparatedByString:@"dataCaches"] lastObject]];
                    NSString *pic2 = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[self.picpath_2 componentsSeparatedByString:@"dataCaches"] lastObject]];
                    
                    if (![[NSFileManager defaultManager] fileExistsAtPath:pic1]&&![[NSFileManager defaultManager] fileExistsAtPath:pic2])
                    {
                        ALERTVIEW(SYSLanguage?@"Please take at least one photo":@"请至少拍摄一张照片");
                        return;
                    }
                }
            }
            if ([view.scoreResult isEqualToString:@"-1"])
            {
                if (view.reason == nil)
                {
                    NSString *showStr = [NSString stringWithFormat:@"第%d项请选择原因",index+1] ;
                    if (SYSLanguage) showStr = [NSString stringWithFormat:@"Please choose reason at %d",index+1] ;
                    
                    ALERTVIEW(showStr);
                    return;
                }
            }
            index++ ;
        }
        
        [self saveSingleResult];
        
        self.No++ ;
        [self checkButton];
        
        for (kidDetailView *view in self.viewArray) {
            
            [view removeFromSuperview] ;
        }
        
        [self.viewArray removeAllObjects];
        
        [self refreshKidPage:self.No];
        
       
    }
    else {
    
        // 配置页面检查问答数据
        if ([self.scoreResult isEqualToString:@"0"] || [self.reason isEqualToString:@"其他原因"]||[self.reason isEqualToString:SYSLanguage?@"other":@"其他"]) {
            if ([self.comment_textview.text length] == 0)
            {
                ALERTVIEW(SYSLanguage?@"Please input remark":@"请填写说明");
                return;
            }
            
            if ([[[CacheManagement instance].dataSource lowercaseString] containsString:@"rbk"]) {
               
                NSString *pic1 = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[self.picpath_1 componentsSeparatedByString:@"dataCaches"] lastObject]];
                NSString *pic2 = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[self.picpath_2 componentsSeparatedByString:@"dataCaches"] lastObject]];
                
                if (![[NSFileManager defaultManager] fileExistsAtPath:pic1]&&![[NSFileManager defaultManager] fileExistsAtPath:pic2])
                {
                    ALERTVIEW(SYSLanguage?@"Please take at least one photo":@"请至少拍摄一张照片");
                    return;
                }
            }
        }
        
        if ([self.scoreResult isEqualToString:@"-1"])
        {
            if (self.reason == nil)
            {
                ALERTVIEW(SYSLanguage?@"Please choose reason":@"请选择原因");
                return;
            }
        }
        // 进入下条之前保存当前结果入数据库
        self.reasonBtn.hidden = YES;
        [self saveSingleResult];
        
        self.No++ ;
        [self checkButton];
        
        // 读取下题内容
        self.remark = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"REMARK_CN"];
        self.scoreOption = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"SCORE_OPTION"];
        self.item_name = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_NAME_CN"];
        self.reasonsArr = [[[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1]valueForKey:@"REASON_CN"]componentsSeparatedByString:@"|"];
        self.item_id = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"VM_ITEM_ID"];
        if (SYSLanguage == EN)
        {
            self.remark = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"REMARK_EN"];
            self.item_name = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_NAME_EN"];
            self.reasonsArr = [[[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1]valueForKey:@"REASON_EN"]componentsSeparatedByString:@"|"];
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
    
    
    
//    CATransition *animation = [CATransition animation];
//    animation.delegate = self;
//    animation.duration = 0.3;
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
//    animation.type = kCATransitionPush;
//    animation.subtype = kCATransitionFromRight;
//    [[self.page_view layer] addAnimation:animation forKey:@"animation"];
}

-(IBAction)lastIssue
{
    [self.pagetextfield resignFirstResponder];
    
    if (ISKIDS) {
        
        int index = 0 ;
        
        for (kidDetailView *view in self.viewArray) {
            
            // 配置页面检查问答数据
            if ([view.scoreResult isEqualToString:@"0"] || [view.reason isEqualToString:@"其他原因"]||[view.reason isEqualToString:SYSLanguage?@"other":@"其他"]) {
                if ([view.comment_textview.text length] == 0)
                {
                    NSString *showStr = [NSString stringWithFormat:@"第%d项请填写说明",index+1] ;
                    if (SYSLanguage) showStr = [NSString stringWithFormat:@"Please input remark at %d",index+1] ;
                    
                    ALERTVIEW(showStr);
                    return;
                }
                
                if ([[[CacheManagement instance].dataSource lowercaseString] containsString:@"rbk"]) {
                    NSString *pic1 = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[self.picpath_1 componentsSeparatedByString:@"dataCaches"] lastObject]];
                    NSString *pic2 = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[self.picpath_2 componentsSeparatedByString:@"dataCaches"] lastObject]];
                    
                    if (![[NSFileManager defaultManager] fileExistsAtPath:pic1]&&![[NSFileManager defaultManager] fileExistsAtPath:pic2])
                    {
                        ALERTVIEW(SYSLanguage?@"Please take at least one photo":@"请至少拍摄一张照片");
                        return;
                    }
                }
            }
            
            if ([view.scoreResult isEqualToString:@"-1"])
            {
                if (view.reason == nil)
                {
                    NSString *showStr = [NSString stringWithFormat:@"第%d项请选择原因",index+1] ;
                    if (SYSLanguage) showStr = [NSString stringWithFormat:@"Please choose reason at %d",index+1] ;
                    
                    ALERTVIEW(showStr);
                    return;
                }
            }
            
            index++ ;
        }
        
        [self saveSingleResult];
        
        self.No-- ;
        [self checkButton];
        
        for (kidDetailView *view in self.viewArray) {
            
            [view removeFromSuperview] ;
        }
        
        [self.viewArray removeAllObjects];
        
        [self refreshKidPage:self.No];
    }
    else {
    
        if ([self.scoreResult isEqualToString:@"0"] || [self.reason isEqualToString:@"其他原因"]||[self.reason isEqualToString:@"其他"]) {
            if ([self.comment_textview.text length] == 0)
            {
                ALERTVIEW(SYSLanguage?@"Please input remark":@"请填写说明");
                return;
            }
            
            if ([[[CacheManagement instance].dataSource lowercaseString] containsString:@"rbk"]) {
                
                NSString *pic1 = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[self.picpath_1 componentsSeparatedByString:@"dataCaches"] lastObject]];
                NSString *pic2 = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[self.picpath_2 componentsSeparatedByString:@"dataCaches"] lastObject]];
                
                if (![[NSFileManager defaultManager] fileExistsAtPath:pic1]&&![[NSFileManager defaultManager] fileExistsAtPath:pic2])
                {
                    ALERTVIEW(SYSLanguage?@"Please take at least one photo":@"请至少拍摄一张照片");
                    return;
                }
            }
        }
        
        if ([self.scoreResult isEqualToString:@"-1"])
        {
            if (self.reason == nil)
            {
                ALERTVIEW(SYSLanguage?@"Please choose reason":@"请选择原因");
                return;
            }
        }
        
        self.reasonBtn.hidden = YES;
        // 保存当前条目结果进数据库 评分如果未填 默认写入3
        [self saveSingleResult];
        
        self.No -- ;
        [self checkButton];
        
        
        // 读取条目检查说明信息
        self.remark = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"REMARK_CN"];
        self.scoreOption = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"SCORE_OPTION"];
        self.item_name = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_NAME_CN"];
        self.reasonsArr = [[[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1]valueForKey:@"REASON_CN"]componentsSeparatedByString:@"|"];
        self.item_id = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"VM_ITEM_ID"];
        if (SYSLanguage == EN)
        {
            self.remark = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"REMARK_EN"];
            self.item_name = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_NAME_EN"];
            self.reasonsArr = [[[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1]valueForKey:@"REASON_EN"]componentsSeparatedByString:@"|"];
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
    
//    CATransition *animation = [CATransition animation];
//    animation.delegate = self;
//    animation.duration = 0.5;
//    animation.timingFunction = UIViewAnimationCurveEaseInOut;
//    animation.type = kCATransitionPush;
//    animation.subtype = kCATransitionFromLeft;
//    [[self.page_view layer] addAnimation:animation forKey:@"animation"];

}

-(IBAction)score:(id)sender
{
    UIButton* button = (UIButton*)sender;
    NSInteger tag = button.tag;
    if (tag == 1)
    {
        self.reasonBtn.hidden = YES;
        self.reason = nil;
        self.secondpageview.frame = CGRectMake(0, 57, DEVICE_WID-10-8, 286);
        self.scoreResult = self.maxScore ;
        [self.Yes_btn setBackgroundImage:[UIImage imageNamed:@"form2.png"] forState:UIControlStateNormal];
        [self.No_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        [self.NA_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        [self.comment_textview resignFirstResponder];
    }
    else if (tag == 2)
    {
        if ([self.reasonsArr count] == 0 || ([self.reasonsArr count] == 1 && ([[self.reasonsArr firstObject] isEqualToString:@""]||![self.reasonsArr firstObject])))
        {
            self.reasonBtn.hidden = YES;
            self.reason = @"";
        }
        else
        {
            self.reasonBtn.hidden = NO;
            [self selectreason];
            self.secondpageview.frame = CGRectMake(0, 90 ,DEVICE_WID-10-8,286);
        }
        self.scoreResult = @"-1";
        
        [self.Yes_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        [self.No_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        [self.NA_btn setBackgroundImage:[UIImage imageNamed:@"form2.png"] forState:UIControlStateNormal];
    }
    else if (tag == 0)
    {
        self.reasonBtn.hidden = YES;
        self.reason = nil;
        self.secondpageview.frame = CGRectMake(0, 57, DEVICE_WID-10-8, 286);
        self.scoreResult = @"0" ;
        [self.comment_textview becomeFirstResponder];
       
        [self.Yes_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        [self.No_btn setBackgroundImage:[UIImage imageNamed:@"form2.png"] forState:UIControlStateNormal];
        [self.NA_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
    }
}

-(void)closekeyboard
{
    [self.view endEditing:YES];
}

-(void)backandsave
{
    [self.pagetextfield resignFirstResponder];
    if (ISKIDS) {
        
        for (kidDetailView *view in self.viewArray) {
            
            if ([view.scoreResult isEqualToString:@"0"] || [view.reason isEqualToString:SYSLanguage?@"other":@"其他原因"] || [view.reason isEqualToString:SYSLanguage?@"other":@"其他"])
            {
                if ([view.comment_textview.text length] == 0)
                {
                    ALERTVIEW(SYSLanguage?@"Please input remark":@"请填写说明");
                    return;
                }
                
                if ([[[CacheManagement instance].dataSource lowercaseString] containsString:@"rbk"]) {
                    
                    NSString *pic1 = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[self.picpath_1 componentsSeparatedByString:@"dataCaches"] lastObject]];
                    NSString *pic2 = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[self.picpath_2 componentsSeparatedByString:@"dataCaches"] lastObject]];
                    
                    if (![[NSFileManager defaultManager] fileExistsAtPath:pic1]&&![[NSFileManager defaultManager] fileExistsAtPath:pic2])
                    {
                        ALERTVIEW(SYSLanguage?@"Please take at least one photo":@"请至少拍摄一张照片");
                        return;
                    }
                }
            }
            else if ([view.scoreResult isEqualToString:@"-1"])
            {
                if (view.reason == nil)
                {
                    ALERTVIEW(SYSLanguage?@"Please choose reason":@"请选择原因");
                    return;
                }
            }
        }
    }
    else {
    
        if ([self.scoreResult isEqualToString:@"0"] || [self.reason isEqualToString:SYSLanguage?@"other":@"其他原因"] || [self.reason isEqualToString:SYSLanguage?@"other":@"其他"])
        {
            if ([self.comment_textview.text length] == 0)
            {
                ALERTVIEW(SYSLanguage?@"Please input remark":@"请填写说明");
                return;
            }
            
            if ([[[CacheManagement instance].dataSource lowercaseString] containsString:@"rbk"]) {
                
                NSString *pic1 = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[self.picpath_1 componentsSeparatedByString:@"dataCaches"] lastObject]];
                NSString *pic2 = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[self.picpath_2 componentsSeparatedByString:@"dataCaches"] lastObject]];
                
                if (![[NSFileManager defaultManager] fileExistsAtPath:pic1]&&![[NSFileManager defaultManager] fileExistsAtPath:pic2])
                {
                    ALERTVIEW(SYSLanguage?@"Please take at least one photo":@"请至少拍摄一张照片");
                    return;
                }
            }
        }
        else if ([self.scoreResult isEqualToString:@"-1"])
        {
            if (self.reason == nil)
            {
                ALERTVIEW(SYSLanguage?@"Please choose reason":@"请选择原因");
                return;
            }
        }
    }
    
    
    [self saveSingleResult];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)hiddenFilter
{
    self.filterview.hidden = YES;
//      self.scrollview.frame = CGRectMake(0, 0, 320, DEVICE_HEIGHT - 64 - 40) ;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.label.text = SYSLanguage?@"Please input remark":@"请输入说明";
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    }
    CGRect af = self.ImageBGView.frame ;
    af.size.width = DEWIDTH ;
    af.size.height = DEWIDTH/320.0*293.0;
    self.ImageBGView.frame = af ;
    self.title = SYSLanguage?@"VM aRMS check":@"陈列检查";
    [self.lastBtn setBackgroundImage:[UIImage imageNamed:SYSLanguage?@"last_en.png": @"last.png"] forState:UIControlStateNormal];
    [self.nextBtn setBackgroundImage:[UIImage imageNamed:SYSLanguage?@"next_en.png":@"next.png"] forState:UIControlStateNormal];
    self.Y_label.text = self.maxScore ;
    self.filterview = [[VMFilterView alloc]initWithFrame:CGRectMake(0, 64, DEWIDTH, 40)];
    self.filterview.userInteractionEnabled = YES;
    //    self.filterview.frame = CGRectMake(0, 0, 320, 40);
    self.filterview.backgroundColor = [UIColor redColor];
    if(!ISKIDS) [self.view addSubview:self.filterview];

    self.filterview.countLabel.text = self.maxScore ;
//    if (SYSLanguage == EN)
//    {
//        self.Item_textview.font = [UIFont systemFontOfSize:10];
//    }
    self.pagetextfield.delegate = self;
    self.photo_1.delegate = self;
    self.photo_2.delegate = self;
    [self UpdateARMS_CheckID];
    [Utilities createLeftBarButton:self clichEvent:@selector(backandsave)];
    
    [self checkButton];
    self.CurrentmanageResultEntity = [VMManageScoreEntity getinstance];
    
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
    
    
    self.totalIssueCount = [APPDelegate VM_CHECK_ItemList].count;
    self.resultArray = [[NSMutableArray alloc]init];
    
    if (!ISKIDS) {
        
        [self.view bringSubviewToFront:self.filterview];
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
    else {
    
        self.No_label.hidden = YES ;
        
        self.scrollview.delegate = self ;
        
        self.scrollview.directionalLockEnabled = YES ;
        
        self.scrollview.pagingEnabled = YES ;
        
        [self createKidView];
    }
}

- (void)refreshKidPage:(NSInteger)location {

    if ([APPDelegate VM_CHECK_ItemList].count > location-1) {
        
        VM_CHECK_ITEM_Entity* checkEntity = [[APPDelegate VM_CHECK_ItemList] objectAtIndex:location-1];
        
        self.vmCategoryID = checkEntity.VM_CATEGORY_ID ;
        
        [self createKidView];
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
//    if (!self.iscamera)
//    {
//        [self saveSingleResult];
//    }
   
}

-(IBAction)gotoPage:(id)sender
{
    [self.pagetextfield resignFirstResponder];
    if (ISKIDS) {
        
        int index = 0 ;
        
        for (kidDetailView *view in self.viewArray) {
            
            // 配置页面检查问答数据
            if ([view.scoreResult isEqualToString:@"0"] || [view.reason isEqualToString:@"其他原因"]||[view.reason isEqualToString:SYSLanguage?@"other":@"其他"]) {
                if ([view.comment_textview.text length] == 0)
                {
                    NSString *showStr = [NSString stringWithFormat:@"第%d项请填写说明",index+1] ;
                    if (SYSLanguage) showStr = [NSString stringWithFormat:@"Please input remark at %d",index+1] ;
                    
                    ALERTVIEW(showStr);
                    return;
                }
                
                if ([[[CacheManagement instance].dataSource lowercaseString] containsString:@"rbk"]) {

                    NSString *pic1 = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[self.picpath_1 componentsSeparatedByString:@"dataCaches"] lastObject]];
                    NSString *pic2 = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[self.picpath_2 componentsSeparatedByString:@"dataCaches"] lastObject]];
                    
                    if (![[NSFileManager defaultManager] fileExistsAtPath:pic1]&&![[NSFileManager defaultManager] fileExistsAtPath:pic2])
                    {
                        ALERTVIEW(SYSLanguage?@"Please take at least one photo":@"请至少拍摄一张照片");
                        return;
                    }
                }
            }
            
            if ([view.scoreResult isEqualToString:@"-1"])
            {
                if (view.reason == nil)
                {
                    NSString *showStr = [NSString stringWithFormat:@"第%d项请选择原因",index+1] ;
                    if (SYSLanguage) showStr = [NSString stringWithFormat:@"Please choose reason at %d",index+1] ;
                    
                    ALERTVIEW(showStr);
                    return;
                }
            }
            
            index++ ;
        }
        
        [self saveSingleResult];
        
        NSInteger go_No = [self.pagetextfield.text integerValue];
        
        if ((go_No <= 0) ||(go_No > [APPDelegate VM_CHECK_ItemList].count))
        {
            ALERTVIEW(SYSLanguage?@"That does not exist":@"该项不存在");
            return;
        }
        
        self.No = go_No ;
        [self checkButton];
        
        for (kidDetailView *view in self.viewArray) {
            
            [view removeFromSuperview] ;
        }
        
        [self.viewArray removeAllObjects];
        
        [self refreshKidPage:self.No];
    }
    else {
    
        if ([self.scoreResult isEqualToString:@"0"] || [self.reason isEqualToString:SYSLanguage?@"other":@"其他原因"] || [self.reason isEqualToString:SYSLanguage?@"other":@"其他"])
        {
            if ([self.comment_textview.text length] == 0)
            {
                ALERTVIEW(SYSLanguage?@"Please input remark":@"请填写说明");
                return;
            }
            
            if ([[[CacheManagement instance].dataSource lowercaseString] containsString:@"rbk"]) {
                
                NSString *pic1 = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[self.picpath_1 componentsSeparatedByString:@"dataCaches"] lastObject]];
                NSString *pic2 = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[self.picpath_2 componentsSeparatedByString:@"dataCaches"] lastObject]];
                
                if (![[NSFileManager defaultManager] fileExistsAtPath:pic1]&&![[NSFileManager defaultManager] fileExistsAtPath:pic2])
                {
                    ALERTVIEW(SYSLanguage?@"Please take at least one photo":@"请至少拍摄一张照片");
                    return;
                }
            }
        }
        if ([self.scoreResult isEqualToString:@"-1"])
        {
            if (self.reason == nil)
            {
                ALERTVIEW(SYSLanguage?@"Please choose reason":@"请选择原因");
                return;
            }
        }
        // 进入下条之前保存当前结果入数据库
        self.reasonBtn.hidden = YES;
        [self saveSingleResult];
        
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
            self.remark = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"REMARK_CN"];
            self.scoreOption = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"SCORE_OPTION"];
            self.item_name = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_NAME_CN"];
            self.reasonsArr = [[[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1]valueForKey:@"REASON_CN"]componentsSeparatedByString:@"|"];
            self.item_id = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"VM_ITEM_ID"];
            if (SYSLanguage == EN)
            {
                self.remark = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"REMARK_EN"];
                self.item_name = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_NAME_EN"];
                self.reasonsArr = [[[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1]valueForKey:@"REASON_EN"]componentsSeparatedByString:@"|"];
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

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesBegan:touches withEvent:event];   
//}

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
        [self.bigImage setImage:[UIImage imageWithContentsOfFile:newfile]] ;
        [self presentPopupView:self.ImageBGView];
    }
}

- (void)showBigImage:(NSString *)path {

    NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[path componentsSeparatedByString:@"/dataCaches"] lastObject]];
    [self.bigImage setImage:[UIImage imageWithContentsOfFile:newfile]] ;
    [self presentPopupView:self.ImageBGView];
}

- (void)createKidView {

    self.pagetextfield.text = [NSString stringWithFormat:@"%d",(int)self.No];
    self.kidsDataArray = [NSMutableArray array];
    self.viewArray = [NSMutableArray array];
    self.labelArray = [NSMutableArray array];
    
    NSString* sql  = [NSString stringWithFormat:@"SELECT * FROM NVM_VM_CHECK_ITEM WHERE VM_CATEGORY_ID = '%@' ORDER BY ITEM_NO",self.vmCategoryID] ;
    
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    
    while([rs next])
    {
        VM_CHECK_ITEM_Entity* checkEntity = [[VM_CHECK_ITEM_Entity alloc]initWithFMResultSet:rs];
        [self.kidsDataArray addObject:checkEntity] ;
    }
    
    
    int index = 0 ;
    
    [self setAllViewWithTotal:self.kidsDataArray.count];
    
    for (VM_CHECK_ITEM_Entity*checkEntity in self.kidsDataArray) {
        
        NSArray* arr = [self getLocalArmsCHKItemBy:checkEntity.VM_ITEM_ID];
        
        if ([arr count] > 0)
        {
            self.CurrentmanageResultEntity = [arr objectAtIndex:0];
        }
        else
        {
            [self.CurrentmanageResultEntity cleanScore];
        }
        
        NSArray *nibview = [[NSBundle mainBundle] loadNibNamed:@"kidDetailView" owner:nil options:nil];
        kidDetailView *view = [nibview firstObject];
        view.frame = CGRectMake(DEVICE_WID*index+5, 40 , DEWIDTH-10, DEVICE_HEIGHT - 40 - 45 - 64 - 20 ) ;
        view.bgview = self.view ;
        view.maxScore = [[checkEntity.SCORE_OPTION componentsSeparatedByString:@","] firstObject] ;
        view.item_id = checkEntity.VM_ITEM_ID ;
        view.Y_label.text = [[checkEntity.SCORE_OPTION componentsSeparatedByString:@","] firstObject];
        view.reasonsArr =  SYSLanguage?[checkEntity.REASON_EN componentsSeparatedByString:@"|"] : [checkEntity.REASON_CN componentsSeparatedByString:@"|"] ;
        view.delegate = self ;
        view.item_textview.text = SYSLanguage == EN ? checkEntity.ITEM_NAME_EN : checkEntity.ITEM_NAME_CN ;
        view.No = checkEntity.ITEM_NO ;
        [view.No_label setTitle:[NSString stringWithFormat:@"%d",index+1] forState:UIControlStateNormal];
        
//        NSInteger height = [self heightForString:SYSLanguage == EN ? checkEntity.ITEM_NAME_EN : checkEntity.ITEM_NAME_CN fontSize:14 andWidth:view.item_textview.frame.size.width];
        
        
        CGSize size = [view.item_textview sizeThatFits:CGSizeMake(CGRectGetWidth(view.item_textview.frame), MAXFLOAT)];
        CGRect itframe = view.item_textview.frame;
        itframe.size.height = size.height;
        view.item_textview.frame = itframe;

//        CGRect itframe = view.item_textview.frame ;
//        itframe.size.height = height+20 ;
//        view.item_textview.frame = itframe ;
        
        CGRect frameIV = view.itemView.frame ;
        frameIV.origin.y = itframe.size.height + 20 ;
        
        
        NSArray* ar = [checkEntity.SCORE_OPTION componentsSeparatedByString:@","];
        if (ar.count == 2)
        {
            view.NA_btn.hidden = YES;
            view.na_label.hidden = YES;
        }
        else
        {
            view.NA_btn.hidden = NO;
            view.na_label.hidden = NO;
        }
        
        view.picpath_1 = self.CurrentmanageResultEntity.picpath1;
        view.picpath_2 = self.CurrentmanageResultEntity.picpath2;
        if ([view.picpath_1 length]> 0) {
            
            NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[view.picpath_1 componentsSeparatedByString:@"/dataCaches"] lastObject]];
            view.photo_1.image = [UIImage imageWithContentsOfFile:newfile];
        }
        else
        {
            view.photo_1.image = [UIImage imageNamed:SYSLanguage?@"takepic_en_new.png":@"takepic_new.png"];
        }
        
        
        if ([view.picpath_2 length] > 0)
        {
            NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[view.picpath_2 componentsSeparatedByString:@"/dataCaches"] lastObject]];
            view.photo_2.image = [UIImage imageWithContentsOfFile:newfile];
        }
        else
        {
            view.photo_2.image = [UIImage imageNamed:SYSLanguage?@"takepic_en_new.png":@"takepic_new.png"];
        }
        
        
        if (!self.CurrentmanageResultEntity.score) {
            
            view.scoreResult = @"3" ;
        }
        else {
            
            view.scoreResult = self.CurrentmanageResultEntity.score;
        }
        
        view.reason = self.CurrentmanageResultEntity.reason;
        
        CGRect secondpageview = view.secondpageview.frame ;
        
        if ([view.scoreResult isEqualToString:[[checkEntity.SCORE_OPTION componentsSeparatedByString:@","] firstObject]])
        {
            view.reasonBtn.hidden = YES;
            secondpageview.origin.y = 57 ;
            [view.YES_btn setBackgroundImage:[UIImage imageNamed:@"formorange2.png"] forState:UIControlStateNormal];
            [view.NO_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
            [view.NA_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
            
        }
        else if([view.scoreResult isEqualToString:@"0"])
        {
            view.reasonBtn.hidden = YES;
            secondpageview.origin.y = 57 ;
            [view.YES_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
            [view.NO_btn setBackgroundImage:[UIImage imageNamed:@"formorange2.png"] forState:UIControlStateNormal];
            [view.NA_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        }
        else if([view.scoreResult isEqualToString:@"-1"])
        {
            view.reasonBtn.hidden = NO;
            view.reason = self.CurrentmanageResultEntity.reason;
            [view.reasonBtn setTitle:view.reason forState:UIControlStateNormal];
            secondpageview.origin.y = 90 ;
            [view.YES_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
            [view.NO_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
            [view.NA_btn setBackgroundImage:[UIImage imageNamed:@"formorange2.png"] forState:UIControlStateNormal];
        }
        else if ([view.scoreResult isEqualToString:@"3"])
        {
            view.reasonBtn.hidden = YES;
            secondpageview.origin.y = 57 ;
            [view.YES_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
            [view.NO_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
            [view.NA_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        }
        else if ([view.reasonsArr count] == 0)
        {
            view.reasonBtn.hidden = YES;
        }
        view.secondpageview.frame = secondpageview ;
        
        frameIV.size.height = secondpageview.size.height + secondpageview.origin.y + 20 ;
        view.itemView.frame = frameIV ;
        view.itemScrollView.contentSize = CGSizeMake(0, frameIV.size.height+frameIV.origin.y) ;
        
        view.comment_textview.text = self.CurrentmanageResultEntity.comment;
        if ([view.comment_textview.text length] > 0) view.label.hidden = YES;
        
        [self.scrollview addSubview:view];
        [self.viewArray addObject:view];
        index++ ;
    }
    
    
    if ([self.kidsDataArray count]) {
        
        VM_CHECK_ITEM_Entity* checkEntity = [self.kidsDataArray firstObject];
        
        NSArray* arr = [self getLocalArmsCHKItemBy:checkEntity.VM_ITEM_ID];
        
        if ([arr count] > 0)
        {
            self.CurrentmanageResultEntity = [arr objectAtIndex:0];
        }
        else
        {
            [self.CurrentmanageResultEntity cleanScore];
        }
        
        if ([self.kidsDataArray count] == 1) self.scrollview.contentSize = CGSizeMake(10, 10 );
        else self.scrollview.contentSize = CGSizeMake(DEVICE_WID*[self.kidsDataArray count], 10 );
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    for (kidDetailView *view in self.viewArray) {
        
        // 配置页面检查问答数据
        if ([view.scoreResult isEqualToString:@"0"] || [view.reason isEqualToString:@"其他原因"]||[view.reason isEqualToString:SYSLanguage?@"other":@"其他"])
            if ([view.comment_textview.text length] == 0)
            {
                continue;
            }
        
        if ([view.scoreResult isEqualToString:@"-1"])
        {
            if (view.reason == nil)
            {
                continue;
            }
        }
        
        self.CurrentmanageResultEntity.score = view.scoreResult;
        self.CurrentmanageResultEntity.reason = view.reason;
        self.CurrentmanageResultEntity.picpath1 = view.picpath_1;
        self.CurrentmanageResultEntity.picpath2 = view.picpath_2;
        self.CurrentmanageResultEntity.item_id = view.item_id;
        
        self.CurrentmanageResultEntity.comment = [view.comment_textview.text getReplaceString];
        self.CurrentmanageResultEntity.check_id = [CacheManagement instance].currentVMCHKID;
        self.CurrentmanageResultEntity.check_item_id = [Utilities GetUUID];
        self.CurrentmanageResultEntity.item_no = view.No;
        
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        [db beginTransaction];
        // 删除原有数据
        BOOL result = YES;
        
        @try
        {
            [self deleteLocalArmsCHKItem:db and:view.item_id];
            
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

            }
            else
            {
                [db rollback];
            }
        }
    }
    
    
    for (int i = 0 ; i < [self.labelArray count]; i++) {
        
        UILabel *alabel = [self.labelArray objectAtIndex:i] ;
        
        if ([self.kidsDataArray count] > i) {
            
            VM_CHECK_ITEM_Entity*checkEntity = [self.kidsDataArray objectAtIndex:i] ;
            
            NSString* sql  = [NSString stringWithFormat:@"select * from NVM_IST_VM_CHECK_ITEM where VM_CHK_ID = '%@' AND ITEM_ID = '%@'",[CacheManagement instance].currentVMCHKID,checkEntity.VM_ITEM_ID];
            FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
            
            while ([rs next])
            {
                if ([[rs stringForColumnIndex:3] isEqualToString:@"3"])
                {
                    alabel.backgroundColor = [Utilities colorWithHexString:@"#bfbfbf"];
                }
                else {
                    
                    alabel.backgroundColor = [Utilities colorWithHexString:@"#fdbf2d"];
                }
            }
        }
    }

}

- (void)setAllViewWithTotal:(NSUInteger)count {
    
    for (UILabel *label in self.labelArray) {
        
        [label removeFromSuperview] ;
    }
    
    for (UIView *sub in self.view.subviews) {
        
        if (sub.tag == 999) {
            
            [sub removeFromSuperview] ;
        }
    }
    
    if (count <= 1) return ;
    
    UIView *bottomview = [[UIView alloc] initWithFrame:CGRectMake(DEWIDTH/2.0-(11*count)-(2*(count-1)), DEHEIGHT - 40-10-7, 22*count+4*(count-1), 12)];
    bottomview.tag = 999 ;
    
    for (int i = 0 ; i < count; i++) {
        
        UILabel *alabel = [[UILabel alloc] initWithFrame:CGRectMake(i*(22+4), 0, 22, 12)];
        alabel.text = @"" ;
        alabel.backgroundColor = [Utilities colorWithHexString:@"#bfbfbf"];
        
        if ([self.kidsDataArray count] > i) {
            
            VM_CHECK_ITEM_Entity*checkEntity = [self.kidsDataArray objectAtIndex:i] ;
            
            NSString* sql  = [NSString stringWithFormat:@"select * from NVM_IST_VM_CHECK_ITEM where VM_CHK_ID = '%@' AND ITEM_ID = '%@'",[CacheManagement instance].currentVMCHKID,checkEntity.VM_ITEM_ID];
            FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
            
            while ([rs next])
            {
                if ([[rs stringForColumnIndex:3] isEqualToString:@"3"])
                {
                     alabel.backgroundColor = [Utilities colorWithHexString:@"#bfbfbf"];
                }
                else {
                
                    alabel.backgroundColor = [Utilities colorWithHexString:@"#fdbf2d"];
                }
            }
        }
        
        [bottomview addSubview:alabel] ;
        [self.labelArray addObject:alabel];
    }
    
    [self.view addSubview:bottomview];
}



@end







