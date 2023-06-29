//
//  NVM_ISSUE_PHOTO_ZONE_Entity.m
//  VM
//
//  Created by wendy on 14-7-19.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import "NVM_ISSUE_PHOTO_ZONE_Entity.h"

@implementation NVM_ISSUE_PHOTO_ZONE_Entity

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        self.ISSUE_ZONE_CODE = [dictionary objectForKey:@"ISSUE_ZONE_CODE"];
        self.ISSUE_ZONE_NAME_CN = [dictionary objectForKey:@"ISSUE_ZONE_NAME_CN"];
        self.ISSUE_ZONE_NAME_EN = [dictionary objectForKey:@"ISSUE_ZONE_NAME_EN"];
        self.ORDER_NO = [[dictionary objectForKey:@"ORDER_NO"]integerValue];
        self.REMARK = [dictionary objectForKey:@"REMARK"];
        self.IS_DELETED = [[dictionary objectForKey:@"IS_DELETED"]integerValue];
        self.IS_MUST = [[dictionary objectForKey:@"IS_MUST"]integerValue];
        self.ISSUE_TYPE = [dictionary objectForKey:@"ISSUE_TYPE"];
        self.LAST_MODIFIED_BY = [dictionary objectForKey:@"LAST_MODIFIED_BY"];
        self.LAST_MODIFIED_TIME = [dictionary objectForKey:@"LAST_MODIFIED_TIME"];
        self.DATASOURCE = [dictionary objectForKey:@"DATA_SOURCE"];
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
        self.ORDER_NO = [rs intForColumn:@"ORDER_NO"];
        self.REMARK = [rs stringForColumn:@"REMARK"];
        self.IS_DELETED = [rs intForColumn:@"IS_DELETED"];
        self.IS_MUST = [rs intForColumn:@"IS_MUST"];
        self.ISSUE_TYPE = [rs stringForColumn:@"ISSUE_TYPE"];
        self.LAST_MODIFIED_BY = [rs stringForColumn:@"LAST_MODIFIED_BY"];
        self.LAST_MODIFIED_TIME = [rs stringForColumn:@"LAST_MODIFIED_TIME"];
        self.DATASOURCE = [rs stringForColumn:@"DATASOURCE"];
    }
    return  self;
}

@end
