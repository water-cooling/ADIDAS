//
//  XMLFileManagement.m
//  ADIDAS
//
//  Created by testing on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XMLFileManagement.h"
#import "XMLWriter.h"
#import "Utilities.h"
#import "CacheManagement.h"
#import "IssueProductEntity.h"
#import "CheckScoreEntity.h"
#import "IST_WORK_MAIN.h"
#import "CampaignPopData.h"
#import "VMCheckScoreEntity.h"
#import "IssuePhotoEntity.h"
#import "VisitStoreEntity.h"
#import "SqliteHelper.h"
#import "VMScoreCardPhotoEntity.h"
#import "VmScoreCardScoreEntity.h"
#import "VMIstScoreCardEntity.h"
#import "FrHeadCountChkItemEntity.h"
#import "RoIssuePhotoEntity.h"
#import "NVMTrainingCheckPhotoEntity.h"
#import "VMAuditScoreEntity.h"
#import "VMStoreAuditPhotoEntity.h"
#import "OnSiteEntity.h"
#import "JSON.h"
#import "CreatTableModel.h"

@interface XMLFileManagement(private)  

-(XMLWriter *) createStoreXml:(XMLWriter *) _write  
                   workMainId:(NSString *) workMainId
                    currStore:(StoreEntity*) currStore
                     currUser:(LoginResultEntity*) currUser
                  currentTime:(NSString *) _currentTime;
@end

    

@implementation XMLFileManagement


//门店签到返回XML信息
- (NSString *) CreateCheckInXmlString
{
    StoreEntity* currStore =[CacheManagement instance].currentStore;
    LoginResultEntity* currUser =[CacheManagement instance].currentUser;
    LocationEntity* currentLocation=[CacheManagement instance].currentLocation;
    
    NSString * _workMainId = [CacheManagement instance].currentWorkMainID;
    NSString * _storeAuditId = [Utilities GetUUID];
    NSString * _currentTime = [CacheManagement instance].checkinTime;
    XMLWriter *_write =[[[XMLWriter alloc] init] autorelease] ;    
    //    [_write writeComment:@"test"];
    //root
    [_write writeStartElement:@"root"];
    
    //WorkMains
    [_write writeStartElement:@"IstWorkMains"];
    //WorkMain
    [_write writeStartElement:@"IstWorkMain"];
    [_write writeElement:@"WorkMainId" eleVaule:_workMainId];
    [_write writeElement:@"StoreCode" eleVaule:currStore.StoreCode];
    [_write writeElement:@"StoreName" eleVaule:currStore.StoreName];
    [_write writeElement:@"StoreAddress" eleVaule:currStore.StoreAddress];
    [_write writeElement:@"StoreTel" eleVaule:currStore.StorePhone];
    [_write writeElement:@"operateUser" eleVaule:currUser.UserId];
    [_write writeElement:@"SelectStoreMethod" eleVaule:currStore.SelectMethod];
    [_write writeElement:@"CheckInTime" eleVaule:[CacheManagement instance].checkinTime];
    [_write writeElement:@"CheckOutTime" eleVaule:[Utilities DateTimeNow]];
    [_write writeElement:@"TimeLength" eleVaule:@"0"];
    [_write writeElement:@"Status" eleVaule:@"1"];
    [_write writeElement:@"Remark" eleVaule:currStore.StoreRemark];
    [_write writeEndElement:@"IstWorkMain"];
    [_write writeEndElement:@"IstWorkMains"];
    //StoreAudits
    [_write writeStartElement:@"StoreAudits"];
    [_write writeStartElement:@"StoreAudit"];
    [_write writeElement:@"StoreAuditId" eleVaule:_storeAuditId];
    [_write writeElement:@"WorkMainId" eleVaule:_workMainId];
    [_write writeElement:@"AuditDate" eleVaule:_currentTime];
    [_write writeElement:@"AuditStartTime" eleVaule:_currentTime];
    [_write writeElement:@"AuditEndTime" eleVaule:_currentTime];
    [_write writeElement:@"PhotoPath" eleVaule:@"1"];
    [_write writeElement:@"PhotoTime" eleVaule:_currentTime];
    [_write writeElement:@"GPSLocationx" eleVaule:@"-1"];
    [_write writeElement:@"GPSLocationy" eleVaule:@"-1"];
    [_write writeElement:@"LbsLocationx" eleVaule:currentLocation.locationX];
    [_write writeElement:@"LbsLocationy" eleVaule:currentLocation.locationY];
    [_write writeElement:@"CellLocationx" eleVaule:@"-1"];
    [_write writeElement:@"CellLocationy" eleVaule:@"-1"];
    [_write writeEndElement:@"StoreAudit"];
    [_write writeEndElement:@"StoreAudits"];
    [_write writeEndElement:@"root"];
    return _write.toString;
}

//创建陈列报修XML数据
- (NSString *) CreateSerVMRepairString:(NSString *) issueCategoryID
                           issueItemID:(NSString *) issueItemID
                           issueRemark:(NSString *) issueRemark
{
    StoreEntity* currStore =[CacheManagement instance].currentStore;
    LoginResultEntity* currUser =[CacheManagement instance].currentUser;
    
    NSString * workMainId = [Utilities GetUUID]; //生成随随机字符串
    NSString * _vmPairIssueId = [Utilities GetUUID];
    NSString * _currentTime = [Utilities DateTimeNow];
    XMLWriter *_write =[[[XMLWriter alloc] init] autorelease] ;    
    
    _write =[self createStoreXml:_write workMainId:workMainId currStore:currStore currUser:currUser currentTime:_currentTime];
    
    //IST_SER_VM_REPAIR_ISSUE
    [_write writeStartElement:@"IST_SER_VM_REPAIR_ISSUE"];
    [_write writeElement:@"VM_REPAIR_ISSUE_ID" eleVaule:_vmPairIssueId];
    [_write writeElement:@"SER_VM_REPAIR_ID" eleVaule:@""];
    
    [_write writeElement:@"STORE_ISSUE_CATEGORY_ID" eleVaule:issueCategoryID];
    [_write writeElement:@"STORE_ISSUE_ITEM_ID" eleVaule:issueItemID];
    [_write writeElement:@"DESCRIPTION" eleVaule:issueRemark];
    [_write writeElement:@"PHOTO_NAME" eleVaule:@"0"];
    [_write writeElement:@"PHOTO_PATH" eleVaule:@"0"];
    [_write writeElement:@"STATUS" eleVaule:@"0"];
    [_write writeElement:@"SOLUTION" eleVaule:@""];
    [_write writeElement:@"REMARK" eleVaule:@""];
    [_write writeElement:@"CREATE_USER" eleVaule:currUser.UserId];
    [_write writeElement:@"CREATE_TIME" eleVaule:_currentTime];
    [_write writeElement:@"CLOSE_USER" eleVaule:@""];
    [_write writeElement:@"CLOSE_TIME" eleVaule:@""];
    [_write writeElement:@"LAST_MODIFIED_BY" eleVaule:@""];
    [_write writeElement:@"LAST_MODIFIED_TIME" eleVaule:@""];
    [_write writeEndElement:@"IST_SER_VM_REPAIR_ISSUE"];
    [_write writeEndElement:@"root"];
    return _write.toString;
}

//生成门店基本信息
-(XMLWriter *) createStoreXml:(XMLWriter *) _write 
                   workMainId:(NSString *) workMainId
                    currStore:(StoreEntity*) currStore
                     currUser:(LoginResultEntity*) currUser
                  currentTime:(NSString *) _currentTime
{
    NSString *COTime = _currentTime ;
    NSString *CITime = [CacheManagement instance].checkinTime ;
    if (FromHistory == 0) {
        
        NSString* sql = [NSString stringWithFormat: @"UPDATE IST_WORK_MAIN SET CHECK_OUT_TIME = '%@',CHECK_IN_TIME = '%@' WHERE STORE_CODE = '%@' and WORK_MAIN_ID = '%@'",_currentTime,CITime,[CacheManagement instance].currentStore.StoreCode,[CacheManagement instance].currentWorkMainID];
        [[SqliteHelper shareCommonSqliteHelper].database executeUpdate:sql];
    }
    if (FromHistory == 1) {
        
        NSString* sql = [NSString stringWithFormat:@"select * from IST_WORK_MAIN WHERE STORE_CODE = '%@' and WORK_MAIN_ID = '%@'",[CacheManagement instance].currentStore.StoreCode,[CacheManagement instance].currentWorkMainID];
        
        FMResultSet *rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
        while ([rs next])
        {
            IST_WORK_MAIN *work = [[IST_WORK_MAIN alloc] initWithFMResultSet:rs];
            COTime = work.CHECK_OUT_TIME ;
            CITime = work.CHECK_IN_TIME ;
        }
        [rs close];
    }
    
    LocationEntity* currentLocation=[CacheManagement instance].currentLocation;

    //root
    [_write writeStartElement:@"root"];
    //WorkMains
    [_write writeStartElement:@"IstWorkMains"];
    //WorkMain
    [_write writeStartElement:@"IstWorkMain"];
    [_write writeElement:@"WORKMAINID" eleVaule:workMainId];
    [_write writeElement:@"STORECODE" eleVaule:currStore.StoreCode];
    [_write writeElement:@"STORENAME" eleVaule:currStore.StoreName];
    [_write writeElement:@"USERID" eleVaule:currUser.UserId];
    [_write writeElement:@"SELECTSTOREMOTHED" eleVaule:@"1"];
    [_write writeElement:@"CONTACTPHONE" eleVaule:currStore.StorePhone];
    [_write writeElement:@"STOREADDRESS" eleVaule:currStore.StoreAddress];
    [_write writeElement:@"CHECKINTIME" eleVaule:CITime];
    [_write writeElement:@"CHECKOUTTIME" eleVaule:COTime];
    [_write writeElement:@"CHECKINLOCATIONX" eleVaule:currentLocation.locationX];
    [_write writeElement:@"CHECKINLOCATIONY" eleVaule:currentLocation.locationY];
    [_write writeElement:@"CHECKOUTLOCATIONX" eleVaule:@""];
    [_write writeElement:@"CHECKOUTLOCATIONY" eleVaule:@""];
    [_write writeElement:@"VISITDURATION" eleVaule:@""];
    [_write writeElement:@"STATUS" eleVaule:@"1"];
    [_write writeElement:@"REMARK" eleVaule:currStore.StoreRemark];
    [_write writeElement:@"SERINSERTTIME" eleVaule:@""];
    [_write writeElement:@"SIGNATUREPIC" eleVaule:@""];
    [_write writeEndElement:@"IstWorkMain"];
    [_write writeEndElement:@"IstWorkMains"];
    return _write;
}

