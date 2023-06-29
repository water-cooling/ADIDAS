//
//  UserInfoEntity.m
//  WSE
//
//  Created by testing on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserInfoEntity.h"
#import "JSON.h"

@implementation UserInfoEntity

@synthesize userID=_userID,userName=_userName,password=_password,newpassword=_newpassword,isSavePwd;

- (id)initWithDictionary:(NSDictionary *)dictionary {
	if (self = [super init]) {
		self.userID = [dictionary objectForKey:@"userID"];
		self.userName = [dictionary objectForKey:@"userName"];
		self.password = [dictionary objectForKey:@"password"];
        self.newpassword = [dictionary objectForKey:@"newpassword"];
	}
	
	return self;	
}


//from local db
-(id) initWithFMResultSet:(FMResultSet*)rs
{
	if(self = [super init])
	{		
		_userID = [[NSString alloc] initWithFormat:@"%@",[rs stringForColumn:@"UserID"]];
		_userName = [[NSString alloc] initWithFormat:@"%@",[rs stringForColumn:@"UserName"]];
		_password = [[NSString alloc] initWithFormat:@"%@",[rs stringForColumn:@"Password"]];
        isSavePwd = [[NSString alloc] initWithFormat:@"%@",[rs stringForColumn:@"isSavePwd"]];
	}
	return self;
}


- (NSString *)ToJSONString {
    
    NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    self.userID,@"userID",
                                    self.userName,@"userName",
                                    self.password,@"password",
                                    self.newpassword,@"newpassword",
                                    nil];
    
	return [userDictionary JSONRepresentation];
}


- (void)dealloc {
    [_userID release];
    [_userName release];
    [_password release];
    [_newpassword release];
    [isSavePwd release];
    [super dealloc];
}
@end
