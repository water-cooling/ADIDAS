//
//  ManageScoreViewController.m
//  ADIDAS
//
//  Created by wendy on 14-4-24.
//
//

#import "AuditDetailViewController.h"
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
#import "auditImageItemCustomCell.h"
#import "VMStoreAuditPhotoEntity.h"
#import "SendEmailViewController.h"
#import "ScoreCollectCustomCell.h"
#import "NvmMstStoreAuditItemEntity.h"
#import "ScoreCustomCell.h"

@interface AuditDetailViewController ()<WBGImageEditorDelegate,WBGImageEditorDataSource,UICollectionViewDelegate,UICollectionViewDataSource,ImageOperateDelegate,SendEmailDelegate,UITableViewDelegate,UITableViewDataSource,ScoreTableDelegate>

@end

@implementation AuditDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width {
    CGRect suggestedRect = [value boundingRectWithSize:CGSizeMake(width,MAXFLOAT)
                                               options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                            attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}
                                               context:nil];
    return suggestedRect.size.height;
}

- (float) widthForString:(NSString *)value font:(UIFont *)font andHeight:(float)height {
    CGRect suggestedRect = [value boundingRectWithSize:CGSizeMake(MAXFLOAT,height)
                                               options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                            attributes:@{NSFontAttributeName:font}
                                               context:nil];
    return suggestedRect.size.width;
}