//创建活动问题XML数据
- (NSString *) CreateServCampaignString:(NSString *) issueCategoryID
                           issueItemID:(NSString *) issueItemID
                           issueRemark:(NSString *) issueRemark
{
    StoreEntity* currStore =[CacheManagement instance].currentStore;
    LoginResultEntity* currUser =[CacheManagement instance].currentUser;
    NSString * workMainId = [Utilities GetUUID]; //生成随随机字符串
    NSString * _vmPairIssueId = [Utilities GetUUID];
    NSString * _currentTime = [Utilities DateTimeNow];
    XMLWriter *_write =[[[XMLWriter alloc] init] autorelease] ;    
    
     _write =[self createStoreXml:_write workMainId:workMainId currStore:currStore currUser:currUser currentTime:_currentTime];
    
    //IST_SER_VM_REPAIR_ISSUE
    [_write writeStartElement:@"IST_SER_CAMP_ISSUE"];
    [_write writeElement:@"SER_CAMPAIGN_ISSUE_ID" eleVaule:_vmPairIssueId];
    [_write writeElement:@"SER_CAMPAIGN_ID" eleVaule:@""];
    
    [_write writeElement:@"STORE_ISSUE_CATEGORY_ID" eleVaule:issueCategoryID];
    [_write writeElement:@"STORE_ISSUE_ITEM_ID" eleVaule:issueItemID];
    [_write writeElement:@"DESCRIPTION" eleVaule:issueRemark];
    [_write writeElement:@"PHOTO_NAME" eleVaule:@"0"];
    [_write writeElement:@"PHOTO_PATH" eleVaule:@"0"];
    [_write writeElement:@"STATUS" eleVaule:@"0"];
    [_write writeElement:@"SOLUTION" eleVaule:@""];
    [_write writeElement:@"REMARK" eleVaule:@""];
    [_write writeElement:@"CREATE_USER" eleVaule:currUser.UserId];
    [_write writeElement:@"CREATE_TIME" eleVaule:_currentTime];
    [_write writeElement:@"CLOSE_USER" eleVaule:@""];
    [_write writeElement:@"CLOSE_TIME" eleVaule:@""];
    [_write writeElement:@"LAST_MODIFIED_BY" eleVaule:@""];
    [_write writeElement:@"LAST_MODIFIED_TIME" eleVaule:@""];
    [_write writeEndElement:@"IST_SER_CAMP_ISSUE"];
    [_write writeEndElement:@"root"];
    return _write.toString;
}
//创建售后服务XML数据
- (NSString *) CreateSalesServString:(NSString *) issueCategoryID
                            issueItemID:(NSString *) issueItemID
                            issueRemark:(NSString *) issueRemark
                            prodCode:(NSString *) prodCode
                            prodSize:(NSString *) prodSize
                            isDamage:(NSInteger) isDamage
                           isDressed:(NSInteger) isDressed
                              isWash:(NSInteger) isWash
{
    StoreEntity* currStore =[CacheManagement instance].currentStore;
    LoginResultEntity* currUser =[CacheManagement instance].currentUser;
    NSString * workMainId = [Utilities GetUUID]; //生成随随机字符串
    NSString * _vmPairIssueId = [Utilities GetUUID];
    NSString * _currentTime = [Utilities DateTimeNow];
    XMLWriter *_write =[[[XMLWriter alloc] init] autorelease] ;    
    
    _write =[self createStoreXml:_write  workMainId:workMainId  currStore:currStore currUser:currUser currentTime:_currentTime];
    
    //IST_SER_VM_REPAIR_ISSUE
    [_write writeStartElement:@"IST_SER_AFTER_SALES_ISSUE"];
    [_write writeElement:@"AFTER_SALES_ISSUE_ID" eleVaule:_vmPairIssueId];
    [_write writeElement:@"SER_AFTER_SALES_ID" eleVaule:@""];
    
    [_write writeElement:@"STORE_ISSUE_CATEGORY_ID" eleVaule:issueCategoryID];
    [_write writeElement:@"STORE_ISSUE_ITEM_ID" eleVaule:issueItemID];
    [_write writeElement:@"PURCHASE_DATE" eleVaule:@""];
    
    [_write writeElement:@"IS_DAMAGE" eleVaule:[Utilities GetIntToString:isDamage]];
    [_write writeElement:@"IS_DRESSED" eleVaule:[Utilities GetIntToString:isDressed]];
    [_write writeElement:@"IS_WASH" eleVaule:[Utilities GetIntToString:isWash]];

    [_write writeElement:@"PRODUCT_CODE" eleVaule:prodCode];
    [_write writeElement:@"PRODUCT_NO" eleVaule:prodCode];
    [_write writeElement:@"PRODUCT_SIZE" eleVaule:prodSize];
    
    [_write writeElement:@"DESCRIPTION" eleVaule:issueRemark];
    [_write writeElement:@"PHOTO_NAME" eleVaule:@"0"];
    [_write writeElement:@"PHOTO_PATH" eleVaule:@"0"];
    [_write writeElement:@"STATUS" eleVaule:@"0"];
    [_write writeElement:@"SOLUTION" eleVaule:@""];
    [_write writeElement:@"REMARK" eleVaule:@""];
    [_write writeElement:@"CREATE_USER" eleVaule:currUser.UserId];
    [_write writeElement:@"CREATE_TIME" eleVaule:_currentTime];
    [_write writeElement:@"CLOSE_USER" eleVaule:@""];
    [_write writeElement:@"CLOSE_TIME" eleVaule:@""];
    [_write writeElement:@"LAST_MODIFIED_BY" eleVaule:@""];
    [_write writeElement:@"LAST_MODIFIED_TIME" eleVaule:@""];
    
    [_write writeEndElement:@"IST_SER_AFTER_SALES_ISSUE"];
    [_write writeEndElement:@"root"];
    return _write.toString;
}

//创建抽检呈报XML数据
- (NSString *) CreateServInspString:(NSString *) inspectionName
                        issueRemark:(NSString *) issueRemark
                           isDamage:(NSInteger) isTakeSample
                          isDressed:(NSInteger) isNeedReport
                             isWash:(NSInteger) isNeedDecl
                        productList:(NSMutableArray *)productList
{
    StoreEntity* currStore =[CacheManagement instance].currentStore;
    LoginResultEntity* currUser =[CacheManagement instance].currentUser;
    NSString * workMainId = [Utilities GetUUID]; //生成随随机字符串
    NSString * _vmPairIssueId = [Utilities GetUUID];
    NSString * _currentTime = [Utilities DateTimeNow];
    XMLWriter *_write =[[[XMLWriter alloc] init] autorelease] ;    
    
    _write =[self createStoreXml:_write  workMainId:workMainId  currStore:currStore currUser:currUser currentTime:_currentTime];

    //IST_SER_VM_REPAIR_ISSUE
    [_write writeStartElement:@"IST_SER_INSPECTION"];
    
    [_write writeElement:@"INSPECTION_ID" eleVaule:_vmPairIssueId];
    [_write writeElement:@"STORE_CODE" eleVaule:currStore.StoreCode];
    [_write writeElement:@"WORK_MAIN_ID" eleVaule:workMainId];
    [_write writeElement:@"WORK_DATE" eleVaule:_currentTime];
    [_write writeElement:@"WORK_START_TIME" eleVaule:_currentTime];
    [_write writeElement:@"WORK_END_TIME" eleVaule:_currentTime];
    [_write writeElement:@"INSPECTION_DEPT" eleVaule:inspectionName];
    [_write writeElement:@"DESCRIPTION" eleVaule:issueRemark];

    [_write writeElement:@"IS_TAKE_SAMPLE" eleVaule:[Utilities GetIntToString:isTakeSample]];
    [_write writeElement:@"IS_NEED_REPORT" eleVaule:[Utilities GetIntToString:isNeedReport]];
    [_write writeElement:@"IS_NEED_DECLARTION" eleVaule:[Utilities GetIntToString:isNeedDecl]];
    
    [_write writeElement:@"USER_SUBMIT_TIME" eleVaule:_currentTime];
    [_write writeElement:@"CLIENT_UPLOAD_TIME" eleVaule:_currentTime];
    [_write writeElement:@"SERVER_INSERT_TIME" eleVaule:@""];
    [_write writeElement:@"STATUS" eleVaule:@"0"];
    [_write writeElement:@"SOLUTION" eleVaule:@""];
    [_write writeElement:@"CLOSE_USER" eleVaule:currUser.UserId];
    [_write writeElement:@"CLOSE_TIME" eleVaule:@""];
    [_write writeElement:@"LAST_MODIFIED_BY" eleVaule:@""];
    [_write writeElement:@"LAST_MODIFIED_TIME" eleVaule:@""];
    [_write writeElement:@"USER_ID" eleVaule:currUser.UserId];
      
    
    [_write writeStartElement:@"IST_SER_INSPECTION_DETAILS"];
    //循环添加产品列表信息
    int count =[productList count];
    for(int i = 0; i < count; i++)
    {   
        IssueProductEntity *entity = [productList objectAtIndex:i];
        [_write writeStartElement:@"IST_SER_INSPECTION_DETAIL"];
        [_write writeElement:@"INSPECTION_DETAIL_ID" eleVaule:[Utilities GetUUID]];
        [_write writeElement:@"INSPECTION_ID" eleVaule:_vmPairIssueId];
        [_write writeElement:@"PRODUCT_CODE" eleVaule:entity.prodCode];
        [_write writeElement:@"PRODUCT_NAME" eleVaule:entity.prodName];
        [_write writeElement:@"PRODUCT_SIZE" eleVaule:entity.prodSize];
        [_write writeEndElement:@"IST_SER_INSPECTION_DETAIL"];
    }
    [_write writeEndElement:@"IST_SER_INSPECTION_DETAILS"];
    
    [_write writeEndElement:@"IST_SER_INSPECTION"];
    [_write writeEndElement:@"root"];
    return _write.toString;
}

