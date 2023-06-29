//
//  UploadFileEntity.m
//  VM
//
//  Created by leo.you on 14-8-7.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import "UploadFileEntity.h"

@implementation UploadFileEntity

-(id) initWithFMResultSet:(FMResultSet*)rs
{
    if (self = [super init])
    {
        self.STORE_CODE = [rs stringForColumn:@"STORE_CODE"];
        self.STORE_NAME = [rs stringForColumn:@"STORE_NAME"];
        self.CREATE_DATE = [rs stringForColumn:@"CREATE_DATE"];
        self.USER_ID = [rs stringForColumn:@"USER_ID"];
        
        self.PHOTO_PIC_PATH = [rs stringForColumn:@"PHOTO_PIC_PATH"];
        self.PHOTO_XML_PATH = [rs stringForColumn:@"PHOTO_XML_PATH"];
        
        self.ISSUE_XML_PATH = [rs stringForColumn:@"ISSUE_XML_PATH"];
        self.ISSUE_PIC_PATH = [rs stringForColumn:@"ISSUE_PIC_PATH"];
        
        self.CHECK_PIC_PATH = [rs stringForColumn:@"CHECK_PIC_PATH"];
        self.CHECK_XML_PATH = [rs stringForColumn:@"CHECK_XML_PATH"];
        
        self.SIGN_PATH = [rs stringForColumn:@"SIGN_PATH"];
        self.ARSMSIGN_PATH = [rs stringForColumn:@"ARSMSIGN_PATH"];
        
        self.RAILCHECK_PIC_PATH = [rs stringForColumn:@"RAILCHECK_PIC_PATH"];
        self.RAILCHECK_XML_PATH = [rs stringForColumn:@"RAILCHECK_XML_PATH"];
        
        self.INSTALL_PIC_PATH = [rs stringForColumn:@"INSTALL_PIC_PATH"];
        self.INSTALL_XML_PATH = [rs stringForColumn:@"INSTALL_XML_PATH"];
        
        self.SCORECARD_PIC_PATH = [rs stringForColumn:@"SCORECARD_PIC_PATH"];
        self.SCORECARD_XML_PATH = [rs stringForColumn:@"SCORECARD_XML_PATH"];
        
        self.SCORECARDDAILY_PIC_PATH = [rs stringForColumn:@"SCORECARDDAILY_PIC_PATH"];
        self.SCORECARDDAILY_XML_PATH = [rs stringForColumn:@"SCORECARDDAILY_XML_PATH"];
        
        self.RO_ISSUE_XML_PATH = [rs stringForColumn:@"RO_ISSUE_XML_PATH"];
        self.RO_ISSUE_PIC_PATH = [rs stringForColumn:@"RO_ISSUE_PIC_PATH"];
        
        self.HEADCOUNT_XML_PATH = [rs stringForColumn:@"HEADCOUNT_XML_PATH"];
        
        self.TRINING_XML_PATH = [rs stringForColumn:@"TRINING_XML_PATH"];
        self.TRINING_PIC_PATH = [rs stringForColumn:@"TRINING_PIC_PATH"];
        
        self.AUDIT_PIC_PATH = [rs stringForColumn:@"AUDIT_PIC_PATH"];
        self.AUDIT_XML_PATH = [rs stringForColumn:@"AUDIT_XML_PATH"];
        
        self.ONSITE_PIC_PATH = [rs stringForColumn:@"ONSITE_PIC_PATH"];
        self.ONSITE_XML_PATH = [rs stringForColumn:@"ONSITE_XML_PATH"];
        
        self.ISSUE_TRACKING_XML_PATH = [rs stringForColumn:@"ISSUE_TRACKING_XML_PATH"];
    }
    return  self;
}

@end
