//
//  StoreManagement.h
//  ADIDAS
//
//  Created by testing on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequestHelper.h"

@class ASIHTTPRequest;

@protocol StoreManagementDelegate <NSObject>

@optional
- (void)completeGetStoreInfoServer:(NSString *)responseString  CurrentError:(NSString *)error  InterfaceName:(NSString *)interface;

@end


@interface StoreManagement : NSObject
{
    HttpRequestHelper *_httpRequestHelper;
}


@property(nonatomic,assign) id<StoreManagementDelegate> delegate;

//获取附近门店信息
- (void)getStoresServer;
//根据输入的门店编码获取门店信息
- (void)getStoreByCodeServer:(NSString *) stroreCode;
//根据权限搜索门店信息
-(void)getStoresServerByUserID;
// 同步方法
- (NSString*)getStoreByCodeServerSyn:(NSString *) stroreCode;
- (NSString*)getStoreByCodeServer_:(NSString *) stroreCode;
- (NSString*)getStoreTrackingByCodeServerSyn:(NSString *) stroreCode withCheckDate:(NSString *)date;
//获取新增门店编码
- (void)getTempStoreServer;
// 获取活动列表
- (void)getInstallList:(NSString*)storeCode;
// 获取安装报告
-(void)getPopList:(NSString*)campaignID;
// VM
- (void)getPlanList;

@end