// 创建活动报告xml
-(NSString*)CreateInstallCheckString:(NSArray*)array
                        WorkStartTime:(NSString*)workstarttime
                         WorkEndTime:(NSString*)endtime
                          CampaignID:(NSString*)Campaign_ID
                           StoreCode:(NSString*)storeCode
                          submittime:(NSString*)submittime
                            WorkDate:(NSString*)workdate
                              reason:(NSString*)reason
                             comment:(NSString*)comment

{
    StoreEntity* currStore =[CacheManagement instance].currentStore;
    LoginResultEntity* currUser =[CacheManagement instance].currentUser;
    NSString* _workMainId = [CacheManagement instance].currentWorkMainID;
    NSString * _currentTime = [Utilities DateTimeNow];
    XMLWriter *_write =[[[XMLWriter alloc] init] autorelease];
    _write = [self createStoreXml:_write workMainId:_workMainId currStore:currStore currUser:currUser currentTime:_currentTime];
    
    // FrCampInstalls
    [_write writeStartElement:@"FrCampInstalls"];
    [_write writeStartElement:@"FrCampInstall"];
    [_write writeElement:@"StoreCode" eleVaule:currStore.StoreCode];
    [_write writeElement:@"WorkMainId" eleVaule:_workMainId];
    [_write writeElement:@"UserId" eleVaule:currUser.UserId];
    [_write writeElement:@"WorkDate" eleVaule:workdate];
    [_write writeElement:@"WorkStartTime" eleVaule:workstarttime];
    [_write writeElement:@"WorkEndTime" eleVaule:endtime];
    [_write writeElement:@"CampaignId" eleVaule:Campaign_ID];
    [_write writeElement:@"UserSubmitTime" eleVaule:submittime];
    [_write writeElement:@"ClientUploadTime" eleVaule:submittime];
    [_write writeElement:@"Reason" eleVaule:reason];
    [_write writeElement:@"ReasonRemark" eleVaule:nil];
    [_write writeElement:@"Comment" eleVaule:comment];

    [_write writeStartElement:@"FrCampInstallDetails"];
    
    
    for (CampaignPopData *data in array) {
        
        NSString *savedStr = [NSString stringWithFormat:@"%@_%@_%@",[CacheManagement instance].currentUser.UserId,[CacheManagement instance].currentStore.StoreCode,data.campaign_id] ;
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] dictionaryForKey:savedStr];
        NSArray *sourceArray ;
        if (dic&&[[dic allKeys] containsObject:data.pop_id]) {
            sourceArray = [dic objectForKey:data.pop_id];
        }
        
        for (NSDictionary *dic in sourceArray) {
            
            [_write writeStartElement:@"FrCampInstallDetail"];
            [_write writeElement:@"PopId" eleVaule:data.pop_id];
            [_write writeElement:@"PhotoPath" eleVaule:[[[dic valueForKey:@"path"] componentsSeparatedByString:@"/"] lastObject]] ;
            
            NSString *remark = [dic valueForKey:@"comment"] ;
            if (!remark) remark = @"" ;
            [_write writeElement:@"Remark" eleVaule:remark];
            [_write writeEndElement:@"FrCampInstallDetail"];
        }
    }

    [_write writeEndElement:@"FrCampInstallDetails"];
    [_write writeEndElement:@"FrCampInstall"];
    [_write writeEndElement:@"FrCampInstalls"];
    [_write writeEndElement:@"root"];
    return _write.toString;
    
}

// 创建101项检查XML数据
-(NSString*)CreateRailcheckString:(NSArray*)array
                      WorkEndTime:(NSString*)endtime
                     FR_ARMSchkID:(NSString*)CHK_ID
                    WorkStartTime:(NSString*)workstarttime
                        StoreCode:(NSString*)storeCode
                       submittime:(NSString*)submittime
                         WorkDate:(NSString*)workdate
                       TotalScore:(NSString*)totalscore
{
    StoreEntity* currStore =[CacheManagement instance].currentStore;
    LoginResultEntity* currUser =[CacheManagement instance].currentUser;
    NSString* _workMainId = [CacheManagement instance].currentWorkMainID;
    NSString * _currentTime = [Utilities DateTimeNow];
    XMLWriter *_write =[[[XMLWriter alloc] init] autorelease];
    _write = [self createStoreXml:_write workMainId:_workMainId currStore:currStore currUser:currUser currentTime:_currentTime];
    
    //IstFrArmsChks
    [_write writeStartElement:@"IstFrArmsChks"];
        [_write writeStartElement:@"IstFrArmsChk"];
            [_write writeElement:@"ServerInsertTime" eleVaule:@""];
            [_write writeElement:@"WorkEndTime" eleVaule:_currentTime];
            [_write writeElement:@"WorkMainId" eleVaule:_workMainId];
            [_write writeElement:@"FrArmsChkId" eleVaule:CHK_ID];
            [_write writeElement:@"UserId" eleVaule:currUser.UserId];
            [_write writeElement:@"WorkStartTime" eleVaule:workstarttime];
            [_write writeElement:@"StoreCode" eleVaule:storeCode];
            [_write writeElement:@"ClientUploadTime" eleVaule:@""];
            [_write writeElement:@"UserSubmitTime" eleVaule:_currentTime];
            [_write writeElement:@"WorkDate" eleVaule:workdate];
            [_write writeElement:@"TotalScore" eleVaule:totalscore];
    
            [ _write writeStartElement:@"IstFrArmsChkItems"];
    
            // 从数据里循环添加评分结果
    for (CheckScoreEntity* entity in array)
    {
            [_write writeStartElement:@"IstFrArmsChkItem"];
            [_write writeElement:@"FrArmsChkId" eleVaule:entity.FR_ARMS_CHK_ID];
            [_write writeElement:@"PhotoPath1" eleVaule:[[entity.photo_path1 componentsSeparatedByString:@"/"] lastObject]];
            [_write writeElement:@"Reason" eleVaule:entity.reason];
            [_write writeElement:@"FrArmsItemId" eleVaule:entity.FR_ARMS_ITEM_ID];
            [_write writeElement:@"FrArmsChkItemId" eleVaule:entity.FR_ARMS_CHK_ITEM_ID];
            [_write writeElement:@"Score" eleVaule:[NSString  stringWithFormat:@"%d",(int)entity.score]];
            [_write writeElement:@"Comment" eleVaule:entity.comment];
            [_write writeElement:@"PhotoPath2" eleVaule:[[entity.photo_path2 componentsSeparatedByString:@"/"] lastObject]];
            [_write writeEndElement:@"IstFrArmsChkItem"];
    }
            [_write writeEndElement:@"IstFrArmsChkItems"];
        [_write writeEndElement:@"IstFrArmsChk"];
    [_write writeEndElement:@"IstFrArmsChks"];
    [_write writeEndElement:@"root"];
    return _write.toString;
}

// VM检查结果 上传
-(NSString*)CreateVMCheckString:(NSArray*)array
                    WorkEndTime:(NSString*)endtime
                      VM_CHK_ID:(NSString*)VM_CHK_ID
                  WorkStartTime:(NSString*)workstarttime
                      StoreCode:(NSString*)storeCode
                     submittime:(NSString*)submittime
                       WorkDate:(NSString*)workdate
                     TotalScore:(NSString*)totalscore
{
    StoreEntity* currStore =[CacheManagement instance].currentStore;
    LoginResultEntity* currUser =[CacheManagement instance].currentUser;
    NSString* _workMainId = [CacheManagement instance].currentWorkMainID;
    NSString * _currentTime = [Utilities DateTimeNow];
    XMLWriter* _write = [[[XMLWriter alloc]init]autorelease];
    _write = [self createStoreXml:_write workMainId:_workMainId currStore:currStore currUser:currUser currentTime:_currentTime];
    
    // VM_chks
    [_write writeStartElement:@"NvmIstVmChks"];
    [_write writeStartElement:@"NvmIstVmCheck"];
    [_write writeElement:@"VmChkId" eleVaule:VM_CHK_ID];
    [_write writeElement:@"StoreCode" eleVaule:storeCode];
    [_write writeElement:@"UserId" eleVaule:currUser.UserId];
    [_write writeElement:@"WorkMainId" eleVaule:_workMainId];
    [_write writeElement:@"WorkDate" eleVaule:workdate];
    [_write writeElement:@"WorkStartTime" eleVaule:workstarttime];
    [_write writeElement:@"WorkEndTime" eleVaule:workstarttime];
    [_write writeElement:@"TotalScore" eleVaule:totalscore];
    [_write writeElement:@"UserSubmitTime" eleVaule:submittime];
    [_write writeElement:@"ClientUploadTime" eleVaule:@""];
    [_write writeElement:@"ServerInsertTime" eleVaule:@""];
    
    [_write writeStartElement:@"NvmIstVmChkItems"];
    
    for (VMCheckScoreEntity* entity in array)
    {
        [_write writeStartElement:@"NvmIstVmCheckItem"];
        [_write writeElement:@"VmChkItemId" eleVaule:entity.VM_CHK_ITEM_ID];
        [_write writeElement:@"VmChkId" eleVaule:entity.VM_CHK_ID];
        [_write writeElement:@"ItemId" eleVaule:entity.ITEM_ID];
        [_write writeElement:@"Score" eleVaule:entity.SCORE];
        [_write writeElement:@"Reason" eleVaule:entity.REASON];
        [_write writeElement:@"Comment" eleVaule:entity.COMMENT];
        if (entity.PHOTO_PATH1 != nil) {
              NSString* path1 = [[entity.PHOTO_PATH1 componentsSeparatedByString:@"/"] lastObject];
            [_write writeElement:@"PhotoPath1" eleVaule:path1];
            
        }
        else
        {
            [_write writeElement:@"PhotoPath1" eleVaule:nil];
        }
        if (entity.PHOTO_PATH2 != nil) {
            NSString* path2 = [[entity.PHOTO_PATH2 componentsSeparatedByString:@"/"] lastObject];
            [_write writeElement:@"PhotoPath2" eleVaule:path2];
            
        }
        else
        {
            [_write writeElement:@"PhotoPath2" eleVaule:nil];

        }
        [_write writeEndElement:@"NvmIstVmCheckItem"];

    }
    [_write writeEndElement:@"NvmIstVmChkItems"];
    [_write writeEndElement:@"NvmIstVmCheck"];
    [_write writeEndElement:@"NvmIstVmChks"];
    [_write writeEndElement:@"root"];
    
    return _write.toString;
}

