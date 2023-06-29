//
//  FrIssuePhotoZoneEntity.m
//  MobileApp
//
//  Created by 桂康 on 2018/1/4.
//

#import "FrIssuePhotoZoneEntity.h"

@implementation FrIssuePhotoZoneEntity

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        self.ISSUE_ZONE_CODE = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"ISSUE_ZONE_CODE"]];
        self.ISSUE_ZONE_NAME_CN = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"ISSUE_ZONE_NAME_CN"]];
        self.ISSUE_ZONE_NAME_EN = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"ISSUE_ZONE_NAME_EN"]];
        self.ORDER_NO = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"ORDER_NO"]];
        self.REMARK = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"REMARK"]];
        self.IS_DELETED = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"IS_DELETED"]];
        self.IS_MUST = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"IS_MUST"]];
        self.ISSUE_TYPE = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"ISSUE_TYPE"]];
        self.LAST_MODIFIED_BY = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"LAST_MODIFIED_BY"]];
        self.LAST_MODIFIED_TIME = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"LAST_MODIFIED_TIME"]];
        self.DATASOURCE = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"DATA_SOURCE"]];
    }
    return  self;
}

-(id) initWithFMResultSet:(FMResultSet*)rs
{
    if (self = [super init])
    {
        self.ISSUE_ZONE_CODE = [rs stringForColumn:@"ISSUE_ZONE_CODE"];
        self.ISSUE_ZONE_NAME_CN = [rs stringForColumn:@"ISSUE_ZONE_NAME_CN"];
        self.ISSUE_ZONE_NAME_EN = [rs stringForColumn:@"ISSUE_ZONE_NAME_EN"];
        self.ORDER_NO = [rs stringForColumn:@"ORDER_NO"];
        self.REMARK = [rs stringForColumn:@"REMARK"];
        self.IS_DELETED = [rs stringForColumn:@"IS_DELETED"];
        self.IS_MUST = [rs stringForColumn:@"IS_MUST"];
        self.ISSUE_TYPE = [rs stringForColumn:@"ISSUE_TYPE"];
        self.LAST_MODIFIED_BY = [rs stringForColumn:@"LAST_MODIFIED_BY"];
        self.LAST_MODIFIED_TIME = [rs stringForColumn:@"LAST_MODIFIED_TIME"];
        self.DATASOURCE = [rs stringForColumn:@"DATASOURCE"];
    }
    return  self;
}

@end
