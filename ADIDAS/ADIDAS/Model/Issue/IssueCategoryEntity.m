//
//  SyncParaVersionEntity.m
//  ADIDAS
//
//  Created by testing on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IssueCategoryEntity.h"
#import "JSON.h"

@implementation IssueCategoryEntity

@synthesize categoryID,paraCateID,nameCN,nameEN,orderNo,type,remark,lastModifyBy,lastModifyTime,isDeleted;

- (id)initWithDictionary:(NSDictionary *)dictionary {
	if (self = [super init]) {
		self.categoryID = [dictionary objectForKey:@"STORE_ISSUE_CATEGORY_ID"];
		self.paraCateID = [dictionary objectForKey:@"PARENT_CATEGORY_ID"];
        self.nameCN = [dictionary objectForKey:@"NAME_CN"];
        self.nameEN = [dictionary objectForKey:@"NAME_EN"];
        self.type = [dictionary objectForKey:@"TYPE"];
        self.isDeleted = [dictionary objectForKey:@"IS_DELETED"];
        
		self.orderNo = [dictionary objectForKey:@"ORDER_NO"];
        self.remark = [dictionary objectForKey:@"REMARK"];
        self.lastModifyBy = [dictionary objectForKey:@"LAST_MODIFIED_BY"];
        self.lastModifyTime = [dictionary objectForKey:@"LAST_MODIFIED_TIME"];
	}
	return self;	
}

//from local db
-(id) initWithFMResultSet:(FMResultSet*)rs
{
	if(self = [super init])
	{		
		categoryID = [[NSString alloc] initWithFormat:@"%@",[rs stringForColumn:@"STORE_ISSUE_CATEGORY_ID"]];
		paraCateID = [[NSString alloc] initWithFormat:@"%@",[rs stringForColumn:@"PARENT_CATEGORY_ID"]];
        
        nameCN = [[NSString alloc] initWithFormat:@"%@",[rs stringForColumn:@"NAME_CN"]];
        nameEN = [[NSString alloc] initWithFormat:@"%@",[rs stringForColumn:@"NAME_EN"]];
        type = [[NSString alloc] initWithFormat:@"%@",[rs stringForColumn:@"TYPE"]];
        isDeleted = [[NSString alloc] initWithFormat:@"%@",[rs stringForColumn:@"IS_DELETED"]];
        
		orderNo = [[NSString alloc] initWithFormat:@"%@",[rs stringForColumn:@"ORDER_NO"]];
      	remark = [[NSString alloc] initWithFormat:@"%@",[rs stringForColumn:@"REMARK"]];
        lastModifyBy = [[NSString alloc] initWithFormat:@"%@",[rs stringForColumn:@"LAST_MODIFIED_BY"]];
      	lastModifyTime = [[NSString alloc] initWithFormat:@"%@",[rs stringForColumn:@"LAST_MODIFIED_TIME"]];
	}
	return self;
}

- (void)dealloc {
    [categoryID release];
    [paraCateID release];
    
    [nameCN release];
    [nameEN release];
    [type release];
    [isDeleted release];
    
    [orderNo release];
    [remark release];
    [lastModifyBy release];
    [lastModifyTime release];
    [super dealloc];
}
@end

