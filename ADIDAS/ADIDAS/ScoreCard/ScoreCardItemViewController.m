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
#import "TakePhotoListCell.h"
#import "UIImageView+YYWebImage.h"
#import "VmScoreCardDetailEntity.h"
#import "MakeScoreCustomCell.h"

@interface ScoreCardItemViewController ()<WBGImageEditorDelegate,WBGImageEditorDataSource,installcellDelegate>

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
    self.small_pageview.hidden = YES ;
    [self.No_label setTitle:[NSString stringWithFormat:@"%d",(int)self.No] forState:UIControlStateNormal];
    self.pagetextfield.text = [NSString stringWithFormat:@"%d",(int)self.No];
    self.Item_textview.text = [NSString stringWithFormat:@"%@(%@%%)",self.item_name,[[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"STANDARD_SCORE"]];
   
    NSInteger height =  [self heightForString:self.Item_textview.text fontSize:14 andWidth:DEVICE_WID-39];
    self.Item_textview.frame = CGRectMake(29, -6, DEVICE_WID-39, height+20);
    
    if([self.type isEqualToString:@"M"]) {
        
        self.small_pageview.hidden = NO ;
        self.comment_textview.editable = YES ;
        self.comment_textview.delegate = self ;
        self.comment_textview.text = self.CurrentmanageResultEntity.comment ;
        
        if (self.comment_textview.text.length == 0) {
            self.label.hidden = NO;
        }else{
            self.label.hidden = YES;
        }
    }
    
    if (self.remarkData) {
        self.small_pageview.hidden = NO ;
        self.comment_textview.editable = NO ;
        self.label.hidden = YES ;
        self.comment_textview.text = @"" ;
        for (NSDictionary *commDic in self.remarkData) {
            
            if ([[commDic valueForKey:@"SCORECARD_ITEM_ID"] isEqualToString:self.item_id]) {
                
                self.comment_textview.text = [commDic valueForKey:@"TRACK_COMMENT"];
            }
        }
        
        if([self.comment_textview.text isEqualToString:@""])
            self.comment_textview.text = @"(审核人员未添加备注)";
    }
    
    if (self.commentData&&[self.type isEqualToString:@"D"]) {
        
        self.small_pageview.hidden = NO ;
        NSMutableArray *mudata = [NSMutableArray array];
        NSMutableArray *photozone = [NSMutableArray array];
        for (NSDictionary *commDic in self.commentData) {
            
            if ([[commDic valueForKey:@"SCORECARD_ITEM_ID"] isEqualToString:self.item_id]&&
                [[commDic valueForKey:@"SCORECARD_CHK_ID"] isEqualToString:[CacheManagement instance].currentVMCHKID]) {

                if(![photozone containsObject:[commDic valueForKey:@"PHOTO_ZONE"]]) [photozone addObject:[commDic valueForKey:@"PHOTO_ZONE"]] ;
                [mudata addObject:commDic] ;
            }
        }
        
        if ([photozone count]) {
            
            FMDatabase *db = [[SqliteHelper shareCommonSqliteHelper] database];
            [db beginTransaction];
            
            BOOL result = YES;
            @try
            {
                for (NSString *zone in photozone) {
                    
                    NSString *PHOTO_WEB_PATH1 = @"" ;
                    NSString *PHOTO_WEB_PATH2 = @"" ;
                    
                    for (NSDictionary *commDic in mudata) {
                        
                        if ([[commDic valueForKey:@"PHOTO_ZONE"] isEqualToString:zone]) {
                            
                            PHOTO_WEB_PATH1 = [commDic valueForKey:@"PHOTO_PATH1"] ;
                            
                            PHOTO_WEB_PATH2 = [commDic valueForKey:@"PHOTO_PATH2"] ;
                        }
                    }
                    
                    NSDictionary *dic = [self getCurrentItemWith:zone];
                    
                    if (dic) {
                        
                        if ((PHOTO_WEB_PATH2&&![PHOTO_WEB_PATH2 isEqualToString:@""]) ||
                            (PHOTO_WEB_PATH1&&![PHOTO_WEB_PATH1 isEqualToString:@""])) {
                            
                            NSString* sql_ = [NSString stringWithFormat:@"UPDATE NVM_IST_SCORECARD_PHOTO_ZONE SET PHOTO_WEB_PATH1 = '%@' , PHOTO_WEB_PATH2 = '%@' where PHOTO_ZONE_NAME_CN = '%@' and SCORECARD_CHECK_PHOTO_ID = '%@' and SCORE_CARD_TYPE = '%@'",PHOTO_WEB_PATH1,PHOTO_WEB_PATH2,zone,self.CurrentmanageResultEntity.scorecard_check_photo_id,self.type];
                            [db executeUpdate:sql_];
                        }
                    }
                    else {
                        
                        NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_SCORECARD_PHOTO_ZONE (SCORECARD_CHECK_PHOTO_ID,PHOTO_ZONE_NAME_CN,PHOTO_WEB_PATH1,PHOTO_WEB_PATH2,PHOTO_UPLOAD_PATH1,PHOTO_UPLOAD_PATH2,SCORE_CARD_TYPE) values (?,?,?,?,?,?,?)"];
                        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
                         self.CurrentmanageResultEntity.scorecard_check_photo_id,
                         zone,
                         PHOTO_WEB_PATH1,
                         PHOTO_WEB_PATH2,
                         @"1",
                         @"1",
                         self.type];
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
    }
    
    self.scoreArray = [self getAllScoreItem];
    [self.scoreTableView reloadData] ;
    CGRect taFrame = self.scoreTableView.frame ;
    taFrame.origin.y = self.Item_textview.height+self.Item_textview.frame.origin.y ;
    taFrame.size.height = [self.scoreArray count]*50 ;
    if ([self.type isEqualToString:@"D"]) {
        taFrame.size.height = [self.scoreArray count]*192 ;
    }
    self.scoreTableView.frame = taFrame ;
    [self.scoreTableView reloadData];
    if (self.small_pageview.hidden) height = self.Item_textview.height + self.scoreTableView.height - 90;
    
    else height = self.Item_textview.height + self.scoreTableView.height;
    
    
    self.small_pageview.frame = CGRectMake(4, height , DEWIDTH-10-8, 90);
    
    CGRect scoreframe = self.scoreItemTableView.frame ;
    scoreframe.origin.y = height+100 ;
    scoreframe.size.width = DEWIDTH ;
    scoreframe.size.height = 78*[[self.photozone componentsSeparatedByString:@"|"] count] + [self caculateTotal] ;
    self.scoreItemTableView.frame = scoreframe ;
    CGRect pageframe = self.page_view.frame ;
    pageframe.size.height = scoreframe.size.height+scoreframe.origin.y+40 ;
    self.page_view.frame = pageframe ;
    self.scrollview.contentSize = CGSizeMake(10, scoreframe.size.height+scoreframe.origin.y+80);
    [self.scoreItemTableView reloadData] ;
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

    [editor.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self setImageValueWith:image];
}

- (void)imageEditorDidCancel:(WBGImageEditor *)editor {
    
}

- (NSArray<WBGMoreKeyboardItem *> *)imageItemsEditor:(WBGImageEditor *)editor {
    return @[];
}

- (void)selectPicWith:(UIImage *)img {
    
    [self.photoPicker dismissViewControllerAnimated:YES completion:nil];
    [self.leveyTabBarController hidesTabBar:YES animated:NO];
    
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

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
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
    if (self.commentData&&[self.type isEqualToString:@"M"]) return ;
    self.CurrentmanageResultEntity.scorecard_item_id = self.item_id;
    self.CurrentmanageResultEntity.comment = @"";
    if ([self.type isEqualToString:@"M"]) self.CurrentmanageResultEntity.comment = self.comment_textview.text ;
    self.CurrentmanageResultEntity.scorecard_check_id = [CacheManagement instance].currentVMCHKID;
    
    if(!self.CurrentmanageResultEntity.scorecard_check_photo_id||
       [self.CurrentmanageResultEntity.scorecard_check_photo_id isEqualToString:@""])
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
    NSString* sql = [NSString stringWithFormat:@"select * from NVM_IST_SCORECARD_CHECK where WORK_MAIN_ID ='%@' and STORE_CODE= '%@' and SCORE_CARD_TYPE = '%@'",workmainID,storecode,self.type];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        [resultarr addObject:[rs stringForColumnIndex:0]];
    }
    [rs close];
    
    return resultarr;
    
}

- (NSArray *)getAllScoreItem {
    
    NSMutableArray* resultarr = [[NSMutableArray alloc]init];
    NSString* sql = [NSString stringWithFormat:@"select * from NVM_VM_SCORECARD_ITEM_DETAIL where SCORECARD_ITEM_ID ='%@'  ",self.item_id];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        VmScoreCardDetailEntity *entity = [[VmScoreCardDetailEntity alloc] initWithFMResultSet:rs];
        [resultarr addObject:entity];
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
        
        NSString *dateStr = [Utilities DateNow];
        
        if (self.commentDate&&self.commentData) dateStr = self.commentDate ;
        
        NSString* workdate = dateStr ;
        
        NSString* workstarttime = [Utilities DateTimeNow];
        NSString* workendtime = [Utilities DateTimeNow];
        NSString* userid = [CacheManagement instance].currentUser.UserId;
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_SCORECARD_CHECK (SCORECARD_CHK_ID,STORE_CODE,USER_ID,WORK_MAIN_ID,WORK_DATE,WORK_START_TIME,WORK_END_TIME,USER_SUBMIT_TIME,CLIENT_UPLOAD_TIME,SERVER_INSERT_TIME,SCORE_CARD_TYPE) values (?,?,?,?,?,?,?,?,?,?,?)"];
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
         nil,
         self.type];
    }
}


