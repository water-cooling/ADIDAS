//
//  VMIstScoreCardEntity.m
//  MobileApp
//
//  Created by 桂康 on 2017/10/26.
//

#import "VMIstScoreCardEntity.h"

@implementation VMIstScoreCardEntity

-(id) initWithFMResultSet:(FMResultSet*)rs
{
    if(self = [super init])
    {
        self.SCORECARD_CHECK_PHOTO_ID = [rs stringForColumn:@"SCORECARD_CHECK_PHOTO_ID"];
        self.SCORECARD_CHK_ID = [rs stringForColumn:@"SCORECARD_CHK_ID"];
        self.SCORECARD_ITEM_ID = [rs stringForColumn:@"SCORECARD_ITEM_ID"];
        self.COMMENT = [rs stringForColumn:@"COMMENT"];
        self.PHOTO_PATH1 = [rs stringForColumn:@"PHOTO_PATH1"];
        self.PHOTO_PATH2 = [rs stringForColumn:@"PHOTO_PATH2"];
        self.LAST_MODIFIED_BY = [rs stringForColumn:@"LAST_MODIFIED_BY"];
        self.LAST_MODIFIED_TIME = [rs stringForColumn:@"LAST_MODIFIED_TIME"];
    }
    return self;
}

@end
