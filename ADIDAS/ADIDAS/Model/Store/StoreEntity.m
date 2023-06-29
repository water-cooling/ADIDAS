//
//  StoreEntity.m
//  ADIDAS
//
//  Created by testing on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StoreEntity.h"
#import "JSON.h"

@implementation StoreEntity
@synthesize CheckFlag,CheckError,StoreCode,StoreName,StorePhone,StoreAddress,StoreRemark,StoreStatus,SelectMethod;

- (id)initWithDictionary:(NSDictionary *)dictionary {
	if (self = [super init]) {
		self.CheckFlag = [dictionary objectForKey:@"CheckFlag"];
		self.CheckError = [dictionary objectForKey:@"CheckError"];
		self.StoreCode = [dictionary objectForKey:@"StoreCode"];
        self.StoreName = [dictionary objectForKey:@"StoreName"];
		self.StorePhone = [dictionary objectForKey:@"StorePhone"];
		self.StoreAddress = [dictionary objectForKey:@"StoreAddress"];
        self.StoreRemark = [dictionary objectForKey:@"StoreRemark"];
        self.StoreStatus = [dictionary objectForKey:@"StoreStatus"];
        self.IsCampaign = [dictionary objectForKey:@"IsCampaign"];
//        self.SelectMethod = [dictionary objectForKey:@"SelectMethod"];
        self.SelectMethod = @"2";
	}
	return self;	
}

- (id)initWithDictionary2:(NSDictionary *)dictionary;
{
    if (self = [super init])
    {
        self.StoreAddress = [dictionary objectForKey:@"Address"];
        self.StoreName = [dictionary objectForKey:@"NameCn"];
        self.StoreCode = [dictionary objectForKey:@"StoreCode"];
    }
    return self ;
}

- (id)initWithDictionary3:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        self.StoreAddress = [dictionary objectForKey:@"Address"];
        self.StoreName = [dictionary objectForKey:@"StoreNameCN"];
        self.StoreCode = [dictionary objectForKey:@"StoreCode"];
    }
    return self ;
}

- (NSString *)ToJSONString {
    NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.CheckFlag,@"CheckFlag",
                                    self.CheckError,@"CheckError",
                                    self.StoreCode,@"StoreCode",
                                    self.StoreName,@"StoreName",
                                    self.StorePhone,@"StorePhone",
                                    self.StoreAddress,@"StoreAddress",
                                    self.StoreRemark,@"StoreRemark",
                                    self.StoreStatus,@"StoreStatus",
                                    self.SelectMethod,@"SelectMethod",
                                    nil];
	return [userDictionary JSONRepresentation];
}

- (void)dealloc {
    [CheckFlag release];
    [CheckError release];
    [StoreCode release];
    [StoreName release];
    [StorePhone release];
    [StoreAddress release];
    [StoreRemark release];
    [StoreStatus release];
    [SelectMethod release];
    [super dealloc];
}
@end