//获取本地评分记录
- (NSMutableArray *) getLocalArmsCHKItemByItem_id
{
    NSString *sql = [NSString stringWithFormat:@"Select * FROM NVM_IST_SCORECARD_CHECK_PHOTO where SCORECARD_ITEM_ID = '%@' and SCORECARD_CHK_ID = '%@' and SCORE_CARD_TYPE = '%@'",self.item_id,[CacheManagement instance].currentVMCHKID,self.type];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
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
    NSString *sql = [NSString stringWithFormat:@"Select * FROM NVM_IST_SCORECARD_CHECK_PHOTO where SCORECARD_ITEM_ID = '%@' and SCORECARD_CHK_ID = '%@' and SCORE_CARD_TYPE = '%@'",Item_id,[CacheManagement instance].currentVMCHKID,self.type];
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
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_SCORECARD_CHECK_PHOTO (SCORECARD_CHECK_PHOTO_ID,SCORECARD_CHK_ID,SCORECARD_ITEM_ID,COMMENT,PHOTO_PATH1,PHOTO_PATH2,LAST_MODIFIED_BY,LAST_MODIFIED_TIME,SCORE_CARD_TYPE) values (?,?,?,?,?,?,?,?,?)"];
    //    FMDatabase *db = [[SqliteHelper shareCommonSqliteHelper] database];
    [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql,
     data.scorecard_check_photo_id,
     data.scorecard_check_id,
     data.scorecard_item_id,
     data.comment,
     data.picpath1,
     data.picpath2,
     [CacheManagement instance].currentDBUser.userName,
     [Utilities DateTimeNow],
     self.type];
}

//删除原有数据
-(void)deleteLocalArmsCHKItem:(FMDatabase*)db
{
    NSString *sql = [NSString stringWithFormat:@"delete from NVM_IST_SCORECARD_CHECK_PHOTO where SCORECARD_ITEM_ID='%@' and SCORECARD_CHK_ID = '%@' and SCORE_CARD_TYPE = '%@'",self.item_id,[CacheManagement instance].currentVMCHKID,self.type];
    [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql];
}

//删除原有数据
-(void)deleteLocalArmsCHKItem:(FMDatabase*)db and:(NSString *)itemID
{
    NSString *sql = [NSString stringWithFormat:@"delete from NVM_IST_SCORECARD_CHECK_PHOTO where SCORECARD_ITEM_ID='%@' and SCORECARD_CHK_ID = '%@' and SCORE_CARD_TYPE = '%@'",itemID,[CacheManagement instance].currentVMCHKID,self.type];
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
    {   // 上一页按钮无效
        self.lastBtn.hidden = YES;
    }
    else
    {   // 都有效
        self.nextBtn.hidden = NO;
        self.lastBtn.hidden = NO;
    }
}

