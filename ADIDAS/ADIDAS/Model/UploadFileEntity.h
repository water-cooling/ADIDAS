//
//  UploadFileEntity.h
//  VM
//
//  Created by leo.you on 14-8-7.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"

@interface UploadFileEntity : NSObject

@property (strong,nonatomic) NSString* STORE_CODE;
@property (strong,nonatomic) NSString* CREATE_DATE;
@property (strong,nonatomic) NSString* STORE_NAME;
@property (strong,nonatomic) NSString* USER_ID;

@property (strong,nonatomic) NSString* PHOTO_PIC_PATH;
@property (strong,nonatomic) NSString* PHOTO_XML_PATH;

@property (strong,nonatomic) NSString* ISSUE_XML_PATH;
@property (strong,nonatomic) NSString* ISSUE_PIC_PATH;

@property (strong,nonatomic) NSString* CHECK_PIC_PATH;
@property (strong,nonatomic) NSString* CHECK_XML_PATH;

@property (strong,nonatomic) NSString* SIGN_PATH;
@property (strong,nonatomic) NSString* ARSMSIGN_PATH;

@property (strong,nonatomic) NSString* RAILCHECK_PIC_PATH;
@property (strong,nonatomic) NSString* RAILCHECK_XML_PATH;

@property (strong,nonatomic) NSString* INSTALL_PIC_PATH;
@property (strong,nonatomic) NSString* INSTALL_XML_PATH;

@property (strong,nonatomic) NSString* SCORECARD_PIC_PATH;
@property (strong,nonatomic) NSString* SCORECARD_XML_PATH;

@property (strong,nonatomic) NSString* SCORECARDDAILY_PIC_PATH;
@property (strong,nonatomic) NSString* SCORECARDDAILY_XML_PATH;

@property (strong,nonatomic) NSString* RO_ISSUE_XML_PATH;
@property (strong,nonatomic) NSString* RO_ISSUE_PIC_PATH;

@property (strong,nonatomic) NSString* HEADCOUNT_XML_PATH;

@property (strong,nonatomic) NSString* TRINING_XML_PATH ;
@property (strong,nonatomic) NSString* TRINING_PIC_PATH ;

@property (strong,nonatomic) NSString* AUDIT_XML_PATH ;
@property (strong,nonatomic) NSString* AUDIT_PIC_PATH ;

@property (strong,nonatomic) NSString* ONSITE_XML_PATH ;
@property (strong,nonatomic) NSString* ONSITE_PIC_PATH ;

@property (strong,nonatomic) NSString* ISSUE_TRACKING_XML_PATH;

-(id)initWithFMResultSet:(FMResultSet*)rs;

@end