// StoreAudit检查结果 上传
-(NSString*)CreateStoreAuditCheckString:(NSArray*)array
                            WorkEndTime:(NSString*)endtime
                    STOREAUDIT_CHECK_ID:(NSString*)STOREAUDIT_CHK_ID
                          WorkStartTime:(NSString*)workstarttime
                              StoreCode:(NSString*)storeCode
                             submittime:(NSString*)submittime
                               WorkDate:(NSString*)workdate
                             TotalScore:(NSString*)totalscore
{
    StoreEntity* currStore =[CacheManagement instance].currentStore;
    LoginResultEntity* currUser =[CacheManagement instance].currentUser;
    NSString* _workMainId = [CacheManagement instance].currentWorkMainID;
    NSString * _currentTime = [Utilities DateTimeNow];
    XMLWriter* _write = [[[XMLWriter alloc]init]autorelease];
    _write = [self createStoreXml:_write workMainId:_workMainId currStore:currStore currUser:currUser currentTime:_currentTime];
    
    // VM_chks
    [_write writeStartElement:@"NvmIstStoreAuditChks"];
    [_write writeStartElement:@"NvmIstStoreAuditCheck"];
    [_write writeElement:@"StoreAuditChkId" eleVaule:STOREAUDIT_CHK_ID];
    [_write writeElement:@"StoreCode" eleVaule:storeCode];
    [_write writeElement:@"UserId" eleVaule:currUser.UserId];
    [_write writeElement:@"WorkMainId" eleVaule:_workMainId];
    [_write writeElement:@"WorkDate" eleVaule:workdate];
    [_write writeElement:@"WorkStartTime" eleVaule:workstarttime];
    [_write writeElement:@"WorkEndTime" eleVaule:workstarttime];
    [_write writeElement:@"UserSubmitTime" eleVaule:submittime];
    [_write writeElement:@"ClientUploadTime" eleVaule:@""];
    [_write writeElement:@"ServerInsertTime" eleVaule:@""];
    
    [_write writeStartElement:@"NvmIstStoreAuditChkItems"];
    
    for (VMAuditScoreEntity* entity in array)
    {
        [_write writeStartElement:@"NvmIstStoreAuditCheckItem"];
        [_write writeElement:@"StoreAuditChkItemId" eleVaule:entity.STOREAUDIT_CHECK_DETAIL_ID];
        [_write writeElement:@"StoreAuditChkId" eleVaule:entity.STOREAUDIT_CHECK_ID];
        [_write writeElement:@"ItemId" eleVaule:entity.ITEM_ID];
        [_write writeElement:@"CheckResult" eleVaule:[@"NA" isEqualToString:entity.CHECK_RESULT]?@"Y":entity.CHECK_RESULT]; //na项是满分 即为Y
        [_write writeElement:@"Comment" eleVaule:entity.COMMENT];
        
        [_write writeStartElement:@"NvmIstStoreAuditCheckPhotos"];
        for (VMStoreAuditPhotoEntity *photoEntity in entity.PHOTO_PATHS)
        {
            [_write writeStartElement:@"NvmIstStoreAuditCheckPhoto"];
            [_write writeElement:@"StoreAuditChkPhotoId" eleVaule:[Utilities GetUUID]];
            [_write writeElement:@"StoreAuditChkId" eleVaule:entity.STOREAUDIT_CHECK_ID];
            [_write writeElement:@"ItemId" eleVaule:entity.ITEM_ID];
           
            if (photoEntity.photoPath&&[photoEntity.photoPath isKindOfClass:[NSString class]]&&photoEntity.photoPath.length > 8) {
                NSString* path1 = [[photoEntity.photoPath componentsSeparatedByString:@"/"] lastObject];
                [_write writeElement:@"PhotoPath" eleVaule:path1];
            } else {
                [_write writeElement:@"PhotoPath" eleVaule:nil];
            }
            [_write writeElement:@"Comment" eleVaule:photoEntity.photoComment];
            [_write writeEndElement:@"NvmIstStoreAuditCheckPhoto"];

        }
        [_write writeEndElement:@"NvmIstStoreAuditCheckPhotos"];
        
        [_write writeEndElement:@"NvmIstStoreAuditCheckItem"];

    }
    [_write writeEndElement:@"NvmIstStoreAuditChkItems"];
    [_write writeEndElement:@"NvmIstStoreAuditCheck"];
    [_write writeEndElement:@"NvmIstStoreAuditChks"];
    [_write writeEndElement:@"root"];
    
    return _write.toString;
}

// ScoreCard 检查结果 上传
-(NSString*)CreateScoreCardCheckString:(NSArray *)array
                           WorkEndTime:(NSString *)endtime
                        ScoreCardChkId:(NSString *)ScoreCardChkId
                         WorkStartTime:(NSString *)workstarttime
                             StoreCode:(NSString *)storeCode
                            submittime:(NSString *)submittime
                              WorkDate:(NSString *)workdate
                             checkType:(NSString *)type
                            scoreArray:(NSArray *)score
                          commentArray:(NSArray *)comment
                              isAddWeb:(BOOL)add
           ClientUploadTimeForWorkMain:(NSString *)upoadtime
{
    StoreEntity* currStore =[CacheManagement instance].currentStore;
    LoginResultEntity* currUser =[CacheManagement instance].currentUser;
    NSString* _workMainId = [CacheManagement instance].currentWorkMainID;
    NSString * _currentTime = [Utilities DateTimeNow];
    XMLWriter* _write = [[[XMLWriter alloc]init]autorelease];
    _write = [self createStoreXml:_write workMainId:_workMainId currStore:currStore currUser:currUser currentTime:_currentTime];
    
    [_write writeStartElement:@"NvmIstScoreCardChks"];
    [_write writeStartElement:@"NvmIstScoreCardCheck"];
    [_write writeElement:@"ScoreCardChkId" eleVaule:ScoreCardChkId];
    [_write writeElement:@"StoreCode" eleVaule:storeCode];
    [_write writeElement:@"UserId" eleVaule:currUser.UserId];
    [_write writeElement:@"WorkMainId" eleVaule:_workMainId];
    [_write writeElement:@"WorkDate" eleVaule:workdate];
    [_write writeElement:@"WorkStartTime" eleVaule:workstarttime];
    [_write writeElement:@"WorkEndTime" eleVaule:workstarttime];
    [_write writeElement:@"UserSubmitTime" eleVaule:submittime];
    [_write writeElement:@"ClientUploadTime" eleVaule:upoadtime];
    [_write writeElement:@"ServerInsertTime" eleVaule:@""];
    [_write writeElement:@"Comment" eleVaule:@""];
    [_write writeElement:@"CheckType" eleVaule:type];
    [_write writeStartElement:@"NvmIstScoreCardChkItems"];
    
    for (VMScoreCardPhotoEntity* entity in array)
    {
        
        [_write writeStartElement:@"NvmIstScoreCardChkItem"];
        [_write writeElement:@"ScoreCardChkItemId" eleVaule:entity.SCORECARD_CHECK_PHOTO_ID];
        [_write writeElement:@"ScoreCardChkId" eleVaule:entity.SCORECARD_CHK_ID];
        [_write writeElement:@"ItemId" eleVaule:entity.SCORECARD_ITEM_ID];
        [_write writeElement:@"LastModifiedTime" eleVaule:_currentTime];
        [_write writeElement:@"LastModifiedBy" eleVaule:currUser.UserId];
        [_write writeElement:@"Comment" eleVaule:entity.COMMENT];
        [_write writeElement:@"PhotoZone" eleVaule:[[entity.PHOTO_ZONE_NAME_CN componentsSeparatedByString:@"_"] firstObject]];

        if (entity.PHOTO_PATH1&&![entity.PHOTO_PATH1 isEqualToString:@""]) {
            
            if (!entity.PHOTO_UPLOAD_PATH1||[entity.PHOTO_UPLOAD_PATH1 isEqual:[NSNull null]]||[entity.PHOTO_UPLOAD_PATH1 isEqualToString:@"0"]) {
                
                NSString* path1 = [[entity.PHOTO_PATH1 componentsSeparatedByString:@"/"] lastObject];
                [_write writeElement:@"PhotoPath1" eleVaule:path1];
            }
            else if ([entity.PHOTO_UPLOAD_PATH1 isEqualToString:@"1"]) {
                
                [_write writeElement:@"PhotoPath1" eleVaule:entity.PHOTO_WEB_PATH1];
            }
        }
        else if (add&&[entity.PHOTO_UPLOAD_PATH1 isEqualToString:@"1"]&&entity.PHOTO_WEB_PATH1&&![entity.PHOTO_WEB_PATH1 isEqualToString:@""]){
            
            [_write writeElement:@"PhotoPath1" eleVaule:entity.PHOTO_WEB_PATH1];
        }
        else {
            
            [_write writeElement:@"PhotoPath1" eleVaule:@""];
        }
        
        
        if ([type isEqualToString:@"Daily"]&&entity.PHOTO_PATH2&&![entity.PHOTO_PATH2 isEqualToString:@""]) {
            
            if (!entity.PHOTO_UPLOAD_PATH2||[entity.PHOTO_UPLOAD_PATH2 isEqual:[NSNull null]]||[entity.PHOTO_UPLOAD_PATH2 isEqualToString:@"0"]) {
                
                NSString* path1 = [[entity.PHOTO_PATH2 componentsSeparatedByString:@"/"] lastObject];
                [_write writeElement:@"PhotoPath2" eleVaule:path1];
            }
            else if ([entity.PHOTO_UPLOAD_PATH2 isEqualToString:@"1"]) {
                
                [_write writeElement:@"PhotoPath2" eleVaule:entity.PHOTO_WEB_PATH2];
            }
        }
        else if (add&&[type isEqualToString:@"Daily"]&&[entity.PHOTO_UPLOAD_PATH2 isEqualToString:@"1"]&&entity.PHOTO_WEB_PATH2&&![entity.PHOTO_WEB_PATH2 isEqualToString:@""]) {
            
            [_write writeElement:@"PhotoPath2" eleVaule:entity.PHOTO_WEB_PATH2];
        }
        else {
            
            [_write writeElement:@"PhotoPath2" eleVaule:@""];
        }
        
        [_write writeEndElement:@"NvmIstScoreCardChkItem"];
    }

    [_write writeEndElement:@"NvmIstScoreCardChkItems"];
    
    
    if ([type isEqualToString:@"Daily"]) {
        
        [_write writeStartElement:@"NvmIstScoreCardScores"];
        
        for (VmScoreCardScoreEntity *entity in score) {
            [_write writeStartElement:@"NvmIstScoreCardScore"];
            
            [_write writeElement:@"ScoreCardScoreId" eleVaule:[Utilities GetUUID]];
            [_write writeElement:@"ScoreCardChkId" eleVaule:ScoreCardChkId];
            [_write writeElement:@"ItemDetailId" eleVaule:entity.SCORECARD_ITEM_DETAIL_ID];
            [_write writeElement:@"LastModifiedTime" eleVaule:_currentTime];
            [_write writeElement:@"LastModifiedBy" eleVaule:currUser.UserId];
            [_write writeElement:@"Comment" eleVaule:entity.REMARK];
            [_write writeElement:@"Score" eleVaule:entity.STANDARD_SCORE];
            
            [_write writeEndElement:@"NvmIstScoreCardScore"];
        }
        
        [_write writeEndElement:@"NvmIstScoreCardScores"];
    }
    
    if ([type isEqualToString:@"Monthly"]) {
        
        [_write writeStartElement:@"NvmIstScoreCardComments"];
        
        for (VMIstScoreCardEntity *entity in comment) {
            [_write writeStartElement:@"NvmIstScoreCardComment"];
            
            [_write writeElement:@"ScoreCardCommentId" eleVaule:[Utilities GetUUID]];
            [_write writeElement:@"ScoreCardChkId" eleVaule:ScoreCardChkId];
            [_write writeElement:@"ItemId" eleVaule:entity.SCORECARD_ITEM_ID];
            [_write writeElement:@"LastModifiedTime" eleVaule:_currentTime];
            [_write writeElement:@"LastModifiedBy" eleVaule:currUser.UserId];
            [_write writeElement:@"Comment" eleVaule:entity.COMMENT];

            [_write writeEndElement:@"NvmIstScoreCardComment"];
        }
        
        [_write writeEndElement:@"NvmIstScoreCardComments"];
    }
    
    [_write writeEndElement:@"NvmIstScoreCardCheck"];
    [_write writeEndElement:@"NvmIstScoreCardChks"];
    [_write writeEndElement:@"root"];
    
    return _write.toString;
}

