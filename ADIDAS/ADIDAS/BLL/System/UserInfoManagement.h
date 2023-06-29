//
//  UserInfoManagement.h
//  WSE
//
//  Created by testing on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequestHelper.h"



@class UserInfoEntity;

@protocol UserManagementDelegate <NSObject>

@optional
- (void)completeServer:(NSString *)responseString  CurrentError:(NSString *)error  InterfaceName:(NSString *)interface;
@end


@interface UserInfoManagement : NSObject
{
    HttpRequestHelper *_httpRequestHelper;
}


@property(nonatomic,assign) id<UserManagementDelegate> delegate;


- (UserInfoEntity *)loadUser;
- (void)updateUser:(UserInfoEntity *) currUser;


- (void)loginServer:(NSString *)userName password:(NSString *)password ;
- (void)forgetPwdServer:(NSString *)userName;
- (void)changePwdServer:(NSString *)userName  password:(NSString *)password  newPassword:(NSString *)newPassword;
@end
