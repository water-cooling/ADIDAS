//
//  UserDA.h
//  WSE
//
//  Created by testing on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoEntity.h"

@interface UserDA : NSObject

-(BOOL) SaveUserEntity:(UserInfoEntity*)userinfo;

- (UserInfoEntity *) GetCurrentUserEntity;

-(BOOL) DeleteAllUserInfo;

@end
