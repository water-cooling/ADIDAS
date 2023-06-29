//
//  RequestHeader.h
//  YumMOSApplication
//
//  Created by Sky.xu on 11-6-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface RequestHeader : NSObject {
	NSMutableDictionary *requestHeaderDictionary;
}

@property (nonatomic,readonly) NSMutableDictionary *requestHeaderDictionary;

+ (RequestHeader *)instance;

- (BOOL)setRequestHeader:(NSString*)value forKey:(NSString *)key;
- (void)setLangIdValue:(NSString*)value;
- (void)setTokenIdValue:(NSString*)value;

@end
