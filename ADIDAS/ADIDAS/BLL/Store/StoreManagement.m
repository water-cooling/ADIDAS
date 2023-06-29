
//
//  UserInfoManagement.m
//  WSE
//
//  Created by testing on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StoreManagement.h"
#import "SqliteHelper.h"
#import "ASIHTTPRequest.h"
#import "Utilities.h"
#import "JSON.h"
#import "AppDelegate.h"
#import "StoreEntity.h"
#import "CacheManagement.h"
#import "ListItemEntity.h"
#import "CommonDefine.h"
#import "NSString+filter.h"


@implementation StoreManagement

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

// 获取巡店计划列表
- (void)getPlanList
{
    NSString* urlString = [NSString stringWithFormat:kGetVisitPlanNew,kWebDataString,
                            [CacheManagement instance].currentUser.UserId,SYSLanguage?@"EN":@"CN"];
    [_httpRequestHelper sendHttpRequest:urlString delegate:self InterfaceName:kGetVisitPlan];
}

//***********获取附近门店信息***********
//获取附近门店信息
- (void)getStoresServer
{
    if (![APPDelegate checkNetWork])
    {
        ALERTVIEW(NO_NETWORK);
        return;
    }
    NSString* urlString = [NSString stringWithFormat:kFindNearStore2String,kWebDataString,
                           [CacheManagement instance].currentLocation.locationX,
                           [CacheManagement instance].currentLocation.locationY,
                           [[CacheManagement instance].currentDBUser.userName mk_urlEncodedString],
                            kMOBILESOLUTIONVERSION];

    [_httpRequestHelper sendHttpRequest:urlString delegate:self InterfaceName:kFindNearStore2String];
}

-(void)getStoresServerByUserID
{
    if (![APPDelegate checkNetWork])
    {
        ALERTVIEW(NO_NETWORK);
        return;
    }
    NSString* urlString  = [NSString stringWithFormat:kGetVisitStore,kWebDataString,[CacheManagement instance].currentUser.UserId];
    [_httpRequestHelper sendHttpRequest:urlString delegate:self InterfaceName:kGetVisitStore];
    
}

//根据输入的门店编码获取门店信息
- (void)getStoreByCodeServer:(NSString *) stroreCode
{
    if (![APPDelegate checkNetWork])
    {
        ALERTVIEW(NO_NETWORK);
        return;
    }
    NSString* urlString = [NSString stringWithFormat:kFindStoreByCodeString,kWebRisesString,
                           stroreCode,
                           [[CacheManagement instance].currentDBUser.userName mk_urlEncodedString],
                          kMOBILESOLUTIONVERSION];
     [_httpRequestHelper sendHttpRequest:urlString delegate:self InterfaceName:kFindStoreByCodeString];
}
// 同步方法
- (NSString*)getStoreByCodeServerSyn:(NSString *) stroreCode
{
    NSString* urlString = [NSString stringWithFormat:kFindStoreByCodeString,kWebDataString,
                           stroreCode,
                           [[CacheManagement instance].currentDBUser.userName mk_urlEncodedString],
                           kMOBILESOLUTIONVERSION];
   return [_httpRequestHelper sendHttpRequest:urlString InterfaceName:kFindStoreByCodeString];
}

- (NSString*)getStoreByCodeServer_:(NSString *) stroreCode
{
    NSString* urlString = [NSString stringWithFormat:kGetVisitStoreByStoreCode,kWebDataString,
                           [[CacheManagement instance].currentDBUser.userID mk_urlEncodedString],
                           stroreCode];
    return [_httpRequestHelper sendHttpRequest:urlString InterfaceName:kGetVisitStore];
}

- (NSString*)getStoreTrackingByCodeServerSyn:(NSString *) stroreCode withCheckDate:(NSString *)date
{
    NSString* urlString = [NSString stringWithFormat:kStoreTrackingByCheckDate,kWebDataString,
                           stroreCode,
                           [[CacheManagement instance].currentDBUser.userName mk_urlEncodedString],
                           date];
   return [_httpRequestHelper sendHttpRequest:urlString InterfaceName:kFindStoreByCodeString];
}

