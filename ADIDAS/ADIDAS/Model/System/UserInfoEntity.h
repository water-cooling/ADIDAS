//
//  UserInfoEntity.h
//  WSE
//
//  Created by testing on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"

@interface UserInfoEntity : NSObject 

@property(nonatomic,copy)NSString *userID;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *password;
@property(nonatomic,copy)NSString *newpassword;
@property(nonatomic,copy)NSString *isSavePwd;

//Json 对象中获得Dictionary初始化User对象
- (id)initWithDictionary:(NSDictionary *)dictionary;
//数据库字段转化
-(id) initWithFMResultSet:(FMResultSet*)resultSet;
//将User对象转化为Json String
- (NSString *)ToJSONString;

@end
