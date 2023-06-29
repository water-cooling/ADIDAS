//
//  VisitStoreEntity.m
//  VM
//
//  Created by leo.you on 14-8-1.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import "VisitStoreEntity.h"

@implementation VisitStoreEntity

-(id) initWithFMResultSet:(FMResultSet*)rs
{
    if (self = [super init])
    {
        self.IST_STORE_PHOTO_LIST_ID = [rs stringForColumn:@"IST_STORE_PHOTO_LIST_ID"];
        self.TAKE_ID = [rs stringForColumn:@"TAKE_ID"];
        self.STORE_ZONE = [rs stringForColumn:@"STORE_ZONE"];
        self.PHOTO_TYPE = [rs stringForColumn:@"PHOTO_TYPE"];
        self.INITIAL_PHOTO_PATH = [rs stringForColumn:@"INITIAL_PHOTO_PATH"];
        self.COMPRESS_PHOTO_PATH = [rs stringForColumn:@"COMPRESS_PHOTO_PATH"];
        self.COMMENT = [rs stringForColumn:@"COMMENT"];
        self.SERVER_INSERT_TIME = [rs stringForColumn:@"SERVER_INSERT_TIME"];
        self.LAST_MODIFIED_BY = [rs stringForColumn:@"LAST_MODIFIED_BY"];
        self.LAST_MODIFIED_TIME = [rs stringForColumn:@"LAST_MODIFIED_TIME"];
        self.order_no = [rs intForColumn:@"ORDER_NO"];
    }
    return  self;
}

@end
