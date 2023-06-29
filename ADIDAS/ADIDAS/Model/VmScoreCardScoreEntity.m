//
//  VmScoreCardScoreEntity.m
//  MobileApp
//
//  Created by 桂康 on 2017/11/28.
//

#import "VmScoreCardScoreEntity.h"

@implementation VmScoreCardScoreEntity

@synthesize SCORECARD_CHECK_PHOTO_ID,SCORECARD_ITEM_DETAIL_ID,STANDARD_SCORE,REMARK,SCORECARD_ITEM_ID;


-(id) initWithFMResultSet:(FMResultSet*)rs
{
    if(self = [super init])
    {
        self.SCORECARD_CHECK_PHOTO_ID = [rs stringForColumn:@"SCORECARD_CHECK_PHOTO_ID"];
        self.SCORECARD_ITEM_DETAIL_ID = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"SCORECARD_ITEM_DETAIL_ID"]];
        self.STANDARD_SCORE = [rs stringForColumn:@"STANDARD_SCORE"];
        self.REMARK = [rs stringForColumn:@"REMARK"];
        self.SCORECARD_ITEM_ID = [rs stringForColumn:@"SCORECARD_ITEM_ID"];
    }
    return self;
}


@end
