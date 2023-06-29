//
//  UploadFileViewController.m
//  VM
//
//  Created by leo.you on 14-8-7.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import "UploadFileViewController.h"
#import "UploadTableViewCell.h"
#import "SqliteHelper.h"
#import "FMResultSet.h"
#import "Utilities.h"
#import "CommonDefine.h"
#import "AppDelegate.h"
#import "ASIFormDataRequest.h"
#import "CacheManagement.h"
#import "NSString+SBJSON.h"
#import "CheckScoreEntity.h"
#import "UserInfoManagement.h"
#import "UserInfoEntity.h"
#import "GTMBase64.h"
#import "VisitStoreEntity.h"
#import "SSZipArchive.h"
#import "CommonUtil.h"

@interface UploadFileViewController ()

@property (strong,nonatomic) UserInfoEntity* userinfoEntity;
@property (strong,nonatomic) UserInfoManagement* usermanagement;

@end

static const CGSize progressViewSize = { 200.0f, 30.0f };
#define DEFAULT_BLUE [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]


@implementation UploadFileViewController

- (dispatch_queue_t)serialQueue
{
    if (!_serialQueue) {
        _serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);//创建串行队列
    }
    return _serialQueue;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)getUploadFileList
{
    self.allFileNum = 0;
    [self.uploadFileArr removeAllObjects];
    NSString* sql = [NSString stringWithFormat:@"SELECT * FROM NVM_FILE_LIST where USER_ID = '%@'",[CacheManagement instance].currentUser.UserId];
    FMDatabase* db = [[SqliteHelper shareCommonSqliteHelper]database];
    FMResultSet* rs = [db executeQuery:sql];
    while ([rs next])
    {
        UploadFileEntity* entity = [[UploadFileEntity alloc]initWithFMResultSet:rs];
        [self.uploadFileArr addObject:entity];
        if ([entity.CHECK_XML_PATH length]>0) {
            self.allFileNum ++;
        }
        if ([entity.ISSUE_XML_PATH length]>0) {
            self.allFileNum ++;
        }
        if ([entity.PHOTO_XML_PATH length]>0) {
            self.allFileNum ++;
        }
        if ([entity.SIGN_PATH length]>0) {
            self.allFileNum ++;
        }
        if ([entity.ARSMSIGN_PATH length] > 0) {
            self.allFileNum ++;
        }
        if ([entity.RAILCHECK_XML_PATH length] > 0) {
            self.allFileNum ++;
        }
        if ([entity.INSTALL_XML_PATH length] > 0) {
            self.allFileNum ++;
        }
        
        if ([entity.SCORECARD_XML_PATH length] > 0) {
            self.allFileNum ++;
        }
        
        if ([entity.SCORECARDDAILY_XML_PATH length] > 0) {
            self.allFileNum ++;
        }
        
        if ([entity.RO_ISSUE_XML_PATH length] > 0) {
            self.allFileNum ++;
        }
        
        if ([entity.HEADCOUNT_XML_PATH length] > 0) {
            self.allFileNum ++ ;
        }
        
        if ([entity.TRINING_XML_PATH length] > 0) {
            self.allFileNum ++;
        }
        
        if ([entity.AUDIT_XML_PATH length] > 0) {
            self.allFileNum ++;
        }
        
        if ([entity.ONSITE_XML_PATH length] > 0) {
            self.allFileNum ++;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.bottomProgressView setProgress:0 animated:YES];

    self.title = SYSLanguage?@"Data to be uploaded": @"待上传列表";
    self.uploadFileArr = [NSMutableArray new];

    [self getUploadFileList];
    if(SYSLanguage == CN)
        [Utilities createRightBarButton:self clichEvent:@selector(uploadAll) btnSize:CGSizeMake(50, 30) btnTitle:@"上传"];
    else if (SYSLanguage == EN)
        [Utilities createRightBarButton:self clichEvent:@selector(uploadAll) btnSize:CGSizeMake(50, 30) btnTitle:@"Submit"];
    
    [Utilities createLeftBarButton:self clichEvent:@selector(back)];
    self.UploadFileTableview.tableFooterView = [[UIView alloc] init];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)uploadAll
{
    __block BOOL result;
    if ([self.uploadFileArr count] == 0)
    {
        
        if (SYSLanguage == CN) {
            [HUD showUIBlockingIndicatorWithText:@"无文件上传" withTimeout:2];
        }
        else if (SYSLanguage == EN)
        {
            [HUD showUIBlockingIndicatorWithText:@"No file to be uploaded" withTimeout:2];
        }
        return;
    }

    [HUD showUIBlockingIndicatorWithText:SYSLanguage?@"submitting...":@"上传中"];

    dispatch_async(dispatch_get_global_queue(0, 0),^{
        for (UploadFileEntity* entity in self.uploadFileArr)
        {
            result =  [self uploadSingle:entity];
            if (result == NO)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HUD hideUIBlockingIndicator];
                    [HUD showUIBlockingIndicatorWithText:SYSLanguage?@"Submit failed":@"上传失败" withTimeout:2];
                    return ;
                });
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
        
            if(result)
            {
                [self getUploadFileList];
                [self.UploadFileTableview reloadData];
                [HUD showUIBlockingSuccessIndicatorWithText:SYSLanguage?@"Submit successfully":@"上传成功" withTimeout:2];
                [self.bottomProgressView setProgress:0];
            }
        });
    });
}

