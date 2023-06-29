//
//  VMManageCardEntity.m
//  MobileApp
//
//  Created by 桂康 on 2017/10/26.
//

#import "VMManageCardEntity.h"

@implementation VMManageCardEntity

static VMManageCardEntity * _instance;

+(VMManageCardEntity *)getinstance
{
    @synchronized(self){
        if (!_instance) {
            _instance = [[VMManageCardEntity alloc] init];
        }
    }
    
    return _instance;
}

-(void)cleanScore
{
    self.comment = nil;
    self.scorecard_item_id = nil;
    self.scorecard_check_id = nil;
    self.scorecard_check_photo_id = nil;
    self.picpath1 = nil;
    self.picpath2 = nil;
    self.reason = nil;
    self.LAST_MODIFIED_BY = nil;
    self.LAST_MODIFIED_TIME = nil;
}

@end
