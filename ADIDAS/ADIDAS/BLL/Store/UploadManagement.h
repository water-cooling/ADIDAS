//
//  StoreManagement.h
//  ADIDAS
//
//  Created by testing on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "HttpRequestHelper.h"

@protocol UploadManagementDelegate <NSObject>

@optional
- (void)completeUploadServer:(NSString *)error;
@end


@interface UploadManagement : NSObject
{
    HttpRequestHelper *_httpRequestHelper;
}


@property(nonatomic,assign) id<UploadManagementDelegate> delegate;

//上传门店签到信息
- (void)uploadCheckInFileToServer:(NSString *) xmlStr picPath:(NSString *) picPath;

// 上传 检查评分表XML 到服务器
-(void)uploadVMRailCheckFileToServer:(NSString *)xmlStr fileType:(NSString* )fileType andfilePathArr:(NSArray*)picarr andxmlPath:(NSString *)xmlpath;

// 上传安装报告 xml 和图片
-(void)uploadInstallFileToServer:(NSString *)xmlStr fileType:(NSString* )fileType andfilePathArr:(NSArray*)picarr andxmlPath:(NSString *)xmlpath;



@end