- (void)configUI {
    
    if (!self.CurrentmanageResultEntity.score) {
        self.scoreResult = @"" ;
    } else {
        self.scoreResult = self.CurrentmanageResultEntity.score;
    }
    self.navigationItem.title = self.parentTitle;
    self.pagetextfield.text = [NSString stringWithFormat:@"%d",(int)self.No];
    [self.No_label setTitle:self.subTitleNo forState:UIControlStateNormal];
    
    self.itemTitleLabel.text = self.item_name ;
    NSInteger height =  [self heightForString:self.itemTitleLabel.text fontSize:14 andWidth:DEVICE_WID-40];
    self.itemTitleLabel.frame = CGRectMake(28, 0, DEVICE_WID-40, height+5);
    
    if (self.item_description&&
        ![self.item_description isEqual:[NSNull null]]&&
        ![self.item_description isEqualToString:@""]&&
        ![self.item_description.lowercaseString containsString:@"null"]) {
        self.itemDescriptionLabel.text = self.item_description;
        height =  [self heightForString:self.itemDescriptionLabel.text fontSize:14 andWidth:DEVICE_WID-22];
        self.itemDescriptionLabel.frame = CGRectMake(6, self.itemTitleLabel.frame.size.height+self.itemTitleLabel.frame.origin.y+15, DEVICE_WID-22, height+5);
    } else {
        self.itemDescriptionLabel.text = @"";
        self.itemDescriptionLabel.frame = CGRectMake(6, self.itemTitleLabel.frame.size.height+self.itemTitleLabel.frame.origin.y+5, DEVICE_WID-22, 0);
    }
    
    self.NAView.hidden = YES ;
    self.small_pageview.hidden = YES ;
    self.scoreTableView.hidden = YES ;
    self.scoreCollectView.hidden = YES ;
    
    FMDatabase* db = [[SqliteHelper shareCommonSqliteHelper]database];
    NSString *itemSql = [NSString stringWithFormat:@"SELECT a.*,b.CHECK_RESULT FROM NVM_MST_STOREAUDIT_ITEM a left join NVM_IST_STOREAUDIT_CHECK_DETAIL b on a.ITEM_ID = b.ITEM_ID and b.STOREAUDIT_CHECK_ID = '%@' where instr(a.ITEM_ID,'_') != 0 and a.ITEM_ID like '%%%@%%' order by a.ITEM_ID asc ",[CacheManagement instance].currentVMCHKID,self.item_id];
    FMResultSet* rs = [db executeQuery:itemSql];
    subArray = [NSMutableArray array];
    while([rs next]){
        NvmMstStoreAuditItemEntity* checkEntity = [[NvmMstStoreAuditItemEntity alloc]initWithFMResultSet:rs];
        [subArray addObject:checkEntity];
    }
    
    float topViewHeight = 0 ;
    BOOL isShowPic = NO ;
    
    if ([subArray count] == 0) {
        self.small_pageview.hidden = NO ;
        self.NAView.hidden = YES ;
        if ([self.isSpecial isEqualToString:@"Y"]) {
            self.NAView.hidden = NO ;
            self.small_pageview.frame = CGRectMake(4, self.itemDescriptionLabel.frame.size.height+self.itemDescriptionLabel.frame.origin.y + 10 , 280-15, 58);
            self.NAView.frame = CGRectMake(244 - 15, self.itemDescriptionLabel.frame.size.height+self.itemDescriptionLabel.frame.origin.y + 10 , 165, 58);
            self.NALabel.text = SYSLanguage?@"Product Arrival":@"正在出/入货";
        } else {
            self.small_pageview.frame = CGRectMake(4, self.itemDescriptionLabel.frame.size.height+self.itemDescriptionLabel.frame.origin.y + 10 , DEWIDTH-10-8, 58);
        }
        
        
        topViewHeight = self.small_pageview.frame.size.height + self.small_pageview.frame.origin.y;
        isShowPic = [@"N" isEqualToString:self.scoreResult]||[@"NA" isEqualToString:self.scoreResult];
        if ([self.scoreResult isEqualToString:@"Y"]){
            [self.Yes_btn setBackgroundImage:[UIImage imageNamed:@"form2.png"] forState:UIControlStateNormal];
            [self.No_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
            [self.NAButton setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        } else if([self.scoreResult isEqualToString:@"N"]) {
            [self.Yes_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
            [self.No_btn setBackgroundImage:[UIImage imageNamed:@"form2.png"] forState:UIControlStateNormal];
            [self.NAButton setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        } else if([self.scoreResult isEqualToString:@"NA"]) {
           [self.Yes_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
           [self.No_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
           [self.NAButton setBackgroundImage:[UIImage imageNamed:@"form2.png"] forState:UIControlStateNormal];
       } else if ([self.scoreResult isEqualToString:@""]) {
            [self.Yes_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
            [self.No_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
            [self.NAButton setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        }
    }
    
    if ([subArray count] > 0) {
        NvmMstStoreAuditItemEntity* checkEntity = subArray.firstObject;
        NSString *scoreOption = [NSString stringWithFormat:@"%@",checkEntity.SCORE_OPTION];
        if ([scoreOption isEqualToString:@"Y"]) {
            self.scoreTableView.hidden = NO ;
            [self.scoreTableView reloadData];
            
            float totalHeight = 0 ;
            for (NvmMstStoreAuditItemEntity* checkEntity in subArray) {
                float height = [self heightForString:SYSLanguage?checkEntity.ITEM_NAME_EN:checkEntity.ITEM_NAME_CN fontSize:14 andWidth:DEVICE_WID-30] + 5;
                if (height < 20) totalHeight += 78;
                totalHeight += (58 + height);
                if ([checkEntity.CHECK_RESULT isEqualToString:@"N"]||[checkEntity.CHECK_RESULT isEqualToString:@"NA"]) isShowPic = YES ;
            }
            
            CGRect frame = self.scoreTableView.frame ;
            frame.origin.y = self.itemDescriptionLabel.frame.size.height+self.itemDescriptionLabel.frame.origin.y + 10;
            frame.size.height = totalHeight;
            self.scoreTableView.frame = frame ;
            topViewHeight = frame.size.height + frame.origin.y;
        }
        if ([scoreOption isEqualToString:@"N"]) {
            self.scoreCollectView.hidden = NO ;
            [self.scoreCollectView reloadData];
            CGRect frame = self.scoreCollectView.frame ;
            frame.origin.y = self.itemDescriptionLabel.frame.size.height+self.itemDescriptionLabel.frame.origin.y + 10;
            frame.size.height = 60;
            self.scoreCollectView.frame = frame ;
            topViewHeight = frame.size.height + frame.origin.y;
            for (NvmMstStoreAuditItemEntity* checkEntity in subArray) {
                if ([checkEntity.CHECK_RESULT isEqualToString:@"Y"]&&![checkEntity.STANDARD_SCORE isEqualToString:self.standardScore]) isShowPic = YES ;
            }
        }
    }
    
    CGRect pframe = self.PicCollectView.frame ;
    pframe.origin.y = topViewHeight + 10;
    if ([self.maxPicCount intValue] > 0&&isShowPic) {
        pframe.size.height = ([self.maxPicCount intValue]/3 + 1)*(DEVICE_WID/3.0);
        [self.PicCollectView reloadData];
        self.PicCollectView.hidden = NO ;
    } else {
        pframe.size.height = 50;
        self.PicCollectView.hidden = YES ;
    }
    self.PicCollectView.frame = pframe ;
    CGRect frame = self.page_view.frame ;
    frame.size.height = pframe.size.height + pframe.origin.y + 20;
    self.page_view.frame = frame ;
    self.scrollview.contentSize = CGSizeMake(DEWIDTH, frame.size.height + frame.origin.y + 20);
}

- (void)deletePic:(id)sender {
    UILongPressGestureRecognizer* longpress = (UILongPressGestureRecognizer*)sender;
    if (longpress.state == UIGestureRecognizerStateBegan)
    {
        UIActionSheet* ac = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:SYSLanguage?@"Cancel": @"取消" destructiveButtonTitle:SYSLanguage?@"Delete": @"删除" otherButtonTitles:nil, nil];
        [ac showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == 100000 && buttonIndex != 2) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if (buttonIndex == 1) {//相册
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        
        self.photoPicker = [[UIImagePickerController alloc]init];
        self.photoPicker.sourceType = sourceType;
        self.photoPicker.delegate = self;
        self.photoPicker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:self.photoPicker animated:YES completion:nil];
        return ;
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

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self.leveyTabBarController hidesTabBar:YES animated:NO];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
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

- (void)setImageValueWith:(UIImage *)image {
    
    NSString *path = nil ;
    if (self.CurrentmanageResultEntity.picArray.count > currentIndex) {
        VMStoreAuditPhotoEntity *entity = [self.CurrentmanageResultEntity.picArray objectAtIndex:currentIndex];
        path = entity.photoPath;
    } else {
        NSMutableArray *temp = [NSMutableArray arrayWithArray:self.CurrentmanageResultEntity.picArray];
        VMStoreAuditPhotoEntity *entity = [[VMStoreAuditPhotoEntity alloc] init];
        entity.photoPath = @"";
        entity.photoComment = @"" ;
        [temp addObject:entity];
        self.CurrentmanageResultEntity.picArray = temp ;
    }
    
    if (path == nil || [path isEqual:[NSNull null]]){
        path = [NSString stringWithFormat:kVMPicturePathString,[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,@"StoreAudit",[NSString stringWithFormat:@"%d.%d",(int)self.No,(int)currentIndex]];
        NSFileManager* fileMannager = [NSFileManager defaultManager];
        if(![fileMannager fileExistsAtPath:path]){
            [fileMannager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
    
    [Utilities saveImage:image imgPath:path];
    
    if (self.CurrentmanageResultEntity.picArray.count > currentIndex) {
        VMStoreAuditPhotoEntity *entity = [self.CurrentmanageResultEntity.picArray objectAtIndex:currentIndex];
        entity.photoPath = path;
        if ((!entity.photoComment||[entity.photoComment isEqual:[NSNull null]]||[entity.photoComment isEqualToString:@""])&&[[NSString stringWithFormat:@"%@",self.mustComment] isEqualToString:@"Y"]) {
            SendEmailViewController *pop = [[SendEmailViewController alloc] initWithNibName:@"SendEmailViewController" bundle:nil] ;
            pop.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            pop.delegate = self ;
            pop.commentInfo = @"";
            pop.mustType = [NSString stringWithFormat:@"%@",self.mustComment];
            pop.index = currentIndex;
            [self presentViewController:pop animated:NO completion:^{}];
        }
    }
    [self.PicCollectView reloadData];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.leveyTabBarController hidesTabBar:YES animated:NO];
}

#pragma mark - textview



#pragma mark - ibaction

- (void)saveSingleResult {
    self.CurrentmanageResultEntity.score = self.scoreResult;
    self.CurrentmanageResultEntity.item_id = self.item_id;
    self.CurrentmanageResultEntity.comment = @"";
    self.CurrentmanageResultEntity.check_id = [CacheManagement instance].currentVMCHKID;
    self.CurrentmanageResultEntity.check_detail_id = [Utilities GetUUID];
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
            self.scoreResult = @"";
        }
        else
        {
            [db rollback];
        }
    }
}


// 检查此次检查表是否存在
- (NSArray*)checkARMS_CheckID {
    __autoreleasing NSMutableArray* resultarr = [[NSMutableArray alloc]init];
    NSString* storecode = [CacheManagement instance].currentStore.StoreCode;
    NSString* workmainID = [CacheManagement instance].currentWorkMainID;
    NSString* sql = [NSString stringWithFormat:@"select * from NVM_IST_STOREAUDIT_CHECK where WORK_MAIN_ID ='%@' and STORE_CODE= '%@'",workmainID,storecode];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        [resultarr addObject:[rs stringForColumnIndex:0]];
    }
    [rs close];
    
	return resultarr;
    
}

- (void)UpdateARMS_CheckID {
    NSArray* arr = [self checkARMS_CheckID];
    if ( arr.count > 0) {
        // 存在列表
        [CacheManagement instance].currentVMCHKID = [arr objectAtIndex:0];
    } else {
        
        NSString* NVM_IST_STOREAUDIT_CHECK_ID =[Utilities GetUUID];
        [CacheManagement instance].currentVMCHKID = NVM_IST_STOREAUDIT_CHECK_ID;
        NSString* storeCode = [CacheManagement instance].currentStore.StoreCode;
        NSString* workdate = [Utilities DateNow];
        NSString* workstarttime = [Utilities DateTimeNow];
        NSString* workendtime = [Utilities DateTimeNow];
        NSString* userid = [CacheManagement instance].currentUser.UserId;
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_STOREAUDIT_CHECK (STOREAUDIT_CHECK_ID,STORE_CODE,USER_ID,WORK_MAIN_ID,WORK_DATE,WORK_START_TIME,WORK_END_TIME,TOTAL_SCORE,USER_SUBMIT_TIME,CLIENT_UPLOAD_TIME,SERVER_INSERT_TIME) values (?,?,?,?,?,?,?,?,?,?,?)"];
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         NVM_IST_STOREAUDIT_CHECK_ID,
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
- (NSMutableArray *) getLocalArmsCHKItemByItem_id {
	NSString *sql = [NSString stringWithFormat:@"Select a.*,b.PHOTO_PATH,b.COMMENT FROM NVM_IST_STOREAUDIT_CHECK_DETAIL a left join NVM_IST_STOREAUDIT_CHECK_PHOTO b on a.STOREAUDIT_CHECK_ID = b.STOREAUDIT_CHECK_ID and a.ITEM_ID = b.ITEM_ID where a.ITEM_ID = '%@' and a.STOREAUDIT_CHECK_ID = '%@'",self.item_id,[CacheManagement instance].currentVMCHKID];
	__autoreleasing NSMutableArray *result = [[NSMutableArray alloc] init];
	
	FMResultSet *rs = nil;
	@try
    {
        rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
        NSMutableArray *paths = [NSMutableArray array];
		while ([rs next])
        {
            VMStoreAuditScoreEntity* data = [[VMStoreAuditScoreEntity alloc]init];
            data.check_detail_id = [rs stringForColumnIndex:0];
            data.check_id = [rs stringForColumnIndex:1];
            data.item_id = [rs stringForColumnIndex:2];
            data.comment = [rs stringForColumnIndex:4];
            data.score = [rs stringForColumnIndex:3];
            NSString *path = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"PHOTO_PATH"]];
            NSString *comment = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"COMMENT"]];
            if (![path isEqualToString:@""]&&![path.lowercaseString containsString:@"null"]&&path.length>10) {
                VMStoreAuditPhotoEntity *entity = [[VMStoreAuditPhotoEntity alloc] init];
                entity.photoPath = path ;
                entity.photoComment = comment;
                [paths addObject:entity];
            }
            if ([result count] == 0) {
                [result addObject:data];
            }
        }
        if (result.count > 0) {
            VMStoreAuditScoreEntity* data = result.firstObject;
            data.picArray = paths;
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
- (void) insertLocalArmsCHKItem:(VMStoreAuditScoreEntity*)data broker:(FMDatabase*)db {
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_STOREAUDIT_CHECK_DETAIL (\
                     STOREAUDIT_CHECK_DETAIL_ID,\
                     STOREAUDIT_CHECK_ID,\
                     ITEM_ID,\
                     COMMENT,\
                     LAST_MODIFIED_BY,\
                     LAST_MODIFIED_TIME,\
                     CHECK_RESULT) values (?,?,?,?,?,?,?)"];
    [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql,
                                                            data.check_detail_id,
                                                            data.check_id,
                                                            data.item_id,
                                                            data.comment,
                                                            [CacheManagement instance].currentDBUser.userName,
                                                            [Utilities DateTimeNow],
                                                            data.score];
    
    if ([subArray count] > 0) {
        NvmMstStoreAuditItemEntity* checkEntity = subArray.firstObject;
        NSString *scoreOption = [NSString stringWithFormat:@"%@",checkEntity.SCORE_OPTION];
        
        if ([scoreOption isEqualToString:@"Y"]) {
            for (NvmMstStoreAuditItemEntity* checkEntity in subArray) {
                sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_STOREAUDIT_CHECK_DETAIL (\
                                 STOREAUDIT_CHECK_DETAIL_ID,\
                                 STOREAUDIT_CHECK_ID,\
                                 ITEM_ID,\
                                 COMMENT,\
                                 LAST_MODIFIED_BY,\
                                 LAST_MODIFIED_TIME,\
                                 CHECK_RESULT) values (?,?,?,?,?,?,?)"];
                [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql,
                                                                        [Utilities GetUUID],
                                                                        data.check_id,
                                                                        checkEntity.ITEM_ID,
                                                                        data.comment,
                                                                        [CacheManagement instance].currentDBUser.userName,
                                                                        [Utilities DateTimeNow],
                                                                        checkEntity.CHECK_RESULT];
            }
        }
        
        if ([scoreOption isEqualToString:@"N"]) {
            for (NvmMstStoreAuditItemEntity* checkEntity in subArray) {
                if ([checkEntity.CHECK_RESULT isEqualToString:@"Y"]) {
                    sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_STOREAUDIT_CHECK_DETAIL (\
                                     STOREAUDIT_CHECK_DETAIL_ID,\
                                     STOREAUDIT_CHECK_ID,\
                                     ITEM_ID,\
                                     COMMENT,\
                                     LAST_MODIFIED_BY,\
                                     LAST_MODIFIED_TIME,\
                                     CHECK_RESULT) values (?,?,?,?,?,?,?)"];
                    [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql,
                                                                            [Utilities GetUUID],
                                                                            data.check_id,
                                                                            checkEntity.ITEM_ID,
                                                                            data.comment,
                                                                            [CacheManagement instance].currentDBUser.userName,
                                                                            [Utilities DateTimeNow],
                                                                            checkEntity.CHECK_RESULT];
                    break;
                }
            }
        }
    }
    
    for (VMStoreAuditPhotoEntity *entity in self.CurrentmanageResultEntity.picArray) {
        sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_STOREAUDIT_CHECK_PHOTO (\
        STOREAUDIT_CHECK_PHOTO_ID,\
        STOREAUDIT_CHECK_ID,\
        ITEM_ID,\
        PHOTO_PATH,\
        LAST_MODIFIED_BY,\
        COMMENT,\
        LAST_MODIFIED_TIME) values (?,?,?,?,?,?,?)"];
        [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql,
                                                                [Utilities GetUUID],
                                                                data.check_id,
                                                                data.item_id,
                                                                entity.photoPath,
                                                                [CacheManagement instance].currentDBUser.userName,
                                                                entity.photoComment,
                                                                [Utilities DateTimeNow]];
    }
}

//删除原有数据
- (void)deleteLocalArmsCHKItem:(FMDatabase*)db {
    NSString *sql = [NSString stringWithFormat:@"delete from NVM_IST_STOREAUDIT_CHECK_DETAIL where ITEM_ID='%@' and STOREAUDIT_CHECK_ID = '%@'",self.item_id,[CacheManagement instance].currentVMCHKID];
    [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql];
    
    sql = [NSString stringWithFormat:@"delete from NVM_IST_STOREAUDIT_CHECK_PHOTO where ITEM_ID='%@' and STOREAUDIT_CHECK_ID = '%@'",self.item_id,[CacheManagement instance].currentVMCHKID];
    [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql];
    
    if ([subArray count] > 0) {
        sql = [NSString stringWithFormat:@"delete from NVM_IST_STOREAUDIT_CHECK_DETAIL where instr(ITEM_ID,'_') != 0 and ITEM_ID like '%%%@%%' and STOREAUDIT_CHECK_ID = '%@'",self.item_id,[CacheManagement instance].currentVMCHKID];
        [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql];
    }
}

- (void)checkButton {
    if (self.No == [APPDelegate VM_CHECK_ItemList].count) {
        // 下一页按钮无效
        self.nextBtn.hidden = YES;
    } else if(self.No == 1) {
        // 上一页按钮无效
        self.lastBtn.hidden = YES;
    } else {
        // 都有效
        self.nextBtn.hidden = NO;
        self.lastBtn.hidden = NO;
    }
}


- (IBAction)nextIssue {
  
    [self.pagetextfield resignFirstResponder];
    if (([self.scoreResult isEqualToString:@"N"]||[self.scoreResult isEqualToString:@"NA"]||!self.PicCollectView.hidden)&&self.maxPicCount.intValue > 0) {
        if (self.CurrentmanageResultEntity.picArray.count == 0) {
            ALERTVIEW(SYSLanguage?@"Please take at least one photo":@"请至少拍摄一张照片");
            return;
        }
    }
    
    [self.pagetextfield resignFirstResponder];
    [self saveSingleResult];
    self.No++ ;
    [self checkButton];
    
    self.parentTitle = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"PARENT_ITEM_NAME_CN"];
    self.subTitleNo = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_NO"];
    self.isSpecial = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"DATA_SOURCE"];
    self.item_name = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_NAME_CN"];
    self.item_description = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_DESCRIPTION_CN"];
    self.item_id = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_ID"];
    self.maxPicCount = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"PHOTO_NUM"];
    self.mustComment = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"MUST_COMMENT"];
    self.standardScore = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"STANDARD_SCORE"];
    if (SYSLanguage == EN) {
        self.item_name = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_NAME_EN"];
        self.parentTitle = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"PARENT_ITEM_NAME_EN"];
        self.item_description = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_DESCRIPTION_EN"];
    }
    
    // 根据当前chkid 和 itemid 取数据库中信息
    NSArray* arr = [self getLocalArmsCHKItemByItem_id];
    if ([arr count] > 0) {
        self.CurrentmanageResultEntity = [arr objectAtIndex:0];
    } else {
        [self.CurrentmanageResultEntity cleanScore];
    }
    [self configUI];
}

- (IBAction)lastIssue {
    
    [self.pagetextfield resignFirstResponder];
    if (([self.scoreResult isEqualToString:@"N"]||[self.scoreResult isEqualToString:@"NA"]||!self.PicCollectView.hidden)&&self.maxPicCount.intValue > 0) {
        if (self.CurrentmanageResultEntity.picArray.count == 0) {
            ALERTVIEW(SYSLanguage?@"Please take at least one photo":@"请至少拍摄一张照片");
            return;
        }
    }
    
    [self.pagetextfield resignFirstResponder];
    [self saveSingleResult];
    self.No -- ;
    [self checkButton];
    
    
    // 读取条目检查说明信息
    self.parentTitle = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"PARENT_ITEM_NAME_CN"];
    self.subTitleNo = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_NO"];
    self.isSpecial = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"DATA_SOURCE"];
    self.item_name = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_NAME_CN"];
    self.item_description = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_DESCRIPTION_CN"];
    self.item_id = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_ID"];
    self.maxPicCount = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"PHOTO_NUM"];
    self.mustComment = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"MUST_COMMENT"];
    self.standardScore = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"STANDARD_SCORE"];
    if (SYSLanguage == EN) {
        self.item_name = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_NAME_EN"];
        self.parentTitle = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"PARENT_ITEM_NAME_EN"];
        self.item_description = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_DESCRIPTION_EN"];
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