-(IBAction)nextIssue
{
    
    [self.pagetextfield resignFirstResponder];
    
    NSString *resu = [self GetScorebyItemID:self.item_id];
    
    if ([resu isEqualToString:@"1"]) {
        
        ALERTVIEW(SYSLanguage?@"Please input remark!": @"0分项请输入说明!");
        return ;
    }
    
    if ([resu isEqualToString:@"2"]) {
        
        ALERTVIEW(SYSLanguage?@"Please finish all items then upload": @"还有未完成项，请继续填写");
        return ;
    }
    
    
    // 进入下条之前保存当前结果入数据库
    [self saveSingleResult];
    self.No++ ;
    [self checkButton];
    
    // 读取下题内容
    self.remark = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"REMARK_CN"];
    self.item_name = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_NAME_CN"];
    self.item_id = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"SCORECARD_ITEM_ID"];
    self.standard_score = [NSString stringWithFormat:@"%@",[[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"STANDARD_SCORE"]];
    if (SYSLanguage == EN)
    {
        self.remark = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"REMARK_EN"];
        self.item_name = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_NAME_EN"];
    }
    
    // 根据当前chkid 和 itemid 取数据库中信息
    NSArray* arr = [self getLocalArmsCHKItemByItem_id];
    if ([arr count] > 0)
    {
        self.CurrentmanageResultEntity = [arr objectAtIndex:0];
    }
    else
    {
        [self.CurrentmanageResultEntity cleanScore];
        self.CurrentmanageResultEntity.scorecard_check_photo_id = [Utilities GetUUID];
    }
    
    NSMutableArray *originStrAry = [NSMutableArray arrayWithArray:[[[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"PHOTO_ZONE_CN"] componentsSeparatedByString:@"|"]];
    
    NSArray *totalzone = [self getTotalPhotoZone];
    
    if ([totalzone count]) {
        
        for (NSString *zone in totalzone) {
            
            if (![originStrAry containsObject:zone]&&[originStrAry containsObject:[[zone componentsSeparatedByString:@"_"] firstObject]]) {
                
                NSInteger indx = [originStrAry indexOfObject:[[zone componentsSeparatedByString:@"_"] firstObject]] ;
                [originStrAry insertObject:zone atIndex:[[[zone componentsSeparatedByString:@"_"] lastObject] integerValue]+indx] ;
            }
        }
    }
    self.photozone = [originStrAry componentsJoinedByString:@"|"];
    
    [self configUI];
}

-(IBAction)lastIssue
{
    [self.pagetextfield resignFirstResponder];
    
    NSString *resu = [self GetScorebyItemID:self.item_id];
    
    if ([resu isEqualToString:@"1"]) {
        
        ALERTVIEW(SYSLanguage?@"Please input remark!": @"0分项请输入说明!");
        return ;
    }
    
    if ([resu isEqualToString:@"2"]) {
        
        ALERTVIEW(SYSLanguage?@"Please finish all items then upload": @"还有未完成项，请继续填写");
        return ;
    }
    
    // 保存当前条目结果进数据库 评分如果未填 默认写入3
    [self saveSingleResult];
    
    self.No -- ;
    [self checkButton];
    
    // 读取条目检查说明信息
    self.remark = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"REMARK_CN"];
    self.item_name = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_NAME_CN"];
    self.item_id = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"SCORECARD_ITEM_ID"];
    self.standard_score = [NSString stringWithFormat:@"%@",[[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"STANDARD_SCORE"]];
    if (SYSLanguage == EN)
    {
        self.remark = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"REMARK_EN"];
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
        self.CurrentmanageResultEntity.scorecard_check_photo_id = [Utilities GetUUID];
    }
    
    NSMutableArray *originStrAry = [NSMutableArray arrayWithArray:[[[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"PHOTO_ZONE_CN"] componentsSeparatedByString:@"|"]];
    
    NSArray *totalzone = [self getTotalPhotoZone];
    
    if ([totalzone count]) {
        
        for (NSString *zone in totalzone) {
            
            if (![originStrAry containsObject:zone]&&[originStrAry containsObject:[[zone componentsSeparatedByString:@"_"] firstObject]]) {
                
                NSInteger indx = [originStrAry indexOfObject:[[zone componentsSeparatedByString:@"_"] firstObject]] ;
                [originStrAry insertObject:zone atIndex:[[[zone componentsSeparatedByString:@"_"] lastObject] integerValue]+indx] ;
            }
        }
    }
    self.photozone = [originStrAry componentsJoinedByString:@"|"];
    
    [self configUI];
}


-(void)closekeyboard
{
    [self.view endEditing:YES];
}

