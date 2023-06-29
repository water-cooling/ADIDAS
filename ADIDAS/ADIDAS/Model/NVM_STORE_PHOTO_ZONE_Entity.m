//
//  NVM_STORE_PHOTO_ZONE_Entity.m
//  VM
//
//  Created by wendy on 14-7-19.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import "NVM_STORE_PHOTO_ZONE_Entity.h"

@implementation NVM_STORE_PHOTO_ZONE_Entity

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        self.PHOTO_ZONE_CODE = [dictionary objectForKey:@"PHOTO_ZONE_CODE"];
        self.PHOTO_ZONE_NAME_CN = [dictionary objectForKey:@"PHOTO_ZONE_NAME_CN"];
        self.PHOTO_ZONE_NAME_EN = [dictionary objectForKey:@"PHOTO_ZONE_NAME_EN"];
        self.ORDER_NO = [[dictionary objectForKey:@"ORDER_NO"]integerValue];
        self.REMARK = [dictionary objectForKey:@"REMARK"];
        self.IS_DELETED = [[dictionary objectForKey:@"IS_DELETED"]integerValue];
        self.IS_MUST = [[dictionary objectForKey:@"IS_MUST"]integerValue];
        self.LAST_MODIFIED_BY = [dictionary objectForKey:@"LAST_MODIFIED_BY"];
        self.LAST_MODIFIED_TIME = [dictionary objectForKey:@"LAST_MODIFIED_TIME"];
        self.ZONE_TYPE = [[dictionary objectForKey:@"ZONE_TYPE"] integerValue];
        self.DATASOURCE = [dictionary objectForKey:@"DATASOURCE"];
    }
    return  self;
}

-(id) initWithFMResultSet:(FMResultSet*)rs
{
    if (self = [super init])
    {
        self.PHOTO_ZONE_CODE = [rs stringForColumn:@"PHOTO_ZONE_CODE"];
        self.PHOTO_ZONE_NAME_CN = [rs stringForColumn:@"PHOTO_ZONE_NAME_CN"];
        self.PHOTO_ZONE_NAME_EN = [rs stringForColumn:@"PHOTO_ZONE_NAME_EN"];
        self.ORDER_NO = [rs intForColumn:@"ORDER_NO"];
        self.REMARK = [rs stringForColumn:@"REMARK"];
        self.IS_DELETED = [rs intForColumn:@"IS_DELETED"];
        self.IS_MUST = [rs intForColumn:@"IS_MUST"];
        self.LAST_MODIFIED_BY = [rs stringForColumn:@"LAST_MODIFIED_BY"];
        self.LAST_MODIFIED_TIME = [rs stringForColumn:@"LAST_MODIFIED_TIME"];
        self.ZONE_TYPE = [rs intForColumn:@"ZONE_TYPE"];
        self.DATASOURCE = [rs stringForColumn:@"DATASOURCE"];
    }
    return  self;
}

@end