- (IBAction)score:(id)sender {
    UIButton* button = (UIButton*)sender;
    NSInteger tag = button.tag;
    if (tag == 1){
        [self selectResultWith:@"Y"];
    }
    else if (tag == 0)
    {
        [self selectResultWith:@"N"];
    }
    else if (tag == 2)
    {
        [self selectResultWith:@"NA"];
    }
}


- (void) selectResultWith:(NSString *)result {
    
    if ([result isEqualToString:@"Y"]) {
        if (self.CurrentmanageResultEntity.picArray.count > 0) {
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:SYSLanguage?@"Remind":@"提示" message:SYSLanguage?@"Pictures will be removed": @"将会清空已拍摄的照片，是否继续？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ac1 = [UIAlertAction actionWithTitle:SYSLanguage?@"OK":@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self closePicture];
            }];
            UIAlertAction *ac2 = [UIAlertAction actionWithTitle:SYSLanguage?@"Cancel":@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [ac addAction:ac1];
            [ac addAction:ac2];
            [self presentViewController:ac animated:YES completion:nil];
        } else {
            [self closePicture];
        }
    }
    
    if ([result isEqualToString:@"N"]||[result isEqualToString:@"NA"]) {
        
        if (!self.small_pageview.hidden) {
            if ([result isEqualToString:@"N"]) {
                self.scoreResult = @"N" ;
                [self.Yes_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
                [self.No_btn setBackgroundImage:[UIImage imageNamed:@"form2.png"] forState:UIControlStateNormal];
                [self.NAButton setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
            }
            
            if ([result isEqualToString:@"NA"]) {
                self.scoreResult = @"NA" ;
                [self.Yes_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
                [self.No_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
                [self.NAButton setBackgroundImage:[UIImage imageNamed:@"form2.png"] forState:UIControlStateNormal];
            }
        }
        
        if (self.maxPicCount.intValue > 0) {
            self.PicCollectView.hidden = NO ;
            float topViewHeight = 0 ;
            if (!self.small_pageview.hidden) topViewHeight = self.small_pageview.frame.size.height + self.small_pageview.frame.origin.y;
            if (!self.scoreTableView.hidden) topViewHeight = self.scoreTableView.frame.size.height + self.scoreTableView.frame.origin.y;
            if (!self.scoreCollectView.hidden) topViewHeight = self.scoreCollectView.frame.size.height + self.scoreCollectView.frame.origin.y;
            
            CGRect pframe = self.PicCollectView.frame ;
            pframe.origin.y = topViewHeight + 10;
            pframe.size.height = ([self.maxPicCount intValue]/3 + 1)*(DEVICE_WID/3.0);
            [self.PicCollectView reloadData];
            self.PicCollectView.frame = pframe ;
            
            CGRect frame = self.page_view.frame ;
            frame.size.height = pframe.size.height + pframe.origin.y + 20;
            self.page_view.frame = frame ;
            self.scrollview.contentSize = CGSizeMake(DEWIDTH, frame.size.height + frame.origin.y + 20);
        } else self.PicCollectView.hidden = YES ;
    }
}

- (void) closePicture {
    
    if (!self.small_pageview.hidden) {
        self.scoreResult = @"Y" ;
        [self.Yes_btn setBackgroundImage:[UIImage imageNamed:@"form2.png"] forState:UIControlStateNormal];
        [self.No_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        [self.NAButton setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
    }
    
    if (!self.scoreCollectView.hidden) {
        for (NvmMstStoreAuditItemEntity* checkEntity in subArray) {
            checkEntity.CHECK_RESULT = @"" ;
        }
        NvmMstStoreAuditItemEntity* checkEntity = [subArray objectAtIndex:currentResultCollectIndex];
        checkEntity.CHECK_RESULT = @"Y" ;
        [self.scoreCollectView reloadData];
    }
    
    if (!self.scoreTableView.hidden) {
        NvmMstStoreAuditItemEntity* checkEntity = [subArray objectAtIndex:currentResultTableIndex];
        checkEntity.CHECK_RESULT = @"Y" ;
        [self.scoreTableView reloadData];
    }
    
    for (VMStoreAuditPhotoEntity *entity in self.CurrentmanageResultEntity.picArray) {
        NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[entity.photoPath componentsSeparatedByString:@"/dataCaches"] lastObject]];
        if ([[NSFileManager defaultManager] fileExistsAtPath:newfile]) {
            [[NSFileManager defaultManager]removeItemAtPath:newfile error:nil];
        }
    }
    
    self.CurrentmanageResultEntity.picArray = @[];
    self.PicCollectView.hidden = YES ;
    self.scrollview.contentSize = CGSizeMake(DEWIDTH, 400);
}

- (void)closekeyboard {
    [self.view endEditing:YES];
}

- (void)backandsave {
    [self.pagetextfield resignFirstResponder];
    [self saveSingleResult];
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)){
        self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    }
    CGRect af = self.ImageBGView.frame ;
    af.size.width = DEWIDTH ;
    af.size.height = DEWIDTH/320.0*293.0;
    self.ImageBGView.frame = af ;
    self.CurrentmanageResultEntity = [VMStoreAuditScoreEntity getinstance];
    self.PicCollectView.dataSource = self;
    self.PicCollectView.delegate = self;
    self.scoreCollectView.delegate = self ;
    self.scoreCollectView.dataSource = self ;
    self.scoreTableView.delegate = self ;
    self.scoreTableView.dataSource = self ;
    [self.lastBtn setBackgroundImage:[UIImage imageNamed:SYSLanguage?@"last_en.png": @"last.png"] forState:UIControlStateNormal];
    [self.nextBtn setBackgroundImage:[UIImage imageNamed:SYSLanguage?@"next_en.png":@"next.png"] forState:UIControlStateNormal];
    self.pagetextfield.delegate = self;
    [self UpdateARMS_CheckID];
    [Utilities createLeftBarButton:self clichEvent:@selector(backandsave)];
    [self checkButton];
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
    [self.page_view addSubview:self.NAView];
    NSArray* arr = [self getLocalArmsCHKItemByItem_id];
    
    if ([arr count] > 0) {
        self.CurrentmanageResultEntity = [arr objectAtIndex:0];
    } else {
        [self.CurrentmanageResultEntity cleanScore];
    }
    
    [self configUI];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.leveyTabBarController hidesTabBar:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (IBAction)gotoPage:(id)sender {
    
    [self.pagetextfield resignFirstResponder];
    if (([self.scoreResult isEqualToString:@"N"]||[self.scoreResult isEqualToString:@"NA"]||!self.PicCollectView.hidden)&&self.maxPicCount.intValue > 0) {
        if (self.CurrentmanageResultEntity.picArray.count == 0) {
            ALERTVIEW(SYSLanguage?@"Please take at least one photo":@"请至少拍摄一张照片");
            return;
        }
    }
    
    [self.pagetextfield resignFirstResponder];
    
    NSInteger go_No = [self.pagetextfield.text integerValue];
    if ((go_No <= 0) ||(go_No > [APPDelegate VM_CHECK_ItemList].count))
    {
        self.pagetextfield.text = [NSString stringWithFormat:@"%d",(int)self.No];
        ALERTVIEW(SYSLanguage?@"That does not exist":@"该项不存在");
        return;
    }
    else
    {
        [self saveSingleResult];
        self.No = go_No;
        [self checkButton];
        // 首先检查根据 No找到itemid 和当前check id 去找到该数据是否有 ，若有 则读取本地
        self.parentTitle = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"PARENT_ITEM_NAME_CN"];
        self.subTitleNo = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_NO"];
        self.isSpecial = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"DATA_SOURCE"];
        self.item_name = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_NAME_CN"];
        self.item_description = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_DESCRIPTION_CN"];
        self.item_id = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_ID"];
        self.maxPicCount = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"PHOTO_NUM"];
        self.mustComment = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"MUST_COMMENT"];
        self.standardScore = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"STANDARD_SCORE"];
        if (SYSLanguage == EN) {
            self.parentTitle = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"PARENT_ITEM_NAME_EN"];
            self.item_name = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_NAME_EN"];
            self.item_description = [[[APPDelegate VM_CHECK_ItemList]objectAtIndex:self.No-1] valueForKey:@"ITEM_DESCRIPTION_EN"];
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


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSTimeInterval animationDuration = 0.25f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.view.frame = CGRectMake(0.0f, -228, DEVICE_WID, DEHEIGHT);
    [UIView commitAnimations];
}


