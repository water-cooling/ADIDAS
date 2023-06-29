//
//  UserDA.m
//  WSE
//
//  Created by testing on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserDA.h"
#import "FMDatabase.h"
#import "UserInfoEntity.h"
#import "SqliteHelper.h"
#import "ASIHTTPRequest.h"
#import "GTMBase64.h"
#import "Utilities.h"


@implementation UserDA

- (UserInfoEntity *) GetCurrentUserEntity {
    NSString *sql = @"SELECT * FROM tblUser limit 1";
	FMResultSet *rs;
	UserInfoEntity *userEntity = nil;
	@try {
		//rs = [super selectResult:sql];
        rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
		while ([rs next]) {
			userEntity = [[UserInfoEntity alloc] initWithFMResultSet:rs];
            
            NSString *userId = [AES128Util AES128Decrypt:userEntity.userID key:[NSString stringWithFormat:@"tblUser-userId"]];
            NSString *userName = [AES128Util AES128Decrypt:userEntity.userName key:[NSString stringWithFormat:@"tblUser-userName"]];
            NSString *password = [AES128Util AES128Decrypt:userEntity.password key:[NSString stringWithFormat:@"tblUser-password"]];
            userEntity.userID = userId;
            userEntity.userName = userName;
            userEntity.password = password;
			break;
		}
	}
	@catch (NSException *e) {
		@throw e;
	}
	@finally {
		if (rs) {
			[rs close];
		}
	}
	return [userEntity autorelease];
}


-(BOOL) SaveUserEntity:(UserInfoEntity*)userinfo {
    
	FMDatabase *db = [[SqliteHelper shareCommonSqliteHelper] database];
	[db beginTransaction];
	BOOL result = YES;
	@try 
	{
        //插入操作
		[self DeleteAllUserInfo];
        
        NSString *userId = [AES128Util AES128Encrypt:userinfo.userID key:[NSString stringWithFormat:@"tblUser-userId"]];
        NSString *userName = [AES128Util AES128Encrypt:userinfo.userName key:[NSString stringWithFormat:@"tblUser-userName"]];
        NSString *password = [AES128Util AES128Encrypt:userinfo.password key:[NSString stringWithFormat:@"tblUser-password"]];
		NSString *sql = [NSString stringWithFormat:@"INSERT INTO tblUser(UserID,UserName,Password,IsSavePwd) values (?,?,?,?)"];
		result = [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql, userId, userName, password,userinfo.isSavePwd];
	}
	@catch (NSException *e) 
	{
		result = NO;
		@throw e;
	}
	@finally 
	{
		if(result==YES)
		{
			[db commit];
		}
		else 
		{
			[db rollback];
		}
	}
	
	return TRUE;
}

-(BOOL) DeleteAllUserInfo
{
	NSString *sql = [NSString stringWithFormat:@"delete from tblUser"]; 
	return [[SqliteHelper shareCommonSqliteHelper] executeSQL:sql];
}

@end