// VM visitstore 上传
-(NSString*)CreateVisteStoreString:(NSArray*)array
                       WorkEndTime:(NSString*)endtime
                           TAKE_ID:(NSString*)TAKE_ID
                     WorkStartTime:(NSString*)workstarttime
                         StoreCode:(NSString*)storeCode
                        submittime:(NSString*)submittime
                          WorkDate:(NSString*)workdate
{
    StoreEntity* currStore =[CacheManagement instance].currentStore;
    LoginResultEntity* currUser =[CacheManagement instance].currentUser;
    NSString* _workMainId = [CacheManagement instance].currentWorkMainID;
    NSString * _currentTime = [Utilities DateTimeNow];
    
    XMLWriter* _write = [[[XMLWriter alloc]init]autorelease];
    _write = [self createStoreXml:_write workMainId:_workMainId currStore:currStore currUser:currUser currentTime:_currentTime];
    [_write writeStartElement:@"NvmIstStorePhoto"];
    [_write writeStartElement:@"NvmIstStoreTakePhoto"];
    [_write writeElement:@"TakeId" eleVaule:TAKE_ID];
    [_write writeElement:@"StoreCode" eleVaule:storeCode];
    [_write writeElement:@"WorkMainId" eleVaule:_workMainId];
    [_write writeElement:@"WorkDate" eleVaule:workdate];
    [_write writeElement:@"WorkStartTime" eleVaule:workstarttime];
    [_write writeElement:@"WorkEndTime" eleVaule:workstarttime];
    [_write writeElement:@"UserSubmitTime" eleVaule:submittime];
    [_write writeElement:@"ClientUploadTime" eleVaule:@""];
    [_write writeElement:@"ServerInsertTime" eleVaule:@""];
    [_write writeElement:@"UserId" eleVaule:currUser.UserId];
    
    [_write writeStartElement:@"NvmIstStorePhotoList"];
    
    for (VisitStoreEntity* entity in array)
    {
        // before
        [_write writeStartElement:@"NvmIstPhoto"];
        [_write writeElement:@"IstStorePhotoListId" eleVaule:entity.IST_STORE_PHOTO_LIST_ID];
        [_write writeElement:@"TakeId" eleVaule:entity.TAKE_ID];
        [_write writeElement:@"StoreZone" eleVaule:entity.STORE_ZONE];
        [_write writeElement:@"PhotoType" eleVaule:@"before"];
        if ((entity.INITIAL_PHOTO_PATH != nil)&& [entity.INITIAL_PHOTO_PATH length] > 5 ){
            
            [_write writeElement:@"InitialPhotoPath" eleVaule:[[entity.INITIAL_PHOTO_PATH componentsSeparatedByString:@"/"] lastObject]];
            [_write writeElement:@"CompressPhotoPath" eleVaule:nil];
        }
        else
        {
            [_write writeElement:@"InitialPhotoPath" eleVaule:nil];
            [_write writeElement:@"CompressPhotoPath" eleVaule:nil];
        }
        [_write writeElement:@"Comment" eleVaule:entity.COMMENT];
        [_write writeElement:@"ServerInsertTime" eleVaule:entity.SERVER_INSERT_TIME];
        [_write writeEndElement:@"NvmIstPhoto"];
        
        
        
        // after
        [_write writeStartElement:@"NvmIstPhoto"];
        [_write writeElement:@"IstStorePhotoListId" eleVaule:entity.IST_STORE_PHOTO_LIST_ID];
        [_write writeElement:@"TakeId" eleVaule:entity.TAKE_ID];
        [_write writeElement:@"StoreZone" eleVaule:entity.STORE_ZONE];
        [_write writeElement:@"PhotoType" eleVaule:@"after"];
        if ((entity.COMPRESS_PHOTO_PATH != nil)&& [entity.COMPRESS_PHOTO_PATH length] > 5 ){
            [_write writeElement:@"InitialPhotoPath" eleVaule:[[entity.COMPRESS_PHOTO_PATH componentsSeparatedByString:@"/"] lastObject]];
            [_write writeElement:@"CompressPhotoPath" eleVaule:nil];
        }
        else
        {
            [_write writeElement:@"InitialPhotoPath" eleVaule:nil];
            [_write writeElement:@"CompressPhotoPath" eleVaule:nil];
        }
        [_write writeElement:@"Comment" eleVaule:entity.COMMENT];
        [_write writeElement:@"ServerInsertTime" eleVaule:entity.SERVER_INSERT_TIME];
        [_write writeEndElement:@"NvmIstPhoto"];
    }
    
    [_write writeEndElement:@"NvmIstStorePhotoList"];
    [_write writeEndElement:@"NvmIstStoreTakePhoto"];
    [_write writeEndElement:@"NvmIstStorePhoto"];
    [_write writeEndElement:@"root"];
    return _write.toString;
}


- (NSString *)CreateIssueTarckingWithItems:(NSArray *)items {
    
    XMLWriter* _write = [[[XMLWriter alloc]init]autorelease];
    [_write writeStartElement:@"root"];
    [_write writeStartElement:@"NvmIstIssuePhotoTrackings"];
    
    for (NSDictionary *dic in items)
    {
        [_write writeStartElement:@"NvmIstIssuePhotoTracking"];
        [_write writeElement:@"IstIssuePhotoListId" eleVaule:[NSString stringWithFormat:@"%@",[dic valueForKey:@"IST_ISSUE_PHOTO_LIST_ID"]]];
        [_write writeElement:@"ConfrimUser" eleVaule:[CacheManagement instance].currentUser.UserId];
        [_write writeElement:@"ConfrimTime" eleVaule:[Utilities DateTimeNow]];
        [_write writeElement:@"ConfrimComment" eleVaule:[NSString stringWithFormat:@"%@",[dic valueForKey:@"REMARK"]]];
        NSString *status = [dic valueForKey:@"TRACKING_STATUS"];
        if (!status||[status isEqual:[NSNull null]]||[status isEqualToString:@""]) {
            [_write writeElement:@"ConfirmResult" eleVaule:@"0"];
        } else {
            [_write writeElement:@"ConfirmResult" eleVaule:[NSString stringWithFormat:@"%@",[dic valueForKey:@"TRACKING_STATUS"]]];
        }
        [_write writeEndElement:@"NvmIstIssuePhotoTracking"];
    }
    [_write writeEndElement:@"NvmIstIssuePhotoTrackings"];
    [_write writeEndElement:@"root"];
    return _write.toString;
}


