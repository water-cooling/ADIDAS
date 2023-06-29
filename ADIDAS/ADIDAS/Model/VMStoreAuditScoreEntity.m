//
//  VMStoreAuditScoreEntity.m
//  ADIDAS
//
//  Created by wendy on 14-5-4.
//
//

#import "VMStoreAuditScoreEntity.h"

@implementation VMStoreAuditScoreEntity

static VMStoreAuditScoreEntity * _instance;

+(VMStoreAuditScoreEntity *)getinstance
{
	@synchronized(self){
		if (!_instance) {
			_instance = [[VMStoreAuditScoreEntity alloc] init];
		}
	}
	
	return _instance;
}

-(void)cleanScore
{
    self.score = nil ;
    self.comment = nil;
    self.item_id = nil;
    self.check_id = nil;
    self.check_detail_id = nil ;
    self.picArray = nil;
    self.LAST_MODIFIED_BY = nil;
    self.LAST_MODIFIED_TIME = nil;
}

@end
