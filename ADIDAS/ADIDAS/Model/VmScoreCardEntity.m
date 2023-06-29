//
//  VmScoreCardEntity.m
//  MobileApp
//
//  Created by 桂康 on 2017/10/25.
//

#import "VmScoreCardEntity.h"

@implementation VmScoreCardEntity

@synthesize SCORECARD_ITEM_ID,ITEM_NO,ITEM_NAME_CN,ITEM_NAME_EN,IS_DELETED,STANDARD_SCORE,LAST_MODIFIED_BY,LAST_MODIFIED_TIME,REMARK_CN,REMARK_EN,PHOTO_ZONE_CN,PHOTO_ZONE_EN,IS_KIDS;

//Json 对象中获得Dictionary初始化User对象
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        
        self.SCORECARD_ITEM_ID = [dictionary objectForKey:@"SCORECARD_ITEM_ID"];
        self.ITEM_NO = [dictionary objectForKey:@"ITEM_NO"];
        self.ITEM_NAME_CN = [dictionary objectForKey:@"ITEM_NAME_CN"];
        self.ITEM_NAME_EN = [dictionary objectForKey:@"ITEM_NAME_EN"];
        self.IS_DELETED = [dictionary objectForKey:@"IS_DELETED"];
        self.STANDARD_SCORE = [dictionary objectForKey:@"STANDARD_SCORE"];
        self.LAST_MODIFIED_BY = [dictionary objectForKey:@"LAST_MODIFIED_BY"];
        self.LAST_MODIFIED_TIME= [dictionary objectForKey:@"LAST_MODIFIED_TIME"];
        self.REMARK_CN= [dictionary objectForKey:@"REMARK_CN"];
        self.PHOTO_ZONE_CN = [dictionary objectForKey:@"PHOTO_ZONE_CN"];
        self.REMARK_EN= [dictionary objectForKey:@"REMARK_EN"];
        self.PHOTO_ZONE_EN = [dictionary objectForKey:@"PHOTO_ZONE_EN"];
        self.IS_KIDS = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"IS_KIDS"]];
    }
    return self;
}

-(id) initWithFMResultSet:(FMResultSet*)rs
{
    if(self = [super init])
    {
        self.SCORECARD_ITEM_ID = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"SCORECARD_ITEM_ID"]];
        self.ITEM_NO = [NSString stringWithFormat:@"%d",[rs intForColumn:@"ITEM_NO"]];
        self.ITEM_NAME_CN = [rs stringForColumn:@"ITEM_NAME_CN"];
        self.ITEM_NAME_EN = [rs stringForColumn:@"ITEM_NAME_EN"];
        self.IS_DELETED = [rs stringForColumn:@"IS_DELETED"];
        self.STANDARD_SCORE = [rs stringForColumn:@"STANDARD_SCORE"];
        self.LAST_MODIFIED_BY = [rs stringForColumn:@"LAST_MODIFIED_BY"];
        self.LAST_MODIFIED_TIME = [rs stringForColumn:@"LAST_MODIFIED_TIME"];
        self.REMARK_CN = [rs stringForColumn:@"REMARK_CN"];
        self.REMARK_EN = [rs stringForColumn:@"REMARK_EN"];
        self.PHOTO_ZONE_CN = [rs stringForColumn:@"PHOTO_ZONE_CN"];
        self.PHOTO_ZONE_EN = [rs stringForColumn:@"PHOTO_ZONE_EN"];
        self.IS_KIDS = [rs stringForColumn:@"IS_KIDS"];
    }
    return self;
}

@end