// VM issuePhoto 上传
-(NSString*)CreateIssuePhotoString:(NSArray*)array
                       WorkEndTime:(NSString*)endtime
                          CHECK_ID:(NSString*)CHECK_ID
                     WorkStartTime:(NSString*)workstarttime
                         StoreCode:(NSString*)storeCode
                        submittime:(NSString*)submittime
                          WorkDate:(NSString*)workdate
{
    StoreEntity* currStore =[CacheManagement instance].currentStore;
    LoginResultEntity* currUser =[CacheManagement instance].currentUser;
    NSString* _workMainId = [CacheManagement instance].currentWorkMainID;
    NSString * _currentTime = [Utilities DateTimeNow];
    
    XMLWriter* _write = [[[XMLWriter alloc]init]autorelease];
    _write = [self createStoreXml:_write workMainId:_workMainId currStore:currStore currUser:currUser currentTime:_currentTime];
    [_write writeStartElement:@"NvmIstIssuePhoto"];
    [_write writeStartElement:@"NvmIstIssueChk"];
    [_write writeElement:@"IssueCheckId" eleVaule:CHECK_ID];
    [_write writeElement:@"StoreCode" eleVaule:storeCode];
    [_write writeElement:@"WorkMainId" eleVaule:_workMainId];
    [_write writeElement:@"WorkDate" eleVaule:workdate];
    [_write writeElement:@"WorkStartTime" eleVaule:workstarttime];
    [_write writeElement:@"WorkEndTime" eleVaule:workstarttime];
    [_write writeElement:@"UserSubmitTime" eleVaule:submittime];
    [_write writeElement:@"ClientUploadTime" eleVaule:@""];
    [_write writeElement:@"ServerInsertTime" eleVaule:@""];
    [_write writeElement:@"UserId" eleVaule:currUser.UserId];
    
    [_write writeStartElement:@"NvmIstIssuePhotoList"];
    
    for (IssuePhotoEntity* entity in array)
    {
        // before
        [_write writeStartElement:@"NvmIstPhoto"];
        [_write writeElement:@"IstIssuePhotoListId" eleVaule:entity.IST_ISSUE_PHOTO_LIST_ID];
        [_write writeElement:@"IssueCheckId" eleVaule:entity.ISSUE_CHECK_ID];
        [_write writeElement:@"IssueZoneCode" eleVaule:entity.ISSUE_ZONE_CODE];
        [_write writeElement:@"IssueType" eleVaule:entity.ISSUE_TYPE];
        [_write writeElement:@"IsNeedTracking" eleVaule:entity.ISSUE_NEED_TRACKING];
        [_write writeElement:@"TrackingUserType" eleVaule:entity.TRACKING_USER_TYPE];
        [_write writeElement:@"PhotoType" eleVaule:@"before"];
        if ((entity.INITIAL_PHOTO_PATH != nil)&& [entity.INITIAL_PHOTO_PATH length] > 3 ){
            [_write writeElement:@"InitialPhotoPath" eleVaule:[[entity.INITIAL_PHOTO_PATH componentsSeparatedByString:@"/"] lastObject]];
            [_write writeElement:@"CompressPhotoPath" eleVaule:nil];
        } else {
            [_write writeElement:@"InitialPhotoPath" eleVaule:nil];
            [_write writeElement:@"CompressPhotoPath" eleVaule:nil];
        }
        [_write writeElement:@"Comment" eleVaule:entity.COMMENT];
        [_write writeElement:@"ServerInsertTime" eleVaule:entity.SERVER_INSERT_TIME];
        [_write writeEndElement:@"NvmIstPhoto"];
        
        
        // after
        [_write writeStartElement:@"NvmIstPhoto"];
        [_write writeElement:@"IstIssuePhotoListId" eleVaule:entity.IST_ISSUE_PHOTO_LIST_ID];
        [_write writeElement:@"IssueCheckId" eleVaule:entity.ISSUE_CHECK_ID];
        [_write writeElement:@"IssueZoneCode" eleVaule:entity.ISSUE_ZONE_CODE];
        [_write writeElement:@"IssueType" eleVaule:entity.ISSUE_TYPE];
        [_write writeElement:@"IsNeedTracking" eleVaule:entity.ISSUE_NEED_TRACKING];
        [_write writeElement:@"TrackingUserType" eleVaule:entity.TRACKING_USER_TYPE];
        [_write writeElement:@"PhotoType" eleVaule:@"after"];
        if ((entity.COMPRESS_PHOTO_PATH != nil)&& [entity.COMPRESS_PHOTO_PATH length] > 5 ){

            [_write writeElement:@"InitialPhotoPath" eleVaule:[[entity.COMPRESS_PHOTO_PATH componentsSeparatedByString:@"/"] lastObject]];
            [_write writeElement:@"CompressPhotoPath" eleVaule:nil];
        } else {
            [_write writeElement:@"InitialPhotoPath" eleVaule:nil];
            [_write writeElement:@"CompressPhotoPath" eleVaule:nil];
        }
        [_write writeElement:@"Comment" eleVaule:entity.COMMENT];
        [_write writeElement:@"ServerInsertTime" eleVaule:entity.SERVER_INSERT_TIME];
        [_write writeEndElement:@"NvmIstPhoto"];
    }
    [_write writeEndElement:@"NvmIstIssuePhotoList"];
    [_write writeEndElement:@"NvmIstIssueChk"];
    [_write writeEndElement:@"NvmIstIssuePhoto"];
    [_write writeEndElement:@"root"];
    return _write.toString;
}

//defective生成XML信息
- (NSString *) CreateDefectiveXmlStringWith:(NSString *)goodNo
                                andGoodSize:(NSString *)goodSize
                               andGoodCount:(NSString *)goodCount
                             andGoodBuyDate:(NSString *)goodBuyDate
                                   andJobNo:(NSString *)jobNo
                              andStorePhone:(NSString *)storePhone
                               andRequestor:(NSString *)requestor
                               andPostAddress:(NSString *)postAddress
                             andStoreLeader:(NSString *)storeLeader
                               andStoreMail:(NSString *)storeMail
                                andGoodType:(NSString *)goodType
                            andGoodDescribe:(NSString *)goodDescribe
                           andMiOrderNumber:(NSString *)miOrderNumber
                                  andAllPic:(NSArray *)pics
                                    andUser:(NSString *)account
                                 andOrderNo:(NSString *)orderno
                                andCaseDate:(NSString *)casedate
                               andIsSpecial:(NSString *)special
                                   andIsRBK:(NSString *)isRBK
{
    XMLWriter *_write =[[[XMLWriter alloc] init] autorelease] ;
    
    [_write writeStartElement:@"root"];
    
    [_write writeElement:@"UserId" eleVaule:account];
    [_write writeElement:@"CaseDate" eleVaule:casedate];
    [_write writeElement:@"StoreCode" eleVaule:account];
    [_write writeElement:@"ArticleNo" eleVaule:goodNo];
    [_write writeElement:@"ArticleQuantity" eleVaule:goodCount];
    [_write writeElement:@"ArticleSize" eleVaule:goodSize];
    [_write writeElement:@"CaseComment" eleVaule:goodDescribe];
    [_write writeElement:@"CaseNumber" eleVaule:orderno];
    [_write writeElement:@"CaseTitle" eleVaule:[[goodType componentsSeparatedByString:@" - "] lastObject]];
    [_write writeElement:@"CaseTitleType" eleVaule:[[goodType componentsSeparatedByString:@" - "] firstObject]];
    [_write writeElement:@"SalesDate" eleVaule:goodBuyDate];
    [_write writeElement:@"Requestor" eleVaule:requestor];
    [_write writeElement:@"PostAddress" eleVaule:postAddress];
    [_write writeElement:@"StoreEmail" eleVaule:storeMail];
    [_write writeElement:@"StoreManagePhone" eleVaule:storeLeader];
    [_write writeElement:@"StorePhone" eleVaule:storePhone];
    [_write writeElement:@"WorkNumber" eleVaule:jobNo];
    [_write writeElement:@"IsSpecial" eleVaule:special];
    [_write writeElement:@"IsRBK" eleVaule:isRBK];
    [_write writeElement:@"MiOrderNumber" eleVaule:miOrderNumber?miOrderNumber:@""];
    
    [_write writeStartElement:@"articlephotos"];
    
    for (int i = 0 ; i < [pics count] ; i++) {
        
        NSString *position = [NSString stringWithFormat:@"%d",i] ;
        
        id oj = [pics objectAtIndex:i];
        
        if ([oj isKindOfClass:[NSString class]]) {
            
            [_write writeStartElement:@"articlephoto"];
            [_write writeElement:@"Smallpictureurl" eleVaule:[[[pics objectAtIndex:i] componentsSeparatedByString:@"/"] lastObject]];
            
            NSString *bigPic = [pics objectAtIndex:i];
            
            if (![bigPic isEqualToString:@""]) bigPic = [NSString stringWithFormat:@"%@.jpg",[[[[[pics objectAtIndex:i] componentsSeparatedByString:@"_s"] firstObject] componentsSeparatedByString:@"/"] lastObject]] ;
            
            [_write writeElement:@"pictureurl" eleVaule:bigPic];
            [_write writeElement:@"isshow" eleVaule:position];
            [_write writeEndElement:@"articlephoto"];
        }
        
        if ([oj isKindOfClass:[NSDictionary class]]) {
            
            [_write writeStartElement:@"articlephoto"];
            [_write writeElement:@"pictureurl" eleVaule:[[pics objectAtIndex:i] valueForKey:@"PictureUrl"]];
            [_write writeElement:@"Smallpictureurl" eleVaule:[[pics objectAtIndex:i] valueForKey:@"SmallPictureUrl"]];
            [_write writeElement:@"isshow" eleVaule:position];
            [_write writeEndElement:@"articlephoto"];
        }
    }
    
    [_write writeEndElement:@"articlephotos"];
    
    [_write writeEndElement:@"root"];
    
    return _write.toString;
}

