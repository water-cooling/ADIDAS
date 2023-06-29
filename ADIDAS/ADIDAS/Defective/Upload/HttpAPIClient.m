//
//  HttpAPIClient.m
//  ComixB2B
//
//  Created by 桂康 on 2016/11/11.
//  Copyright © 2016年 joinone. All rights reserved.
//

#import "HttpAPIClient.h"
#import "CommonDefine.h"

@implementation HttpAPIClient

+ (instancetype)sharedClient {

    static HttpAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedClient = [[HttpAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kWebDefectiveHeadString]];
        
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        _sharedClient.requestSerializer.timeoutInterval = 20;
        
        
        _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
        
        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [_sharedClient.requestSerializer setValue:@"customer defective" forHTTPHeaderField:@"User-Agent"];

        
        if ([CacheManagement instance].userEncode&&![[CacheManagement instance].userEncode isEqualToString:@""]) {
            
            [_sharedClient.requestSerializer setValue:[NSString stringWithFormat:@"Basic %@",[CacheManagement instance].userEncode ? [CacheManagement instance].userEncode : @""] forHTTPHeaderField:@"Authorization"] ;
        }
        [_sharedClient.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [_sharedClient.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

        _sharedClient.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", @"text/plain", nil];
    });
    
    return _sharedClient;
}



@end
