//
//  FrHeadCountChkItemEntity.m
//  MobileApp
//
//  Created by 桂康 on 2018/7/13.
//

#import "FrHeadCountChkItemEntity.h"

@implementation FrHeadCountChkItemEntity

-(id) initWithFMResultSet:(FMResultSet*)rs
{
    if (self = [super init])
    {
        self.FR_HEADCOUNT_CHK_ITEM_ID = [rs stringForColumn:@"FR_HEADCOUNT_CHK_ITEM_ID"];
        self.FR_HEADCOUNT_CHK_ID = [rs stringForColumn:@"FR_HEADCOUNT_CHK_ID"];
        self.FR_HEADCOUNT_ITEM_ID = [rs stringForColumn:@"FR_HEADCOUNT_ITEM_ID"];
        self.RESULT = [rs stringForColumn:@"RESULT"];
    }
    return  self;
}

@end