//EC defective生成XML信息
- (NSString *) CreateECDefectiveXmlStringWith:(NSString *)caseTitle
                                 andExpressNo:(NSString *)expressNo
                                 andVideoName:(NSMutableArray *)videoNames
                                 andImageName:(NSMutableArray *)imageNames
                                      andUser:(NSString *)account
                                  andCaseDate:(NSString *)casedate
{
    XMLWriter *_write =[[[XMLWriter alloc] init] autorelease] ;
    
    [_write writeStartElement:@"root"];
    
    [_write writeElement:@"UserId" eleVaule:account];
    [_write writeElement:@"CaseDate" eleVaule:casedate];
    [_write writeElement:@"StoreCode" eleVaule:account];
    [_write writeElement:@"CaseComment" eleVaule:@""];
    [_write writeElement:@"CaseNumber" eleVaule:@""];
    [_write writeElement:@"CaseTitle" eleVaule:caseTitle];
    [_write writeElement:@"ExpressNo" eleVaule:expressNo];
    [_write writeElement:@"VideoName" eleVaule:@""];
    [_write writeStartElement:@"ImageNames"];
    for (NSString *path in imageNames) {
        [_write writeElement:@"AttachmentFile" eleVaule:[[path componentsSeparatedByString:@"/"].lastObject stringByReplacingOccurrencesOfString:@"_s" withString:@""]];
    }
    for (NSString *path in videoNames) {
        [_write writeElement:@"AttachmentFile" eleVaule:[path componentsSeparatedByString:@"/"].lastObject];
    }
    [_write writeEndElement:@"ImageNames"];
    [_write writeEndElement:@"root"];
    
    return _write.toString;
}
// RO issuePhoto 上传
-(NSString*)CreateROIssuePhotoString:(NSArray*)array
                         WorkEndTime:(NSString*)endtime
                            CHECK_ID:(NSString*)CHECK_ID
                       WorkStartTime:(NSString*)workstarttime
                           StoreCode:(NSString*)storeCode
                          submittime:(NSString*)submittime
                            WorkDate:(NSString*)workdate
{
    StoreEntity* currStore =[CacheManagement instance].currentStore;
    LoginResultEntity* currUser =[CacheManagement instance].currentUser;
    NSString* _workMainId = [CacheManagement instance].currentWorkMainID;
    NSString * _currentTime = [Utilities DateTimeNow];
    
    XMLWriter* _write = [[[XMLWriter alloc]init]autorelease];
    _write = [self createStoreXml:_write workMainId:_workMainId currStore:currStore currUser:currUser currentTime:_currentTime];
    [_write writeStartElement:@"IstFrIssuePhoto"];
    [_write writeStartElement:@"IstFrIssueChk"];
    [_write writeElement:@"IssueCheckId" eleVaule:CHECK_ID];
    [_write writeElement:@"StoreCode" eleVaule:storeCode];
    [_write writeElement:@"WorkMainId" eleVaule:_workMainId];
    [_write writeElement:@"WorkDate" eleVaule:workdate];
    [_write writeElement:@"WorkStartTime" eleVaule:workstarttime];
    [_write writeElement:@"WorkEndTime" eleVaule:workstarttime];
    [_write writeElement:@"UserSubmitTime" eleVaule:submittime];
    [_write writeElement:@"ClientUploadTime" eleVaule:@""];
    [_write writeElement:@"ServerInsertTime" eleVaule:@""];
    [_write writeElement:@"UserId" eleVaule:currUser.UserId];
    
    [_write writeStartElement:@"IstFrIssuePhotoList"];
    
    for (RoIssuePhotoEntity* entity in array)
    {
        // before
        [_write writeStartElement:@"FrIstPhoto"];
        [_write writeElement:@"IstIssuePhotoListId" eleVaule:entity.IST_ISSUE_PHOTO_LIST_ID];
        [_write writeElement:@"IssueCheckId" eleVaule:entity.ISSUE_CHECK_ID];
        [_write writeElement:@"IssueZoneCode" eleVaule:entity.ISSUE_ZONE_CODE];
        [_write writeElement:@"IssueZoneName" eleVaule:entity.ISSUE_ZONE_NAME];
        [_write writeElement:@"IssueZoneNameEn" eleVaule:entity.ISSUE_ZONE_NAME_EN];
        [_write writeElement:@"ResponsiblePerson" eleVaule:entity.RESPONSIBLE_PERSON];
        [_write writeElement:@"CompleteDate" eleVaule:entity.COMPLETE_DATE];
        [_write writeElement:@"IssueSolution" eleVaule:entity.ISSUE_SOLUTION];
        if ((entity.PHOTO_PATH1 != nil)&& [entity.PHOTO_PATH1 length] > 3 ){
            
            [_write writeElement:@"PhotoPath1" eleVaule:[[entity.PHOTO_PATH1 componentsSeparatedByString:@"/"] lastObject]];
        }
        else
        {
            [_write writeElement:@"PhotoPath1" eleVaule:nil];
        }
        
        if ((entity.PHOTO_PATH2 != nil)&& [entity.PHOTO_PATH2 length] > 3 ){
            
            [_write writeElement:@"PhotoPath2" eleVaule:[[entity.PHOTO_PATH2 componentsSeparatedByString:@"/"] lastObject]];
        }
        else
        {
            [_write writeElement:@"PhotoPath2" eleVaule:nil];
        }
        
        [_write writeElement:@"Comment" eleVaule:entity.COMMENT];
        [_write writeElement:@"ServerInsertTime" eleVaule:entity.SERVER_INSERT_TIME];
        [_write writeEndElement:@"FrIstPhoto"];
    }
    
    [_write writeEndElement:@"IstFrIssuePhotoList"];
    [_write writeEndElement:@"IstFrIssueChk"];
    [_write writeEndElement:@"IstFrIssuePhoto"];
    [_write writeEndElement:@"root"];
    return _write.toString;
}

- (NSString *)applyMain:(NSDictionary *)dict PicArr:(NSArray *)picArr CustomerCode:(NSString *)CustomerCode DesArr:(NSMutableArray *)desArr{
    
    XMLWriter *_write =[[[XMLWriter alloc] init] autorelease] ;
    [_write writeStartElement:@"root"];
    [_write writeStartElement:@"CaseHeader"];
    [_write writeElement:@"CustomerCode" eleVaule:CustomerCode];
    [_write writeElement:@"CaseNumber" eleVaule:@""];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyy/MM/dd";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    
    [_write writeElement:@"CaseDate" eleVaule:str];

    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        [_write writeElement:key eleVaule:obj];

    }];
    [_write writeStartElement:@"Pictures"];

    for (NSString *path in picArr) {
        
        [_write writeStartElement:@"Picture"];
        [_write writeElement:@"PictureUrl" eleVaule:[path componentsSeparatedByString:@"/"].lastObject];
        [_write writeEndElement:@"Picture"];

    }
    [_write writeEndElement:@"Pictures"];
    [_write writeStartElement:@"Articles"];

    for(NSDictionary *desDict in desArr){
        [_write writeStartElement:@"Article"];
        NSMutableDictionary * xmlDic = [self creatData];

        [xmlDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if (desDict[key]) {
                [_write writeElement:key eleVaule:desDict[key]];
            }else{
                [_write writeElement:key eleVaule:obj];
                }
        }];
        [_write writeStartElement:@"ArticlePictures"];
        NSArray *desPicArr =  desDict[@"ShoeArr"];
        for (NSString *desPath in desPicArr) {
            [_write writeStartElement:@"ArticlePicture"];

            [_write writeElement:@"ArticlePictureUrl" eleVaule:[desPath componentsSeparatedByString:@"/"].lastObject];
            [_write writeEndElement:@"ArticlePicture"];

        }
        [_write writeEndElement:@"ArticlePictures"];
        
        [_write writeEndElement:@"Article"];

    }
    [_write writeEndElement:@"Articles"];

    [_write writeEndElement:@"CaseHeader"];

    [_write writeEndElement:@"root"];
    NSLog(@"_write.toString:%@",_write.toString);
    return _write.toString;
}

// 人数检查 上传
-(NSString*)CreateHeadCountString:(NSArray*)array
                      WorkEndTime:(NSString*)endtime
                         CHECK_ID:(NSString*)CHECK_ID
                    WorkStartTime:(NSString*)workstarttime
                        StoreCode:(NSString*)storeCode
                       submittime:(NSString*)submittime
                         WorkDate:(NSString*)workdate
{
    StoreEntity* currStore =[CacheManagement instance].currentStore;
    LoginResultEntity* currUser =[CacheManagement instance].currentUser;
    NSString* _workMainId = [CacheManagement instance].currentWorkMainID;
    NSString * _currentTime = [Utilities DateTimeNow];
    
    XMLWriter* _write = [[[XMLWriter alloc]init]autorelease];
    _write = [self createStoreXml:_write workMainId:_workMainId currStore:currStore currUser:currUser currentTime:_currentTime];
    [_write writeStartElement:@"IstFrHeadCountChks"];
    [_write writeStartElement:@"IstFrHeadCountChk"];
    [_write writeElement:@"FrHeadCountChkId" eleVaule:CHECK_ID];
    [_write writeElement:@"StoreCode" eleVaule:storeCode];
    [_write writeElement:@"WorkMainId" eleVaule:_workMainId];
    [_write writeElement:@"WorkDate" eleVaule:workdate];
    [_write writeElement:@"WorkStartTime" eleVaule:workstarttime];
    [_write writeElement:@"WorkEndTime" eleVaule:workstarttime];
    [_write writeElement:@"UserSubmitTime" eleVaule:submittime];
    [_write writeElement:@"ClientUploadTime" eleVaule:@""];
    [_write writeElement:@"ServerInsertTime" eleVaule:@""];
    [_write writeElement:@"UserId" eleVaule:currUser.UserId];
    
    [_write writeStartElement:@"IstFrHeadCountChkItems"];
    
    for (FrHeadCountChkItemEntity* entity in array)
    {
        
        [_write writeStartElement:@"IstFrHeadCountChkItem"];
        [_write writeElement:@"FrHeadCountChkId" eleVaule:entity.FR_HEADCOUNT_CHK_ID];
        [_write writeElement:@"FrHeadCountItemId" eleVaule:entity.FR_HEADCOUNT_ITEM_ID];
        [_write writeElement:@"FrHeadCountChkItemId" eleVaule:entity.FR_HEADCOUNT_CHK_ITEM_ID];
        [_write writeElement:@"FrHeadCountChkItemValue" eleVaule:entity.RESULT];
        [_write writeElement:@"Comment" eleVaule:@""];
        [_write writeEndElement:@"IstFrHeadCountChkItem"];
    }
    
    [_write writeEndElement:@"IstFrHeadCountChkItems"];
    [_write writeEndElement:@"IstFrHeadCountChk"];
    [_write writeEndElement:@"IstFrHeadCountChks"];
    [_write writeEndElement:@"root"];
    return _write.toString;
}


