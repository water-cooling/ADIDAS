//
//  XMLFileManagement.h
//  ADIDAS
//
//  Created by testing on 3/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NVMTrainingCheckResultEntity.h"

@interface XMLFileManagement : NSObject

//门店签到XML
- (NSString *) CreateCheckInXmlString;

//创建陈列报修XML
- (NSString *) CreateSerVMRepairString:(NSString *) issueCategoryID
                           issueItemID:(NSString *) issueItemID
                           issueRemark:(NSString *) issueRemark;
//创建活动问题XML数据
- (NSString *) CreateServCampaignString:(NSString *) issueCategoryID
                            issueItemID:(NSString *) issueItemID
                            issueRemark:(NSString *) issueRemark;
//创建售后服务XML数据
- (NSString *) CreateSalesServString:(NSString *) issueCategoryID
                         issueItemID:(NSString *) issueItemID
                         issueRemark:(NSString *) issueRemark
                            prodCode:(NSString *) prodCode
                            prodSize:(NSString *) prodSize
                            isDamage:(NSInteger) isDamage
                           isDressed:(NSInteger) isDressed
                              isWash:(NSInteger) isWash;

//创建抽检呈报XML数据
- (NSString *) CreateServInspString:(NSString *) inspectionName
                        issueRemark:(NSString *) issueRemark
                           isDamage:(NSInteger) isTakeSample
                          isDressed:(NSInteger) isNeedReport
                             isWash:(NSInteger) isNeedDecl
                        productList:(NSMutableArray *)productList;

// 101 检查XML 数据
-(NSString*)CreateRailcheckString:(NSArray*)array
                      WorkEndTime:(NSString*)endtime
                     FR_ARMSchkID:(NSString*)CHK_ID
                    WorkStartTime:(NSString*)workstarttime
                        StoreCode:(NSString*)storeCode
                       submittime:(NSString*)submittime
                         WorkDate:(NSString*)workdate
                       TotalScore:(NSString*)totalscore;
// 活动报告xml
-(NSString*)CreateInstallCheckString:(NSArray*)array
                       WorkStartTime:(NSString*)workstarttime
                         WorkEndTime:(NSString*)endtime
                          CampaignID:(NSString*)Campaign_ID
                           StoreCode:(NSString*)storeCode
                          submittime:(NSString*)submittime
                            WorkDate:(NSString*)workdate
                              reason:(NSString*)reason
                             comment:(NSString*)comment;
// VM

//创建VM检查xml数据

-(NSString*)CreateVMCheckString:(NSArray*)array
                    WorkEndTime:(NSString*)endtime
                      VM_CHK_ID:(NSString*)VM_CHK_ID
                  WorkStartTime:(NSString*)workstarttime
                      StoreCode:(NSString*)storeCode
                     submittime:(NSString*)submittime
                       WorkDate:(NSString*)workdate
                     TotalScore:(NSString*)totalscore;
// 创建 visitStore xml

-(NSString*)CreateVisteStoreString:(NSArray*)array
                       WorkEndTime:(NSString*)endtime
                           TAKE_ID:(NSString*)TAKE_ID
                     WorkStartTime:(NSString*)workstarttime
                         StoreCode:(NSString*)storeCode
                        submittime:(NSString*)submittime
                          WorkDate:(NSString*)workdate;


// VM issuePhoto 上传
-(NSString*)CreateIssuePhotoString:(NSArray*)array
                       WorkEndTime:(NSString*)endtime
                          CHECK_ID:(NSString*)CHECK_ID
                     WorkStartTime:(NSString*)workstarttime
                         StoreCode:(NSString*)storeCode
                        submittime:(NSString*)submittime
                          WorkDate:(NSString*)workdate;

//defective 上传
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
                                   andIsRBK:(NSString *)isRBK ;

//EC defective 上传
- (NSString *) CreateECDefectiveXmlStringWith:(NSString *)caseTitle
                                 andExpressNo:(NSString *)expressNo
                                 andVideoName:(NSMutableArray *)videoNames
                                 andImageName:(NSMutableArray *)imageNames
                                      andUser:(NSString *)account
                                  andCaseDate:(NSString *)casedate;
//scorecard 上传
-(NSString*)CreateScoreCardCheckString:(NSArray*)array
                           WorkEndTime:(NSString*)endtime
                        ScoreCardChkId:(NSString*)ScoreCardChkId
                         WorkStartTime:(NSString*)workstarttime
                             StoreCode:(NSString*)storeCode
                            submittime:(NSString*)submittime
                              WorkDate:(NSString*)workdate
                             checkType:(NSString*)type
                            scoreArray:(NSArray *)score
                          commentArray:(NSArray *)comment
                              isAddWeb:(BOOL)add
           ClientUploadTimeForWorkMain:(NSString *)upoadtime;

// RO issuePhoto 上传
-(NSString*)CreateROIssuePhotoString:(NSArray*)array
                         WorkEndTime:(NSString*)endtime
                            CHECK_ID:(NSString*)CHECK_ID
                       WorkStartTime:(NSString*)workstarttime
                           StoreCode:(NSString*)storeCode
                          submittime:(NSString*)submittime
                            WorkDate:(NSString*)workdate ;

// 人数检查 上传
-(NSString*)CreateHeadCountString:(NSArray*)array
                      WorkEndTime:(NSString*)endtime
                         CHECK_ID:(NSString*)CHECK_ID
                    WorkStartTime:(NSString*)workstarttime
                        StoreCode:(NSString*)storeCode
                       submittime:(NSString*)submittime
                         WorkDate:(NSString*)workdate ;

//training 上传
-(NSString*)CreateTrainingCheckString:(NSArray *)array
                WorkEndTime:(NSString *)endtime
             TrainingChkId:(NSString *)TrainingChkId
              WorkStartTime:(NSString *)workstarttime
                  StoreCode:(NSString *)storeCode
                 submittime:(NSString *)submittime
                   WorkDate:(NSString *)workdate
                     result:(NVMTrainingCheckResultEntity *)result
ClientUploadTimeForWorkMain:(NSString *)upoadtime;

-(NSString*)CreateStoreAuditCheckString:(NSArray*)array
                            WorkEndTime:(NSString*)endtime
                    STOREAUDIT_CHECK_ID:(NSString*)STOREAUDIT_CHK_ID
                          WorkStartTime:(NSString*)workstarttime
                              StoreCode:(NSString*)storeCode
                             submittime:(NSString*)submittime
                               WorkDate:(NSString*)workdate
                             TotalScore:(NSString*)totalscore;


-(NSString*)CreateOnSiteString:(NSArray*)array
                   WorkEndTime:(NSString*)endtime
                       CheckID:(NSString*)TAKE_ID
                 WorkStartTime:(NSString*)workstarttime
                     StoreCode:(NSString*)storeCode
                    submittime:(NSString*)submittime
                      WorkDate:(NSString*)workdate
                AdjustmentMode:(NSString*)adjustmentMode;

- (NSString *)CreateIssueTarckingWithItems:(NSArray *)items ;


- (NSString *)applyMain:(NSDictionary *)dict PicArr:(NSArray *)picArr CustomerCode:(NSString *)CustomerCode DesArr:(NSMutableArray *)desArr;
@end