-(void)backandsave
{
    [self.scoreTableView endEditing:false] ;
    
    NSString *resu = [self GetScorebyItemID:self.item_id];
    
    if ([resu isEqualToString:@"1"]) {
        
        ALERTVIEW(SYSLanguage?@"Please input remark!": @"0分项请输入说明!");
        return ;
    }
    
    if ([resu isEqualToString:@"2"]) {
        
        ALERTVIEW(SYSLanguage?@"Please finish all items then upload": @"还有未完成项，请继续填写");
        return ;
    }
    
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
    CGRect af = self.ImageBGView.frame ;
    af.size.width = DEWIDTH ;
    af.size.height = DEWIDTH/320.0*293.0;
    self.ImageBGView.frame = af ;
    if (ISKIDS) {
        
        [self.No_label setBackgroundImage:[UIImage imageNamed:@"VMorange.png"] forState:UIControlStateNormal] ;
    }
    
    if ([self.type isEqualToString:@"D"]) {
        
        self.title = SYSLanguage?@"Daily Visit":@"日常巡店";
    }
    
    if ([self.type isEqualToString:@"M"]) {
        
        self.title = SYSLanguage?@"Month Report":@"月度报告";
    }
    
    [self.lastBtn setBackgroundImage:[UIImage imageNamed:SYSLanguage?@"last_en.png": @"last.png"] forState:UIControlStateNormal];
    [self.nextBtn setBackgroundImage:[UIImage imageNamed:SYSLanguage?@"next_en.png":@"next.png"] forState:UIControlStateNormal];
    
    self.pagetextfield.delegate = self;
    if (!(self.commentData&&[self.type isEqualToString:@"M"])) [self UpdateARMS_CheckID];
    [Utilities createLeftBarButton:self clichEvent:@selector(backandsave)];
    self.view.backgroundColor = [Utilities colorWithHexString:@"#f0eff5"] ;
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
    [self.page_view addSubview:self.scoreItemTableView];
    
    self.scoreItemTableView.delegate = self ;
    self.scoreItemTableView.dataSource = self ;
    self.scoreTableView.delegate = self ;
    self.scoreTableView.dataSource = self ;
    NSArray* arr = [self getLocalArmsCHKItemByItem_id];
    
    if ([arr count] > 0)
    {
        self.CurrentmanageResultEntity = [arr objectAtIndex:0];
    }
    else
    {
        [self.CurrentmanageResultEntity cleanScore];
        self.CurrentmanageResultEntity.scorecard_check_photo_id = [Utilities GetUUID];
    }
    
    NSMutableArray *originStrAry = [NSMutableArray arrayWithArray:[[[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"PHOTO_ZONE_CN"] componentsSeparatedByString:@"|"]];
    
    NSArray *totalzone = [self getTotalPhotoZone];
    
    if ([totalzone count]) {
        
        for (NSString *zone in totalzone) {
            
            if (![originStrAry containsObject:zone]&&[originStrAry containsObject:[[zone componentsSeparatedByString:@"_"] firstObject]]) {
                
                NSInteger indx = [originStrAry indexOfObject:[[zone componentsSeparatedByString:@"_"] firstObject]] ;
                [originStrAry insertObject:zone atIndex:[[[zone componentsSeparatedByString:@"_"] lastObject] integerValue]+indx] ;
            }
        }
    }
    self.photozone = [originStrAry componentsJoinedByString:@"|"];
    
    [self configUI];
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
    NSString *resu = [self GetScorebyItemID:self.item_id];
    
    if ([resu isEqualToString:@"1"]) {
        
        ALERTVIEW(SYSLanguage?@"Please input remark!": @"0分项请输入说明!");
        return ;
    }
    
    if ([resu isEqualToString:@"2"]) {
        
        ALERTVIEW(SYSLanguage?@"Please finish all items then upload": @"还有未完成项，请继续填写");
        return ;
    }
    
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
        self.remark = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"REMARK_CN"];
        self.item_name = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_NAME_CN"];
        self.item_id = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"SCORECARD_ITEM_ID"];
        self.standard_score = [NSString stringWithFormat:@"%@",[[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"STANDARD_SCORE"]];
        if (SYSLanguage == EN)
        {
            self.remark = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"REMARK_EN"];
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
            self.CurrentmanageResultEntity.scorecard_check_photo_id = [Utilities GetUUID];
        }
        
        NSMutableArray *originStrAry = [NSMutableArray arrayWithArray:[[[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"PHOTO_ZONE_CN"] componentsSeparatedByString:@"|"]];
        
        NSArray *totalzone = [self getTotalPhotoZone];
        
        if ([totalzone count]) {
            
            for (NSString *zone in totalzone) {
                
                if (![originStrAry containsObject:zone]&&[originStrAry containsObject:[[zone componentsSeparatedByString:@"_"] firstObject]]) {
                    
                    NSInteger indx = [originStrAry indexOfObject:[[zone componentsSeparatedByString:@"_"] firstObject]] ;
                    [originStrAry insertObject:zone atIndex:[[[zone componentsSeparatedByString:@"_"] lastObject] integerValue]+indx] ;
                }
            }
        }
        self.photozone = [originStrAry componentsJoinedByString:@"|"];
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


- (void)showBigImage:(NSString *)path {
     NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[path componentsSeparatedByString:@"/dataCaches"] lastObject]];
    [self.bigImage setImage:[UIImage imageWithContentsOfFile:newfile]] ;
    [self presentPopupView:self.ImageBGView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.scoreTableView) {
        
        if ([self.type isEqualToString:@"D"]) {
            
            return 192 ;
        }
        return 50 ;
    }
    
    BOOL ischange = NO ;
    NSDictionary *result = [self getCurrentItem:indexPath.row];
    
    NSString* beforePath = [result valueForKey:@"PHOTO_PATH1"] ;
    NSString* beforePathWeb = [result valueForKey:@"PHOTO_WEB_PATH1"] ;
    NSString* beforePathWebUpload = [result valueForKey:@"PHOTO_UPLOAD_PATH1"] ;

    
    if ((![beforePath isEqualToString:@""])&&(![beforePath isEqualToString:@"0"])&&(beforePath != nil))
    {
        NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[beforePath componentsSeparatedByString:@"/dataCaches"] lastObject]];
        
        if ([UIImage imageWithContentsOfFile:newfile] != nil) {
            
            ischange = YES ;
        }
    }
    
    if (self.commentData) {
        
        if ((![beforePathWeb isEqualToString:@""])&&(![beforePathWeb isEqualToString:@"0"])&&(beforePathWeb != nil)&&[beforePathWeb length] > 1)
        {
            if (beforePathWebUpload&&[beforePathWebUpload isEqualToString:@"1"]) {
                
                ischange = YES ;
            }
        }
        
        if ([self.type isEqualToString:@"M"]) {
            for (NSDictionary *dic in self.commentData) {
                
                if ([[NSString stringWithFormat:@"%@",[dic valueForKey:@"SCORECARD_ITEM_ID"]] isEqualToString:self.item_id]&&
                    [[[self.photozone componentsSeparatedByString:@"|"] objectAtIndex:indexPath.row] isEqualToString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"PHOTO_ZONE"]]]) {
                    
                    if ([[NSString stringWithFormat:@"%@",[dic valueForKey:@"PHOTO_PATH1"]] length] > 1) {
                        
                        ischange = YES ;
                    }
                }
            }
        }
    }
    
    if (ischange) return 78 + 20 ;
    
    return 78  ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"cell";

    if (tableView == self.scoreTableView) {
        
        MakeScoreCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            
            NSArray *nibary = [[NSBundle mainBundle] loadNibNamed:@"MakeScoreCustomCell" owner:self options:nil];
            for (UIView *view in nibary) {
                
                if ([view isKindOfClass:[MakeScoreCustomCell class]]) {
                    
                    cell = (MakeScoreCustomCell *)view ;
                    break ;
                }
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        VmScoreCardDetailEntity *entity = [self.scoreArray objectAtIndex:indexPath.row];
        cell.itemNameLabel.text = [NSString stringWithFormat:@"%@  %@(%@%%)",entity.ITEM_NO,entity.ITEM_NAME_CN,entity.STANDARD_SCORE] ;
        if (SYSLanguage == EN) {
            
            cell.itemNameLabel.text = [NSString stringWithFormat:@"%@  %@(%@%%)",entity.ITEM_NO,entity.ITEM_NAME_EN,entity.STANDARD_SCORE] ;
        }
        cell.scoredArray = self.scoreData ;
        
        cell.scoreView.hidden = YES ;
        
        if ([self.type isEqualToString:@"D"]) {
            
            cell.scoreView.hidden = NO ;
            cell.scoreLabel.text = entity.STANDARD_SCORE ;
            
            cell.ScoreCardItemDetailId = entity.SCORECARD_ITEM_DETAIL_ID ;
            cell.ScoreCardItemId = self.item_id ;
            cell.scoreCardCheckPhotoId = self.CurrentmanageResultEntity.scorecard_check_photo_id ;
        }
        
        return cell;
    }
    
    TakePhotoListCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (nil == cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"TakePhotoListCell" owner:self options:nil]objectAtIndex:0];
    }
    
    cell.leftDetailButton.hidden = YES ;
    cell.rightDetailButton.hidden = YES ;
    cell.addNewbtn.hidden = NO ;
    cell.doneImage.hidden= YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.indexType = indexPath.row ;
    cell.titleLabel.text = [[self.photozone componentsSeparatedByString:@"|"] objectAtIndex:indexPath.row] ;
    cell.delegate = self ;
    
    if ([self.type isEqualToString:@"D"]) {
        cell.rightBtn.enabled = YES ;
        cell.rightBtn.hidden = NO ;
        cell.leftBtn.enabled = YES ;
        cell.leftBtn.hidden = NO ;
        [cell.before setImage:[UIImage imageNamed:SYSLanguage?@"Take-Pictures.png":@"sbefore.png"]];
        [cell.after setImage:[UIImage imageNamed:SYSLanguage?@"Take-Pictures.png":@"safter.png"]];
    }
    
    if ([self.type isEqualToString:@"M"]) {
        cell.rightBtn.enabled = NO ;
        cell.rightBtn.hidden = YES ;
        cell.leftBtn.enabled = YES ;
        cell.leftBtn.hidden = NO ;
        [cell.before setImage:[UIImage imageNamed:SYSLanguage?@"Take-Pictures.png":@"takepic.png"]];
        cell.after.hidden = YES ;
        
        CGRect aframe = cell.leftBtn.frame ;
        aframe.size.width = DEVICE_WID - 70 ;
        cell.leftBtn.frame = aframe ;
    }
    
    NSDictionary *result = [self getCurrentItem:indexPath.row];
    
    NSString* beforePath = [result valueForKey:@"PHOTO_PATH1"] ;
    NSString* afterPath = [result valueForKey:@"PHOTO_PATH2"] ;
    
    NSString* beforePathWeb = [result valueForKey:@"PHOTO_WEB_PATH1"] ;
    NSString* afterPathWeb = [result valueForKey:@"PHOTO_WEB_PATH2"] ;
    NSString* beforePathWebUpload = [result valueForKey:@"PHOTO_UPLOAD_PATH1"] ;
    NSString* afterPathWebUpload = [result valueForKey:@"PHOTO_UPLOAD_PATH2"] ;
    
    
    if ((![beforePath isEqualToString:@""])&&(![beforePath isEqualToString:@"0"])&&(beforePath != nil))
    {
        NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[beforePath componentsSeparatedByString:@"/dataCaches"] lastObject]];
        
        if ([UIImage imageWithContentsOfFile:newfile] != nil) {
            
            [cell.before setImage:[[UIImage imageWithContentsOfFile:newfile]scaleToSize:CGSizeMake(50, 50)] ];
            cell.leftDetailButton.hidden = NO ;
        }
    }
    
    if ([self.type isEqualToString:@"D"]) {
        cell.rightBtn.enabled = NO ;
        cell.rightBtn.hidden = YES ;
        cell.after.hidden = YES ;
//        if ((![beforePath isEqualToString:@""])&&(![beforePath isEqualToString:@"0"])&&(beforePath != nil)){
//
//            cell.rightBtn.enabled = YES ;
//            cell.rightBtn.hidden = NO ;
//            cell.after.hidden = NO ;
//
//            if ((![afterPath isEqualToString:@""])&&(![afterPath isEqualToString:@"0"])&&(afterPath != nil))
//            {
//                NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[afterPath componentsSeparatedByString:@"/dataCaches"] lastObject]];
//                if ([UIImage imageWithContentsOfFile:newfile] != nil) {
//
//                    [cell.after setImage:[[UIImage imageWithContentsOfFile:newfile] scaleToSize:CGSizeMake(50, 50)]];
//                }
//            }
//        }
//        else {
//
//            cell.rightBtn.enabled = NO ;
//            cell.rightBtn.hidden = YES ;
//            cell.after.hidden = YES ;
//        }
        
    }
    
    if (self.commentData) {
        
        if ((![beforePathWeb isEqualToString:@""])&&(![beforePathWeb isEqualToString:@"0"])&&(beforePathWeb != nil)&&[beforePathWeb length] > 1)
        {
            if (beforePathWebUpload&&[beforePathWebUpload isEqualToString:@"1"]) {
                
                 [cell.before yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kWebMobileHeadString,[beforePathWeb substringFromIndex:1]]] placeholder:[UIImage imageNamed:SYSLanguage?@"Take-Pictures.png":@"takepic.png"] options:YYWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {}];
                cell.leftDetailButton.hidden = NO ;
            }
        }
        
        
        if ((![beforePathWeb isEqualToString:@""])&&(![beforePathWeb isEqualToString:@"0"])&&(beforePathWeb != nil)&&[beforePathWeb length] > 1) {
            cell.rightBtn.enabled = NO ;
            cell.rightBtn.hidden = YES ;
            cell.after.hidden = YES ;
//            cell.rightBtn.enabled = YES ;
//            cell.rightBtn.hidden = NO ;
//            cell.after.hidden = NO ;
//
//            if ((![afterPathWeb isEqualToString:@""])&&(![afterPathWeb isEqualToString:@"0"])&&(afterPathWeb != nil)&&[afterPathWeb length] > 1)
//            {
//                if (afterPathWebUpload&&[afterPathWebUpload isEqualToString:@"1"]) {
//
//                    [cell.after yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kWebMobileHeadString,[afterPathWeb substringFromIndex:1]]] placeholder:[UIImage imageNamed:SYSLanguage?@"Take-Pictures.png":@"takepic.png"] options:YYWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {}];
//                }
//            }
        }
        else if ([self.type isEqualToString:@"M"]) {
            
            [cell.before setImage:[UIImage imageNamed:SYSLanguage?@"Take-Pictures.png":@"takepic.png"]];
            cell.rightBtn.enabled = NO ;
            cell.rightBtn.hidden = YES ;
            cell.after.hidden = YES ;
            cell.addNewbtn.hidden = YES ;
            for (NSDictionary *dic in self.commentData) {
                
                if ([[NSString stringWithFormat:@"%@",[dic valueForKey:@"SCORECARD_ITEM_ID"]] isEqualToString:self.item_id]&&
                    [cell.titleLabel.text containsString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"PHOTO_ZONE"]]]) {
                    
                    if ([[NSString stringWithFormat:@"%@",[dic valueForKey:@"PHOTO_PATH1"]] length] > 1) {
                        
                        [cell.before yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kWebMobileHeadString,[[NSString stringWithFormat:@"%@",[dic valueForKey:@"PHOTO_PATH1"]] substringFromIndex:1]]] placeholder:[UIImage imageNamed:SYSLanguage?@"Take-Pictures.png":@"takepic.png"] options:YYWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {}];
                        cell.leftDetailButton.hidden = NO ;
                    }
                }
            }
        }
        else {
            
            cell.rightBtn.enabled = NO ;
            cell.rightBtn.hidden = YES ;
            cell.after.hidden = YES ;
        }

    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.scoreTableView) {
        
        return [self.scoreArray count] ;
    }
    
    return [[self.photozone componentsSeparatedByString:@"|"] count];
}

