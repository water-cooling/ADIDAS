//
//  VmScoreCardDetailEntity.m
//  MobileApp
//
//  Created by 桂康 on 2017/11/27.
//

#import "VmScoreCardDetailEntity.h"

@implementation VmScoreCardDetailEntity

@synthesize SCORECARD_ITEM_DETAIL_ID,SCORECARD_ITEM_ID,ITEM_NO,ITEM_NAME_CN,ITEM_NAME_EN,IS_DELETED,STANDARD_SCORE,LAST_MODIFIED_BY,LAST_MODIFIED_TIME,REMARK;

//Json 对象中获得Dictionary初始化User对象
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        
        self.SCORECARD_ITEM_DETAIL_ID = [dictionary objectForKey:@"SCORECARD_ITEM_DETAIL_ID"];
        self.SCORECARD_ITEM_ID = [dictionary objectForKey:@"SCORECARD_ITEM_ID"];
        self.ITEM_NO = [dictionary objectForKey:@"ITEM_NO"];
        self.ITEM_NAME_CN = [dictionary objectForKey:@"ITEM_NAME_CN"];
        self.ITEM_NAME_EN = [dictionary objectForKey:@"ITEM_NAME_EN"];
        self.IS_DELETED = [dictionary objectForKey:@"IS_DELETED"];
        self.STANDARD_SCORE = [dictionary objectForKey:@"STANDARD_SCORE"];
        self.LAST_MODIFIED_BY = [dictionary objectForKey:@"LAST_MODIFIED_BY"];
        self.LAST_MODIFIED_TIME= [dictionary objectForKey:@"LAST_MODIFIED_TIME"];
        self.REMARK= [dictionary objectForKey:@"REMARK_CN"];
    }
    return self;
}

-(id) initWithFMResultSet:(FMResultSet*)rs
{
    if(self = [super init])
    {
        self.SCORECARD_ITEM_DETAIL_ID = [rs stringForColumn:@"SCORECARD_ITEM_DETAIL_ID"];
        self.SCORECARD_ITEM_ID = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"SCORECARD_ITEM_ID"]];
        self.ITEM_NO = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"ITEM_NO"]];
        self.ITEM_NAME_CN = [rs stringForColumn:@"ITEM_NAME_CN"];
        self.ITEM_NAME_EN = [rs stringForColumn:@"ITEM_NAME_EN"];
        self.IS_DELETED = [rs stringForColumn:@"IS_DELETED"];
        self.STANDARD_SCORE = [rs stringForColumn:@"STANDARD_SCORE"];
        self.LAST_MODIFIED_BY = [rs stringForColumn:@"LAST_MODIFIED_BY"];
        self.LAST_MODIFIED_TIME = [rs stringForColumn:@"LAST_MODIFIED_TIME"];
        self.REMARK = [rs stringForColumn:@"REMARK"];
    }
    return self;
}

@end
