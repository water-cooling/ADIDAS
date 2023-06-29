//
//  LocationEntity.m
//  ADIDAS
//
//  Created by testing on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocationEntity.h"

@implementation LocationEntity

@synthesize locationX=_locationX;
@synthesize locationY=_locationY;

- (id)initWithDictionary:(NSDictionary *)dictionary {
	if (self = [super init]) {
		self.locationX = [dictionary objectForKey:@"locationX"];
		self.locationY = [dictionary objectForKey:@"locationY"];
	}
	
	return self;	
}


- (void)dealloc {
    [_locationX release];
    [_locationY release];
    [super dealloc];
}
@end