//获取新增门店编码
- (void)getTempStoreServer
{
    if (![APPDelegate checkNetWork])
    {
        ALERTVIEW(NO_NETWORK);
        return;
    }
    NSString* urlString = [NSString stringWithFormat:kGetNewTempStoreCodeString,kWebRisesString,
                           [[CacheManagement instance].currentDBUser.userName mk_urlEncodedString],
                           kMOBILESOLUTIONVERSION];
     [_httpRequestHelper sendHttpRequest:urlString delegate:self InterfaceName:kGetNewTempStoreCodeString];
}

// 根据storecode 获取活动报告
- (void)getInstallList:(NSString*)storeCode
{
    if (![APPDelegate checkNetWork])
    {
        ALERTVIEW(NO_NETWORK);
        return;
    }
    NSString* urlString = [NSString stringWithFormat:kGetInstallList,kWebDataString,[CacheManagement instance].currentDBUser.userID,storeCode];
//      NSString* urlString = [NSString stringWithFormat:kGetInstallList,kWebDataString,@"51528070-e47d-41fd-b15f-640ff10f6c94",@"P15464"];
    [_httpRequestHelper sendHttpRequest:urlString delegate:self InterfaceName:kGetInstallList];
}

// 根据活动id 获取活动物料清单
-(void)getPopList:(NSString *)campaignID
{
    if (![APPDelegate checkNetWork])
    {
        ALERTVIEW(NO_NETWORK);
        return;
    }
    NSString* urlString = [NSString stringWithFormat:kGetPopList,kWebDataString,[CacheManagement instance].currentUser.UserId,[CacheManagement instance].currentStore.StoreCode,campaignID];
    [_httpRequestHelper sendHttpRequest:urlString delegate:self InterfaceName:kGetPopList];}


// 服务器返回
-(void) completeFromServer:(NSString *)responseString CurrentError:(NSString *)error InterfaceName:(NSString *)interface
{
    if(error !=nil && ![error  isEqual:@""])
    {
        //有错误，不做处理，直接返回错误信息
//        [Utilities showAlertMessageView:@"请求超时"];
    }
    else
    {
        if([interface isEqualToString:kFindNearStore2String])
        {
            //解析返回值
            NSArray *array = [responseString JSONValue];  
            NSMutableArray *dictStores = [[[NSMutableArray alloc] init] autorelease];
            for (NSDictionary *dictionary  in array) 
            {
                StoreEntity *entity = [[[StoreEntity alloc] initWithDictionary:dictionary] autorelease];
                [dictStores addObject:entity];
            }
            [CacheManagement instance].currStoreList = dictStores;
        }
        else if([interface isEqualToString: kFindStoreByCodeString])
        {
            //解析返回值
            NSArray *array = [responseString JSONValue];
            StoreEntity *entity = [[[StoreEntity alloc] initWithDictionary:[array firstObject]] autorelease];
            if([entity.CheckFlag isEqual:@"0"])
            {
                error=entity.CheckError;
            }
            else
            {
                [CacheManagement instance].currentStore = entity;
            }
        }
        else if([interface isEqualToString: kGetNewTempStoreCodeString])
        {
            //解析返回值
            NSDictionary *dic = [responseString JSONValue]; 
            StoreEntity *entity = [[[StoreEntity alloc] initWithDictionary:dic] autorelease];
            if([entity.CheckFlag isEqual:@"0"])
            {
                error=entity.CheckError;
            }
            else
            {
                [CacheManagement instance].currentStore = entity;
            }
        }
        else if ([interface isEqualToString:kGetInstallList])
        {
            
        }
        else if ([interface isEqualToString:kGetPopList])
        {
        
        }
    }

    if ([delegate respondsToSelector:@selector(completeGetStoreInfoServer:CurrentError:InterfaceName:)]) {
        [delegate completeGetStoreInfoServer:responseString CurrentError:error InterfaceName:interface];
    }
}




- (void)dealloc {
    
    [_httpRequestHelper release];
    self.delegate = nil; 
    [super dealloc];
}

@end