- (void)showDetailImage:(NSInteger)index beforeafter:(int)type {
    
    NSDictionary *result = [self getCurrentItem:index];
    
    NSString* beforePath = [result valueForKey:@"PHOTO_PATH1"] ;
    NSString* beforePathWeb = [result valueForKey:@"PHOTO_WEB_PATH1"] ;
    NSString* beforePathWebUpload = [result valueForKey:@"PHOTO_UPLOAD_PATH1"] ;
    
    if ((![beforePath isEqualToString:@""])&&(![beforePath isEqualToString:@"0"])&&(beforePath != nil))
    {
        NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[beforePath componentsSeparatedByString:@"/dataCaches"] lastObject]];
        
        if ([UIImage imageWithContentsOfFile:newfile] != nil) {
            
            [self.bigImage setImage:[UIImage imageWithContentsOfFile:newfile]];
        }
    }
    
    if (self.commentData) {
        
        if ((![beforePathWeb isEqualToString:@""])&&(![beforePathWeb isEqualToString:@"0"])&&(beforePathWeb != nil)&&[beforePathWeb length] > 1)
        {
            if (beforePathWebUpload&&[beforePathWebUpload isEqualToString:@"1"]) {
                
                [self.bigImage yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kWebMobileHeadString,[beforePathWeb substringFromIndex:1]]] placeholder:[UIImage imageNamed:SYSLanguage?@"Take-Pictures.png":@"takepic.png"] options:YYWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {}];
            }
        }
        
        
        if ((![beforePathWeb isEqualToString:@""])&&(![beforePathWeb isEqualToString:@"0"])&&(beforePathWeb != nil)&&[beforePathWeb length] > 1) {
           
        }
        else if ([self.type isEqualToString:@"M"]) {
            
            for (NSDictionary *dic in self.commentData) {
                
                if ([[NSString stringWithFormat:@"%@",[dic valueForKey:@"SCORECARD_ITEM_ID"]] isEqualToString:self.item_id]&&
                    [[[self.photozone componentsSeparatedByString:@"|"] objectAtIndex:index] isEqualToString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"PHOTO_ZONE"]]]) {
                    
                    if ([[NSString stringWithFormat:@"%@",[dic valueForKey:@"PHOTO_PATH1"]] length] > 1) {
                        
                        [self.bigImage yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kWebMobileHeadString,[[NSString stringWithFormat:@"%@",[dic valueForKey:@"PHOTO_PATH1"]] substringFromIndex:1]]] placeholder:[UIImage imageNamed:SYSLanguage?@"Take-Pictures.png":@"takepic.png"] options:YYWebImageOptionProgressiveBlur completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {}];
                    }
                }
            }
        }
    }
    
    [self presentPopupView:self.ImageBGView];
}


