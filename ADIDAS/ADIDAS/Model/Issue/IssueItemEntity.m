//
//  SyncParaVersionEntity.m
//  ADIDAS
//
//  Created by testing on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IssueItemEntity.h"
#import "JSON.h"

@implementation IssueItemEntity

@synthesize itemID=_itemID, categoryID=_categoryID,nameCN=_nameCN,nameEN=_nameEN,orderNo=_orderNo,remark=_remark,lastModifyBy=_lastModifyBy,lastModifyTime=_lastModifyTime,isDeleted=_isDeleted;

- (id)initWithDictionary:(NSDictionary *)dictionary {
	if (self = [super init]) {
        self.itemID = [dictionary objectForKey:@"STORE_ISSUE_ITEM_ID"];
		self.categoryID = [dictionary objectForKey:@"STORE_ISSUE_CATEGORY_ID"];
        self.nameCN = [dictionary objectForKey:@"NAME_CN"];
        self.nameEN = [dictionary objectForKey:@"NAME_EN"];
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
        _itemID = [[NSString alloc] initWithFormat:@"%@",[rs stringForColumn:@"STORE_ISSUE_ITEM_ID"]];
        _nameCN = [[NSString alloc] initWithFormat:@"%@",[rs stringForColumn:@"NAME_CN"]];
	}
	return self;
}

- (void)dealloc {
    [_itemID release];
    [_categoryID release];
    
    [_nameCN release];
    [_nameEN release];
    [_isDeleted release];
    
    [_orderNo release];
    [_remark release];
    [_lastModifyBy release];
    [_lastModifyTime release];
    [super dealloc];
}
@end

