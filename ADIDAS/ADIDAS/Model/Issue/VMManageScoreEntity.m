//
//  ManageScoreData.m
//  ADIDAS
//
//  Created by wendy on 14-5-4.
//
//

#import "VMManageScoreEntity.h"

@implementation VMManageScoreEntity

static VMManageScoreEntity * _instance;

+(VMManageScoreEntity *)getinstance
{
	@synchronized(self){
		if (!_instance) {
			_instance = [[VMManageScoreEntity alloc] init];
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
    self.check_item_id = nil;
    self.picpath1 = nil;
    self.picpath2 = nil;
    self.reason = nil;
    self.LAST_MODIFIED_BY = nil;
    self.LAST_MODIFIED_TIME = nil;
}

@end