- (void)addNew:(id)cell {
    
    if (self.commentData&&[self.type isEqualToString:@"M"]) return ;
    
    TakePhotoListCell *selecell = (TakePhotoListCell *)cell ;
    
    NSString *lastzone = selecell.titleLabel.text ;
    NSString *newzone = @"" ;
    NSInteger insertindex = [[self.photozone componentsSeparatedByString:@"|"] indexOfObject:[[lastzone componentsSeparatedByString:@"_"] firstObject]] ;
    
    NSString *zone = [[lastzone componentsSeparatedByString:@"_"] firstObject];
    int cur = 0 ;
    
    for (NSString * str in [self.photozone componentsSeparatedByString:@"|"]) {
        if ([str containsString:zone]) {
            
            int last = 0 ;
            
            if ([[str componentsSeparatedByString:@"_"] count] == 2) {
                
                last = [[[str componentsSeparatedByString:@"_"] lastObject] intValue] ;
            }
            
            if (last > cur) cur = last ;
        }
    }
    
    if ([self.type isEqualToString:@"M"]&&cur == 9) {
        
        ALERTVIEW(SYSLanguage?@"Sorry,can not add":@"对不起,不能再添加了");
        return ;
    }
    
    if ([self.type isEqualToString:@"D"]&&cur == 9) {
        
        ALERTVIEW(SYSLanguage?@"Sorry,can not add":@"对不起,不能再添加了");
        return ;
    }
    
    insertindex = [[self.photozone componentsSeparatedByString:@"|"] indexOfObject:[[lastzone componentsSeparatedByString:@"_"] firstObject]] + cur + 1 ;
    newzone = [NSString stringWithFormat:@"%@_%d",zone,cur+1];
    
    FMDatabase *db = [[SqliteHelper shareCommonSqliteHelper] database];
    [db beginTransaction];
    
    BOOL result = YES;
    @try
    {
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_SCORECARD_PHOTO_ZONE (SCORECARD_CHECK_PHOTO_ID,PHOTO_ZONE_NAME_CN,PHOTO_WEB_PATH1,PHOTO_WEB_PATH2,PHOTO_UPLOAD_PATH1,PHOTO_UPLOAD_PATH2,SCORE_CARD_TYPE) values (?,?,?,?,?,?,?)"];
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         self.CurrentmanageResultEntity.scorecard_check_photo_id,
         newzone,
         @"",
         @"",
         @"0",
         @"0",
         self.type];
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
            
            self.CurrentmanageResultEntity.comment = self.comment_textview.text ;
            NSMutableArray *oldAry = [NSMutableArray arrayWithArray:[self.photozone componentsSeparatedByString:@"|"]];
            [oldAry insertObject:newzone atIndex:insertindex];
            self.photozone = [oldAry componentsJoinedByString:@"|"];
            [self.scoreItemTableView reloadData] ;
            [self configUI];
        }
        else
        {
            [db rollback];
        }
    }
}

- (void)openCamera:(NSInteger)index beforeafter:(int)type {
    
    if (self.commentData&&[self.type isEqualToString:@"M"]) return ;
    
    self.currentSelectType =  [NSString stringWithFormat:@"%d",type] ;
    self.currentSelectIndex = index ;
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    if(!self.photoPicker) self.photoPicker = [[UIImagePickerController alloc]init];
    self.photoPicker.sourceType = sourceType;
    self.photoPicker.delegate = self;
    self.photoPicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:self.photoPicker animated:YES completion:nil];
}

