//
//  ManageScoreData.m
//  ADIDAS
//
//  Created by wendy on 14-5-4.
//
//

#import "ManageScoreEntity.h"

@implementation ManageScoreEntity

static ManageScoreEntity * _instance;

+(ManageScoreEntity *)getinstance
{
	@synchronized(self){
		if (!_instance) {
			_instance = [[ManageScoreEntity alloc] init];
		}
	}
	
	return _instance;
}

-(void)cleanScore
{
    self.score = 3;
    self.comment = nil;
    self.item_id = nil;
    self.check_id = nil;
    self.check_item_id = nil;
    self.picpath1 = nil;
    self.picpath2 = nil;
    self.reason = nil;
}

@end
