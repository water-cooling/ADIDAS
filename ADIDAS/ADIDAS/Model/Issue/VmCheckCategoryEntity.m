//
//  VmCheckCategoryEntity.m
//  ADIDAS
//
//  Created by 桂康 on 2017/7/30.
//
//

#import "VmCheckCategoryEntity.h"

@implementation VmCheckCategoryEntity

@synthesize DATA_SOURCE,IS_DELETED,LAST_MODIFIED_BY,LAST_MODIFIED_TIME,NAME_CN,NAME_EN,ORDER_NO,PARENT_CATEGORY_ID,REMARK_CN,REMARK_EN,VM_CATEGORY_ID;

//Json 对象中获得Dictionary初始化User对象
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        self.DATA_SOURCE = [dictionary objectForKey:@"DATA_SOURCE"];
        self.IS_DELETED = [dictionary objectForKey:@"IS_DELETED"];
        self.LAST_MODIFIED_BY = [dictionary objectForKey:@"LAST_MODIFIED_BY"];
        self.LAST_MODIFIED_TIME = [dictionary objectForKey:@"LAST_MODIFIED_TIME"];
        self.NAME_CN = [dictionary objectForKey:@"NAME_CN"];
        self.NAME_EN = [dictionary objectForKey:@"NAME_EN"];
        self.ORDER_NO = [dictionary objectForKey:@"ORDER_NO"];
        self.PARENT_CATEGORY_ID= [dictionary objectForKey:@"PARENT_CATEGORY_ID"];
        self.REMARK_CN= [dictionary objectForKey:@"REMARK_CN"];
        self.REMARK_EN = [dictionary objectForKey:@"REMARK_EN"];
        self.VM_CATEGORY_ID = [dictionary objectForKey:@"VM_CATEGORY_ID"];
    }
    return self;
}

-(id) initWithFMResultSet:(FMResultSet*)rs
{
    if(self = [super init])
    {
        self.DATA_SOURCE = [rs stringForColumn:@"DATA_SOURCE"];
        self.IS_DELETED = [rs stringForColumn:@"IS_DELETED"];
        self.LAST_MODIFIED_BY = [rs intForColumn:@"LAST_MODIFIED_BY"];
        self.LAST_MODIFIED_TIME = [rs stringForColumn:@"LAST_MODIFIED_TIME"];
        self.NAME_CN = [rs stringForColumn:@"NAME_CN"];
        self.NAME_EN = [rs stringForColumn:@"NAME_EN"];
        self.ORDER_NO = [rs stringForColumn:@"ORDER_NO"];
        self.PARENT_CATEGORY_ID = [rs stringForColumn:@"PARENT_CATEGORY_ID"];
        self.REMARK_CN = [rs stringForColumn:@"REMARK_CN"];
        self.REMARK_EN = [rs stringForColumn:@"REMARK_EN"];
        self.VM_CATEGORY_ID = [rs stringForColumn:@"VM_CATEGORY_ID"];
    }
    return self;
}

@end
