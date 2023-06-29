//
//  NvmMstStoreAuditItemEntity.m
//  MobileApp
//
//  Created by 桂康 on 2018/7/13.
//

#import "NvmMstStoreAuditItemEntity.h"

@implementation NvmMstStoreAuditItemEntity

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        self.ITEM_ID = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"ITEM_ID"]];
        self.ITEM_NO = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"ITEM_NO"]];
        self.ITEM_NAME_CN = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"ITEM_NAME_CN"]];
        self.ITEM_NAME_EN = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"ITEM_NAME_EN"]];
        self.PARENT_ITEM_NO = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"PARENT_ITEM_NO"]];
        self.PARENT_ITEM_NAME_CN = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"PARENT_ITEM_NAME_CN"]];
        self.PARENT_ITEM_NAME_EN = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"PARENT_ITEM_NAME_EN"]];
        self.STANDARD_SCORE = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"STANDARD_SCORE"]];
        self.LAST_MODIFIED_BY = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"LAST_MODIFIED_BY"]];
        self.LAST_MODIFIED_TIME = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"LAST_MODIFIED_TIME"]];
        self.DATA_SOURCE = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"DATASOURCE"]];
        self.PHOTO_NUM = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"PHOTO_NUM"]];
        self.ITEM_STATUS = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"ITEM_STATUS"]];
        self.ITEM_DESCRIPTION_CN = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"ITEM_DESCRIPTION_CN"]];
        self.ITEM_DESCRIPTION_EN = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"ITEM_DESCRIPTION_EN"]];
        self.SCORE_OPTION = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"SCORE_OPTION"]];
        self.MUST_COMMENT = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"MUST_COMMENT"]];
    }
    return  self;
}

-(id) initWithFMResultSet:(FMResultSet*)rs
{
    if (self = [super init])
    {
        self.ITEM_ID = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"ITEM_ID"]];
        self.ITEM_NO = [NSString stringWithFormat:@"%d",[rs intForColumn:@"ITEM_NO"]];
        self.ITEM_NAME_CN = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"ITEM_NAME_CN"]];
        self.ITEM_NAME_EN = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"ITEM_NAME_EN"]];
        self.PARENT_ITEM_NO = [NSString stringWithFormat:@"%d",[rs intForColumn:@"PARENT_ITEM_NO"]];
        self.PARENT_ITEM_NAME_CN = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"PARENT_ITEM_NAME_CN"]];
        self.PARENT_ITEM_NAME_EN = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"PARENT_ITEM_NAME_EN"]];
        self.STANDARD_SCORE = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"STANDARD_SCORE"]];
        self.LAST_MODIFIED_BY = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"LAST_MODIFIED_BY"]];
        self.LAST_MODIFIED_TIME = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"LAST_MODIFIED_TIME"]];
        self.DATA_SOURCE = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"DATA_SOURCE"]];
        self.PHOTO_NUM = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"PHOTO_NUM"]];
        self.ITEM_STATUS = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"ITEM_STATUS"]];
        self.ITEM_DESCRIPTION_CN = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"ITEM_DESCRIPTION_CN"]];
        self.ITEM_DESCRIPTION_EN = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"ITEM_DESCRIPTION_EN"]];
        self.SCORE_OPTION = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"SCORE_OPTION"]];
        self.CHECK_RESULT = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"CHECK_RESULT"]];
        self.MUST_COMMENT = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"MUST_COMMENT"]];
    }
    return  self;
}

@end
