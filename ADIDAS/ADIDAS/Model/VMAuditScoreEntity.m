//
//  VMAuditScoreEntity.m
//  ADIDAS
//
//  Created by wendy on 14-5-15.
//
//

#import "VMAuditScoreEntity.h"

@implementation VMAuditScoreEntity

//from local db
-(id) initWithFMResultSet:(FMResultSet*)rs
{
	if(self = [super init])
	{
        self.STOREAUDIT_CHECK_DETAIL_ID = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"STOREAUDIT_CHECK_DETAIL_ID"]];
        self.STOREAUDIT_CHECK_ID = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"STOREAUDIT_CHECK_ID"]];
        self.ITEM_ID = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"ITEM_ID"]];
        self.CHECK_RESULT = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"CHECK_RESULT"]];
        self.COMMENT = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"COMMENT"]];
        self.LAST_MODIFIED_BY = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"LAST_MODIFIED_BY"]];
        self.LAST_MODIFIED_TIME = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"LAST_MODIFIED_TIME"]];
        self.TOTAL = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"TOTAL"]];
        self.PHOTO_NUM = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"PHOTO_NUM"]];
        self.ITEM_NAME_EN = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"ITEM_NAME_EN"]];
        self.SCORE_OPTION = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"SCORE_OPTION"]];
	}
	return self;
}

@end
