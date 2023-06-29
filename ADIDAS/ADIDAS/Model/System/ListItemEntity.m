//
//  ListItemEntity.m
//  ADIDAS
//
//  Created by testing on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListItemEntity.h"
#import "JSON.h"

@implementation ListItemEntity

@synthesize itemID,itemName;

- (id)initWithDictionary:(NSDictionary *)dictionary {
	if (self = [super init]) {
		self.itemID = [dictionary objectForKey:@"itemID"];
		self.itemName = [dictionary objectForKey:@"itemName"];
	}
	return self;	
}


- (void)dealloc {
    [itemID release];
    [itemName release];
    [super dealloc];
}
@end
