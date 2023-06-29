//
//  UserInfoManagement.m
//  WSE
//
//  Created by testing on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UploadManagement.h"
#import "SqliteHelper.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Utilities.h"
#import "JSON.h"
#import "CommonDefine.h"

#import "StoreEntity.h"
#import "CacheManagement.h"
#import "AppDelegate.h"


@implementation UploadManagement

@synthesize  delegate;
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

//上传门店签到数据到服务器
- (void)uploadCheckInFileToServer:(NSString *) xmlStr picPath:(NSString *) picPath
{
    if (![APPDelegate checkNetWork])
    {
        ALERTVIEW(NO_NETWORK);
        return;
    }
    NSString* urlString = [NSString stringWithFormat:kUploadStoreVisitString,kWebRisesString,
                           [CacheManagement instance].currentDBUser.userName,kMOBILESOLUTIONVERSION];
    //调服务器接口
    [_httpRequestHelper sendHttpFileRequest:urlString 
                                  xmlString:xmlStr                                    
                                   delegate:self 
                                   filePath:picPath 
                              InterfaceName:kUploadStoreVisitString];

}


-(void)uploadVMRailCheckFileToServer:(NSString *)xmlStr
                            fileType:(NSString* )fileType
                      andfilePathArr:(NSArray*)picarr
                          andxmlPath:(NSString *)xmlpath
{
    if (![APPDelegate checkNetWork])
    {
        ALERTVIEW(NO_NETWORK);
        return;
    }
    NSString* urlString = [NSString stringWithFormat:kUploadDataNEW,kWebDataString,[CacheManagement instance].userLoginName,fileType];
    [_httpRequestHelper sendHttpFileRequest:urlString
                                  xmlString:xmlStr
                                   delegate:self
                                   fileType:fileType
                                filePathArr:picarr
                              InterfaceName:kUploadDataNEW
                            xmlPathString:xmlpath
     ];
}

// 上传安装报告文件
-(void)uploadInstallFileToServer:(NSString *)xmlStr fileType:(NSString* )fileType andfilePathArr:(NSArray*)picarr andxmlPath:(NSString *)xmlpath
{
    if (![APPDelegate checkNetWork])
    {
        ALERTVIEW(NO_NETWORK);
        return;
    }
    
    NSString* urlString = [NSString stringWithFormat:kUploadDataNEW,kWebDataString,[CacheManagement instance].userLoginName,fileType];
    
    [_httpRequestHelper sendHttpFileRequest:urlString
                                  xmlString:xmlStr
                                   delegate:self
                                   fileType:kXmlFrCampInstall
                                filePathArr:picarr
                              InterfaceName:kWebDataString
                              xmlPathString:xmlpath];

}

// 服务器返回
-(void) completeFromServer:(NSString *)responseString CurrentError:(NSString *)error InterfaceName:(NSString *)interface
{
    if ([delegate respondsToSelector:@selector(completeUploadServer:)]) {
        [delegate completeUploadServer:error];
    }
}

- (void)dealloc {
    [_httpRequestHelper release];
    self.delegate = nil; 
    [super dealloc];
}

@end
