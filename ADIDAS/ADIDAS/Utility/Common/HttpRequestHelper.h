//
//  RequestHelper.h
//  WSE
//
//  Created by dextrys on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "Utilities.h"

// 服务器返回的通用接代理
@protocol HttpRequestHelperDelegate <NSObject>
@optional
- (void)completeFromServer:(NSString *)responseString 
              CurrentError:(NSString *)error 
             InterfaceName:(NSString *)interface;
@end

@interface HttpRequestHelper : NSObject<ASIProgressDelegate>
{
    id<HttpRequestHelperDelegate> _delegate; 
    NSString *_interfaceName;
    ASIHTTPRequest *_request;
    ASIFormDataRequest *_fileRequest;
    
}

@property(nonatomic,assign) id<HttpRequestHelperDelegate> delegate;
@property(nonatomic,copy)NSString *interfaceName;

//带附件的访问服务器方法
- (void)sendHttpFileRequest:(NSString *) urlString
                  xmlString:(NSString *)xmlString
                   delegate:(id)delegate  
                   filePath:(NSString *)filePath
              InterfaceName:(NSString *)interface;

//不带附件的访问服务器方法
- (void)sendHttpRequest:(NSString *)urlString
               delegate:(id)delegate  
          InterfaceName:(NSString *)interface;

// 同步访问方法
- (NSString*)sendHttpRequest:(NSString *)urlString
               InterfaceName:(NSString *)interface;


// wendy 的 上传方法
- (void)sendHttpFileRequest:(NSString *)urlString
                  xmlString:(NSString *)xmlString
                   delegate:(id)delegate
                   fileType:(NSString *)fileType
              InterfaceName:(NSString *)interface;

// wendy 图片上传方法
- (NSString*)sendHttpFileRequest:(NSString *)urlString
                        fileName:(NSString *)fileName
                        delegate:(id)delegate
                        fileType:(NSString*)fileType
                        filePath:(NSString *)filePath
                   InterfaceName:(NSString *)interface;

//带附件 的安装报告提交方法
- (void)sendHttpFileRequest:(NSString *)urlString
                  xmlString:(NSString *)xmlString
                   delegate:(id)delegate
                   fileType:(NSString*)fileType
                filePathArr:(NSArray *)picArr
              InterfaceName:(NSString *)interface
              xmlPathString:(NSString *)xmlPath;

@end
