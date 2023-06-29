//
//  VM_CHECK_ITEM_Entity.m
//  VM
//
//  Created by wendy on 14-7-19.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import "VM_CHECK_ITEM_Entity.h"

@implementation VM_CHECK_ITEM_Entity

@synthesize VM_ITEM_ID,VM_CATEGORY_ID,ITEM_NO,ITEM_NAME_CN,ITEM_NAME_EN,ITEM_ICON,REASON_CN,REASON_EN,ORDER_NO,SCORE_OPTION,REMARK_CN,REMARK_EN,IS_KEY,IS_DELETED,STANDARD_SCORE,LAST_MODIFIED_BY,LAST_MODIFIED_TIME,DATASOURCE;

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.VM_ITEM_ID = [dictionary objectForKey:@"VM_ITEM_ID"];
        self.VM_CATEGORY_ID = [dictionary objectForKey:@"VM_CATEGORY_ID"];
        self.ITEM_NO = [[dictionary objectForKey:@"ITEM_NO"] integerValue];
        self.ITEM_NAME_CN = [dictionary objectForKey:@"ITEM_NAME_CN"];
        self.ITEM_NAME_EN = [dictionary objectForKey:@"ITEM_NAME_EN"];
        self.ITEM_ICON = [dictionary objectForKey:@"ITEM_ICON"];
        self.REMARK_CN = [dictionary objectForKey:@"REMARK_CN"];
        self.REMARK_EN = [dictionary objectForKey:@"REMARK_EN"];
        self.REASON_CN = [dictionary objectForKey:@"REASON_CN"];
        self.REASON_EN = [dictionary objectForKey:@"REASON_EN"];
        self.ORDER_NO = [dictionary objectForKey:@"ORDER_NO"];
        self.SCORE_OPTION = [dictionary objectForKey:@"SCORE_OPTION"];
        self.IS_KEY = [[dictionary valueForKey:@"IS_KEY"]integerValue];
        self.IS_DELETED = [[dictionary valueForKey:@"IS_DELETED"]integerValue];
        self.STANDARD_SCORE = [dictionary objectForKey:@"STANDARD_SCORE"];
        self.LAST_MODIFIED_BY = [dictionary objectForKey:@"LAST_MODIFIED_BY"];
        self.LAST_MODIFIED_TIME = [dictionary objectForKey:@"LAST_MODIFIED_TIME"];
        self.DATASOURCE = [dictionary objectForKey:@"DATASOURCE"];
    }
    return self;
}

-(id) initWithFMResultSet:(FMResultSet*)rs
{
	if(self = [super init])
	{
        self.VM_ITEM_ID = [rs stringForColumn:@"VM_ITEM_ID"];
        self.VM_CATEGORY_ID = [rs stringForColumn:@"VM_CATEGORY_ID"];
        self.ITEM_NO = [rs intForColumn:@"ITEM_NO"];
        self.ITEM_NAME_CN = [rs stringForColumn:@"ITEM_NAME_CN"];
        self.ITEM_NAME_EN = [rs stringForColumn:@"ITEM_NAME_EN"];
        self.ITEM_ICON = [rs stringForColumn:@"ITEM_ICON"];
        self.REMARK_CN = [rs stringForColumn:@"REMARK_CN"];
        self.REMARK_EN = [rs stringForColumn:@"REMARK_EN"];
        self.REASON_CN = [rs stringForColumn:@"REASON_CN"];
        self.REASON_EN = [rs stringForColumn:@"REASON_EN"];
        self.ORDER_NO = [rs stringForColumn:@"ORDER_NO"];
        self.SCORE_OPTION = [rs stringForColumn:@"SCORE_OPTION"];
        self.IS_KEY = [rs intForColumn:@"IS_KEY"];
        self.IS_DELETED = [rs intForColumn:@"IS_DELETED"];
        self.STANDARD_SCORE = [rs stringForColumn:@"STANDARD_SCORE"];
        self.LAST_MODIFIED_BY = [rs stringForColumn:@"LAST_MODIFIED_BY"];
        self.LAST_MODIFIED_TIME = [rs stringForColumn:@"LAST_MODIFIED_TIME"];
        self.DATASOURCE = [rs stringForColumn:@"DATASOURCE"];
	}
	return self;
}


@end
