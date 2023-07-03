//
//  CommonDefine.h
//  WSE
//
//  Created by dextrys on 3/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark -------------gridview tag-------------------
#define kSOLUTIONWORKMAINID @"SolutionWorkMainId"
#define kDBVERSION @"DataBaseVersion.plist"
#define kTitleLabelTag 200
#define PicWidth (PHONE_WIDTH-60)/4

#define kPicLabelTag 201
#define kRemarkLabelTag 202
//#define kDBVERSIONNUMBER 10 //线上的版本是10 发布版要改成18 ----------- 2021-04-12
#define kDBVERSIONNUMBER 18
#define kAUTOUPGRADE @"Y"
#define DEWIDTH  [UIScreen mainScreen].bounds.size.width
#define DEHEIGHT  [UIScreen mainScreen].bounds.size.height
#pragma mark -------------web interface-------------------


//服务器地址
//#define kWebRisesString             @"https://mbs-visit2-uat.adidas.com.cn/RisesSyncService.aspx?osType=iPhone&"
//#define kWebDataString              @"https://mbs-visit2-uat.adidas.com.cn/DataSyncService.aspx?osType=iPhone&"
//#define kWebMobileHeadString        @"https://mbs-visit2-uat.adidas.com.cn"
#define kWebDefectiveHeadString     @"https://mbs-defective-uat.adidas.com.cn"
//#define kWebDefectiveHeadString     @"https://mobiletest.adidas.com.cn"

//#define kWebDefectiveString         @"/OnLineDefectiveAPI/EGDataSync.ashx?Action="
//#define kWebECDefectiveString       @"/OnLineDefectiveAPI/ECDataSync.ashx?Action="
//#define kMOBILESOLUTIONVERSION      @"1.9.0"
//#define kCertName                   @"uat"
//#define kCertPass                   CFSTR("Joinone@0116")

#define kWebRisesString             @"https://mbs-visit2.adidas.com.cn/RisesSyncService.aspx?osType=iPhone&"
#define kWebDataString              @"https://mbs-visit2.adidas.com.cn/DataSyncService.aspx?osType=iPhone&"
#define kWebMobileHeadString        @"https://mbs-visit2.adidas.com.cn"
//#define kWebDefectiveHeadString     @"https://mbs-defective.adidas.com.cn"
#define kWebDefectiveString         @"/OnLineDefectiveAPI/EGDataSync.ashx?Action="
#define kWebECDefectiveString       @"/OnLineDefectiveAPI/ECDataSync.ashx?Action="
#define KWebEHDefectiveString @"/OnLineDefectiveAPI/EHDataSync.ashx?Action="
#define kMOBILESOLUTIONVERSION      @"1.9.3"
#define kCertName                   @"pro"
#define kCertPass                   CFSTR("Adidas@0417@")

// 正式地址
//#define kWebRisesString             @"https://mobile.adidas.com.cn/RisesSyncService.aspx?osType=iPhone&"
//#define kWebDataString              @"https://mobile.adidas.com.cn/DataSyncService.aspx?osType=iPhone&"
//#define kWebMobileHeadString        @"https://mobile.adidas.com.cn"
//#define kWebDefectiveHeadString     @"https://mobile.adidas.com.cn"
//#define kWebDefectiveString         @"/OnLineDefectiveAPI/EGDataSync.ashx?Action="
//#define kWebECDefectiveString       @"/OnLineDefectiveAPI/ECDataSync.ashx?Action="
//#define kMOBILESOLUTIONVERSION      @"1.9.2"

