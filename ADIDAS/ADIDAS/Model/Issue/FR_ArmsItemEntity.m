//
//  FR_ArmsItemEntity.m
//  ADIDAS
//
//  Created by wendy on 14-5-13.
//
//

#import "FR_ArmsItemEntity.h"

@implementation FR_ArmsItemEntity

@synthesize item_id,item_name_cn,item_name_en,item_NO,remark_en,remark_cn,last_modified_by,reason_en,reason_cn,isdelete,score_option,last_modified_time,DATASOURCE;

//Json 对象中获得Dictionary初始化User对象
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.item_id = [dictionary objectForKey:@"FR_ARMS_ITEM_ID"];
		self.item_name_cn = [dictionary objectForKey:@"ITEM_NAME_CN"];
        self.item_name_en = [dictionary objectForKey:@"ITEM_NAME_EN"];
        self.item_NO = [dictionary objectForKey:@"ITEM_NO"];
        self.remark_cn = [dictionary objectForKey:@"REMARK_CN"];
        
		self.remark_en = [dictionary objectForKey:@"REMARK_EN"];
        self.last_modified_by = [dictionary objectForKey:@"LAST_MODIFIED_BY"];
        self.reason_cn= [dictionary objectForKey:@"REASONS_CN"];
        self.reason_en= [dictionary objectForKey:@"REASONS_EN"];
        
        self.isdelete = [dictionary objectForKey:@"IS_DELETED"];
        self.score_option = [dictionary objectForKey:@"SCORE_OPTION"];
        self.last_modified_time = [dictionary objectForKey:@"LAST_MODIFIED_TIME"];
        self.DATASOURCE = [dictionary objectForKey:@"DATA_SOURCE"];
	}
	return self;
}


@end
