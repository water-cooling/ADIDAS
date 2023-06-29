//
//  IssueManagement.m
//  ADIDAS
//
//  Created by testing on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IssueManagement.h"
#import "FMDatabase.h"
#import "ASIHTTPRequest.h"
#import "SqliteHelper.h"
#import "Utilities.h"
#import "JSON.h"
#import "IssueDA.h"
#import "CommonDefine.h"
#import "CacheManagement.h"
#import "NSString+filter.h"

@implementation IssueManagement
@synthesize delegate;

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

//获取表中的数据
- (void)getTableDataServer:(NSString *) tableName
{
    NSString* urlString = [NSString stringWithFormat:kGetDataByTableNameString,kWebDataString,tableName,[[CacheManagement instance].currentDBUser.userName mk_urlEncodedString]];
    if([tableName isEqualToString:kSYNC_PARAMETER_VERSION])
        urlString = [NSString stringWithFormat:kGetSyncVersionString,kWebDataString,[[CacheManagement instance].currentDBUser.userName mk_urlEncodedString]];
    NSLog(@"------------ %@",urlString);
    [_httpRequestHelper sendHttpRequest:urlString delegate:self InterfaceName:tableName];
}

// 服务器返回
-(void) completeFromServer:(NSString *)responseString CurrentError:(NSString *)error InterfaceName:(NSString *)interface
{
    if ([delegate respondsToSelector:@selector(completeDownloadServer:CurrentError:InterfaceName:)]) {
        [delegate  completeDownloadServer:responseString CurrentError:error InterfaceName:interface];
    }
}


//本地数据操作
//获取本地数据版本信息
- (NSMutableArray *) getLocalSyncVersion
{
    IssueDA * issueDA =[[IssueDA alloc] autorelease];
    return [issueDA getLocalSyncVersionDB];
}

//保存数据版本信息到本地
-(BOOL) saveLocalSyncVersion:(SyncParaVersionEntity *) newSyncVersion  newIssueData:(NSArray *)newIssueData
{
    IssueDA * issueDA =[IssueDA alloc];
    [issueDA saveLocalSyncVersionDB:newSyncVersion newIssueData:newIssueData ];
    [issueDA release];
    return TRUE;
}

//查询本地Issue数据
- (NSMutableArray *)getIssueCategoryData:tableName  parentID:(NSString *)parentID  categoryType:(NSString *)categoryType
{
    IssueDA * issueDA =[[IssueDA alloc] autorelease];
    return [issueDA getIssueCategoryDataDB:tableName parentID:parentID categoryType:categoryType];
}
- (NSMutableArray *)getIssueItemData:tableName categoryID:(NSString *)categoryID 
{
    IssueDA * issueDA =[[IssueDA alloc] autorelease];
    return [issueDA getIssueItemDataDB:tableName categoryID:categoryID];
}


@end
