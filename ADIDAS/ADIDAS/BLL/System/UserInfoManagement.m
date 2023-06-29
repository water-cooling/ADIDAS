//
//  UserInfoManagement.m
//  WSE
//
//  Created by testing on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserInfoManagement.h"
#import "FMDatabase.h"
#import "ASIHTTPRequest.h"
#import "UserInfoEntity.h"
#import "SqliteHelper.h"
#import "Utilities.h"
#import "JSON.h"
#import "UserDA.h"
#import "CommonDefine.h"
#import "LoginResultEntity.h"
#import "CacheManagement.h"
#import "NSString+filter.h"


@implementation UserInfoManagement

@synthesize  delegate;

//- (NSString*) mk_urlEncodedString:(NSString*)string
//{ // mk_ prefix prevents a clash with a private api
//    
//    CFStringRef encodedCFString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
//                                                                          (__bridge CFStringRef) string,
//                                                                          nil,
//                                                                          CFSTR("?!@#$^&%*+,:;='\"`<>()[]{}/\\| "),
//                                                                          kCFStringEncodingUTF8);
//    
//    NSString *encodedString = [[NSString alloc] initWithString:(__bridge_transfer NSString*) encodedCFString];
//    
//    if(!encodedString)
//        encodedString = @"";
//    
//    return encodedString;
//}


///数据库Load用户
- (UserInfoEntity *)loadUser {
    
    UserDA * userDA =[[UserDA alloc] autorelease] ;
    return [userDA GetCurrentUserEntity];
}

//修改用户
- (void)updateUser:(UserInfoEntity *) currUser
{
    UserDA * userDA =[UserDA alloc];
    [userDA SaveUserEntity:currUser];
    [userDA release];
}

//**********访问服务器方法
// 初始化
-(id)init
{
    self= [super init];
    if (self)
    {
        _httpRequestHelper = [[HttpRequestHelper alloc] init];
    }
    return self;
}

//系统登录
- (void)loginServer:(NSString *)userName password:(NSString *)password
{
//    NSString *userName_ = [userName stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];

    NSString* urlString =[NSString stringWithFormat:kLoginString,kWebDataString,
                            [userName mk_urlEncodedString],
                            password,
                            [Utilities DateNow2],
                            [CacheManagement instance].currentiOSVersion,
                            kMOBILESOLUTIONVERSION,
                            kAUTOUPGRADE
                          ];
    //调服务器接口
    [_httpRequestHelper sendHttpRequest:urlString delegate:self InterfaceName:kLoginString];
}

//忘记密码
- (void)forgetPwdServer:(NSString *)userName {
    
    NSString* urlString = [NSString stringWithFormat:kReGetPasswordString,kWebDataString,userName];

    [_httpRequestHelper sendHttpRequest:urlString delegate:self InterfaceName:kReGetPasswordString];
}

//修改密码
- (void)changePwdServer:(NSString *)userName  password:(NSString *)password  newPassword:(NSString *)newPassword {
    
    NSString* urlString = [NSString stringWithFormat:kChangePasswordString,kWebRisesString, 
                           userName,
                           password,
                           newPassword,
                           kMOBILESOLUTIONVERSION];
    [_httpRequestHelper sendHttpRequest:urlString delegate:self InterfaceName:kChangePasswordString];
}


// 服务器返回
-(void) completeFromServer:(NSString *)responseString CurrentError:(NSString *)error InterfaceName:(NSString *)interface
{
    if ([delegate respondsToSelector:@selector(completeServer:CurrentError:InterfaceName:)]) {
        [delegate completeServer:responseString CurrentError:error InterfaceName:interface];
    }
}

- (void)dealloc {
    [_httpRequestHelper release];
    self.delegate = nil; 
    [super dealloc];
}

@end