// training 检查结果 上传
-(NSString*)CreateTrainingCheckString:(NSArray *)array
                          WorkEndTime:(NSString *)endtime
                       TrainingChkId:(NSString *)TrainingChkId
                        WorkStartTime:(NSString *)workstarttime
                            StoreCode:(NSString *)storeCode
                           submittime:(NSString *)submittime
                             WorkDate:(NSString *)workdate
                               result:(NVMTrainingCheckResultEntity *)result
          ClientUploadTimeForWorkMain:(NSString *)upoadtime
{
    StoreEntity* currStore =[CacheManagement instance].currentStore;
    LoginResultEntity* currUser =[CacheManagement instance].currentUser;
    NSString* _workMainId = [CacheManagement instance].currentWorkMainID;
    NSString * _currentTime = [Utilities DateTimeNow];
    XMLWriter* _write = [[[XMLWriter alloc]init]autorelease];
    _write = [self createStoreXml:_write workMainId:_workMainId currStore:currStore currUser:currUser currentTime:_currentTime];
    
    [_write writeStartElement:@"NvmIstTrainingPhoto"];
    [_write writeStartElement:@"NvmIstTrainingChk"];
    [_write writeElement:@"TrainingCheckId" eleVaule:TrainingChkId];
    [_write writeElement:@"StoreCode" eleVaule:storeCode];
    [_write writeElement:@"UserId" eleVaule:currUser.UserId];
    [_write writeElement:@"WorkMainId" eleVaule:_workMainId];
    [_write writeElement:@"WorkDate" eleVaule:workdate];
    [_write writeElement:@"WorkStartTime" eleVaule:workstarttime];
    [_write writeElement:@"WorkEndTime" eleVaule:workstarttime];
    [_write writeElement:@"UserSubmitTime" eleVaule:submittime];
    [_write writeElement:@"ClientUploadTime" eleVaule:upoadtime];
    [_write writeElement:@"ServerInsertTime" eleVaule:@""];
    [_write writeElement:@"TrainingType" eleVaule:result.TRAINING_TYPE];
    NSArray *students = [result.TRAIN_OBJECT JSONValue];
    NSString *object = @"" ;
    for (NSDictionary *dic in students) {
        if ([object isEqualToString:@""]) {
            object = [NSString stringWithFormat:@"%@-%@",[dic valueForKey:@"name"],[dic valueForKey:@"count"]];
        } else {
            object = [NSString stringWithFormat:@"%@;%@-%@",object,[dic valueForKey:@"name"],[dic valueForKey:@"count"]];
        }
    }
    [_write writeElement:@"TrainObject" eleVaule:object];
    [_write writeElement:@"TrainTitle" eleVaule:result.TRAIN_TITLE];
    NSArray *comments = [result.TRAIN_COMMENT JSONValue];
    [_write writeElement:@"TrainComment" eleVaule:[comments componentsJoinedByString:@","]];
    [_write writeElement:@"TraineeNumber" eleVaule:@"0"];
    [_write writeElement:@"TrainDate" eleVaule:result.TRAINEE_NUMBER];
    [_write writeElement:@"Trainer" eleVaule:result.TRAINER];
    [_write writeElement:@"REMARK" eleVaule:result.REMARK];
    [_write writeElement:@"TrainParticipant" eleVaule:result.TRAIN_PARTICIPANT];
    
    [_write writeStartElement:@"NvmIstTrainingPhotoList"];
    for (NVMTrainingCheckPhotoEntity* entity in array){
        [_write writeStartElement:@"NvmIstPhoto"];
        [_write writeElement:@"IstTrainingPhotoListId" eleVaule:entity.TRAINING_PHOTO_LIST_ID];
        [_write writeElement:@"TrainingCheckId" eleVaule:entity.TRAINING_CHECK_ID];
        
        if ([entity.PHOTO_TYPE isEqualToString:@"1"]) {
            [_write writeElement:@"PhotoType" eleVaule:@"课堂培训"];
        } else if ([entity.PHOTO_TYPE isEqualToString:@"2"]) {
            [_write writeElement:@"PhotoType" eleVaule:@"实操培训"];
        } else if ([entity.PHOTO_TYPE isEqualToString:@"3"]) {
            [_write writeElement:@"PhotoType" eleVaule:@"远程培训"];
        }
        
        [_write writeElement:@"PhotoPath" eleVaule:[[entity.PHOTO_PATH componentsSeparatedByString:@"/"] lastObject]];
        [_write writeElement:@"Comment" eleVaule:entity.COMMENT];
        [_write writeElement:@"ServerInsertTime" eleVaule:entity.LAST_MODIFIED_TIME];
        [_write writeEndElement:@"NvmIstPhoto"];
    }
    [_write writeEndElement:@"NvmIstTrainingPhotoList"];
    
    [_write writeEndElement:@"NvmIstTrainingChk"];
    [_write writeEndElement:@"NvmIstTrainingPhoto"];
    [_write writeEndElement:@"root"];
    
    return _write.toString;
}

-(NSString*)CreateOnSiteString:(NSArray*)array
                   WorkEndTime:(NSString*)endtime
                       CheckID:(NSString*)CheckId
                 WorkStartTime:(NSString*)workstarttime
                     StoreCode:(NSString*)storeCode
                    submittime:(NSString*)submittime
                      WorkDate:(NSString*)workdate
                AdjustmentMode:(NSString*)adjustmentMode{
    StoreEntity* currStore =[CacheManagement instance].currentStore;
    LoginResultEntity* currUser =[CacheManagement instance].currentUser;
    NSString* _workMainId = [CacheManagement instance].currentWorkMainID;
    NSString * _currentTime = [Utilities DateTimeNow];
    
    XMLWriter* _write = [[[XMLWriter alloc]init]autorelease];
    _write = [self createStoreXml:_write workMainId:_workMainId currStore:currStore currUser:currUser currentTime:_currentTime];
    [_write writeStartElement:@"NvmIstOnSiteChks"];
    [_write writeStartElement:@"NvmIstOnSiteCheck"];
    [_write writeElement:@"OnSiteChkId" eleVaule:CheckId];
    [_write writeElement:@"StoreCode" eleVaule:storeCode];
    [_write writeElement:@"WorkMainId" eleVaule:_workMainId];
    [_write writeElement:@"WorkDate" eleVaule:workdate];
    [_write writeElement:@"WorkStartTime" eleVaule:workstarttime];
    [_write writeElement:@"WorkEndTime" eleVaule:workstarttime];
    [_write writeElement:@"UserSubmitTime" eleVaule:submittime];
    [_write writeElement:@"ClientUploadTime" eleVaule:@""];
    [_write writeElement:@"ServerInsertTime" eleVaule:@""];
    [_write writeElement:@"UserId" eleVaule:currUser.UserId];
    [_write writeElement:@"AdjustmentMode" eleVaule:adjustmentMode];
    
    [_write writeStartElement:@"NvmIstOnSiteChkItems"];
    
    for (OnSiteEntity* entity in array){
        [_write writeStartElement:@"NvmIstOnSiteCheckItem"];
        [_write writeElement:@"OnSiteChkItemId" eleVaule:entity.ONSITE_CHECK_DETAIL_ID];
        [_write writeElement:@"OnSiteChkId" eleVaule:entity.ONSITE_CHECK_ID];
        [_write writeElement:@"ZoneId" eleVaule:[entity.ZONE_ID componentsSeparatedByString:@"_"].firstObject];
        if (entity.BEFORE_PHOTO_PATH&&
            ![entity.BEFORE_PHOTO_PATH isEqual:[NSNull null]]&&
            [entity.BEFORE_PHOTO_PATH length] > 5){
            [_write writeElement:@"BeforePhotoPath" eleVaule:[[entity.BEFORE_PHOTO_PATH componentsSeparatedByString:@"/"] lastObject]];
        } else {
            [_write writeElement:@"BeforePhotoPath" eleVaule:nil];
        }
        if (entity.AFTER_PHOTO_PATH&&
            ![entity.AFTER_PHOTO_PATH isEqual:[NSNull null]]&&
            [entity.AFTER_PHOTO_PATH length] > 5 ){
            [_write writeElement:@"AfterPhotoPath" eleVaule:[[entity.AFTER_PHOTO_PATH componentsSeparatedByString:@"/"] lastObject]];
        } else {
            [_write writeElement:@"AfterPhotoPath" eleVaule:nil];
        }
        [_write writeElement:@"Comment" eleVaule:entity.COMMENT];
        [_write writeElement:@"BeforeAdjustmentMode" eleVaule:entity.BEFORE_ADJUSTMENT_MODE];
        [_write writeElement:@"AfterAdjustmentMode" eleVaule:entity.AFTER_ADJUSTMENT_MODE];
        [_write writeEndElement:@"NvmIstOnSiteCheckItem"];
    }
    
    [_write writeEndElement:@"NvmIstOnSiteChkItems"];
    [_write writeEndElement:@"NvmIstOnSiteCheck"];
    [_write writeEndElement:@"NvmIstOnSiteChks"];
    [_write writeEndElement:@"root"];
    return _write.toString;
}

- (NSMutableDictionary *)creatData{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:@"" forKey:@"FactoryCode"];
    [dict setValue:@"" forKey:@"ArticleNo"];
    [dict setValue:@"" forKey:@"ArticleSize"];
    [dict setValue:@"" forKey:@"Number"];
    [dict setValue:@"" forKey:@"PoNumber"];
    [dict setValue:@"" forKey:@"IbpoNumber"];
    [dict setValue:@"" forKey:@"PasterNumber"];
    [dict setValue:@"" forKey:@"CartonSize"];
    [dict setValue:@"" forKey:@"ArticleChannel"];
    [dict setValue:@"" forKey:@"ArticleName"];
    [dict setValue:@"" forKey:@"ProductionDate"];
    [dict setValue:@"" forKey:@"PasterEancode"];
    [dict setValue:@"" forKey:@"ModelName"];
    [dict setValue:@"" forKey:@"Gender"];
    [dict setValue:@"" forKey:@"Category"];
    [dict setValue:@"" forKey:@"Color"];
    [dict setValue:@"" forKey:@"UpperMaterial"];
    [dict setValue:@"" forKey:@"ShowWidth"];
    [dict setValue:@"" forKey:@"ExecutiveStandards"];
    [dict setValue:@"" forKey:@"OutsoleType"];
    [dict setValue:@"" forKey:@"SecurityCategory"];
    [dict setValue:@"" forKey:@"ArticleGrade"];
    [dict setValue:@"" forKey:@"MaterialComposition"];
    [dict setValue:@"" forKey:@"Attention"];
    [dict setValue:@"" forKey:@"CaseReason"];


    return dict;
}

@end
