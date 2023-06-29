//
//  CheckScoreEntity.m
//  ADIDAS
//
//  Created by wendy on 14-5-15.
//
//

#import "VMCheckScoreEntity.h"

@implementation VMCheckScoreEntity

//from local db
-(id) initWithFMResultSet:(FMResultSet*)rs
{
	if(self = [super init])
	{
        self.VM_CHK_ITEM_ID = [rs stringForColumn:@"VM_CHK_ITEM_ID"];
        self.VM_CHK_ID = [rs stringForColumn:@"VM_CHK_ID"];
        self.ITEM_ID = [rs stringForColumn:@"ITEM_ID"];
        self.SCORE = [rs stringForColumn:@"SCORE"];
        self.REASON = [rs stringForColumn:@"REASON"];
        self.COMMENT = [rs stringForColumn:@"COMMENT"];
        self.PHOTO_PATH1 = [rs stringForColumn:@"PHOTO_PATH1"];
        self.PHOTO_PATH2 = [rs stringForColumn:@"PHOTO_PATH2"];
        self.LAST_MODIFIED_BY = [rs stringForColumn:@"LAST_MODIFIED_BY"];
        self.LAST_MODIFIED_TIME = [rs stringForColumn:@"LAST_MODIFIED_TIME"];
	}
	return self;
}

@end
