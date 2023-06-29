//
//  IssuePhotoEntity.m
//  VM
//
//  Created by leo.you on 14-8-1.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import "IssuePhotoEntity.h"

@implementation IssuePhotoEntity

-(id) initWithFMResultSet:(FMResultSet*)rs
{
    if (self = [super init])
    {
        self.IST_ISSUE_PHOTO_LIST_ID = [rs stringForColumn:@"IST_ISSUE_PHOTO_LIST_ID"];
        self.ISSUE_CHECK_ID = [rs stringForColumn:@"ISSUE_CHECK_ID"];
        self.ISSUE_ZONE_CODE = [rs stringForColumn:@"ISSUE_ZONE_CODE"];
        self.ISSUE_TYPE = [rs stringForColumn:@"ISSUE_TYPE"];
        self.PHOTO_TYPE = [rs stringForColumn:@"PHOTO_TYPE"];
        self.INITIAL_PHOTO_PATH = [rs stringForColumn:@"INITIAL_PHOTO_PATH"];
        self.COMPRESS_PHOTO_PATH = [rs stringForColumn:@"COMPRESS_PHOTO_PATH"];
        self.COMMENT = [rs stringForColumn:@"COMMENT"];
        self.SERVER_INSERT_TIME = [rs stringForColumn:@"SERVER_INSERT_TIME"];
        self.LAST_MODIFIED_BY = [rs stringForColumn:@"LAST_MODIFIED_BY"];
        self.LAST_MODIFIED_TIME = [rs stringForColumn:@"LAST_MODIFIED_TIME"];
        self.order_no = [rs intForColumn:@"ORDER_NO"];
        self.TRACKING_USER_TYPE = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"TRACKING_USER_TYPE"]];
        self.ISSUE_NEED_TRACKING = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"ISSUE_NEED_TRACKING"]];
    }
    return  self;
}

@end