- (void)setImageValueWith:(UIImage *)image {
    
    NSDictionary *result = [self getCurrentItem:self.currentSelectIndex];
    
    NSString *dateStr = [Utilities DateNow];
    
    if (self.commentDate&&self.commentData) dateStr = self.commentDate ;
    
    NSString *path = [NSString stringWithFormat:kVMPicturePathString,[Utilities SysDocumentPath],dateStr,[CacheManagement instance].currentStore.StoreCode,[NSString stringWithFormat:@"SCORECARD_%@",self.type],[Utilities GetUUID]];
    
    NSFileManager* fileMannager = [NSFileManager defaultManager];
    
    if(![fileMannager fileExistsAtPath:path])
    {
        [fileMannager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [fileMannager removeItemAtPath:path error:nil] ;
    
    [Utilities saveImage:image imgPath:path];
    
    if (!result) {
        
        NSString *photo_1 = @"" ;
        NSString *photo_2 = @"" ;
        
        if([self.currentSelectType isEqualToString:@"1"]) photo_1 = path ;
        if([self.currentSelectType isEqualToString:@"2"]) photo_2 = path ;
        
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_SCORECARD_PHOTO_ZONE (SCORECARD_CHECK_PHOTO_ID,PHOTO_ZONE_NAME_CN,PHOTO_PATH1,PHOTO_PATH2,PHOTO_UPLOAD_PATH1,PHOTO_UPLOAD_PATH2,SCORE_CARD_TYPE) values (?,?,?,?,?,?,?)"];
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         self.CurrentmanageResultEntity.scorecard_check_photo_id,
         [[self.photozone componentsSeparatedByString:@"|"] objectAtIndex:self.currentSelectIndex],
         photo_1,
         photo_2,
         @"0",
         @"0",
         self.type];
    }
    
    else {
        
        NSString *column_name = @"" ;
        NSString *column_name_web = @"" ;
        
        if ([self.currentSelectType isEqualToString:@"1"]) {
            
            column_name_web = @"PHOTO_UPLOAD_PATH1" ;
            column_name = @"PHOTO_PATH1" ;
            
            NSString *oldFile = [result valueForKey:@"PHOTO_PATH1"];
            
            if ([fileMannager fileExistsAtPath:oldFile]) {
                
                [fileMannager removeItemAtPath:oldFile error:nil] ;
            }
        }
        
        if ([self.currentSelectType isEqualToString:@"2"]) {
            
            column_name_web = @"PHOTO_UPLOAD_PATH2" ;
            column_name = @"PHOTO_PATH2" ;
            
            NSString *oldFile = [result valueForKey:@"PHOTO_PATH2"];
            
            if ([fileMannager fileExistsAtPath:oldFile]) {
                
                [fileMannager removeItemAtPath:oldFile error:nil] ;
            }
        }
        
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        NSString* sql_ = [NSString stringWithFormat:@"UPDATE NVM_IST_SCORECARD_PHOTO_ZONE SET %@ = '%@' where PHOTO_ZONE_NAME_CN = '%@' and SCORECARD_CHECK_PHOTO_ID = '%@' and SCORE_CARD_TYPE = '%@'",column_name,path,[[self.photozone componentsSeparatedByString:@"|"] objectAtIndex:self.currentSelectIndex],self.CurrentmanageResultEntity.scorecard_check_photo_id,self.type];
        
        if (self.commentData) {
            
            sql_ = [NSString stringWithFormat:@"UPDATE NVM_IST_SCORECARD_PHOTO_ZONE SET %@ = '%@' , %@='0' where PHOTO_ZONE_NAME_CN = '%@' and SCORECARD_CHECK_PHOTO_ID = '%@' and SCORE_CARD_TYPE = '%@'",column_name,path,column_name_web,[[self.photozone componentsSeparatedByString:@"|"] objectAtIndex:self.currentSelectIndex],self.CurrentmanageResultEntity.scorecard_check_photo_id,self.type];
        }
        
        [db executeUpdate:sql_];
    }
    
    [self.scoreItemTableView reloadData];
    [self resetViewFrame];
}

- (NSDictionary *)getCurrentItem:(NSInteger)index {
    
    NSString *sql = [NSString stringWithFormat:@"Select * FROM NVM_IST_SCORECARD_PHOTO_ZONE where PHOTO_ZONE_NAME_CN = '%@' and SCORECARD_CHECK_PHOTO_ID = '%@' and SCORE_CARD_TYPE = '%@'",[[self.photozone componentsSeparatedByString:@"|"] objectAtIndex:index],self.CurrentmanageResultEntity.scorecard_check_photo_id,self.type];
    
    NSDictionary *result = nil ;
    
    FMResultSet *rs = nil;
    @try
    {
        rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
        while ([rs next])
        {
            result = @{@"PHOTO_PATH1":[rs stringForColumn:@"PHOTO_PATH1"]?[rs stringForColumn:@"PHOTO_PATH1"]:@"",
                       @"PHOTO_PATH2":[rs stringForColumn:@"PHOTO_PATH2"]?[rs stringForColumn:@"PHOTO_PATH2"]:@"",
                       @"PHOTO_WEB_PATH1":[rs stringForColumn:@"PHOTO_WEB_PATH1"]?[rs stringForColumn:@"PHOTO_WEB_PATH1"]:@"",
                       @"PHOTO_WEB_PATH2":[rs stringForColumn:@"PHOTO_WEB_PATH2"]?[rs stringForColumn:@"PHOTO_WEB_PATH2"]:@"",
                       @"PHOTO_UPLOAD_PATH1":[rs stringForColumn:@"PHOTO_UPLOAD_PATH1"]?[rs stringForColumn:@"PHOTO_UPLOAD_PATH1"]:@"",
                       @"PHOTO_UPLOAD_PATH2":[rs stringForColumn:@"PHOTO_UPLOAD_PATH2"]?[rs stringForColumn:@"PHOTO_UPLOAD_PATH2"]:@"",
                       @"PHOTO_ZONE_NAME_CN":[rs stringForColumn:@"PHOTO_ZONE_NAME_CN"]?[rs stringForColumn:@"PHOTO_ZONE_NAME_CN"]:@"",
                       @"SCORECARD_CHECK_PHOTO_ID":[rs stringForColumn:@"SCORECARD_CHECK_PHOTO_ID"]?[rs stringForColumn:@"SCORECARD_CHECK_PHOTO_ID"]:@""} ;
        }
    }
    @catch (NSException *e)
    {
        @throw e;
    }
    @finally
    {
        if (rs)[rs close];
    }
    
    return result ;
}


- (NSDictionary *)getCurrentItemWith:(NSString *)zone {
    
    NSString *sql = [NSString stringWithFormat:@"Select * FROM NVM_IST_SCORECARD_PHOTO_ZONE where PHOTO_ZONE_NAME_CN = '%@' and SCORECARD_CHECK_PHOTO_ID = '%@' and SCORE_CARD_TYPE = '%@'",zone,self.CurrentmanageResultEntity.scorecard_check_photo_id,self.type];
    
    NSDictionary *result = nil ;
    
    FMResultSet *rs = nil;
    @try
    {
        rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
        while ([rs next])
        {
            result = @{@"PHOTO_PATH1":[rs stringForColumn:@"PHOTO_PATH1"]?[rs stringForColumn:@"PHOTO_PATH1"]:@"",
                       @"PHOTO_PATH2":[rs stringForColumn:@"PHOTO_PATH2"]?[rs stringForColumn:@"PHOTO_PATH2"]:@"",
                       @"PHOTO_WEB_PATH1":[rs stringForColumn:@"PHOTO_WEB_PATH1"]?[rs stringForColumn:@"PHOTO_WEB_PATH1"]:@"",
                       @"PHOTO_WEB_PATH2":[rs stringForColumn:@"PHOTO_WEB_PATH2"]?[rs stringForColumn:@"PHOTO_WEB_PATH2"]:@"",
                       @"PHOTO_UPLOAD_PATH1":[rs stringForColumn:@"PHOTO_UPLOAD_PATH1"]?[rs stringForColumn:@"PHOTO_UPLOAD_PATH1"]:@"",
                       @"PHOTO_UPLOAD_PATH2":[rs stringForColumn:@"PHOTO_UPLOAD_PATH2"]?[rs stringForColumn:@"PHOTO_UPLOAD_PATH2"]:@"",
                       @"PHOTO_ZONE_NAME_CN":[rs stringForColumn:@"PHOTO_ZONE_NAME_CN"]?[rs stringForColumn:@"PHOTO_ZONE_NAME_CN"]:@"",
                       @"SCORECARD_CHECK_PHOTO_ID":[rs stringForColumn:@"SCORECARD_CHECK_PHOTO_ID"]?[rs stringForColumn:@"SCORECARD_CHECK_PHOTO_ID"]:@""} ;
        }
    }
    @catch (NSException *e)
    {
        @throw e;
    }
    @finally
    {
        if (rs)[rs close];
    }
    
    return result ;
}


- (NSArray *)getTotalPhotoZone {
    
    NSString *sql = [NSString stringWithFormat:@"Select PHOTO_ZONE_NAME_CN FROM NVM_IST_SCORECARD_PHOTO_ZONE where SCORECARD_CHECK_PHOTO_ID = '%@' and SCORE_CARD_TYPE = '%@'",self.CurrentmanageResultEntity.scorecard_check_photo_id,self.type];
    
    NSMutableArray *result = [NSMutableArray array] ;
    
    FMResultSet *rs = nil;
    @try
    {
        rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
        while ([rs next])
        {
            [result addObject:[rs stringForColumn:@"PHOTO_ZONE_NAME_CN"]?[rs stringForColumn:@"PHOTO_ZONE_NAME_CN"]:@""] ;
        }
    }
    @catch (NSException *e)
    {
        @throw e;
    }
    @finally
    {
        if (rs)[rs close];
    }
    
    return [result sortedArrayUsingSelector:@selector(compare:)] ;
}

-(NSString*)GetScorebyItemID:(NSString*)Item_ID
{
    if ([self.type isEqualToString:@"M"]) {
        
        return @"finished" ;
    }
    
    NSArray *allItem = [self getAllScoreItem:Item_ID];
    
    int count = 0 ;
    NSString *sql2 = [NSString stringWithFormat:@"Select * FROM NVM_IST_SCORECARD_ITEM_DETAIL where SCORECARD_CHECK_PHOTO_ID = '%@' and SCORECARD_ITEM_ID = '%@'",self.CurrentmanageResultEntity.scorecard_check_photo_id,Item_ID];
    
    NSString *finish = @"finished"  ;
    FMResultSet *rs2 = nil;
    
    @try
    {
        rs2 = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql2];
        while ([rs2 next])
        {
            count += 1 ;
            VmScoreCardScoreEntity *entity = [[VmScoreCardScoreEntity alloc] initWithFMResultSet:rs2];
            
            if ((entity.STANDARD_SCORE&&![entity.STANDARD_SCORE isEqual:[NSNull null]]&&[entity.STANDARD_SCORE isEqualToString:@"0"])) {
                
                if (!entity.REMARK||[entity.REMARK isEqual:[NSNull null]]||[entity.REMARK isEqualToString:@""]) {
                    
                    
                    [rs2 close];
                    return @"1" ;
                }
            }
        }
    }
    @catch (NSException *e)
    {
        @throw e;
    }
    @finally
    {
        if (rs2)[rs2 close];
    }
    if (count != [allItem count]) {
        
        return @"2" ;
    }

    return finish ;
}