-(BOOL)uploadSingle:(UploadFileEntity*)entity
{
    NSString* Sign_path = entity.SIGN_PATH;
    NSString* ARSMSign_path = entity.ARSMSIGN_PATH;
    
    NSString* Issue_xmlPath = entity.ISSUE_XML_PATH;
    NSString* Issue_picPath = entity.ISSUE_PIC_PATH;

    NSString* Photo_xmlPath = entity.PHOTO_XML_PATH;
   
    
    NSString* Check_xmlPath = entity.CHECK_XML_PATH;
    NSString* Check_picPath = entity.CHECK_PIC_PATH;
    
    
    NSString* ScoreCard_xmlPath = entity.SCORECARD_XML_PATH;
    NSString* ScoreCard_picPath = entity.SCORECARD_PIC_PATH;
    
    
    NSString* ScoreCardDaily_xmlPath = entity.SCORECARDDAILY_XML_PATH;
    NSString* ScoreCardDaily_picPath = entity.SCORECARDDAILY_PIC_PATH;
    
    
    NSString* RailCheck_xmlPath = entity.RAILCHECK_XML_PATH;
   
    
    NSString* Install_picPath = entity.INSTALL_PIC_PATH;
    NSString* Install_xmlPath = entity.INSTALL_XML_PATH;
    
    
    NSString* Ro_Issue_xmlPath = entity.RO_ISSUE_XML_PATH;
    NSString* Ro_Issue_picPath = entity.RO_ISSUE_PIC_PATH;
    

    NSString* HEADCOUNT_XML_PATH = entity.HEADCOUNT_XML_PATH ;
    
    
    NSString* Training_xmlPath = entity.TRINING_XML_PATH;
    NSString* Training_picPath = entity.TRINING_PIC_PATH;
    
    NSString* Audit_xmlPath = entity.AUDIT_XML_PATH;
    NSString* Audit_picPath = entity.AUDIT_PIC_PATH;
    
    NSString* Onsite_xmlPath = entity.ONSITE_XML_PATH;
    NSString* Onsite_picPath = entity.ONSITE_PIC_PATH;
    
    NSString* Issuetracking_xmlPath = entity.ISSUE_TRACKING_XML_PATH;
    
    NSData* installdata = [[NSData alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[Install_xmlPath componentsSeparatedByString:@"/dataCaches"] lastObject]]];
    NSString* installXmlstr = [[NSString alloc]initWithData:installdata encoding:NSUTF8StringEncoding];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSString *newInstallPic = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[Install_picPath componentsSeparatedByString:@"/dataCaches"] lastObject]] ;
    NSMutableArray* installArrTemp = (NSMutableArray*)[fileManager contentsOfDirectoryAtPath:newInstallPic error:nil];
    NSArray* installArr = [NSArray new];
    NSMutableArray *sortArray = [NSMutableArray array];
    for (NSString* obj in installArrTemp)
    {
        NSString *fileType = [[obj componentsSeparatedByString:@"."] lastObject];
        if ([obj length] < 5||![fileType isEqualToString:@"jpg"])
        {
        }
        else
        {
            NSString* picpath = [NSString stringWithFormat:@"%@/%@",newInstallPic,obj];
            NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:picpath error:nil];
            unsigned long long fileSize = [attributes fileSize];
            if (fileSize < 10) {
                [[NSFileManager defaultManager] removeItemAtPath:picpath error:nil];
            } else {
                [sortArray addObject:picpath];
            }
        }
    }
    installArr = [sortArray sortedArrayUsingSelector:@selector(compare:)];
    
    NSData* issuedata = [[NSData alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[Issue_xmlPath componentsSeparatedByString:@"/dataCaches"] lastObject]]];
    NSString* issueXmlstr = [[NSString alloc]initWithData:issuedata encoding:NSUTF8StringEncoding];
    NSMutableArray* issueArrTemp = (NSMutableArray*)[fileManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[Issue_picPath componentsSeparatedByString:@"/dataCaches"] lastObject]] error:nil];
    NSMutableArray* issueArr = [NSMutableArray new];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"floatValue" ascending:YES];
    NSArray *descriptors = [NSArray arrayWithObject:descriptor];
    NSArray* issue_sortArray = [issueArrTemp sortedArrayUsingDescriptors:descriptors];

    for (NSString* obj in issue_sortArray)
    {
        NSString *fileType = [[obj componentsSeparatedByString:@"."] lastObject];
        if ([obj length] < 3 ||![fileType isEqualToString:@"jpg"])
        {
        }
        else
        {
            NSString* picpath = [NSString stringWithFormat:@"%@/%@",[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[Issue_picPath componentsSeparatedByString:@"/dataCaches"] lastObject]],obj];
            NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:picpath error:nil];
            unsigned long long fileSize = [attributes fileSize];
            if (fileSize < 10) {
                [[NSFileManager defaultManager] removeItemAtPath:picpath error:nil];
            }
            else
            {
                [issueArr addObject:picpath];
            }
        }
    }
    
    NSData* photodata = [[NSData alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[Photo_xmlPath componentsSeparatedByString:@"/dataCaches"] lastObject]]];
    NSString* photoXmlstr = [[NSString alloc]initWithData:photodata encoding:NSUTF8StringEncoding];
    
    NSMutableArray *resultPicArr = [NSMutableArray array] ;
    
    if (![photoXmlstr isEqualToString:@""]) {
        
        NSArray *InfoArray = [photoXmlstr componentsSeparatedByString:@"<WORKMAINID>"];
        
        if ([InfoArray count] > 1) {
            
            NSString *workmain = [[[InfoArray objectAtIndex:1] componentsSeparatedByString:@"</WORKMAINID>"] firstObject];
            
            NSString* sql_select  = [NSString stringWithFormat:@"\
                                     Select a.* From                       NVM_IST_STORE_PHOTO_LIST  a \
                                     inner join nvm_ist_store_take_photo b on a.TAKE_ID=b.TAKE_ID \
                                     where b.WORK_MAIN_ID='%@' \
                                     order by a.order_no",workmain];
            
            FMResultSet* rs_Select = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql_select];
            while ([rs_Select next])
            {
                VisitStoreEntity* Entity = [[VisitStoreEntity alloc]initWithFMResultSet:rs_Select];
                
                if ((Entity.INITIAL_PHOTO_PATH != nil) && ([Entity.INITIAL_PHOTO_PATH length]>2))
                {
                    [resultPicArr addObject:Entity.INITIAL_PHOTO_PATH];
                }
                if ((Entity.COMPRESS_PHOTO_PATH != nil)&&([Entity.COMPRESS_PHOTO_PATH length]>2))
                {
                    [resultPicArr addObject:Entity.COMPRESS_PHOTO_PATH];
                }
            }
            [rs_Select close];
        }
    }
    
    NSData* rail_checkdata = [[NSData alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[RailCheck_xmlPath componentsSeparatedByString:@"/dataCaches"] lastObject]]];
    self.RailCheck_XML = [[NSString alloc]initWithData:rail_checkdata encoding:NSUTF8StringEncoding];
    NSMutableArray* rail_checkListArray = [NSMutableArray new];
    
    if (![self.RailCheck_XML isEqualToString:@""]) {
        
        NSString *checkItemT = @"" ;
        NSArray *checkInfoArray = [self.RailCheck_XML componentsSeparatedByString:@"<FrArmsChkId>"];
        
        if ([checkInfoArray count] > 1) {
            
            checkItemT = [[[checkInfoArray objectAtIndex:1] componentsSeparatedByString:@"</FrArmsChkId>"] firstObject];
        }
        
        NSString* sql  = [NSString stringWithFormat:@"select * from IST_FR_ARMS_CHK_ITEM where FR_ARMS_CHK_ID = '%@' ORDER BY ITEM_NO",checkItemT];
        FMResultSet* rs_ = [[SqliteHelper shareCommonSqliteHelper]selectResult:sql];
        while ([rs_ next])
        {
            CheckScoreEntity* checkScoreEntity = [[CheckScoreEntity alloc]initWithFMResultSet:rs_];
            if (checkScoreEntity.photo_path1 != nil)
            {
                [rail_checkListArray addObject:checkScoreEntity.photo_path1];
            }
            if (checkScoreEntity.photo_path2 != nil)
            {
                [rail_checkListArray addObject:checkScoreEntity.photo_path2];
            }
        }
        [rs_ close];
    }

    
    NSData* checkdata = [[NSData alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[Check_xmlPath componentsSeparatedByString:@"/dataCaches"] lastObject]]];
    NSString* checkXmlstr = [[NSString alloc]initWithData:checkdata encoding:NSUTF8StringEncoding];
    NSMutableArray* checkArrTemp = (NSMutableArray*)[fileManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[Check_picPath componentsSeparatedByString:@"/dataCaches"] lastObject]] error:nil];
    NSMutableArray* checkArr = [NSMutableArray new];
    NSArray*  check_sortArray = [checkArrTemp sortedArrayUsingDescriptors:descriptors];
    for (NSString* obj in check_sortArray)
    {
        NSString *fileType = [[obj componentsSeparatedByString:@"."] lastObject];
        if ([obj length] < 3||![fileType isEqualToString:@"jpg"])  // 删除DS_Store
        {
        }
        else
        {
            NSString* picpath = [NSString stringWithFormat:@"%@/%@",[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[Check_picPath componentsSeparatedByString:@"/dataCaches"] lastObject]],obj];
            NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:picpath error:nil];
            unsigned long long fileSize = [attributes fileSize];
            if (fileSize < 10) {
                [[NSFileManager defaultManager] removeItemAtPath:picpath error:nil];
            }
            else
            {
                [checkArr addObject:picpath];
            }
        }
    }
    
    
    NSData* scorecarddata = [[NSData alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[ScoreCard_xmlPath componentsSeparatedByString:@"/dataCaches"] lastObject]]];
    NSString* scorecardXmlstr = [[NSString alloc]initWithData:scorecarddata encoding:NSUTF8StringEncoding];

    NSString *newScoreCardfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[ScoreCard_picPath componentsSeparatedByString:@"/dataCaches"] lastObject]];
    NSMutableArray* scorecardArrTemp = (NSMutableArray*)[fileManager contentsOfDirectoryAtPath:newScoreCardfile error:nil];
    NSMutableArray* scorecardArr = [NSMutableArray new];
    NSArray*  scorecard_sortArray = [scorecardArrTemp sortedArrayUsingDescriptors:descriptors];
    for (NSString* obj in scorecard_sortArray)
    {
        NSString *fileType = [[obj componentsSeparatedByString:@"."] lastObject];
        if ([obj length] < 3||![fileType isEqualToString:@"jpg"])  // 删除DS_Store
        {
        }
        else
        {
            NSString* picpath = [NSString stringWithFormat:@"%@/%@",newScoreCardfile,obj];
            NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:picpath error:nil];
            unsigned long long fileSize = [attributes fileSize];
            if (fileSize < 10) {
                [[NSFileManager defaultManager] removeItemAtPath:picpath error:nil];
            }
            else
            {
                [scorecardArr addObject:picpath];
            }
        }
    }
    
    NSData* scorecarddataDaily = [[NSData alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[ScoreCardDaily_xmlPath componentsSeparatedByString:@"/dataCaches"] lastObject]]];
    NSString* scorecardXmlstrDaily = [[NSString alloc]initWithData:scorecarddataDaily encoding:NSUTF8StringEncoding];
    
    NSString *newScoreCardfileDaily = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[ScoreCardDaily_picPath componentsSeparatedByString:@"/dataCaches"] lastObject]];
    NSMutableArray* scorecardArrTempDaily = (NSMutableArray*)[fileManager contentsOfDirectoryAtPath:newScoreCardfileDaily error:nil];
    NSMutableArray* scorecardArrDaily = [NSMutableArray new];
    NSArray*  scorecard_sortArrayDaily = [scorecardArrTempDaily sortedArrayUsingDescriptors:descriptors];
    for (NSString* obj in scorecard_sortArrayDaily)
    {
        NSString *fileType = [[obj componentsSeparatedByString:@"."] lastObject];
        if ([obj length] < 3||![fileType isEqualToString:@"jpg"])  // 删除DS_Store
        {
        }
        else
        {
            NSString* picpath = [NSString stringWithFormat:@"%@/%@",newScoreCardfileDaily,obj];
            NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:picpath error:nil];
            unsigned long long fileSize = [attributes fileSize];
            if (fileSize < 10) {
                [[NSFileManager defaultManager] removeItemAtPath:picpath error:nil];
            }
            else
            {
                [scorecardArrDaily addObject:picpath];
            }
        }
    }
    
    
    
    NSData* Ro_issuedata = [[NSData alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[Ro_Issue_xmlPath componentsSeparatedByString:@"/dataCaches"] lastObject]]];
    NSString* Ro_issueXmlstr = [[NSString alloc]initWithData:Ro_issuedata encoding:NSUTF8StringEncoding];
    NSMutableArray* Ro_issueArrTemp = (NSMutableArray*)[fileManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[Ro_Issue_picPath componentsSeparatedByString:@"/dataCaches"] lastObject]] error:nil];
    NSMutableArray* Ro_issueArr = [NSMutableArray new];
    NSSortDescriptor *Ro_descriptor = [NSSortDescriptor sortDescriptorWithKey:@"floatValue" ascending:YES];
    NSArray *Ro_descriptors = [NSArray arrayWithObject:Ro_descriptor];
    NSArray* Ro_issue_sortArray = [Ro_issueArrTemp sortedArrayUsingDescriptors:Ro_descriptors];

    for (NSString* obj in Ro_issue_sortArray)
    {
        NSString *fileType = [[obj componentsSeparatedByString:@"."] lastObject];
        if ([obj length] < 3 ||![fileType isEqualToString:@"jpg"])
        {
        }
        else
        {
            NSString* picpath = [NSString stringWithFormat:@"%@/%@",[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[Ro_Issue_picPath componentsSeparatedByString:@"/dataCaches"] lastObject]],obj];
            NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:picpath error:nil];
            unsigned long long fileSize = [attributes fileSize];
            if (fileSize < 10) {
                [[NSFileManager defaultManager] removeItemAtPath:picpath error:nil];
            }
            else
            {
                [Ro_issueArr addObject:picpath];
            }
        }
    }
    
    
    NSData* headcountdata = [[NSData alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[HEADCOUNT_XML_PATH componentsSeparatedByString:@"/dataCaches"] lastObject]]];
    NSString* headcountXmlstr = [[NSString alloc]initWithData:headcountdata encoding:NSUTF8StringEncoding];
    
    
    
    NSData* Training_data = [[NSData alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[Training_xmlPath componentsSeparatedByString:@"/dataCaches"] lastObject]]];
    NSString* Training_Xmlstr = [[NSString alloc]initWithData:Training_data encoding:NSUTF8StringEncoding];
    NSMutableArray* Training_ArrTemp = (NSMutableArray*)[fileManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[Training_picPath componentsSeparatedByString:@"/dataCaches"] lastObject]] error:nil];
    NSMutableArray* Training_Arr = [NSMutableArray new];
    
    for (NSString* obj in Training_ArrTemp)
    {
        NSString *fileType = [[obj componentsSeparatedByString:@"."] lastObject];
        if ([obj length] < 3 ||![fileType isEqualToString:@"jpg"])
        {
        }
        else
        {
            NSString* picpath = [NSString stringWithFormat:@"%@/%@",[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[Training_picPath componentsSeparatedByString:@"/dataCaches"] lastObject]],obj];
            NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:picpath error:nil];
            unsigned long long fileSize = [attributes fileSize];
            if (fileSize < 10) {
                [[NSFileManager defaultManager] removeItemAtPath:picpath error:nil];
            }
            else
            {
                [Training_Arr addObject:picpath];
            }
        }
    }
    
    
    
    NSData* issuetrackingdata = [[NSData alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[Issuetracking_xmlPath componentsSeparatedByString:@"/dataCaches"] lastObject]]];
    NSString* issuetrackingXmlstr = [[NSString alloc]initWithData:issuetrackingdata encoding:NSUTF8StringEncoding];
    
    
    
    
    NSData* auditdata = [[NSData alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[Audit_xmlPath componentsSeparatedByString:@"/dataCaches"] lastObject]]];
    NSString* auditXmlstr = [[NSString alloc]initWithData:auditdata encoding:NSUTF8StringEncoding];
    NSMutableArray* auditArrTemp = (NSMutableArray*)[fileManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[Audit_picPath componentsSeparatedByString:@"/dataCaches"] lastObject]] error:nil];
    NSMutableArray* auditArr = [NSMutableArray new];
    NSArray*  audit_sortArray = [auditArrTemp sortedArrayUsingDescriptors:descriptors];
    for (NSString* obj in audit_sortArray)
    {
        NSString *fileType = [[obj componentsSeparatedByString:@"."] lastObject];
        if ([obj length] < 3||![fileType isEqualToString:@"jpg"])  // 删除DS_Store
        {
        }
        else
        {
            NSString* picpath = [NSString stringWithFormat:@"%@/%@",[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[Audit_picPath componentsSeparatedByString:@"/dataCaches"] lastObject]],obj];
            NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:picpath error:nil];
            unsigned long long fileSize = [attributes fileSize];
            if (fileSize < 10) {
                [[NSFileManager defaultManager] removeItemAtPath:picpath error:nil];
            }
            else
            {
                [auditArr addObject:picpath];
            }
        }
    }
    
    
    
    
    NSData* onsitedata = [[NSData alloc]initWithContentsOfFile:[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[Onsite_xmlPath componentsSeparatedByString:@"/dataCaches"] lastObject]]];
    NSString* onsiteXmlstr = [[NSString alloc]initWithData:onsitedata encoding:NSUTF8StringEncoding];
    NSMutableArray* onsiteArrTemp = (NSMutableArray*)[fileManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[Onsite_picPath componentsSeparatedByString:@"/dataCaches"] lastObject]] error:nil];
    NSMutableArray* onsiteArr = [NSMutableArray new];
    NSArray*  onsite_sortArray = [onsiteArrTemp sortedArrayUsingDescriptors:descriptors];
    for (NSString* obj in onsite_sortArray) {
        NSString *fileType = [[obj componentsSeparatedByString:@"."] lastObject];
        if ([obj length] < 3||![fileType isEqualToString:@"jpg"]) {
        } else {
            NSString* picpath = [NSString stringWithFormat:@"%@/%@",[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[Onsite_picPath componentsSeparatedByString:@"/dataCaches"] lastObject]],obj];
            NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:picpath error:nil];
            unsigned long long fileSize = [attributes fileSize];
            if (fileSize < 10) {
                [[NSFileManager defaultManager] removeItemAtPath:picpath error:nil];
            } else {
                [onsiteArr addObject:picpath];
            }
        }
    }
    
    
    FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
    NSString* s1 = @"1";
    NSString* s2 = @"1";
    NSString* s3 = @"1";
    NSString* s4 = @"1";
    NSString* s5 = @"1";
    NSString* s6 = @"1";
    NSString* s7 = @"1";
    NSString* s8 = @"1";
    NSString* s9 = @"1";
    NSString* s10 = @"1";
    NSString* s11 = @"1";
    NSString* s12 = @"1";
    NSString* s13 = @"1";
    NSString* s14 = @"1";
    NSString* s15 = @"1";
    
    if (installXmlstr && [installXmlstr length]>0)
    {
        NSDictionary* str5  = [self sendHttpFileRequest:installXmlstr fileType:kXmlFrCampInstall filePathArr:installArr xmlPath:Install_xmlPath];
        s5 = [str5 objectForKey:@"CheckFlag"];
        if ([s5 isEqualToString:@"1"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.uploadedNum++;
                float progress = self.uploadedNum/self.allFileNum;
                [self.bottomProgressView setProgress:progress animated:YES];
            });
        }
    }
    
    if (self.RailCheck_XML && [self.RailCheck_XML length]>0)
    {
        NSDictionary* str7  = [self sendHttpFileRequest:self.RailCheck_XML fileType:kXmlUploadCHK filePathArr:rail_checkListArray xmlPath:RailCheck_xmlPath];
        s7 = [str7 objectForKey:@"CheckFlag"];
        if ([s7 isEqualToString:@"1"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.uploadedNum++;
                float progress = self.uploadedNum/self.allFileNum;
                [self.bottomProgressView setProgress:progress animated:YES];
            });
        }
    }
    
    if (issueXmlstr && ([issueXmlstr length]>0))
    {
        NSDictionary* str1 = [self sendHttpFileRequest:issueXmlstr fileType:kVMXmlUploadIssue filePathArr:issueArr xmlPath:Issue_xmlPath];
        s1 = [str1 objectForKey:@"CheckFlag"];
        if ([s1 isEqualToString:@"1"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.uploadedNum++;
                float progress = self.uploadedNum/self.allFileNum;
                [self.bottomProgressView setProgress:progress animated:YES];
            });
        }
    }
    
    if (photoXmlstr && ([resultPicArr count]>0))
    {
        NSDictionary* str2 = [self sendHttpFileRequest:photoXmlstr fileType:kVMXmlUploadStore filePathArr:resultPicArr xmlPath:Photo_xmlPath];
        s2 = [str2 objectForKey:@"CheckFlag"];
        if ([s2 isEqualToString:@"1"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.uploadedNum++;
                float progress = self.uploadedNum/self.allFileNum;
                [self.bottomProgressView setProgress:progress animated:YES];
            });
        }
    }
    if (checkXmlstr && [checkXmlstr length] > 10)
    {
        NSDictionary* str3 = [self sendHttpFileRequest:checkXmlstr fileType:kVMXmlUploadCHK filePathArr:checkArr xmlPath:Check_xmlPath];
        s3 = [str3 objectForKey:@"CheckFlag"];
        if ([s3 isEqualToString:@"1"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.uploadedNum++;
                float progress = self.uploadedNum/self.allFileNum;
                [self.bottomProgressView setProgress:progress animated:YES];
            });
        }
    }

    if (Sign_path != nil)
    {
        Sign_path = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[Sign_path componentsSeparatedByString:@"/dataCaches"] lastObject]] ;
        
        if (ISFROMEHK) s4 = [[self uploadSignFile:Sign_path andUpload:entity] objectForKey:@"CheckFlag"];
        
        else s4 = [[self uploadSignFileNew:Sign_path andUpload:entity] objectForKey:@"CheckFlag"];
        
        if ([s4 isEqualToString:@"1"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.uploadedNum++;
                float progress = self.uploadedNum/self.allFileNum;
                [self.bottomProgressView setProgress:progress animated:YES];
            });
        }
    }
    
    if (ARSMSign_path != nil)
    {
        ARSMSign_path = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[ARSMSign_path componentsSeparatedByString:@"/dataCaches"] lastObject]] ;
        s6 = [[self uploadARSMSignFile:ARSMSign_path andUpload:entity] objectForKey:@"CheckFlag"];
        
        if ([s6 isEqualToString:@"1"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.uploadedNum++;
                float progress = self.uploadedNum/self.allFileNum;
                [self.bottomProgressView setProgress:progress animated:YES];
            });
        }
    }
    
    if (scorecardXmlstr && [scorecardXmlstr length] > 10)
    {
        NSDictionary* str8 = [self sendHttpFileRequest:scorecardXmlstr fileType:kVMXmlUploadScoreCard filePathArr:scorecardArr xmlPath:ScoreCard_xmlPath];
        s8 = [str8 objectForKey:@"CheckFlag"];
        if ([s8 isEqualToString:@"1"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.uploadedNum++;
                float progress = self.uploadedNum/self.allFileNum;
                [self.bottomProgressView setProgress:progress animated:YES];
            });
        }
    }
    
    if (scorecardXmlstrDaily && [scorecardXmlstrDaily length] > 10)
    {
        NSDictionary* str9 = [self sendHttpFileRequest:scorecardXmlstrDaily fileType:kVMXmlUploadScoreCard filePathArr:scorecardArrDaily xmlPath:ScoreCardDaily_xmlPath];
        s9 = [str9 objectForKey:@"CheckFlag"];
        if ([s9 isEqualToString:@"1"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.uploadedNum++;
                float progress = self.uploadedNum/self.allFileNum;
                [self.bottomProgressView setProgress:progress animated:YES];
            });
        }
    }
    
    if (Ro_issueXmlstr && ([Ro_issueXmlstr length]>0))
    {
        NSDictionary* str1 = [self sendHttpFileRequest:Ro_issueXmlstr fileType:kFrXmlIssuePhoto filePathArr:Ro_issueArr xmlPath:Ro_Issue_xmlPath];
        s10 = [str1 objectForKey:@"CheckFlag"];
        if ([s10 isEqualToString:@"1"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.uploadedNum++;
                float progress = self.uploadedNum/self.allFileNum;
                [self.bottomProgressView setProgress:progress animated:YES];
            });
        }
    }
    
    
    if (headcountXmlstr && ([headcountXmlstr length]>0))
    {
        NSDictionary* str1 = [self sendHttpFileRequest:headcountXmlstr fileType:kFrXmlHeadCount filePathArr:[NSArray array] xmlPath:HEADCOUNT_XML_PATH];
        s11 = [str1 objectForKey:@"CheckFlag"];
        if ([s11 isEqualToString:@"1"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.uploadedNum++;
                float progress = self.uploadedNum/self.allFileNum;
                [self.bottomProgressView setProgress:progress animated:YES];
            });
        }
    }
    
    if (Training_Xmlstr && ([Training_Xmlstr length]>0))
    {
        NSDictionary* str1 = [self sendHttpFileRequest:Training_Xmlstr fileType:kVMXmlUploadTraining filePathArr:Training_Arr xmlPath:Training_xmlPath];
        s12 = [str1 objectForKey:@"CheckFlag"];
        if ([s12 isEqualToString:@"1"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.uploadedNum++;
                float progress = self.uploadedNum/self.allFileNum;
                [self.bottomProgressView setProgress:progress animated:YES];
            });
        }
    }
    
    if (issuetrackingXmlstr && ([issuetrackingXmlstr length]>0))
    {
        NSDictionary* str1 = [self sendHttpFileRequest:issuetrackingXmlstr fileType:kIssueTrackingConfirm filePathArr:[NSArray array] xmlPath:Issuetracking_xmlPath];
        s13 = [str1 objectForKey:@"CheckFlag"];
        if ([s13 isEqualToString:@"1"])
        {
            NSString* sql = [NSString stringWithFormat:@"select * from NVM_IST_ISSUE_TRACKING_CHECK where STORE_CODE ='%@' and USER_ID= '%@' and STATUS = '1'",entity.STORE_CODE,entity.USER_ID];
            FMResultSet* rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
            NSString *check_id = @"" ;
            if ([rs next]) {
                check_id = [rs stringForColumn:@"ISSUE_TRACKING_CHECK_ID"];
            }
            [rs close];
            if (check_id&&![check_id isEqual:[NSNull null]]&&![check_id isEqualToString:@""]) {
                [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:[NSString stringWithFormat:@"DELETE FROM NVM_IST_ISSUE_TRACKING_CHECK WHERE ISSUE_TRACKING_CHECK_ID = '%@'",check_id]];
                [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:[NSString stringWithFormat:@"DELETE FROM NVM_IST_ISSUE_TRACKING_ITEM_LIST WHERE ISSUE_TRACKING_CHECK_ID = '%@'",check_id]];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.uploadedNum++;
                float progress = self.uploadedNum/self.allFileNum;
                [self.bottomProgressView setProgress:progress animated:YES];
            });
        }
    }
    
    
    if (auditXmlstr && ([auditXmlstr length]>0))
    {
        NSDictionary* str1 = [self sendHttpFileRequest:auditXmlstr fileType:kVMXmlUploadAudit filePathArr:auditArr xmlPath:Audit_xmlPath];
        s14 = [str1 objectForKey:@"CheckFlag"];
        if ([s14 isEqualToString:@"1"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.uploadedNum++;
                float progress = self.uploadedNum/self.allFileNum;
                [self.bottomProgressView setProgress:progress animated:YES];
            });
        }
    }
    
    
    if (onsiteXmlstr && ([onsiteXmlstr length]>0))
    {
        NSDictionary* str1 = [self sendHttpFileRequest:onsiteXmlstr fileType:kVMXmlUploadOnSite filePathArr:onsiteArr xmlPath:Onsite_xmlPath];
        s15 = [str1 objectForKey:@"CheckFlag"];
        if ([s15 isEqualToString:@"1"])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.uploadedNum++;
                float progress = self.uploadedNum/self.allFileNum;
                [self.bottomProgressView setProgress:progress animated:YES];
            });
        }
    }
    
    if (([s1  isEqualToString:@"1"])&&
        ([s2  isEqualToString:@"1"])&&
        ([s7  isEqualToString:@"1"])&&
        ([s8  isEqualToString:@"1"])&&
        ([s10  isEqualToString:@"1"])&&
        ([s11  isEqualToString:@"1"])&&
        ([s12  isEqualToString:@"1"])&&
        ([s13  isEqualToString:@"1"])&&
        ([s9  isEqualToString:@"1"])&&
        ([s3  isEqualToString:@"1"])&&
        ([s14  isEqualToString:@"1"])&&
        ([s15  isEqualToString:@"1"]))
    {
        NSString* sql = [NSString stringWithFormat:@"DELETE FROM NVM_FILE_LIST WHERE STORE_CODE = '%@' AND CREATE_DATE = '%@' AND USER_ID = '%@'",entity.STORE_CODE,entity.CREATE_DATE,entity.USER_ID];
         [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql];

        return YES;
    }
    else
        return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.uploadFileArr count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"cell";
    UploadTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (nil == cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"UploadTableViewCell" owner:self options:nil]objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.uploadEntity = [self.uploadFileArr objectAtIndex:indexPath.row];
    cell.storeNameLabel.text = cell.uploadEntity.STORE_NAME;
    cell.storeNameLabel.adjustsFontSizeToFitWidth = YES ;
    cell.storeCodeLabel.text = cell.uploadEntity.STORE_CODE;
    cell.storeCodeLabel.adjustsFontSizeToFitWidth = YES ;
    cell.timeLabel.text = cell.uploadEntity.CREATE_DATE;
    cell.timeLabel.adjustsFontSizeToFitWidth = YES ;
    
    NSString *pathStore = [NSString stringWithFormat:@"%@/storetypeforkid.plist",[Utilities SysDocumentPath]] ;
    NSDictionary *storeType = [NSDictionary dictionaryWithContentsOfFile:pathStore];
    if (!storeType) storeType = [NSDictionary dictionary];
    
    NSString *dataSource = [storeType valueForKey:cell.uploadEntity.STORE_CODE] ? [storeType valueForKey:cell.uploadEntity.STORE_CODE] : @"" ;
    if([dataSource isEqual:[NSNull null]]) dataSource = @"" ;
    
    if ([cell.uploadEntity.CHECK_XML_PATH length]>0) {
         cell.vmchecklabel.text = @"陈列检查";
        if (SYSLanguage == EN) {
            cell.vmchecklabel.text = @"VMCheck";
        }
    }
    
    if ([cell.uploadEntity.SCORECARD_XML_PATH length]>0 || [cell.uploadEntity.SCORECARDDAILY_XML_PATH length]>0) {
        [cell.scorecardLabel setAdjustsFontSizeToFitWidth:YES] ;
        if ([cell.uploadEntity.SCORECARD_XML_PATH length]>0) cell.scorecardLabel.text = @"ScoreCard-M";
        if ([cell.uploadEntity.SCORECARDDAILY_XML_PATH length]>0) cell.scorecardLabel.text = @"ScoreCard-D";
        if ([cell.uploadEntity.SCORECARD_XML_PATH length]>0 && [cell.uploadEntity.SCORECARDDAILY_XML_PATH length]>0)
            cell.scorecardLabel.text = @"ScoreCard-M-D";
        cell.scorecardLabel.adjustsFontSizeToFitWidth = YES ;
    }
    
    if ([cell.uploadEntity.ISSUE_XML_PATH length]>0) {
        cell.vmissuelabel.text = @"问题列表";
        if (SYSLanguage == EN) {
            cell.vmissuelabel.text = @"Issue";
        }
    }
    
    if ([cell.uploadEntity.PHOTO_XML_PATH length]>0) {
        cell.vmphotolabel.text = @"门店拍照";
        if (SYSLanguage == EN) {
            cell.vmphotolabel.text = @"Photo";
        }
    }
    
    if ([cell.uploadEntity.SIGN_PATH length]>0) {
        cell.vmsignlabel.text = @"签名";
        if (SYSLanguage == EN) {
            cell.vmsignlabel.text = @"Sign";
        }
    }
    
    if ([cell.uploadEntity.ARSMSIGN_PATH length]>0) {
        cell.ARSMSignLabel.text = @"RO店铺确认";
        if ([[dataSource lowercaseString] containsString:@"rbk"]) cell.ARSMSignLabel.text = @"FO店铺确认";
        if (SYSLanguage == EN) {
            cell.ARSMSignLabel.text = @"RO Store Signoff";
            if ([[dataSource lowercaseString] containsString:@"rbk"]) cell.ARSMSignLabel.text = @"FO Store Signoff";
        }
        cell.ARSMSignLabel.adjustsFontSizeToFitWidth = YES ;
    }
    
    if ([cell.uploadEntity.RAILCHECK_XML_PATH length]>0)
    {
        cell.railchecklabel.text = SYSLanguage?@"F-aRMS Check List": @"F-aRMS Check List";
        if ([[dataSource lowercaseString] containsString:@"rbk"]) cell.railchecklabel.text = SYSLanguage?@"F-RMS Check List": @"F-RMS Check List";
        cell.railchecklabel.adjustsFontSizeToFitWidth = YES ;
    }
    
    if ([cell.uploadEntity.INSTALL_XML_PATH length] > 0)
    {
        cell.installlabel.text = SYSLanguage?@"Install":@"安装报告";
        cell.installlabel.adjustsFontSizeToFitWidth = YES ;
    }
    
    if ([cell.uploadEntity.RO_ISSUE_XML_PATH length] > 0)
    {
        cell.RoIssueLabel.text = SYSLanguage?@"RO Issue Feedback":@"RO走店问题反馈";
        if ([[dataSource lowercaseString] containsString:@"rbk"]) cell.RoIssueLabel.text = SYSLanguage?@"FO Issue Feedback":@"FO走店问题反馈";
        cell.RoIssueLabel.adjustsFontSizeToFitWidth = YES ;
    }
    
    if ([cell.uploadEntity.HEADCOUNT_XML_PATH length] > 0)
    {
        cell.headCountLabel.text = SYSLanguage?@"Headcount Check":@"人数检查";
        cell.headCountLabel.adjustsFontSizeToFitWidth = YES ;
    }
    
    if ([cell.uploadEntity.TRINING_XML_PATH length] > 0)
    {
        cell.trainingLabel.text = SYSLanguage?@"Training":@"培训";
        cell.trainingLabel.adjustsFontSizeToFitWidth = YES ;
    }
    
    if ([cell.uploadEntity.ISSUE_TRACKING_XML_PATH length] > 0)
    {
        cell.issueTrackingLabel.text = SYSLanguage?@"Issue Tracking":@"问题跟踪";
        cell.issueTrackingLabel.adjustsFontSizeToFitWidth = YES ;
    }
    
    if ([cell.uploadEntity.AUDIT_XML_PATH length] > 0)
    {
        cell.vmchecklabel.text = SYSLanguage?@"Store Audit":@"店铺检查";
        cell.vmchecklabel.adjustsFontSizeToFitWidth = YES ;
    }
    
    if ([cell.uploadEntity.ONSITE_XML_PATH length]>0) {
        cell.scorecardLabel.text = SYSLanguage?@"On Site":@"陈列调整";
    }
   
    return cell;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UploadTableViewCell* cell = (UploadTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
//    [self uploadSingle:cell.uploadEntity];
//}

- (id)uploadARSMSignFile:(NSString *)picpath  andUpload:(UploadFileEntity*)entity{

    NSString *workmainid = @"" ;
    NSString* sql = [NSString stringWithFormat:@"select WORK_MAIN_ID from IST_WORK_MAIN where OPERATE_USER ='%@' and STORE_CODE='%@' and ser_insert_time like '%@%%'",entity.USER_ID,entity.STORE_CODE,entity.CREATE_DATE];
    
    FMResultSet *rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        workmainid = [NSString stringWithFormat:@"%@",[rs stringForColumnIndex:0]] ;
    }
    [rs close];
    
    //里面有中文。需要转化为NSUTF8StringEncoding
    NSString* urlString = [NSString stringWithFormat:kUploadArsmSignature,kWebDataString,[CacheManagement instance].userLoginName,workmainid];
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
    
    if ([filemananger fileExistsAtPath:[NSString stringWithFormat:@"%@_GroupPhoto.jpg",[[picpath componentsSeparatedByString:@".jp"] firstObject]]])
    {
        [zipObjectArray addObject:[NSString stringWithFormat:@"%@_GroupPhoto.jpg",[[picpath componentsSeparatedByString:@".jp"] firstObject]]];
    }
    
    NSString *signpath = [[picpath  componentsSeparatedByString:@".jp"] firstObject] ;
    NSString *response = nil;
    BOOL result = [SSZipArchive createZipFileAtPath:[NSString stringWithFormat:@"%@.zip",signpath] withFilesAtPaths:zipObjectArray];
    
    if (result) {
        
        [_fileRequest setFile:[NSString stringWithFormat:@"%@.zip",signpath] forKey:@"zipfile"];
        [_fileRequest startSynchronous];
        
        NSError *error = [_fileRequest error];
        
        if (!error)
        {
            response = [_fileRequest responseString];

            if (![response JSONValue]) {
                response = [AES128Util AES128Decrypt:[_fileRequest responseString] key:[CommonUtil getDecryKey:[CacheManagement instance].currentDBUser.userName]]  ;
            }
            
            if([[NSString stringWithFormat:@"%@",[[response JSONValue] objectForKey:@"CheckFlag"]] isEqualToString:@"1"])
            {
                FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
                NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET ARSMSIGN = '%@' where WORKMAINID = '%@'",@"2",workmainid];
                [db executeUpdate:sql];
            }
        }
    }
    
    return [response JSONValue];
}