// VM
#define kStoreCheckOutSave          @"%@action=STORECHECKOUT&storeCode=%@&locationX=%@&locationY=%@&checkInTime=%@&workMainId=%@&account=%@&checkOutTime=&ActionType=en"
#define kLogOut                     @"%@action=USERLOGOUT&userAccount=%@&locationX=%@&locationY=%@&ActionType=en"
#define kGetVisitPlan               @"%@action=GETVISITPLAN&userId=%@&ActionType=en"
#define kGetVisitPlanNew            @"%@action=GETVISITPLANNEW&userId=%@&Lang=%@&ActionType=en"
#define kUpdateVisitPlan            @"%@action=UPDATEVISITPLAN&userAccount=%@&ActionType=en"
#define kUpdateVisitStore           @"%@action=UPDATEVISITSTORE&userAccount=%@&ActionType=en"
#define kGetFileList                @"%@action=GETFILELIST&account=%@&ActionType=en"
#define kGetVisitStore              @"%@action=GETVISITSTORE&userId=%@&ActionType=en"
#define kGetVisitStoreByStoreCode   @"%@action=GETVISITSTORE&userId=%@&storeName=%@&ActionType=en"
#define kGetStorePic                @"%@action=DOWNLOADSTOREPIC&account=%@&StoreCode=%@&ActionType=en"
#define kStoreSignIn                @"%@action=SIGNIN&account=%@&storeCode=%@&ActionType=en"
#define kUploadSignature            @"%@action=UPLOADSIGNATURE&account=%@&WorkMainId=%@&ActionType=en"
#define kUploadArsmSignature        @"%@action=UploadARSMSignature&account=%@&WorkMainId=%@&ActionType=en"
#define kStoreCheckIn               @"%@action=STORECHECKIN&account=%@&storeCode=%@&locationx=%@&locationy=%@&ActionType=en"
#define kStoreCheckOut              @"%@action=STORECHECKOUT&storeCode=%@&locationX=%@&locationY=%@&checkInTime=%@&checkOutTime=%@&workMainId=%@&account=%@&ActionType=en"
#define kGetVMStoreLastCheck        @"%@action=GETVMSTORELASTCHECK&storeCode=%@&account=%@&checkTime=%@&ActionType=en"
#define kGetStoreLastCheck          @"%@Action=GETSTORELASTCHECK&account=%@&ActionType=en"
#define kFindNearStore2String       @"%@action=FindNearStoreList&locationX=%@&locationY=%@&account=%@&clientVersion=%@&ActionType=en"
#define kFindStoreByCodeString      @"%@action=CheckStore&storeCode=%@&account=%@&clientVersion=%@&ActionType=en"
#define kGetNewTempStoreCodeString  @"%@action=GetNewTempStoreCode&account=%@&clientVersion=%@&ActionType=en"
#define kLoginString                @"%@action=userlogin&account=%@&password=%@&today=%@&iOSVersion=%@&clientVersion=%@&ActionType=en&AutoUpgrade=%@"
#define kReGetPasswordString        @"%@action=ReGetPassword&account=%@&language=CN&ActionType=en"
#define kChangePasswordString       @"%@action=ChangePassword&account=%@&oldPassword=%@&newPassword=%@&clientVersion=%@&ActionType=en"
#define kGetInstallList             @"%@action=GetVendorFrCamps&userId=%@&storeCode=%@&ActionType=en"
#define kGetPopList                 @"%@action=GETVENDORFRCAMPSPOP&userId=%@&storeCode=%@&campaignId=%@&ActionType=en"
#define kUploadStoreVisitString     @"%@action=UploadStoreVisitList&account=%@&clientVersion=%@&ActionType=en"
#define kUploadData                 @"%@action=UploadData&account=%@&ActionType=en"
#define kUploadDataNEW              @"%@action=UploadZIPData&account=%@&fileType=%@&ActionType=en"
#define kGetIgnoreItem              @"%@action=GETIGNOREITEM&account=%@&ActionType=en&storecode=%@"
#define kCanCheckIn                 @"%@action=StoreCanCheckIn&account=%@&storeCode=%@&ActionType=en"
#define kGetSyncVersionString       @"%@action=GetSyncVersion&account=%@&ActionType=en"
#define kGetDataByTableNameString   @"%@action=GetDataByTableName&TableName=%@&account=%@&ActionType=en"
#define kStoreTrackingByCheckDate   @"%@action=StoreTracking&storecode=%@&account=%@&checkdate=%@&ActionType=en"
#define kIssueTrackingByStoreCode   @"%@action=LASTSTOREISSUETRACKING&storecode=%@&account=%@&ActionType=en"


#pragma mark -------------Issue table-------------------

#define kSYNC_PARAMETER_VERSION     @"SYNC_PARAMETER_VERSION"
#define kSTORE_ISSUE_CATEGORY       @"STORE_ISSUE_CATEGORY"
#define kSTORE_ISSUE_ITEM           @"STORE_ISSUE_ITEM"

