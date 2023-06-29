//
//  IssueManagement.h
//  ADIDAS
//
//  Created by testing on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SyncParaVersionEntity.h"
#import "IssueCategoryEntity.h"
#import "IssueItemEntity.h"
#import "HttpRequestHelper.h"


@protocol IssueManagementDelegate <NSObject>

@optional
- (void)completeDownloadServer:(NSString *)responseString  CurrentError:(NSString *)error InterfaceName:(NSString *)interface;
@end


@interface IssueManagement : NSObject
{
    HttpRequestHelper *_httpRequestHelper;
}

@property(nonatomic,assign) id<IssueManagementDelegate> delegate;

//访问服务器方法
- (void)getTableDataServer:(NSString *) tableName;



//获取本地数据版本信息
- (NSMutableArray *) getLocalSyncVersion;
//保存数据版本信息到本地
-(BOOL) saveLocalSyncVersion:(SyncParaVersionEntity *) newSyncVersion  newIssueData:(NSArray *)newIssueData;

//查询本地Issue数据
- (NSMutableArray *)getIssueCategoryData:tableName  parentID:(NSString *)parentID  categoryType:(NSString *)categoryType;
- (NSMutableArray *)getIssueItemData:tableName categoryID:(NSString *)categoryID ;

@end
