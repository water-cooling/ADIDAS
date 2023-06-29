//
//  CheckScoreEntity.m
//  ADIDAS
//
//  Created by wendy on 14-5-15.
//
//

#import "CheckScoreEntity.h"

@implementation CheckScoreEntity

@synthesize FR_ARMS_CHK_ITEM_ID,FR_ARMS_CHK_ID,FR_ARMS_ITEM_ID,score,reason,comment,photo_path1,photo_path2;

//from local db
-(id) initWithFMResultSet:(FMResultSet*)rs
{
	if(self = [super init])
	{
        self.FR_ARMS_CHK_ITEM_ID = [rs stringForColumnIndex:0];
        self.FR_ARMS_CHK_ID = [rs stringForColumnIndex:1];
        self.FR_ARMS_ITEM_ID = [rs stringForColumnIndex:2];
        self.score = [rs intForColumnIndex:3];
        self.reason = [rs stringForColumnIndex:4];
        self.comment = [rs stringForColumnIndex:5];
        self.photo_path1 = [rs stringForColumnIndex:6];
        self.photo_path2 = [rs stringForColumnIndex:7];
	}
	return self;
}

@end
