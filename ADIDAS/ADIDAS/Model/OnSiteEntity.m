//
//  OnSiteEntity.m
//  VM
//
//  Created by leo.you on 14-8-1.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import "OnSiteEntity.h"

@implementation OnSiteEntity

- (id) initWithFMResultSet:(FMResultSet*)rs {
    if (self = [super init]) {
        self.ONSITE_CHECK_ID = [rs stringForColumn:@"ONSITE_CHECK_ID"];
        self.ONSITE_CHECK_DETAIL_ID = [rs stringForColumn:@"ONSITE_CHECK_DETAIL_ID"];
        self.ZONE_ID = [rs stringForColumn:@"ZONE_ID"];
        self.BEFORE_PHOTO_PATH = [rs stringForColumn:@"BEFORE_PHOTO_PATH"];
        self.AFTER_PHOTO_PATH = [rs stringForColumn:@"AFTER_PHOTO_PATH"];
        self.BEFORE_ADJUSTMENT_MODE = [rs stringForColumn:@"BEFORE_ADJUSTMENT_MODE"];
        self.AFTER_ADJUSTMENT_MODE = [rs stringForColumn:@"AFTER_ADJUSTMENT_MODE"];
        self.COMMENT = [rs stringForColumn:@"COMMENT"];
        self.LAST_MODIFIED_BY = [rs stringForColumn:@"LAST_MODIFIED_BY"];
        self.LAST_MODIFIED_TIME = [rs stringForColumn:@"LAST_MODIFIED_TIME"];
    }
    return  self;
}

@end