- (NSArray *)getAllScoreItem:(NSString *)itemid {
    
    NSMutableArray* resultarr = [[NSMutableArray alloc]init];
    NSString* sql = [NSString stringWithFormat:@"select * from NVM_VM_SCORECARD_ITEM_DETAIL where SCORECARD_ITEM_ID ='%@' ",itemid];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        VmScoreCardDetailEntity *entity = [[VmScoreCardDetailEntity alloc] initWithFMResultSet:rs];
        [resultarr addObject:entity];
    }
    [rs close];
    
    return resultarr;
}

- (int)caculateTotal{
    
    int total = 0 ;
    
    for (int index = 0 ; index < [[self.photozone componentsSeparatedByString:@"|"] count]; index++) {
        
        BOOL ischange = NO ;
        NSDictionary *result = [self getCurrentItem:index];
        
        NSString* beforePath = [result valueForKey:@"PHOTO_PATH1"] ;
        NSString* beforePathWeb = [result valueForKey:@"PHOTO_WEB_PATH1"] ;
        NSString* beforePathWebUpload = [result valueForKey:@"PHOTO_UPLOAD_PATH1"] ;
        
        
        if ((![beforePath isEqualToString:@""])&&(![beforePath isEqualToString:@"0"])&&(beforePath != nil))
        {
            NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[beforePath componentsSeparatedByString:@"/dataCaches"] lastObject]];
            
            if ([UIImage imageWithContentsOfFile:newfile] != nil) {
                
                ischange = YES ;
            }
        }
        
        if (self.commentData) {
            
            if ((![beforePathWeb isEqualToString:@""])&&(![beforePathWeb isEqualToString:@"0"])&&(beforePathWeb != nil)&&[beforePathWeb length] > 1)
            {
                if (beforePathWebUpload&&[beforePathWebUpload isEqualToString:@"1"]) {
                    
                    ischange = YES ;
                }
            }
            
            if ([self.type isEqualToString:@"M"]) {
                for (NSDictionary *dic in self.commentData) {
                    
                    if ([[NSString stringWithFormat:@"%@",[dic valueForKey:@"SCORECARD_ITEM_ID"]] isEqualToString:self.item_id]&&
                        [[[self.photozone componentsSeparatedByString:@"|"] objectAtIndex:index] isEqualToString:[NSString stringWithFormat:@"%@",[dic valueForKey:@"PHOTO_ZONE"]]]) {
                        
                        if ([[NSString stringWithFormat:@"%@",[dic valueForKey:@"PHOTO_PATH1"]] length] > 1) {
                            
                            ischange = YES ;
                        }
                    }
                }
            }
        }
        
        if (ischange) total += 20 ;
    }
    
    return total ;
}

- (void)resetViewFrame {
    
    CGRect aframe = self.scoreItemTableView.frame ;
    aframe.size.height = 78*[[self.photozone componentsSeparatedByString:@"|"] count] + [self caculateTotal] ;
    self.scoreItemTableView.frame = aframe ;
    
    CGRect pageframe = self.page_view.frame ;
    pageframe.size.height = aframe.size.height+aframe.origin.y+40 ;
    self.page_view.frame = pageframe ;
    
    self.scrollview.contentSize = CGSizeMake(10, aframe.size.height+aframe.origin.y+80);
}

@end

