-(id)uploadSignFileNew:(NSString* )picpath  andUpload:(UploadFileEntity*)entity{
    
    NSString *workmainid = @"" ;
    NSString* sql = [NSString stringWithFormat:@"select WORK_MAIN_ID from IST_WORK_MAIN where OPERATE_USER ='%@' and STORE_CODE='%@' and ser_insert_time like '%@%%'",entity.USER_ID,entity.STORE_CODE,entity.CREATE_DATE];
    
    FMResultSet *rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        workmainid = [NSString stringWithFormat:@"%@",[rs stringForColumnIndex:0]] ;
    }
    [rs close];
    
    //里面有中文。需要转化为NSUTF8StringEncoding
    NSString* urlString = [NSString stringWithFormat:kUploadSignature,kWebDataString,[CacheManagement instance].userLoginName,workmainid];
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
    
    if ([filemananger fileExistsAtPath:[NSString stringWithFormat:@"%@_GroupPhoto.jpg",[[picpath componentsSeparatedByString:@".jp"] firstObject]]])
    {
        [zipObjectArray addObject:[NSString stringWithFormat:@"%@_GroupPhoto.jpg",[[picpath componentsSeparatedByString:@".jp"] firstObject]]];
    }
    
    
    NSString *signpath = [[picpath  componentsSeparatedByString:@".jp"] firstObject] ;
    NSString *response = nil;
    BOOL result = [SSZipArchive createZipFileAtPath:[NSString stringWithFormat:@"%@.zip",signpath] withFilesAtPaths:zipObjectArray];
    
    if (result) {
        
        
        [_fileRequest setFile:[NSString stringWithFormat:@"%@.zip",signpath] forKey:@"zipfile"];
        [_fileRequest startSynchronous];
        
        NSError *error = [_fileRequest error];
        
        if (!error)
        {
            response = [_fileRequest responseString];
            if (![response JSONValue]) {
                response = [AES128Util AES128Decrypt:[_fileRequest responseString] key:[CommonUtil getDecryKey:[CacheManagement instance].currentDBUser.userName]]  ;
            }
            if([[[response JSONValue]objectForKey:@"CheckError"] length] == 0)
            {
                FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
                NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET SIGN = '%@' where WORKMAINID = '%@'",@"2",workmainid];
                [db executeUpdate:sql];
            }
        }
    }
    
    
    return [response JSONValue];
}