#define kNVM_SYNC_PARAMETER_VERSION     @"SYNC_PARAMETER_VERSION"
#define kNVM_STORE_PHOTO_ZONE           @"NVM_STORE_PHOTO_ZONE"
#define kNVM_ISSUE_PHOTO_ZONE           @"NVM_ISSUE_PHOTO_ZONE"
#define kNVM_VM_CHECK_ITEM              @"NVM_VM_CHECK_ITEM"

#pragma mark -------------xml的上传类型定义(fileType)-------------------
//上传文件的上传类型
//xml的上传类型定义(fileType)
#define kXmlFrCampaignTrk           @"XmlFrCampaignTrk"
#define kXmlOrCampaignTrk           @"XmlOrCampaignTrk"
#define kXmlFrPromotionTrk          @"XmlFrPromotionTrk"
#define kXmlFrCampExec              @"XmlFrCampExec"
#define kXmlFrInfoCollection        @"XmlFrInfoCollection"
#define kXmlFrKpiIncrease           @"XmlFrKpiIncrease"
#define kXmlFrPromExec              @"XmlFrPromExec"
#define kXmlFrCampInstall           @"XmlFrCampInstall"
#define kXmlFrPromInstall           @"XmlFrPromInstall"
#define kXmlFrRmsChk                @"XmlFrRmsChk"
#define kXmlFrStoreVisit            @"XmlFrStoreVisit"
#define kXmlFrVmChk                 @"XmlFrVmChk"
#define kXmlIssue                   @"XmlIssue"
#define kXmlOrAssChk                @"XmlOrAssChk"
#define kXmlOrCampExec              @"XmlOrCampExec"
#define kXmlOrInvChk                @"XmlOrInvChk"
#define kXmlOrVmChk                 @"XmlOrVmChk"
#define kXmlOrRmsChk                @"XmlOrRmsChk"
#define kXmlUploadIssue             @"XmlUploadIssue"
#define kXmlUploadCHK               @"XmlFrArmsChk"

//上传文件的上传类型
//xml的上传类型定义(fileType)
#define kIssueTrackingConfirm         @"IssueTrackingConfirm"
#define kFrXmlHeadCount               @"FrXmlHeadCount"
#define kFrXmlIssuePhoto              @"FrXmlIssuePhoto"
#define kVMXmlUploadCHK               @"NvmXmlCheckItem"
#define kVMXmlUploadAudit             @"NvmStoreAudit"
#define kVMXmlUploadOnSite            @"NvmOnSiteSupport"
#define kVMXmlUploadIssue             @"NvmXmlIssuePhoto"
#define kVMXmlUploadStore             @"NvmXmlVisitStore"
#define kVMXmlUploadTraining          @"NvmXmlTraining"
#define kVMXmlUploadScoreCard         @"NvmXmlScoreCard"
#define kVMXmlUploadScoreCardDaily    @"NvmXmlScoreCard_Daily"


//***********友盟事件**********
#define kUmAdidasOpenApp            @"adidas_OpenApp"
#define kUmAdidasUserLogin          @"adidas_UserLogin"
#define kUmAdidasUserLogOut         @"adidas_UserLogOut"
#define kUmAdidasCheckIn            @"adidas_CheckIn"
#define kUmAdidasGetStoreList       @"adidas_GetStoreList"
#define kUmAdidasChangePwd          @"adidas_ChangePwd"
#define kUmAdidasForgotPwd          @"adidas_ForgotPwd"
#define kUmAdidasAddStore           @"adidas_AddStore"
#define kUmAdidasStoreAudit         @"adidas_StoreAudit"

//*********************

#define kVMPicturePathString          @"%@/%@/%@/%@/%@.jpg"
#define kVM_Score_PicturePathString   @"%@/%@/%@/%@/%@.jpg"

#define kXmlPathString              @"%@/%@/%@/%@.xml"
#define kPicturePathString          @"%@/%@.jpg"
#define ALERTVIEW(x) { UIAlertView *av = [[UIAlertView alloc] initWithTitle:nil message:x delegate:self cancelButtonTitle:SYSLanguage?@"Sure": @"确定" otherButtonTitles: nil]; \
    [av show]; }
#define IOSVersion   [[[UIDevice currentDevice]systemVersion]floatValue]

typedef void(^ImageDeleteBlock) (NSInteger index);
typedef void(^ImageBigBlock) (NSInteger index);

@interface CommonDefine : NSObject

@end
