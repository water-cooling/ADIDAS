    //
//  RequestHelper.m
//  WSE
//
//  Created by dextrys on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HttpRequestHelper.h"
#import "Utilities.h"
#import "NSString+SBJSON.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "CacheManagement.h"
#import "SSZipArchive.h"
#import "CommonUtil.h"

@implementation HttpRequestHelper

@synthesize delegate=_delegate;
@synthesize interfaceName=_interfaceName;


// 向服务器发送请求
//带附件的访问服务器方法
-(void) sendHttpFileRequest:(NSString *) urlString
                  xmlString:(NSString *) xmlString
               delegate:(id)delegate  
             filePath:(NSString *)filePath
          InterfaceName:(NSString *)interface
{
    // 先检查ASIHttpRequest是否为空，没空先relase,防止多次调用此函数
    if (_fileRequest != nil) 
    {
        _fileRequest.delegate=nil;
		[_fileRequest release];
		_fileRequest = nil;
	}
    // 先将delegate和接口名保存到实例变量
    self.delegate = delegate;
    self.interfaceName = interface;
    
    //里面有中文。需要转化为NSUTF8StringEncoding
    NSURL *url = [NSURL URLWithString:urlString];
    
    _fileRequest = [ASIFormDataRequest requestWithURL:url];
    [_fileRequest setValidatesSecureCertificate:NO];
    [_fileRequest setRequestMethod:@"POST"];
    [_fileRequest addRequestHeader:@"Accept" value:@"application/json"];
    [_fileRequest addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    
    //添加Post数据
    [_fileRequest addPostValue:xmlString forKey:@"xml"];
    //添加ISA 密文验证
    if ([CacheManagement instance].userEncode&&![[CacheManagement instance].userEncode isEqualToString:@""])
        [_fileRequest addRequestHeader:@"Authorization"
                         value:[NSString stringWithFormat:@"Basic %@",[CacheManagement instance].userEncode]];
    
	[_fileRequest setTimeOutSeconds:200];
	[_fileRequest setDelegate:self];
	[_fileRequest setDidFinishSelector:@selector(didFinish:)];
	[_fileRequest setDidFailSelector:@selector(didFailed:)];
    
    if(filePath!=nil && ![filePath isEqualToString:@""])
    {
        [_fileRequest setFile:filePath forKey:@"1"];
    }
	[_fileRequest startAsynchronous];
    [_fileRequest retain];
}

// wendy 上传方法
-(void) sendHttpFileRequest:(NSString *) urlString
                  xmlString:(NSString *) xmlString
                   delegate:(id)delegate
                   fileType:(NSString *)fileType
              InterfaceName:(NSString *)interface
{
    // 先检查ASIHttpRequest是否为空，没空先relase,防止多次调用此函数
    if (_fileRequest != nil)
    {
        _fileRequest.delegate=nil;
		[_fileRequest release];
          _fileRequest = nil;
	}
    
    // 先将delegate和接口名保存到实例变量
    self.delegate = delegate;
    self.interfaceName = interface;
    
    //里面有中文。需要转化为NSUTF8StringEncoding
    NSURL *url = [NSURL URLWithString:urlString];
    
    _fileRequest = [ASIFormDataRequest requestWithURL:url];
    [_fileRequest setValidatesSecureCertificate:NO];
    [_fileRequest setRequestMethod:@"POST"];
    [_fileRequest addRequestHeader:@"Accept" value:@"application/json"];
    [_fileRequest addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    
    //添加Post数据
    [_fileRequest addPostValue:xmlString forKey:@"xml"];
    [_fileRequest addPostValue:fileType forKey:@"fileType"];
    //添加ISA 密文验证
    if ([CacheManagement instance].userEncode&&![[CacheManagement instance].userEncode isEqualToString:@""])
        [_fileRequest addRequestHeader:@"Authorization"
                             value:[NSString stringWithFormat:@"Basic %@",[CacheManagement instance].userEncode]];
    
	[_fileRequest setTimeOutSeconds:200];
	[_fileRequest setDelegate:self];
	[_fileRequest setDidFinishSelector:@selector(didFinish:)];
	[_fileRequest setDidFailSelector:@selector(didFailed:)];

	[_fileRequest startAsynchronous];
    [_fileRequest retain];
}

// wendy 上传图片方法
-(NSString*) sendHttpFileRequest:(NSString *) urlString
                  fileName:(NSString *) fileName
                   delegate:(id)delegate
                   fileType:(NSString*)fileType
                filePath:(NSString *)filePath
              InterfaceName:(NSString *)interface
{
//    // 先检查ASIHttpRequest是否为空，没空先relase,防止多次调用此函数
//    
//    
    if (_fileRequest != nil)
    {
        _fileRequest.delegate=nil;
		[_fileRequest release];
		_fileRequest = nil;
	}
    
    // 先将delegate和接口名保存到实例变量
//    self.delegate = delegate;
//    self.interfaceName = interface;
    
    //里面有中文。需要转化为NSUTF8StringEncoding
    NSURL *url = [NSURL URLWithString:urlString];
    
    
    _fileRequest = [ASIFormDataRequest requestWithURL:url];
    [_fileRequest setValidatesSecureCertificate:NO];
    [_fileRequest setRequestMethod:@"POST"];
    [_fileRequest addRequestHeader:@"Accept" value:@"application/json"];
    //    [_fileRequest addRequestHeader:@"Content-Type" value:@"application/json"];
    [_fileRequest addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    
    //添加Post数据
    [_fileRequest addPostValue:fileName forKey:@"fileName"];
    [_fileRequest addPostValue:fileType forKey:@"fileType"];
    //添加ISA 密文验证
    if ([CacheManagement instance].userEncode&&![[CacheManagement instance].userEncode isEqualToString:@""])
        [_fileRequest addRequestHeader:@"Authorization"
                             value:[NSString stringWithFormat:@"Basic %@",[CacheManagement instance].userEncode]];
    
   	[_fileRequest setTimeOutSeconds:200];

    if(filePath!=nil && ![filePath isEqualToString:@""])
    {
        [_fileRequest setFile:filePath forKey:fileName];
    }

   	[_fileRequest startSynchronous];
    [_fileRequest retain];
    
    NSError *error = [_request error];
    NSString *response = nil;
    if (!error) {
        response = [_fileRequest responseString];
        if (![response JSONValue]) {
            response = [AES128Util AES128Decrypt:[_fileRequest responseString] key:[CommonUtil getDecryKey:[CacheManagement instance].currentDBUser.userName]]  ;
        }
    }
    
    return response;
}

//带附件 的安装报告提交方法 wendy
-(void) sendHttpFileRequest:(NSString *) urlString
                  xmlString:(NSString *) xmlString
                   delegate:(id)delegate
                   fileType:(NSString*)fileType
                   filePathArr:(NSArray *)picArr
              InterfaceName:(NSString *)interface
              xmlPathString:(NSString *)xmlPath
{
    // 先检查ASIHttpRequest是否为空，没空先relase,防止多次调用此函数
    
    if (_fileRequest != nil)
    {
        _fileRequest.delegate=nil;
		[_fileRequest release];
		_fileRequest = nil;
	}

    // 先将delegate和接口名保存到实例变量
    self.delegate = delegate;
    self.interfaceName = interface;
    
    //里面有中文。需要转化为NSUTF8StringEncoding
    NSURL *url = [NSURL URLWithString:urlString];
    
    _fileRequest = [ASIFormDataRequest requestWithURL:url];
    [_fileRequest setValidatesSecureCertificate:NO]; // no
    [_fileRequest setRequestMethod:@"POST"];
    [_fileRequest addRequestHeader:@"Accept" value:@"application/json"];
    //    [_fileRequest addRequestHeader:@"Content-Type" value:@"application/json"];
    [_fileRequest addRequestHeader:@"Content-Type" value:@"text/xml; charset=utf-8"];
    
    //添加Post数据
    [_fileRequest addPostValue:fileType forKey:@"fileType"];
    //添加ISA 密文验证
    if ([CacheManagement instance].userEncode&&![[CacheManagement instance].userEncode isEqualToString:@""])
        [_fileRequest addRequestHeader:@"Authorization"
                             value:[NSString stringWithFormat:@"Basic %@",[CacheManagement instance].userEncode]];
    
	[_fileRequest setDelegate:self];
    _fileRequest.uploadProgressDelegate = self ;
    _fileRequest.showAccurateProgress = YES ;
	[_fileRequest setDidFinishSelector:@selector(didFinish:)];
	[_fileRequest setDidFailSelector:@selector(didFailed:)];

    
    NSMutableArray *zipObjectArray = [NSMutableArray array];
    NSString *zipPath = @"" ;
    for (NSString* filePath in picArr)
    {
        if(filePath!=nil && ![filePath isEqualToString:@""]&&![filePath isEqualToString:@"0"])
        {
            NSMutableArray *pathArray = [NSMutableArray arrayWithArray:[filePath componentsSeparatedByString:@"/"]] ;
            [pathArray removeLastObject] ;
            zipPath = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[[pathArray componentsJoinedByString:@"/"] componentsSeparatedByString:@"dataCaches"] lastObject]];
            
            [zipObjectArray addObject:[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[filePath componentsSeparatedByString:@"dataCaches"] lastObject]]] ;
        }
    }
    
    NSFileManager *appFileManager = [NSFileManager defaultManager] ;
    
    if ([picArr count]&&![zipPath isEqualToString:@""]) {
        
        NSArray *fileList = [appFileManager subpathsAtPath:zipPath];
        
        for (NSString *format in fileList) {
            
            NSString *lastName = [[format componentsSeparatedByString:@"."] lastObject];
            if ([lastName isEqualToString:@"xml"]||
                [lastName isEqualToString:@"zip"]) {
                
                [appFileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",zipPath,format] error:nil] ;
            }
        }
    }
    else {
    
        NSArray *fileList = [appFileManager subpathsAtPath:xmlPath];
        
        for (NSString *format in fileList) {
            
            NSString *lastName = [[format componentsSeparatedByString:@"."] lastObject];
            if ([lastName isEqualToString:@"zip"]) {
                
                [appFileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",xmlPath,format] error:nil] ;
            }
        }
        zipPath = xmlPath ;
    }
    
    NSString* cachePath = [NSString stringWithFormat:@"%@/%@.xml",zipPath,[Utilities GetUUID]];
    if(![appFileManager fileExistsAtPath:cachePath])
    {
        [appFileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    [appFileManager removeItemAtPath:cachePath error:nil];
    NSData* xmlData = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
    [xmlData writeToFile:cachePath atomically:YES];
    [zipObjectArray addObject:cachePath];
    
    
    NSString *finalPath = [NSString stringWithFormat:@"%@/IOS%@.zip",zipPath,[Utilities GetUUID]] ;
    finalPath = [NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[finalPath componentsSeparatedByString:@"dataCaches"] lastObject]];
    if ([appFileManager fileExistsAtPath:finalPath]) {
        
        [appFileManager removeItemAtPath:finalPath error:nil] ;
    }
    
    
   BOOL result = [SSZipArchive createZipFileAtPath:finalPath withFilesAtPaths:zipObjectArray];
    if (result) {
        
        [_fileRequest setFile:finalPath forKey:@"zipfile"];
        
        [_fileRequest startAsynchronous];
        [_fileRequest retain];
    }
    else {
    
        [self failToCreateZip];
    }
}

- (void)failToCreateZip {

    if (_fileRequest != nil) {
        
        _fileRequest.delegate = nil;
        [_fileRequest release];
        _fileRequest = nil;
    }
    
    // 将返回的信息传到外面
    if ([self.delegate respondsToSelector:@selector(completeFromServer:CurrentError:InterfaceName:)])
    {
        [self.delegate completeFromServer:nil CurrentError:@"Request Failed" InterfaceName:_interfaceName];
    }
}


//不带附件的访问服务器方法
-(void) sendHttpRequest:(NSString *) urlString
                   delegate:(id)delegate
              InterfaceName:(NSString *)interface
{
    // 先检查ASIHttpRequest是否为空，没空先relase,防止多次调用此函数
    if (_request != nil) 
    {
         _request.delegate=nil;
		[_request release];
		_request = nil;
	}
    
    // 先将delegate和接口名保存到实例变量
    self.delegate = delegate;
    self.interfaceName = interface;
    
    //里面有中文。需要转化为NSUTF8StringEncoding
    NSURL *url = [NSURL URLWithString:urlString];
    
    _request = [ASIHTTPRequest requestWithURL:url];
    [_request setValidatesSecureCertificate:NO];
    [_request setRequestMethod:@"GET"];
    [_request addRequestHeader:@"Accept" value:@"application/json"];
    [_request addRequestHeader:@"Content-Type" value:@"application/json"];
    
    //添加ISA 密文验证
    if ([CacheManagement instance].userEncode&&![[CacheManagement instance].userEncode isEqualToString:@""])
        [_request addRequestHeader:@"Authorization"
                         value:[NSString stringWithFormat:@"Basic %@",[CacheManagement instance].userEncode] ];
    
	[_request setTimeOutSeconds:600];
	[_request setDelegate:self];
	[_request setDidFinishSelector:@selector(didFinish:)];
	[_request setDidFailSelector:@selector(didFailed:)];
	[_request startAsynchronous];
    [_request retain];
}

//不带附件的同步访问服务器方法
-(NSString*)sendHttpRequest:(NSString *)urlString InterfaceName:(NSString *)interface {
    // 先检查ASIHttpRequest是否为空，没空先relase,防止多次调用此函数
    if (_request != nil)
    {
        _request.delegate=nil;
		[_request release];
		_request = nil;
	}
    
    // 先将delegate和接口名保存到实例变量
    self.interfaceName = interface;
    
    //里面有中文。需要转化为NSUTF8StringEncoding
    NSURL *url = [NSURL URLWithString:urlString];
//     NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    
    _request = [ASIHTTPRequest requestWithURL:url];
    [_request setValidatesSecureCertificate:NO];
    [_request setRequestMethod:@"GET"];
    [_request addRequestHeader:@"Accept" value:@"application/json"];
    [_request addRequestHeader:@"Content-Type" value:@"application/json"];
    
    //添加ISA 密文验证
    if ([CacheManagement instance].userEncode&&![[CacheManagement instance].userEncode isEqualToString:@""])
        [_request addRequestHeader:@"Authorization"
                         value:[NSString stringWithFormat:@"Basic %@",[CacheManagement instance].userEncode] ];
    
	[_request setTimeOutSeconds:600];
	[_request startSynchronous];
    NSError *error = [_request error];
    NSString *response = nil;
    if (!error){
        response = [_request responseString];
        if (![response JSONValue]) {
            response = [AES128Util AES128Decrypt:[_request responseString] key:[CommonUtil getDecryKey:[CacheManagement instance].currentDBUser.userName]]  ;
        }
    }
    [_request retain];
    return response;
}




//获取返回的错误信息
-(NSString *)getRequestError:(ASIHTTPRequest *)request
{
    NSString *errorMsg=nil;
    NSInteger errCode= [request responseStatusCode];
    if(errCode !=200)
    {
        if (errCode ==401) //域验证失败
        {
            errorMsg =@"401";
        }
        else 
        {
            NSError * error =[request error];
            NSLog(@"error==%@",[error description]);
            errorMsg =NSLocalizedString(@"msgConnectNetError", nil);
        }
    }
    return errorMsg;
}

#pragma mark - ASIHttpRequest delegate

// 访问完成
- (void)didFinish:(ASIHTTPRequest *)request{

	NSString *responseString = [request responseString];
    if (![responseString JSONValue]) {
        responseString = [AES128Util AES128Decrypt:[request responseString] key:[CommonUtil getDecryKey:[CacheManagement instance].userLoginName]]  ;
    }
    //错误信息
    NSString *errorMsg =[self getRequestError:request];
    //　这里释放request，且将delegate设为nil,防止再像delegate发消息
    [_request release];
	_request.delegate = nil;
	_request = nil;
    
    if (_fileRequest != nil) {
		_fileRequest.delegate = nil;
		[_fileRequest release];
         _fileRequest = nil;
	}
    
    [CacheManagement instance].lastLoginTime=[NSDate date];//记录最后一次成功访问网络时间
    
    // 将返回的信息传到外面
    if ([self.delegate respondsToSelector:@selector(completeFromServer:CurrentError:InterfaceName:)]) 
    {
        [self.delegate completeFromServer:responseString CurrentError:errorMsg InterfaceName:_interfaceName];
    }
}

// 访问失败
- (void)didFailed:(ASIHTTPRequest *)request
{
    //错误信息
    
    NSString *errorMsg =[self getRequestError:request];
    
    NSError * err = [request error];
    NSInteger errCode= [err  code];
    if(errCode ==ASIConnectionFailureErrorType && errorMsg==nil) //网络请求失败
    {
        errorMsg =NSLocalizedString(@"msgConnectNetError", nil);
        if (SYSLanguage) {
            errorMsg = @"Request failed";
        }
//        [Utilities showAlertMessageView:errorMsg];

    }
    //　这里释放request，且将delegate设为nil,防止再像delegate发消息
    [_request release];
	_request.delegate = nil;
	_request = nil;

    if (_fileRequest != nil) 
    {
		_fileRequest.delegate = nil;
		[_fileRequest release];
        _fileRequest=nil;
	}
    
    // 将返回的信息传到外面
    if ([self.delegate respondsToSelector:@selector(completeFromServer:CurrentError:InterfaceName:)]) 
    {
        [self.delegate completeFromServer:nil CurrentError:errorMsg InterfaceName:_interfaceName];
    }
}


// 释放
-(void) dealloc
{
    _delegate=nil;
    [_interfaceName release];
    
    // 释放ASIHTTPRequest
    if (_request != nil) 
    {
		_request.delegate = nil;
		[_request release];
	}
    if (_fileRequest != nil) 
    {
		_fileRequest.delegate = nil;
		[_fileRequest release];
	}
    [super dealloc];
}

@end