//输入框编辑完成以后，将视图恢复到原始状态
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSTimeInterval animationDuration = 0.25f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    self.view.frame =CGRectMake(0, 0, DEVICE_WID, DEHEIGHT);
    [UIView commitAnimations];
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showBigImage:(NSString *)path {

    NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[path componentsSeparatedByString:@"/dataCaches"] lastObject]];
    [self.bigImage setImage:[UIImage imageWithContentsOfFile:newfile]] ;
    [self presentPopupView:self.ImageBGView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return subArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NvmMstStoreAuditItemEntity* checkEntity = [subArray objectAtIndex:indexPath.row];
    float height = [self heightForString:SYSLanguage?checkEntity.ITEM_NAME_EN:checkEntity.ITEM_NAME_CN fontSize:14 andWidth:DEVICE_WID-30] + 5;
    if (height < 20) return 78;
    return 58 + height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell" ;
    ScoreCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nibAry = [[NSBundle mainBundle] loadNibNamed:@"ScoreCustomCell" owner:self options:nil];
        for (UIView *view in nibAry) {
            if ([view isKindOfClass:[ScoreCustomCell class]]) {
                cell = (ScoreCustomCell *)view;
                break;
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.idx = indexPath.row;
    cell.backgroundColor = [UIColor clearColor];
    NvmMstStoreAuditItemEntity* checkEntity = [subArray objectAtIndex:indexPath.row];
    cell.titleNameLabel.text = [NSString stringWithFormat:@"%@. %@",[checkEntity.ITEM_ID componentsSeparatedByString:@"_"].lastObject,SYSLanguage?checkEntity.ITEM_NAME_EN:checkEntity.ITEM_NAME_CN];
    [cell.yesBtn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
    [cell.noBtn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
    [cell.NABtn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
    if ([checkEntity.CHECK_RESULT isEqualToString:@"Y"]) {
        [cell.yesBtn setBackgroundImage:[UIImage imageNamed:@"form2.png"] forState:UIControlStateNormal];
    }
    if ([checkEntity.CHECK_RESULT isEqualToString:@"N"]) {
        [cell.noBtn setBackgroundImage:[UIImage imageNamed:@"form2.png"] forState:UIControlStateNormal];
    }
    if ([checkEntity.CHECK_RESULT isEqualToString:@"NA"]) {
        [cell.NABtn setBackgroundImage:[UIImage imageNamed:@"form2.png"] forState:UIControlStateNormal];
    }
    
    cell.naView.hidden = YES ;
    cell.NALabel.text = @"" ;
    cell.normalView.frame = CGRectMake((DEVICE_WID-10)/2-100, 20, 200, 58);
    if ([self.isSpecial isEqualToString:@"Y"]) {
        cell.NALabel.text = SYSLanguage?@"Product Arrival":@"正在出/入货";
        cell.naView.hidden = NO ;
        cell.normalView.frame = CGRectMake((DEVICE_WID-10)/2-80-80, 20, 160, 58);
        cell.naView.frame = CGRectMake(cell.normalView.frame.size.width + cell.normalView.frame.origin.x, 20, 160, 58);
    }
    return cell;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.scoreCollectView) {
        [collectionView registerClass:[ScoreCollectCustomCell class] forCellWithReuseIdentifier:@"cell"];
        ScoreCollectCustomCell *cell = (ScoreCollectCustomCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        NvmMstStoreAuditItemEntity* checkEntity = [subArray objectAtIndex:indexPath.row];
        cell.titleNameLabel.text = [NSString stringWithFormat:@"%@",SYSLanguage?checkEntity.ITEM_NAME_EN:checkEntity.ITEM_NAME_CN];
        [cell.yesBtn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        if ([checkEntity.CHECK_RESULT isEqualToString:@"Y"]) {
            [cell.yesBtn setBackgroundImage:[UIImage imageNamed:@"form2.png"] forState:UIControlStateNormal];
        }
        return cell ;
    }
    
    [collectionView registerClass:[auditImageItemCustomCell class] forCellWithReuseIdentifier:@"cell"];
    auditImageItemCustomCell *cell = (auditImageItemCustomCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.index = indexPath.row;
    cell.topView.hidden = YES ;
    
    if (indexPath.row == self.CurrentmanageResultEntity.picArray.count) {
        cell.bottomView.hidden = YES ;
        cell.defaultImageView.hidden = NO ;
        cell.menuImageView.hidden = YES ;
    } else {
        cell.delegate = self ;
        cell.defaultImageView.hidden = YES ;
        cell.bottomView.hidden = NO ;
        cell.menuImageView.hidden = NO ;
        VMStoreAuditPhotoEntity *entity = [self.CurrentmanageResultEntity.picArray objectAtIndex:indexPath.row];
        NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[entity.photoPath componentsSeparatedByString:@"/dataCaches"] lastObject]];
        cell.menuImageView.image = [UIImage imageWithContentsOfFile:newfile];
        cell.delegate = self;
        if ([@"Y" isEqualToString:self.mustComment]&&
            ([entity.photoComment isEqual:[NSNull null]]||
             [entity.photoComment isEqualToString:@""]||
             [entity.photoComment.lowercaseString containsString:@"null"])) {
            cell.topView.hidden = NO ;
        }
    }
    
    return cell ;
}

- (void)selectTableWith:(NSUInteger)index withResult:(NSString *)result {
    
    NvmMstStoreAuditItemEntity* checkEntity = [subArray objectAtIndex:index];
    NSMutableArray *temp = [NSMutableArray array];
    [temp addObject:result];
    for (NvmMstStoreAuditItemEntity* entity in subArray) {
        if (![checkEntity.ITEM_ID isEqualToString:entity.ITEM_ID]) {
            NSString *result = [NSString stringWithFormat:@"%@",entity.CHECK_RESULT];
            if ([result isEqualToString:@"N"]||[result isEqualToString:@"Y"]||[result isEqualToString:@"NA"]) {
                [temp addObject:entity.CHECK_RESULT];
            }
        }
    }
    if ([temp containsObject:@"N"]||[temp containsObject:@"NA"]) {
        [self selectResultWith:@"N"];
        checkEntity.CHECK_RESULT = result ;
        [self.scoreTableView reloadData];
    } else {
        currentResultTableIndex = index;
        [self selectResultWith:@"Y"];
    }
}

- (void)deleteImage:(NSUInteger)index {
    
    if (self.CurrentmanageResultEntity.picArray.count > index) {
        
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:SYSLanguage?@"Reminding": @"提示" message:SYSLanguage?@" Do you want to delete this photo?": @"是否删除照片?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ac1 = [UIAlertAction actionWithTitle:SYSLanguage?@"Ok": @"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            VMStoreAuditPhotoEntity *entity = [self.CurrentmanageResultEntity.picArray objectAtIndex:index];
            NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[entity.photoPath componentsSeparatedByString:@"/dataCaches"] lastObject]];
            [[NSFileManager defaultManager]removeItemAtPath:newfile error:nil];
            NSMutableArray *temp = [NSMutableArray arrayWithArray:self.CurrentmanageResultEntity.picArray];
            [temp removeObjectAtIndex:index];
            self.CurrentmanageResultEntity.picArray = [NSArray arrayWithArray:temp];
            [self.PicCollectView reloadData];
        }];

        UIAlertAction *ac2 = [UIAlertAction actionWithTitle:SYSLanguage?@"Cancel": @"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [ac addAction:ac1];[ac addAction:ac2];
        [self presentViewController:ac animated:YES completion:nil];
    }
}

- (void)detailImage:(NSUInteger)index {
    
    if (self.CurrentmanageResultEntity.picArray.count > index) {
        VMStoreAuditPhotoEntity *entity = [self.CurrentmanageResultEntity.picArray objectAtIndex:index];
        NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[entity.photoPath componentsSeparatedByString:@"/dataCaches"] lastObject]];
        [self.bigImage setImage:[UIImage imageWithContentsOfFile:newfile]] ;
        [self presentPopupView:self.ImageBGView];
    }
}

