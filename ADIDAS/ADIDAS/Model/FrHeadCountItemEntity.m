//
//  FrHeadCountItemEntity.m
//  MobileApp
//
//  Created by 桂康 on 2018/7/13.
//

#import "FrHeadCountItemEntity.h"

@implementation FrHeadCountItemEntity

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        self.FR_HEADCOUNT_ITEM_ID = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"FR_HEADCOUNT_ITEM_ID"]];
        self.ITEM_NO = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"ITEM_NO"]];
        self.ITEM_NAME_CN = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"ITEM_NAME_CN"]];
        self.ITEM_NAME_EN = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"ITEM_NAME_EN"]];
        self.IS_DELETED = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"IS_DELETED"]];
        self.ITEM_TYPE = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"ITEM_TYPE"]];
        self.DATA_SOURCE = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"DATA_SOURCE"]];
        self.LAST_MODIFIED_BY = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"LAST_MODIFIED_BY"]];
        self.LAST_MODIFIED_TIME = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"LAST_MODIFIED_TIME"]];
        self.IS_MUST = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"IS_MUST"]];
        self.SUMMARY_ITEM = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"SUMMARY_ITEM"]];
        self.VALIDATION = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"VALIDATION"]];
    }
    return  self;
}

-(id) initWithFMResultSet:(FMResultSet*)rs
{
    if (self = [super init])
    {
        self.FR_HEADCOUNT_ITEM_ID = [rs stringForColumn:@"FR_HEADCOUNT_ITEM_ID"];
        self.ITEM_NO = [rs stringForColumn:@"ITEM_NO"];
        self.ITEM_NAME_CN = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"ITEM_NAME_CN"]];
        self.ITEM_NAME_EN = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"ITEM_NAME_EN"]];
        self.IS_DELETED = [rs stringForColumn:@"IS_DELETED"];
        self.ITEM_TYPE = [rs stringForColumn:@"ITEM_TYPE"];
        self.DATA_SOURCE = [rs stringForColumn:@"DATA_SOURCE"];
        self.LAST_MODIFIED_BY = [rs stringForColumn:@"LAST_MODIFIED_BY"];
        self.LAST_MODIFIED_TIME = [rs stringForColumn:@"LAST_MODIFIED_TIME"];
        self.IS_MUST = [rs stringForColumn:@"IS_MUST"];
        self.SUMMARY_ITEM = [rs stringForColumn:@"SUMMARY_ITEM"];
        self.VALIDATION = [rs stringForColumn:@"VALIDATION"];
    }
    return  self;
}

@end