-(id)uploadSignFile:(NSString* )picpath andUpload:(UploadFileEntity*)entity{
    
    NSString *workmainid = @"" ;
    NSString* sql = [NSString stringWithFormat:@"select WORK_MAIN_ID from IST_WORK_MAIN where OPERATE_USER ='%@' and STORE_CODE='%@' and ser_insert_time like '%@%%'",entity.USER_ID,entity.STORE_CODE,entity.CREATE_DATE];
    
    FMResultSet *rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
    while ([rs next])
    {
        workmainid = [NSString stringWithFormat:@"%@",[rs stringForColumnIndex:0]] ;
    }
    [rs close];
    
    //里面有中文。需要转化为NSUTF8StringEncoding
    NSString* urlString = [NSString stringWithFormat:kUploadSignature,kWebDataString,[CacheManagement instance].userLoginName,workmainid];
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
    if(picpath!=nil && ![picpath isEqualToString:@""]&&[filemananger fileExistsAtPath:picpath])
    {
        [_fileRequest setFile:picpath forKey:@"sign.jpg"];
    }
    
    [_fileRequest startSynchronous];
    
    NSError *error = [_fileRequest error];
    NSString *response = nil;
    if (!error)
    {
        response = [_fileRequest responseString];
        if (![response JSONValue]) {
            response = [AES128Util AES128Decrypt:[_fileRequest responseString] key:[CommonUtil getDecryKey:[CacheManagement instance].currentDBUser.userName]]  ;
        }
        if([[[response JSONValue]objectForKey:@"CheckError"] length] == 0)
        {
            FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
            NSString* sql = [NSString stringWithFormat:@"UPDATE NVM_STATUS SET SIGN = '%@' where WORKMAINID = '%@'",@"2",workmainid];
            [db executeUpdate:sql];
        }
    }
    
    return [response JSONValue];
}