- (void)commentImage:(NSUInteger)index {
    
    if (self.CurrentmanageResultEntity.picArray.count > index) {
        VMStoreAuditPhotoEntity *entity = [self.CurrentmanageResultEntity.picArray objectAtIndex:index];
        SendEmailViewController *pop = [[SendEmailViewController alloc] initWithNibName:@"SendEmailViewController" bundle:nil] ;
        pop.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        pop.delegate = self ;
        pop.commentInfo = entity.photoComment;
        pop.index = index;
        pop.mustType = [NSString stringWithFormat:@"%@",self.mustComment];
        [self presentViewController:pop animated:NO completion:^{}];
    }
}

- (void)updateComment:(NSString *)comment withIndex:(NSUInteger)index {
    
    if (self.CurrentmanageResultEntity.picArray.count > index) {
        VMStoreAuditPhotoEntity *entity = [self.CurrentmanageResultEntity.picArray objectAtIndex:index];
        entity.photoComment = comment ;
        [self.PicCollectView reloadData];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.scoreCollectView) {
        NvmMstStoreAuditItemEntity* checkEntity = [subArray objectAtIndex:indexPath.row];
        float width = [self widthForString:SYSLanguage?checkEntity.ITEM_NAME_EN:checkEntity.ITEM_NAME_CN font:[UIFont boldSystemFontOfSize:15] andHeight:20] + 10;
        return CGSizeMake(42+(width<20?20:width),58) ;
    }
    return CGSizeMake((DEVICE_WID-10-20-15)/3.0,(DEVICE_WID-10-20-15)/3.0) ;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.scoreCollectView) {
        return subArray.count ;
    }
    NSUInteger total = self.CurrentmanageResultEntity.picArray.count;
    return total == self.maxPicCount.intValue ? total : total + 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView == self.scoreCollectView) UIEdgeInsetsMake(0, 0, 0, 0) ;
    return UIEdgeInsetsMake(0, 10, 0, 10) ;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 7.5;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == self.scoreCollectView) {
        
        NvmMstStoreAuditItemEntity* checkEntity = [subArray objectAtIndex:indexPath.row];
        NSString *currentStore = checkEntity.STANDARD_SCORE;
        if (![currentStore isEqualToString:self.standardScore]) {
            [self selectResultWith:@"N"];
            for (NvmMstStoreAuditItemEntity* checkEntity in subArray) {
                checkEntity.CHECK_RESULT = @"" ;
            }
            checkEntity.CHECK_RESULT = @"Y" ;
            [self.scoreCollectView reloadData];
        } else {
            currentResultCollectIndex = indexPath.row;
            [self selectResultWith:@"Y"];
        }
        return ;
    }
    

    if (![self.scoreResult containsString:@"N"]&&!self.small_pageview.hidden)
    {
        UIAlertView* av = [[UIAlertView alloc]initWithTitle:nil message:SYSLanguage?@"you need add pictures if you choose 'N'": @"选择“N”才需要拍照" delegate:self cancelButtonTitle:SYSLanguage?@"OK": @"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    
    currentIndex = indexPath.row;
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    self.photoPicker = [[UIImagePickerController alloc]init];
    self.photoPicker.sourceType = sourceType;
    self.photoPicker.delegate = self;
    self.photoPicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:self.photoPicker animated:YES completion:nil];
}

- (IBAction)closeKeyBoard:(id)sender {
    [self.pagetextfield resignFirstResponder];
}


@end







