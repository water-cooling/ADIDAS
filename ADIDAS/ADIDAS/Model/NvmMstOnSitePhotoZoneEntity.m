//
//  NvmMstOnSitePhotoZoneEntity.m
//  VM
//
//  Created by wendy on 14-7-19.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import "NvmMstOnSitePhotoZoneEntity.h"

@implementation NvmMstOnSitePhotoZoneEntity

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        self.ZONE_ID = [dictionary objectForKey:@"ZONE_ID"];
        self.ZONE_NAME_CN = [dictionary objectForKey:@"ZONE_NAME_CN"];
        self.ZONE_NAME_EN = [dictionary objectForKey:@"ZONE_NAME_EN"];
        self.PHOTO_NUM = [dictionary objectForKey:@"PHOTO_NUM"];
        self.ZONE_ORDER = [dictionary objectForKey:@"ZONE_ORDER"];
        self.ZONE_STATUS = [dictionary objectForKey:@"ZONE_STATUS"];
        self.LAST_MODIFIED_BY = [dictionary objectForKey:@"LAST_MODIFIED_BY"];
        self.LAST_MODIFIED_TIME = [dictionary objectForKey:@"ISSUE_TYPE"];
        self.DATA_SOURCE = [dictionary objectForKey:@"DATA_SOURCE"];
    }
    return  self;
}

- (id) initWithFMResultSet:(FMResultSet*)rs {
    if (self = [super init])
    {
        self.ZONE_ID_NEW = [rs stringForColumn:@"ZONE_ID_NEW"];
        if (!self.ZONE_ID_NEW||[self.ZONE_ID_NEW isEqual:[NSNull null]]||[self.ZONE_ID_NEW isEqualToString:@""]) {
            self.ZONE_ID = [rs stringForColumn:@"ZONE_ID"];
        } else {
            self.ZONE_ID = self.ZONE_ID_NEW;
        }
        self.ZONE_NAME_CN = [rs stringForColumn:@"ZONE_NAME_CN"];
        self.ZONE_NAME_EN = [rs stringForColumn:@"ZONE_NAME_EN"];
        self.PHOTO_NUM = [rs stringForColumn:@"PHOTO_NUM"];
        self.ZONE_ORDER = [rs stringForColumn:@"ZONE_ORDER"];
        self.ZONE_STATUS = [rs stringForColumn:@"ZONE_STATUS"];
        self.LAST_MODIFIED_BY = [rs stringForColumn:@"LAST_MODIFIED_BY"];
        self.LAST_MODIFIED_TIME = [rs stringForColumn:@"LAST_MODIFIED_TIME"];
        self.DATA_SOURCE = [rs stringForColumn:@"DATA_SOURCE"];
        self.BEFORE_PHOTO_PATH = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"BEFORE_PHOTO_PATH"]];
        self.AFTER_PHOTO_PATH = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"AFTER_PHOTO_PATH"]];
        self.BEFORE_ADJUSTMENT_MODE = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"BEFORE_ADJUSTMENT_MODE"]];
        self.AFTER_ADJUSTMENT_MODE = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"AFTER_ADJUSTMENT_MODE"]];
        self.COMMENT = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"COMMENT"]];
        if ([[self.ZONE_ID componentsSeparatedByString:@"_"] count] == 2) {
            self.ZONE_NAME_CN = [NSString stringWithFormat:@"%@_%@",self.ZONE_NAME_CN,[self.ZONE_ID componentsSeparatedByString:@"_"].lastObject];
            self.ZONE_NAME_EN = [NSString stringWithFormat:@"%@_%@",self.ZONE_NAME_EN,[self.ZONE_ID componentsSeparatedByString:@"_"].lastObject];
        }
    }
    return  self;
}

- (id)initWithFirstFMResultSet:(FMResultSet*)rs {
    
    if (self = [super init])
    {
        self.ZONE_ID = [rs stringForColumn:@"ZONE_ID"];
        self.ZONE_NAME_CN = [rs stringForColumn:@"ZONE_NAME_CN"];
        self.ZONE_NAME_EN = [rs stringForColumn:@"ZONE_NAME_EN"];
        self.PHOTO_NUM = [rs stringForColumn:@"PHOTO_NUM"];
        self.ZONE_ORDER = [rs stringForColumn:@"ZONE_ORDER"];
        self.ZONE_STATUS = [rs stringForColumn:@"ZONE_STATUS"];
        self.LAST_MODIFIED_BY = [rs stringForColumn:@"LAST_MODIFIED_BY"];
        self.LAST_MODIFIED_TIME = [rs stringForColumn:@"LAST_MODIFIED_TIME"];
        self.DATA_SOURCE = [rs stringForColumn:@"DATA_SOURCE"];
    }
    return  self;
}

@end
