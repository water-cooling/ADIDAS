//
//  HttpAPIClient.h
//  ComixB2B
//
//  Created by 桂康 on 2016/11/11.
//  Copyright © 2016年 joinone. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface HttpAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient ;

@end
