//
//  IssueDA.h
//  ADIDAS
//
//  Created by testing on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "SyncParaVersionEntity.h"

@interface IssueDA : NSObject


//获取本地数据版本信息
- (NSMutableArray *) getLocalSyncVersionDB;
//保存数据版本信息到本地
-(BOOL) saveLocalSyncVersionDB:(SyncParaVersionEntity *) newSyncVersion  newIssueData:(NSArray *)newIssueData;


//本地数据查询方法
- (NSMutableArray *)getIssueCategoryDataDB:tableName  parentID:(NSString *)parentID  categoryType:(NSString *)categoryType;
- (NSMutableArray *)getIssueItemDataDB:tableName categoryID:(NSString *)categoryID ;
@end