//带附件 的安装报告提交方法
-(id) sendHttpFileRequest:(NSString *)xmlString
                   fileType:(NSString*)fileType
                filePathArr:(NSArray *)picArr
                  xmlPath:(NSString *)path
{
    //里面有中文。需要转化为NSUTF8StringEncoding
    NSString* urlString = [NSString stringWithFormat:kUploadDataNEW,kWebDataString,[CacheManagement instance].userLoginName,fileType];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest*  _fileRequest = [ASIFormDataRequest requestWithURL:url];
    [_fileRequest setValidatesSecureCertificate:NO]; // no
    [_fileRequest setRequestMethod:@"POST"];
    [_fileRequest addRequestHeader:@"Accept" value:@"application/json"];
    [_fileRequest addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    
    //添加Post数据
    [_fileRequest addPostValue:fileType forKey:@"fileType"];
    //添加ISA 密文验证
    if ([CacheManagement instance].userEncode&&![[CacheManagement instance].userEncode isEqualToString:@""])
        [_fileRequest addRequestHeader:@"Authorization"
                             value:[NSString stringWithFormat:@"Basic %@",[CacheManagement instance].userEncode]];
    
   	[_fileRequest setTimeOutSeconds:1000];
    
    NSMutableArray *zipObjectArray = [NSMutableArray array];
    NSString *zipPath = @"" ;
    for (NSString* filePath in picArr)
    {
        if(filePath!=nil && ![filePath isEqualToString:@""]&&![filePath isEqualToString:@"0"])
        {
            NSMutableArray *pathArray = [NSMutableArray arrayWithArray:[filePath componentsSeparatedByString:@"/"]] ;
            [pathArray removeLastObject] ;
            zipPath = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[[pathArray componentsJoinedByString:@"/"] componentsSeparatedByString:@"dataCaches"] lastObject]];
            
            [zipObjectArray addObject:[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[filePath componentsSeparatedByString:@"dataCaches"] lastObject]]] ;
        }
    }
    NSString *newXmlfile = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[path componentsSeparatedByString:@"/dataCaches"] lastObject]];
    [zipObjectArray addObject:newXmlfile] ;
    NSFileManager *appFileManager = [NSFileManager defaultManager] ;
    NSString *finalPath = @"" ;
    
    if ([zipPath isEqualToString:@""]&&path) {
        
        NSMutableArray *pathAry = [NSMutableArray arrayWithArray:[path componentsSeparatedByString:@"/"]];
        if ([pathAry count]) [pathAry removeLastObject] ;
        
        NSArray *fileList = [appFileManager subpathsAtPath:[pathAry componentsJoinedByString:@"/"]];
        
        for (NSString *format in fileList) {
            
            NSString *lastName = [[format componentsSeparatedByString:@"."] lastObject];
            if ([lastName isEqualToString:@"zip"]) {
                
                [appFileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",[pathAry componentsJoinedByString:@"/"],format] error:nil] ;
            }
        }
        
        finalPath = [NSString stringWithFormat:@"%@/IOS%@.zip",[pathAry componentsJoinedByString:@"/"],[Utilities GetUUID]] ;
    }
    else {
    
        NSArray *fileList = [appFileManager subpathsAtPath:zipPath];
        
        for (NSString *format in fileList) {
            
            NSString *lastName = [[format componentsSeparatedByString:@"."] lastObject];
            if ([lastName isEqualToString:@"xml"]||[lastName isEqualToString:@"zip"]) {
                
                [appFileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",zipPath,format] error:nil] ;
            }
        }
        
        finalPath = [NSString stringWithFormat:@"%@/IOS%@.zip",zipPath,[Utilities GetUUID]] ;
    }
    finalPath = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[finalPath componentsSeparatedByString:@"dataCaches"] lastObject]];
    if ([appFileManager fileExistsAtPath:finalPath]) {
        
        [appFileManager removeItemAtPath:finalPath error:nil] ;
    }
    
    BOOL result = [SSZipArchive createZipFileAtPath:finalPath withFilesAtPaths:zipObjectArray];
    if (result) {
        
        [_fileRequest setFile:finalPath forKey:@"zipfile"];
        
        [_fileRequest startSynchronous];
        NSError *error = [_fileRequest error];
        NSString *response = nil;
        
        if (!error) {
            response = [_fileRequest responseString];
            if (![response JSONValue]) {
                response = [AES128Util AES128Decrypt:[_fileRequest responseString] key:[CommonUtil getDecryKey:[CacheManagement instance].currentDBUser.userName]]  ;
            }
        }
        return [response JSONValue];
    }
    else return @{@"CheckFlag":@"0"} ;
    
   	
}


@end
