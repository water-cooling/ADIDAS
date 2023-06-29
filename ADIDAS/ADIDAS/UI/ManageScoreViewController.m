//
//  ManageScoreViewController.m
//  ADIDAS
//
//  Created by wendy on 14-4-24.
//
//

#import "ManageScoreViewController.h"
#import "UIView+SFAdditions.h"
#import "RailManageSingleIssueData.h"
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


@interface ManageScoreViewController ()<WBGImageEditorDelegate,WBGImageEditorDataSource>
@end

@implementation ManageScoreViewController


@synthesize No;
@synthesize item_name;
@synthesize remark;
@synthesize imageArray;
@synthesize photoPicker;
@synthesize CurrentmanageResultEntity;

@synthesize No_label,Item_textview,Remark_label,comment_textview,photo_1,photo_2;

- (NSString *) decimalwithFormat:(NSString *)format  floatV:(float)floatV
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    
    [numberFormatter setPositiveFormat:format];
    
    return  [numberFormatter stringFromNumber:[NSNumber numberWithFloat:floatV]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)Statistics // 统计结果
{
    NSString* sql  = [NSString stringWithFormat:@"select * from IST_FR_ARMS_CHK_ITEM where FR_ARMS_CHK_ID = '%@'",[CacheManagement instance].currentCHKID];
    FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
    
    double_t score = 0;
    double_t totalNumber = [APPDelegate railmanageIssueList].count;
    int Y = 0;
    int N = 0;
    int NA = 0;
    while ([rs next])
    {
        if ([rs intForColumnIndex:3] == 1)
        {
            score ++;
            Y ++;
        }
        if (([rs intForColumnIndex:3] == 0))
        {
            N ++;
        }
        if (([rs intForColumnIndex:3] == -1))
        {
            totalNumber -- ;
            NA ++;
        }
    }
    [rs close];
   
//    int totalScore =  [[self decimalwithFormat:@"0" floatV:score/totalNumber* 100]integerValue] ;
    int totalScore = score/totalNumber * 100;
    [self.filterview.totalScoreButton setTitle:[NSString stringWithFormat:@"%d",totalScore] forState:UIControlStateNormal];
    if (totalScore < self.TOTAL_num)
    {
        [self.filterview.totalScoreButton setBackgroundImage:[UIImage imageNamed:@"red.png"] forState:UIControlStateNormal];
    }
    else if (totalScore > self.TOTAL_num)
    {
        [self.filterview.totalScoreButton setBackgroundImage:[UIImage imageNamed:@"green.png"] forState:UIControlStateNormal];
    }
    else if (totalScore == self.TOTAL_num)
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
    
    self.frame = self.secondpageview.frame;
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
    [self.No_label setTitle:[NSString stringWithFormat:@"%d",No] forState:UIControlStateNormal];
    self.pagetextfield.text = [NSString stringWithFormat:@"%d",No];
    self.Item_textview.text = item_name;
    
//    NSInteger height = self.Item_textview.height;
    
    NSInteger height =  [self heightForString:self.Item_textview.text fontSize:12 andWidth:DEWIDTH-30];
    self.Item_textview.frame = CGRectMake(30, 3, DEWIDTH-30, height+ 10);
    
    self.Remark_label.frame = CGRectMake(8, height + 20, DEWIDTH-16, 400);
    self.Remark_label.text = self.remark;
    self.Remark_label.numberOfLines = 0;
    [self.Remark_label sizeToFit];
    
    height = self.Item_textview.height + self.Remark_label.height+10;
    self.small_pageview.frame = CGRectMake(0, height + 13 , DEWIDTH, 390);
    self.comment_textview.text = self.CurrentmanageResultEntity.comment;
    self.scrollview.contentSize = CGSizeMake(200, height+430);
    
    self.picpath_1 = self.CurrentmanageResultEntity.picpath1;
    self.picpath_2 = self.CurrentmanageResultEntity.picpath2;
    if ([self.picpath_1 length]> 0) {
        
        NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[self.picpath_1 componentsSeparatedByString:@"/dataCaches"] lastObject]];
        self.photo_1.image = [UIImage imageWithContentsOfFile:newfile];
    }
    else
    {
        self.photo_1.image = [UIImage imageNamed:SYSLanguage?@"takepic_en.png": @"takepic.png"];
    }
    if ([self.picpath_2 length] > 0)
    {
        NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[self.picpath_2 componentsSeparatedByString:@"/dataCaches"] lastObject]];
        self.photo_2.image = [UIImage imageWithContentsOfFile:newfile];
    }
    else
    {
        self.photo_2.image = [UIImage imageNamed:SYSLanguage?@"takepic_en.png":@"takepic.png"];
    }
    self.scoreResult = self.CurrentmanageResultEntity.score;
    self.reason = self.CurrentmanageResultEntity.reason;
    self.secondpageview.frame = CGRectMake(0, 47, DEWIDTH, 286);
    
    if (self.scoreResult == 1)
    {
        self.reasonBtn.hidden = YES;
        [self.Yes_btn setBackgroundImage:[UIImage imageNamed:@"form2.png"] forState:UIControlStateNormal];
        [self.No_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        [self.NA_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
    }
    else if(self.scoreResult == 0)
    {
        self.reasonBtn.hidden = YES;
        [self.Yes_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        [self.No_btn setBackgroundImage:[UIImage imageNamed:@"form2.png"] forState:UIControlStateNormal];
        [self.NA_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
    }
    else if(self.scoreResult == -1)
    {
        self.reasonBtn.hidden = NO;
        self.reason = self.CurrentmanageResultEntity.reason;
        [self.reasonBtn setTitle:self.reason forState:UIControlStateNormal];
        self.secondpageview.frame = CGRectMake(0, 90, DEWIDTH, 316);
        [self.Yes_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        [self.No_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        [self.NA_btn setBackgroundImage:[UIImage imageNamed:@"form2.png"] forState:UIControlStateNormal];
    }
    else if (self.scoreResult == 3)
    {
        self.reasonBtn.hidden = YES;
        [self.Yes_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        [self.No_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        [self.NA_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
    }
    [self Statistics];
    if ([self.comment_textview.text length] > 0)
    {
        self.placeHolderLabel.hidden = YES;
    }
    else {
        self.placeHolderLabel.hidden = NO ;
    }
}

- (float) heightForString:(NSString *)value fontSize:(float)fontSize andWidth:(float)width
{
    CGSize sizeToFit = [value sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];//此处的换行类型（lineBreakMode）可根据自己的实际情况进行设置
    return sizeToFit.height;
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
    if (actionSheet.title == nil)
    {
        if (buttonIndex == 0)
        {
            if (self.view.tag == 111)
            {
                [[NSFileManager defaultManager]removeItemAtPath:self.picpath_1 error:nil];
                self.picpath_1 = nil;
                self.photo_1.image = [UIImage imageNamed:SYSLanguage?@"takepic_en.png":@"takepic.png"];
            }
            else
            {
                [[NSFileManager defaultManager]removeItemAtPath:self.picpath_2 error:nil];
                self.picpath_2 = nil;
                self.photo_2.image = [UIImage imageNamed:SYSLanguage?@"takepic_en.png":@"takepic.png"];
            }
        }
    }
    else if ([actionSheet.title isEqualToString:SYSLanguage?@"Choose reason":@"选择原因"])
    {
        self.reason = [self.reasonsArr objectAtIndex:buttonIndex];
        [self.reasonBtn setTitle:self.reason forState:UIControlStateNormal];
    }
    if ([self.reason isEqualToString:SYSLanguage?@"other reason":@"其他原因"])
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
    if (self.scoreResult == 3)
    {
        UIAlertView* av = [[UIAlertView alloc]initWithTitle:nil message:SYSLanguage?@"Can not scoring can not take pictures": @"未打分不能拍照" delegate:self cancelButtonTitle:SYSLanguage?@"OK": @"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    TapLongPressImageView* touchPhoto = (TapLongPressImageView*)sender;
    self.view.tag = touchPhoto.tag;

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


#pragma mark - photo

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    WBGImageEditor *editor = [[WBGImageEditor alloc] initWithImage:image delegate:self dataSource:self] ;
    editor.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:editor animated:YES completion:nil];
    
    self.iscamera = NO;
    [self.leveyTabBarController hidesTabBar:YES  animated:NO];
}

#pragma mark - WBGImageEditorDelegate
- (void)imageEditor:(WBGImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image {
    
    [editor.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    if (self.view.tag == 111)
    {
        photo_1.image = [image scaleToSize:CGSizeMake(100, 100)];
        if (self.picpath_1 == nil)
        {
            self.picpath_1 = [NSString stringWithFormat:kVM_Score_PicturePathString,[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,@"RAIL_CHECK",[Utilities GetUUID]];
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
        photo_2.image = [image scaleToSize:CGSizeMake(100, 100)];
        if (self.picpath_2 == nil)
        {
            self.picpath_2 = [NSString stringWithFormat:kVM_Score_PicturePathString,[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,@"RAIL_CHECK",[Utilities GetUUID]];
            NSFileManager* fileMannager = [NSFileManager defaultManager];
            if(![fileMannager fileExistsAtPath:self.picpath_2])
            {
                [fileMannager createDirectoryAtPath:self.picpath_2 withIntermediateDirectories:YES attributes:nil error:nil];
            }
            
        }
        [Utilities saveImage:image imgPath:self.picpath_2];
    }
    
    self.iscamera = NO;
    [self.leveyTabBarController hidesTabBar:YES  animated:NO];
}

- (void)imageEditorDidCancel:(WBGImageEditor *)editor {
    
}

- (NSArray<WBGMoreKeyboardItem *> *)imageItemsEditor:(WBGImageEditor *)editor {
    return @[];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    self.iscamera = NO;
    [self.leveyTabBarController hidesTabBar:YES  animated:NO] ;
    [picker dismissViewControllerAnimated:YES completion:nil];

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
    self.CurrentmanageResultEntity.score = self.scoreResult;
    self.CurrentmanageResultEntity.reason = self.reason;
    self.CurrentmanageResultEntity.picpath1 = self.picpath_1;
    self.CurrentmanageResultEntity.picpath2 = self.picpath_2;
    self.CurrentmanageResultEntity.item_id = self.item_id;
    
    self.CurrentmanageResultEntity.comment = [self.comment_textview.text getReplaceString] ;
    self.CurrentmanageResultEntity.check_id = [CacheManagement instance].currentCHKID;
    self.CurrentmanageResultEntity.check_item_id = [Utilities GetUUID];

    FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
    [db beginTransaction];
    // 删除原有数据
    BOOL result = YES;
    
    @try
    {
        [self deleteLocalArmsCHKItem:db];
        
        [self insertLocalArmsCHKItem:self.CurrentmanageResultEntity broker:db];
        
        [self Statistics];
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
            self.scoreResult = 3;
            self.reason = nil;
            [self.reasonBtn setTitle:SYSLanguage?@"Please choose reason": @"请选择原因" forState:UIControlStateNormal];
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
    NSString* sql = [NSString stringWithFormat:@"select * from IST_FR_ARMS_CHK where WORK_MAIN_ID ='%@' and STORE_CODE= '%@'",workmainID,storecode];
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
        [CacheManagement instance].currentCHKID = [arr objectAtIndex:0];
    }
    else
    {
        NSString* FR_ARMS_CHK_ID =[Utilities GetUUID];  [CacheManagement instance].currentCHKID = FR_ARMS_CHK_ID;
        NSString* storeCode = [CacheManagement instance].currentStore.StoreCode;
        NSString* workdate = [Utilities DateNow];
        NSString* workstarttime = [Utilities DateTimeNow];
        NSString* workendtime = [Utilities DateTimeNow];
        NSString* userid = [CacheManagement instance].currentUser.UserId;
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO IST_FR_ARMS_CHK (FR_ARMS_CHK_ID,STORE_CODE,WORK_MAIN_ID,WORK_DATE,WORK_START_TIME,WORK_END_TIME,TOTAL_SCORE,USER_SUBMIT_TIME,CLIENT_UPLOAD_TIME,SERVER_INSERT_TIME,USER_ID) values (?,?,?,?,?,?,?,?,?,?,?)"];
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         FR_ARMS_CHK_ID,
         storeCode,
         [CacheManagement instance].currentWorkMainID,
         workdate,
         workstarttime,
         workendtime,
         @"0",
         workendtime, //  提交时间
         nil,
         nil,
         userid];
    }
}


//获取本地评分记录
- (NSMutableArray *) getLocalArmsCHKItemByItem_id
{
	NSString *sql = [NSString stringWithFormat:@"Select * FROM IST_FR_ARMS_CHK_ITEM where FR_ARMS_ITEM_ID = '%@' and FR_ARMS_CHK_ID = '%@'",self.item_id,[CacheManagement instance].currentCHKID];
	__autoreleasing NSMutableArray *result = [[NSMutableArray alloc] init];
	
	FMResultSet *rs = nil;
	@try
    {
        rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
		while ([rs next])
        {
            ManageScoreEntity* data = [[ManageScoreEntity alloc]init];
            data.check_item_id = [rs stringForColumnIndex:0];
            data.check_id = [rs stringForColumnIndex:1];
            data.item_id = [rs stringForColumnIndex:2];
            data.score = [rs intForColumnIndex:3];
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
-(void) insertLocalArmsCHKItem:(ManageScoreEntity*)data broker:(FMDatabase*)db
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO IST_FR_ARMS_CHK_ITEM (FR_ARMS_CHK_ITEM_ID,FR_ARMS_CHK_ID,FR_ARMS_ITEM_ID,SCORE,REASON,COMMENT,PHOTO_PATH1,PHOTO_PATH2) values (?,?,?,?,?,?,?,?)"];
//    FMDatabase *db = [[SqliteHelper shareCommonSqliteHelper] database];
    [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql,
                                                            data.check_item_id,
                                                            data.check_id,
                                                            data.item_id,
                                                            [NSNumber numberWithInteger:data.score ],
                                                            data.reason,
                                                            data.comment,
                                                            data.picpath1,
                                                            data.picpath2];
}

//删除原有数据
-(void)deleteLocalArmsCHKItem:(FMDatabase*)db
{
    NSString *sql = [NSString stringWithFormat:@"delete from IST_FR_ARMS_CHK_ITEM where FR_ARMS_ITEM_ID='%@' and FR_ARMS_CHK_ID = '%@'",self.item_id,[CacheManagement instance].currentCHKID];
    [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql];
}

-(void)checkButton
{
    if (self.No == [APPDelegate railmanageIssueList].count)
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
    // 配置页面检查问答数据
    if (self.scoreResult == 0 || [self.reason isEqualToString:SYSLanguage?@"other reason":@"其他原因"]){
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
    
    if (self.scoreResult == -1)
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
    
    No ++ ;
    [self checkButton];
    
    // 读取下题内容
    self.remark = [[[APPDelegate railmanageIssueList]objectAtIndex:No-1] valueForKey:SYSLanguage?@"remark_en": @"remark_cn"];
    self.scoreOption = [[[APPDelegate railmanageIssueList]objectAtIndex:No-1] valueForKey:@"score_option"];
    self.item_name = [[[APPDelegate railmanageIssueList]objectAtIndex:No-1] valueForKey:SYSLanguage?@"item_name_en":@"item_name_cn"];
    self.reasonsArr = [[[[APPDelegate railmanageIssueList]objectAtIndex:No-1]valueForKey:SYSLanguage?@"reason_en": @"reason_cn"]componentsSeparatedByString:@"|"];
    self.item_id = [[[APPDelegate railmanageIssueList]objectAtIndex:No-1] valueForKey:@"item_id"];
    
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
    if (self.scoreResult == 0 || [self.reason isEqualToString:SYSLanguage?@"other reason": @"其他原因"]){
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
    if (self.scoreResult == -1)
    {
        if (self.reason == nil)
        {
            ALERTVIEW(SYSLanguage?@"Please choose reason": @"请选择原因");
            return;
        }
    }

    self.reasonBtn.hidden = YES;
    // 保存当前条目结果进数据库 评分如果未填 默认写入3
    [self saveSingleResult];
    
    No -- ;
    [self checkButton];

    
    // 读取条目检查说明信息
    self.remark = [[[APPDelegate railmanageIssueList]objectAtIndex:No-1] valueForKey:SYSLanguage?@"remark_en": @"remark_cn"];
    self.scoreOption = [[[APPDelegate railmanageIssueList]objectAtIndex:No-1] valueForKey: @"score_option"];
    self.item_name = [[[APPDelegate railmanageIssueList]objectAtIndex:No-1] valueForKey:SYSLanguage?@"item_name_en": @"item_name_cn"];
    self.reasonsArr = [[[[APPDelegate railmanageIssueList]objectAtIndex:No-1]valueForKey:SYSLanguage?@"reason_en": @"reason_cn"]componentsSeparatedByString:@"|"];
    self.item_id = [[[APPDelegate railmanageIssueList]objectAtIndex:No-1] valueForKey:@"item_id"];
    
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
        self.secondpageview.frame = CGRectMake(0, 47, DEWIDTH, 286);
        self.scoreResult = 1;
        [self.Yes_btn setBackgroundImage:[UIImage imageNamed:@"form2.png"] forState:UIControlStateNormal];
        [self.No_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        [self.NA_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        [self.comment_textview resignFirstResponder];
    }
    else if (tag == 2)
    {
        self.reasonBtn.hidden = NO;
        [self selectreason];
        self.scoreResult = -1;
        self.secondpageview.frame = CGRectMake(0, 90 ,DEWIDTH,316);
        [self.Yes_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        [self.No_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        [self.NA_btn setBackgroundImage:[UIImage imageNamed:@"form2.png"] forState:UIControlStateNormal];
    }
    else if (tag == 0)
    {
        self.reasonBtn.hidden = YES;
        self.reason = nil;
        self.secondpageview.frame = CGRectMake(0, 47, DEWIDTH, 286);
        self.scoreResult = 0;
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
    if (self.scoreResult == 0 || [self.reason isEqualToString:SYSLanguage?@"other reason": @"其他原因"])
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
    else if (self.scoreResult == -1)
    {
        if (self.reason == nil)
        {
            ALERTVIEW(SYSLanguage?@"Please choose reason": @"请选择原因");
            return;
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
    self.placeHolderLabel.text = SYSLanguage?@"Please input remark":@"请输入说明";
    [self.lastBtn setBackgroundImage:[UIImage imageNamed:SYSLanguage?@"last_en.png": @"last.png"] forState:UIControlStateNormal];
    [self.nextBtn setBackgroundImage:[UIImage imageNamed:SYSLanguage?@"next_en.png":@"next.png"] forState:UIControlStateNormal];
    self.filterview = [[FilterView alloc]initWithFrame:CGRectMake(0, 64, DEWIDTH, 40)];
    self.filterview.userInteractionEnabled = YES;
    //    self.filterview.frame = CGRectMake(0, 0, 320, 40);
    self.filterview.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.filterview];
    CGRect af = self.BGPicView.frame ;
    af.size.width = DEWIDTH ;
    af.size.height = DEWIDTH/320.0*293.0;
    self.BGPicView.frame = af ;
   
    self.pagetextfield.delegate = self;
    self.photo_1.delegate = self;
    self.photo_2.delegate = self;
    [self UpdateARMS_CheckID];
    [Utilities createLeftBarButton:self clichEvent:@selector(backandsave)];
    
//    self.scrollview.canCancelContentTouches = NO;
//    self.scrollview.delaysContentTouches = NO;
//    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closekeyboard)];
//    tap.cancelsTouchesInView = NO;
//    [self.view addGestureRecognizer:tap];
    [self checkButton];
    [self.reasonBtn setTitle:SYSLanguage?@"Please Choose Reason":@"请选择原因" forState:UIControlStateNormal] ;
    self.CurrentmanageResultEntity = [ManageScoreEntity getinstance];
    UILabel* label =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44) ];
    label.text = SYSLanguage?@"aRMS": @"零售标准管理检查";
//    [Utilities createLeftBarButton:self  clichEvent:@selector(back)];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:18];
    label.textAlignment = NSTextAlignmentCenter;
    [self.navigationItem setTitleView:label];
    
    
    UIImageView* locationview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, DEWIDTH, 40)];
    locationview.tag = 200;
    locationview.image = [UIImage imageNamed:@"locationBarbg.png"];
    UILabel* locationlabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, DEWIDTH-30, 40)];
    locationlabel.backgroundColor =[UIColor clearColor];
    locationlabel.font = [UIFont systemFontOfSize:14];
    locationlabel.tag = 111;
    locationlabel.text = [CacheManagement instance].currentStore.StoreName;
    [locationview addSubview:locationlabel];
    [self.view addSubview:locationview];

    [self.page_view setBackgroundColor:[UIColor clearColor]];
    [self.page_view addSubview:self.small_pageview];
    [self.page_view addSubview:self.Remark_label];
   
    [self.view bringSubviewToFront:self.filterview];

    self.totalIssueCount = [APPDelegate railmanageIssueList].count;
    
    // 在初次加载会取对应id的信息
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
        self.placeHolderLabel.hidden = YES;
    }
    self.resultArray = [[NSMutableArray alloc]init];
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
    
    if (self.scoreResult == 0 || [self.reason isEqualToString:@"其他原因"])
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
    
    
    if (self.scoreResult == -1)
    {
        if (self.reason == nil)
        {
            ALERTVIEW(SYSLanguage?@"Please choose reason": @"请选择原因");
            return;
        }
    }
    // 进入下条之前保存当前结果入数据库
    self.reasonBtn.hidden = YES;
    [self saveSingleResult];
    
    NSInteger go_No = [self.pagetextfield.text integerValue];
    if ((go_No <= 0) ||(go_No > [APPDelegate railmanageIssueList].count))
    {
        ALERTVIEW(@"该项不存在.");
        return;
    }
    else
    {
        No = go_No;
        // 首先检查根据 No找到itemid 和当前check id 去找到该数据是否有 ，若有 则读取本地
        self.remark = [[[APPDelegate railmanageIssueList]objectAtIndex:No-1] valueForKey:SYSLanguage?@"remark_en": @"remark_cn"];
        self.scoreOption = [[[APPDelegate railmanageIssueList]objectAtIndex:No-1] valueForKey:@"score_option"];
        self.item_name = [[[APPDelegate railmanageIssueList]objectAtIndex:No-1] valueForKey:SYSLanguage?@"item_name_en": @"item_name_cn"];
        self.reasonsArr = [[[[APPDelegate railmanageIssueList]objectAtIndex:No-1]valueForKey:SYSLanguage?@"reason_en": @"reason_cn"]componentsSeparatedByString:@"|"];
        self.item_id = [[[APPDelegate railmanageIssueList]objectAtIndex:No-1] valueForKey:@"item_id"];
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

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.placeHolderLabel.hidden = NO;
    }else{
        self.placeHolderLabel.hidden = YES;
    }
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
    if (picpath_1.length > 0) self.leftButton.hidden = NO ;
    else self.leftButton.hidden = YES ;
}

- (void)setPicpath_2:(NSString *)picpath_2 {
    
    _picpath_2 = picpath_2 ;
    if (picpath_2.length > 0) self.rightButton.hidden = NO ;
    else self.rightButton.hidden = YES ;
}

- (IBAction)leftPicAction:(id)sender {
    
    if ([self.picpath_1 length]> 0) {
        
        NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[self.picpath_1 componentsSeparatedByString:@"/dataCaches"] lastObject]];
        [self.picBGView setImage:[UIImage imageWithContentsOfFile:newfile]] ;
        [self presentPopupView:self.BGPicView];
    }
}

- (IBAction)rightPicAction:(id)sender {
    
    if ([self.picpath_2 length]> 0) {
        
        NSString *newfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[self.picpath_2 componentsSeparatedByString:@"/dataCaches"] lastObject]];
        [self.picBGView setImage:[UIImage imageWithContentsOfFile:newfile]] ;
        [self presentPopupView:self.BGPicView];
    }
}


@end
