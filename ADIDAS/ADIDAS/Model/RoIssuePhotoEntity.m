//
//  RoIssuePhotoEntity.m
//  MobileApp
//
//  Created by 桂康 on 2018/1/4.
//

#import "RoIssuePhotoEntity.h"

@implementation RoIssuePhotoEntity

-(id) initWithFMResultSet:(FMResultSet*)rs
{
    if (self = [super init])
    {
        self.IST_ISSUE_PHOTO_LIST_ID = [rs stringForColumn:@"IST_ISSUE_PHOTO_LIST_ID"];
        self.ISSUE_CHECK_ID = [rs stringForColumn:@"ISSUE_CHECK_ID"];
        self.ISSUE_ZONE_CODE = [rs stringForColumn:@"ISSUE_ZONE_CODE"];
        self.ISSUE_ZONE_NAME = [rs stringForColumn:@"ISSUE_ZONE_NAME"];
        self.RESPONSIBLE_PERSON = [rs stringForColumn:@"RESPONSIBLE_PERSON"];
        self.PHOTO_PATH1 = [rs stringForColumn:@"PHOTO_PATH1"];
        self.PHOTO_PATH2 = [rs stringForColumn:@"PHOTO_PATH2"];
        self.COMMENT = [rs stringForColumn:@"COMMENT"];
        self.SERVER_INSERT_TIME = [rs stringForColumn:@"SERVER_INSERT_TIME"];
        self.LAST_MODIFIED_BY = [rs stringForColumn:@"LAST_MODIFIED_BY"];
        self.LAST_MODIFIED_TIME = [rs stringForColumn:@"LAST_MODIFIED_TIME"];
        self.COMPLETE_DATE = [rs stringForColumn:@"COMPLETE_DATE"];
        self.ISSUE_ZONE_NAME_EN = [rs stringForColumn:@"ISSUE_ZONE_NAME_EN"];
        self.ISSUE_SOLUTION = [rs stringForColumn:@"ISSUE_SOLUTION"];
    }
    return  self;
}

@end
