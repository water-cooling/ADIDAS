//
//  RequestHeader.m
//  YumMOSApplication
//
//  Created by Sky.xu on 11-6-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RequestHeader.h"


@implementation RequestHeader

@synthesize requestHeaderDictionary;

static RequestHeader *instance;

+ (RequestHeader *)instance {
	
	@synchronized(self){
		if (!instance) {
			instance = [[RequestHeader alloc] init];			
		}
	}
	
	return instance;
}

- (id)init {
	if (self = [super init]) {
		requestHeaderDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"",@"LangId",
								   @"",@"TokenId",
								   @"2",@"VERSION",
								   @"application/json; charset=utf-8",@"Content-Type",
								   nil];
	}
	return self;
}

- (BOOL)setRequestHeader:(NSString*)value forKey:(NSString *)key {
	NSString *currentValue = [requestHeaderDictionary objectForKey:key];
	if (currentValue != nil) {
		[requestHeaderDictionary setValue:value forKey:key];
		return YES;
	}
	else {
		return NO;
	}

}

- (void)setLangIdValue:(NSString*)value {
	[requestHeaderDictionary setValue:value forKey:@"LangId"];
}

- (void)setTokenIdValue:(NSString*)value {
	[requestHeaderDictionary setValue:value forKey:@"TokenId"];
}

- (void)dealloc {
	[requestHeaderDictionary release];
	[super dealloc];
}

@end
