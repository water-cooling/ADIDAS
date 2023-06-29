//
//  SyncParaVersionEntity.m
//  ADIDAS
//
//  Created by testing on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SyncParaVersionEntity.h"
#import "JSON.h"

@implementation SyncParaVersionEntity

@synthesize paraType=_paraType,paraVersion=_paraVersion,orderNo=_orderNo,remark=_remark,lastModifyBy=_lastModifyBy,lastModifyTime=_lastModifyTime;

- (id)initWithDictionary:(NSDictionary *)dictionary {
	if (self = [super init]) {
		self.paraType = [dictionary objectForKey:@"PARAMETER_TYPE"];
		self.paraVersion = [dictionary objectForKey:@"PARAMETER_VERSION"];
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
		_paraType = [[NSString alloc] initWithFormat:@"%@",[rs stringForColumn:@"PARAMETER_TYPE"]];
		_paraVersion = [[NSString alloc] initWithFormat:@"%@",[rs stringForColumn:@"PARAMETER_VERSION"]];
//		orderNo = [[NSString alloc] initWithFormat:@"%@",[rs stringForColumn:@"ORDER_NO"]];
//      	remark = [[NSString alloc] initWithFormat:@"%@",[rs stringForColumn:@"REMARK"]];
//        lastModifyBy = [[NSString alloc] initWithFormat:@"%@",[rs stringForColumn:@"LAST_MODIFIED_BY"]];
//      	lastModifyTime = [[NSString alloc] initWithFormat:@"%@",[rs stringForColumn:@"LAST_MODIFIED_TIME"]];
	}
	return self;
}

- (void)dealloc {
    [_paraType release];
    [_paraVersion release];
    [_orderNo release];
    [_remark release];
    [_lastModifyBy release];
    [_lastModifyTime release];
    [super dealloc];
}
@end

