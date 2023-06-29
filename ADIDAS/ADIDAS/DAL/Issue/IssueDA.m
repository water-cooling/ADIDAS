 //
//  UserDA.m
//  WSE
//
//  Created by testing on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IssueDA.h"
#import "SqliteHelper.h"
#import "Utilities.h"
#import "SyncParaVersionEntity.h"
#import "JSON.h"
#import "IssueCategoryEntity.h"
#import "IssueItemEntity.h"
#import "CommonDefine.h"
#import "Utilities.h"
#import "ListItemEntity.h"
#import "FR_ArmsItemEntity.h"
#import "VM_CHECK_ITEM_Entity.h"
#import "NVM_STORE_PHOTO_ZONE_Entity.h"
#import "NVM_ISSUE_PHOTO_ZONE_Entity.h"
#import "VmCheckCategoryEntity.h"
#import "VmScoreCardEntity.h"
#import "VmScoreCardDetailEntity.h"
#import "FrIssuePhotoZoneEntity.h"
#import "FrHeadCountItemEntity.h"
#import "NvmMstStoreAuditItemEntity.h"
#import "NvmMstOnSitePhotoZoneEntity.h"


@interface IssueDA(private)  

//本地数据版本信息
-(void) insertSyncVersion:(SyncParaVersionEntity *) newSyncVersion broker: (FMDatabase *) db;
-(void) deleteSyncVersionByID:(NSString *)syncID broker: (FMDatabase *) db;

//保存表数据
-(void) saveLocalIssueData:(NSArray *)newIssueData tableName:(NSString *)tableName  broker: (FMDatabase *) db;
-(void) saveData:(NSDictionary *)dictionary tableName:(NSString *)tableName broker: (FMDatabase *) db;
//清除本地表数据
-(BOOL) deleteLocalIssueData:(NSString *)tableName broker: (FMDatabase *) db;
@end


@implementation IssueDA

//获取本地数据版本信息
- (NSMutableArray *) getLocalSyncVersionDB
{
	NSString *sql = @"Select PARAMETER_TYPE,PARAMETER_VERSION FROM SYS_PARAMETER order by ORDER_NO ";
	NSMutableArray *dict= [[NSMutableArray alloc] init];
	
	FMResultSet *rs;
	@try {
        rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
        while ([rs next]) {
			SyncParaVersionEntity * entity = [[SyncParaVersionEntity alloc] initWithFMResultSet:rs];
            [dict addObject:entity];
            [entity release];
		}
	}
	@catch (NSException *e) {
		@throw e;
        NSLog(@"%@",e.description);
        
	}
	@finally {
		if (rs) {
			[rs close];
		}
	}
	return [dict autorelease];
}

//*************Sync Version 表数据方法*******************    
//保存数据版本信息到本地
-(BOOL) saveLocalSyncVersionDB:(SyncParaVersionEntity *) newSyncVersion  newIssueData:(NSArray *)newIssueData
{
    //  针对数据库的操作 要有回滚机制，保证数据库内容正常。
	FMDatabase *db = [[SqliteHelper shareCommonSqliteHelper] database];
	[db beginTransaction];
    
    BOOL result = YES;
	@try 
	{
        //先删除  SYNC_PARAMETER_VERSION 表里面的 单条表数据
        [self deleteSyncVersionByID:newSyncVersion.paraType broker:db];
        
        //Issue 数据操作
        [self saveLocalIssueData:newIssueData tableName:newSyncVersion.paraType broker:db];
        
        //插入对应的Issue表数据
        [self insertSyncVersion:newSyncVersion broker:db];
    }
    @catch (NSException *e) 
    {
        result = NO;
    }
    @finally 
    {
        if(result==YES)
        {
            [db commit];
        }
        else 
        {
            [db rollback];
        }
    }
	return TRUE;
}

//新增
-(void) insertSyncVersion:(SyncParaVersionEntity *) newSyncVersion broker: (FMDatabase *) db
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO SYS_PARAMETER (PARAMETER_TYPE,PARAMETER_VERSION,ORDER_NO,REMARK,LAST_MODIFIED_BY,LAST_MODIFIED_TIME) values (?,?,?,?,?,?)"];
    [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql,
     newSyncVersion.paraType,newSyncVersion.paraVersion,newSyncVersion.orderNo,newSyncVersion.remark, 
     newSyncVersion.lastModifyBy,newSyncVersion.lastModifyTime];
}
//删除rfaz
-(void) deleteSyncVersionByID:(NSString *)syncID broker: (FMDatabase *) db
{
	NSString *sql = [NSString stringWithFormat:@"delete from SYS_PARAMETER where PARAMETER_TYPE='%@'",syncID]; 
    [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql];
}

// 删除workmain表数据 wendy

-(void) deleteWorkMainLastDatabroker:(FMDatabase*)db
{
    NSString* sql = [NSString stringWithFormat:@"delete from IST_WORK_MAIN"];
    [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql];
}


//*************Issue 表数据方法*******************
- (NSMutableArray *)getIssueCategoryDataDB:tableName  parentID:(NSString *)parentID  categoryType:(NSString *)categoryType 
{
    NSString *sql;
    NSInteger index =[Utilities getIssueTableIndex:tableName];
    if(index ==1) //kSTORE_ISSUE_CATEGORY
    {
        sql = [NSString stringWithFormat:@"select STORE_ISSUE_CATEGORY_ID,NAME_CN from %@ where PARENT_CATEGORY_ID ='%@' and TYPE=%@ and IS_DELETED=0 order by ORDER_NO",tableName,parentID,categoryType];
    }
    if(index ==2) //kSTORE_ISSUE_ITEM
    {
        sql = [NSString stringWithFormat:@"select STORE_ISSUE_ITEM_ID,NAME_CN from %@ where STORE_ISSUE_CATEGORY_ID ='%@' and IS_DELETED=0 order by ORDER_NO",tableName,parentID];
    }
    
    NSMutableArray *dict= [[NSMutableArray alloc] init ];
	FMResultSet *rs;
	@try {
        rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
		while ([rs next]) {
            if(index ==1)
            {
                ListItemEntity * entity = [[ListItemEntity alloc] init];
                entity.itemID = [rs stringForColumn:@"STORE_ISSUE_CATEGORY_ID"];
                entity.itemName = [rs stringForColumn:@"NAME_CN"];
                [dict addObject:entity];
                [entity release];
            }
            else if(index ==2)
            {
                ListItemEntity * entity = [[ListItemEntity alloc] init];
                entity.itemID = [rs stringForColumn:@"STORE_ISSUE_ITEM_ID"];
                entity.itemName = [rs stringForColumn:@"NAME_CN"];
                [dict addObject:entity];
                [entity release];
            }
		}
	}
	@catch (NSException *e) {
		@throw e;
	}
	@finally {
		if (rs) {
			[rs close];
		}
	}
	return [dict autorelease];
}

- (NSMutableArray *)getIssueItemDataDB:tableName categoryID:(NSString *)categoryID 
{
    NSString *sql;
    NSInteger index =[Utilities getIssueTableIndex:tableName];
    if(index ==2) //STORE_ISSUE_ITEM
    {
        sql = [NSString stringWithFormat:@"select STORE_ISSUE_ITEM_ID,NAME_CN from %@ where STORE_ISSUE_CATEGORY_ID ='%@' order by ORDER_NO",tableName,categoryID];
    }
    NSMutableArray *dict= [[NSMutableArray alloc] init ];
	FMResultSet *rs;
	@try
    {
        rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
		while ([rs next])
        {
            if(index ==2)
            {
                IssueItemEntity * entity = [[IssueItemEntity alloc] initWithFMResultSet:rs];
                [dict addObject:entity];
                [entity release];
            }
		}
	}
	@catch (NSException *e)
    {
		@throw e;
	}
	@finally
    {
		if (rs)
        {
			[rs close];
		}
	}
	return [dict autorelease];
}

//保存数据Issue信息到本地
-(void) saveLocalIssueData:(NSArray *)newIssueData tableName:(NSString *)tableName  broker: (FMDatabase *) db
{
    //整表删除
    [self deleteLocalIssueData:tableName broker:db];
    if ([tableName isEqualToString:@"FR_ARMS_ITEM"])
    {
        [self deleteLocalIssueData:@"IST_FR_ARMS_CHK" broker:db];
        [self deleteLocalIssueData:@"IST_FR_ARMS_CHK_ITEM" broker:db];
    }
    // 如果题目内容有更新，则需要删除结果主子表
    else if ([tableName isEqualToString:kNVM_VM_CHECK_ITEM])
    {
        [self deleteLocalIssueData:@"NVM_IST_VM_CHECK" broker:db];
        [self deleteLocalIssueData:@"NVM_IST_VM_CHECK_ITEM" broker:db];
    }
    else if ([tableName isEqualToString:@"NVM_VM_SCORECARD_ITEM"])
    {
        [self deleteLocalIssueData:@"NVM_IST_SCORECARD_CHECK" broker:db];
        [self deleteLocalIssueData:@"NVM_IST_SCORECARD_CHECK_PHOTO" broker:db];
    }
    else if([tableName isEqualToString:kNVM_ISSUE_PHOTO_ZONE])
    {
        [self deleteLocalIssueData:@"NVM_IST_ISSUE_PHOTO_LIST" broker:db];
    }
    else if([tableName isEqualToString:kNVM_STORE_PHOTO_ZONE])
    {
        [self deleteLocalIssueData:@"NVM_IST_STORE_PHOTO_LIST" broker:db];
    }
    
    for (NSDictionary *dictionary in newIssueData) 
    {
        [self saveData:dictionary tableName:tableName broker:db];
    }
}

//清除本地Issue表数据
-(BOOL) deleteLocalIssueData:(NSString *)tableName broker: (FMDatabase *) db
{
	NSString *sql = [NSString stringWithFormat:@"delete from  %@ ",tableName]; 
	return [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql];
}

//私有方法，保存Issue数据
-(void) saveData:(NSDictionary *)dictionary tableName:(NSString *)tableName broker: (FMDatabase *) db
{
    NSInteger index =[Utilities getIssueTableIndex:tableName];
    
    // 通过表名 来调用对应更新表方法 
    if(index == 1) //STORE_ISSUE_CATEGORY
    {
        IssueCategoryEntity *entity = [[IssueCategoryEntity alloc] initWithDictionary:dictionary];
        //新增
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO STORE_ISSUE_CATEGORY (STORE_ISSUE_CATEGORY_ID,PARENT_CATEGORY_ID,NAME_CN,NAME_EN,TYPE,IS_DELETED,ORDER_NO,REMARK,LAST_MODIFIED_BY,LAST_MODIFIED_TIME) values (?,?,?,?,?,?,?,?,?,?)"];
        [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql,
         entity.categoryID,
         entity.paraCateID,
         entity.nameCN,
         entity.nameEN,
         entity.type,
         entity.isDeleted,
         entity.orderNo,
         entity.remark,
         entity.lastModifyBy,
         entity.lastModifyTime];
        [entity release];
    }
    else if(index == 2) //STORE_ISSUE_ITEM
    {
        IssueItemEntity *entity = [[IssueItemEntity alloc] initWithDictionary:dictionary];
        //新增
        
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO STORE_ISSUE_ITEM (STORE_ISSUE_ITEM_ID,STORE_ISSUE_CATEGORY_ID,NAME_CN,NAME_EN,IS_DELETED,ORDER_NO,REMARK,LAST_MODIFIED_BY,LAST_MODIFIED_TIME) values (?,?,?,?,?,?,?,?,?)"];
        [[SqliteHelper shareCommonSqliteHelper] executeSQL:db SqlString:sql,
         entity.itemID,
         entity.categoryID,
         entity.nameCN,
         entity.nameEN, 
         entity.isDeleted,
         entity.orderNo,
         entity.remark,
         entity.lastModifyBy,
         entity.lastModifyTime];
        [entity release];
    }
    else if (index == 3)   
    {
        VM_CHECK_ITEM_Entity* entity = [[VM_CHECK_ITEM_Entity alloc]initWithDictionary:dictionary];
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_VM_CHECK_ITEM (VM_ITEM_ID,VM_CATEGORY_ID,ITEM_NO,ITEM_NAME_CN,ITEM_NAME_EN,ITEM_ICON,REASON_CN,REASON_EN,ORDER_NO,SCORE_OPTION,REMARK_CN,REMARK_EN,IS_KEY,IS_DELETED,STANDARD_SCORE,LAST_MODIFIED_BY,LAST_MODIFIED_TIME,DATASOURCE) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         entity.VM_ITEM_ID,
         entity.VM_CATEGORY_ID,
         [NSNumber numberWithInteger:entity.ITEM_NO],
         entity.ITEM_NAME_CN,
         entity.ITEM_NAME_EN,
         entity.ITEM_ICON,
         entity.REASON_CN,
         entity.REASON_EN,
         entity.ORDER_NO,
         entity.SCORE_OPTION,
         entity.REMARK_CN,
         entity.REMARK_EN,
         [NSNumber numberWithInteger:entity.IS_KEY],
         [NSNumber numberWithInteger:entity.IS_DELETED],
         entity.STANDARD_SCORE,
         entity.LAST_MODIFIED_BY,
         entity.LAST_MODIFIED_TIME,
         entity.DATASOURCE];
        [entity release];
    }
    else if (index == 4) // kNVM_ISSUE_PHOTO_ZONE
    {
        
        NVM_ISSUE_PHOTO_ZONE_Entity* entity = [[NVM_ISSUE_PHOTO_ZONE_Entity alloc]initWithDictionary:dictionary];
        NSString* sql = [NSString stringWithFormat:@"INSERT INTO NVM_ISSUE_PHOTO_ZONE (ISSUE_ZONE_CODE,ISSUE_ZONE_NAME_CN,ISSUE_ZONE_NAME_EN,ISSUE_TYPE,ORDER_NO,REMARK,IS_DELETED,IS_MUST,LAST_MODIFIED_BY,LAST_MODIFIED_TIME,DATASOURCE) values (?,?,?,?,?,?,?,?,?,?,?)"];
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         entity.ISSUE_ZONE_CODE,
         entity.ISSUE_ZONE_NAME_CN,
         entity.ISSUE_ZONE_NAME_EN,
         entity.ISSUE_TYPE,
         [NSNumber numberWithInteger:entity.ORDER_NO],
         entity.REMARK,
         [NSNumber numberWithInteger:entity.IS_DELETED],
         [NSNumber numberWithInteger:entity.IS_MUST],
         entity.LAST_MODIFIED_BY,
         entity.LAST_MODIFIED_TIME,
         entity.DATASOURCE];
        [entity release];
    }
    else if (index == 5) // kNVM_STORE_PHOTO_ZONE
    {
        NVM_STORE_PHOTO_ZONE_Entity* entity = [[NVM_STORE_PHOTO_ZONE_Entity alloc]initWithDictionary:dictionary];
        NSString* sql = [NSString stringWithFormat:@"INSERT INTO NVM_STORE_PHOTO_ZONE (PHOTO_ZONE_CODE,PHOTO_ZONE_NAME_CN,PHOTO_ZONE_NAME_EN,ORDER_NO,REMARK,IS_DELETED,IS_MUST,LAST_MODIFIED_BY,LAST_MODIFIED_TIME,ZONE_TYPE,DATASOURCE) values (?,?,?,?,?,?,?,?,?,?,?)"];
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         entity.PHOTO_ZONE_CODE,
         entity.PHOTO_ZONE_NAME_CN,
         entity.PHOTO_ZONE_NAME_EN,
         [NSNumber numberWithInteger:entity.ORDER_NO],
         entity.REMARK,
         [NSNumber numberWithInteger:entity.IS_DELETED ],
         [NSNumber numberWithInteger:entity.IS_MUST],
         entity.LAST_MODIFIED_BY,
         entity.LAST_MODIFIED_TIME,
         [NSNumber numberWithInteger:entity.ZONE_TYPE],
         entity.DATASOURCE];
        [entity release];
    }
    else if (index == 6) // FR_ARMS_ITEM
    {
        FR_ArmsItemEntity* entity = [[FR_ArmsItemEntity alloc]initWithDictionary:dictionary];
        
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO FR_ARMS_ITEM (FR_ARMS_ITEM_ID,ITEM_NAME_CN,ITEM_NAME_EN,ITEM_NO,SCORE_OPTION,IS_DELETED,REMARK_CN,REMARK_EN,REASONS_CN,REASONS_EN,LAST_MODIFIED_BY,LAST_MODIFIED_TIME,DATASOURCE) values (?,?,?,?,?,?,?,?,?,?,?,?,?)"];
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         entity.item_id,
         entity.item_name_cn,
         entity.item_name_en,
         entity.item_NO,
         entity.score_option,
         entity.isdelete,
         entity.remark_cn,
         entity.remark_en,
         entity.reason_cn,
         entity.reason_en,
         entity.last_modified_by,
         entity.last_modified_time,
         entity.DATASOURCE];
        [entity release];
    }
    else if (index == 7) // NVM_VM_CHECK_CATEGORY
    {
        VmCheckCategoryEntity* entity = [[VmCheckCategoryEntity alloc]initWithDictionary:dictionary];
        
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_VM_CHECK_CATEGORY (DATA_SOURCE,IS_DELETED,LAST_MODIFIED_BY,LAST_MODIFIED_TIME,NAME_CN,NAME_EN,ORDER_NO,PARENT_CATEGORY_ID,REMARK_CN,REMARK_EN,VM_CATEGORY_ID) values (?,?,?,?,?,?,?,?,?,?,?)"];
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         entity.DATA_SOURCE,
         entity.IS_DELETED,
         entity.LAST_MODIFIED_BY,
         entity.LAST_MODIFIED_TIME,
         entity.NAME_CN,
         entity.NAME_EN,
         entity.ORDER_NO,
         entity.PARENT_CATEGORY_ID,
         entity.REMARK_CN,
         entity.REMARK_EN,
         entity.VM_CATEGORY_ID];
        [entity release];
    }
    else if (index == 8) // NVM_VM_SCORECARD_ITEM
    {
        VmScoreCardEntity* entity = [[VmScoreCardEntity alloc]initWithDictionary:dictionary];
        
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_VM_SCORECARD_ITEM (SCORECARD_ITEM_ID,ITEM_NO,PHOTO_ZONE_CN,ITEM_NAME_CN,ITEM_NAME_EN,IS_DELETED,STANDARD_SCORE,LAST_MODIFIED_BY,LAST_MODIFIED_TIME,REMARK_CN,REMARK_EN,PHOTO_ZONE_EN,IS_KIDS) values (?,?,?,?,?,?,?,?,?,?,?,?,?)"];
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         entity.SCORECARD_ITEM_ID,
         entity.ITEM_NO,
         entity.PHOTO_ZONE_CN,
         entity.ITEM_NAME_CN,
         entity.ITEM_NAME_EN,
         entity.IS_DELETED,
         entity.STANDARD_SCORE,
         entity.LAST_MODIFIED_BY,
         entity.LAST_MODIFIED_TIME,
         entity.REMARK_CN,
         entity.REMARK_EN,
         entity.PHOTO_ZONE_EN,
         entity.IS_KIDS];
        [entity release];
    }
    else if (index == 9) // NVM_VM_SCORECARD_ITEM
    {
        VmScoreCardDetailEntity* entity = [[VmScoreCardDetailEntity alloc]initWithDictionary:dictionary];
        
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_VM_SCORECARD_ITEM_DETAIL (SCORECARD_ITEM_DETAIL_ID,SCORECARD_ITEM_ID,ITEM_NO,ITEM_NAME_CN,ITEM_NAME_EN,IS_DELETED,STANDARD_SCORE,LAST_MODIFIED_BY,LAST_MODIFIED_TIME,REMARK) values (?,?,?,?,?,?,?,?,?,?)"];
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         entity.SCORECARD_ITEM_DETAIL_ID,
         entity.SCORECARD_ITEM_ID,
         entity.ITEM_NO,
         entity.ITEM_NAME_CN,
         entity.ITEM_NAME_EN,
         entity.IS_DELETED,
         entity.STANDARD_SCORE,
         entity.LAST_MODIFIED_BY,
         entity.LAST_MODIFIED_TIME,
         entity.REMARK];
        [entity release];
    }
    else if (index == 10)
    {
        FrIssuePhotoZoneEntity* entity = [[FrIssuePhotoZoneEntity alloc]initWithDictionary:dictionary];
        
        NSString* sql = [NSString stringWithFormat:@"INSERT INTO FR_ISSUE_PHOTO_ZONE (ISSUE_ZONE_CODE,ISSUE_ZONE_NAME_CN,ISSUE_ZONE_NAME_EN,ISSUE_TYPE,ORDER_NO,REMARK,IS_DELETED,IS_MUST,LAST_MODIFIED_BY,LAST_MODIFIED_TIME,DATASOURCE) values (?,?,?,?,?,?,?,?,?,?,?)"];
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         entity.ISSUE_ZONE_CODE,
         entity.ISSUE_ZONE_NAME_CN,
         entity.ISSUE_ZONE_NAME_EN,
         entity.ISSUE_TYPE,
         entity.ORDER_NO,
         entity.REMARK,
         entity.IS_DELETED,
         entity.IS_MUST,
         entity.LAST_MODIFIED_BY,
         entity.LAST_MODIFIED_TIME,
         entity.DATASOURCE];
        [entity release];
    }
    else if (index == 11)
    {
        FrHeadCountItemEntity* entity = [[FrHeadCountItemEntity alloc]initWithDictionary:dictionary];
        NSString* sql = [NSString stringWithFormat:@"INSERT INTO FR_HEADCOUNT_ITEM (FR_HEADCOUNT_ITEM_ID,ITEM_NO,ITEM_NAME_CN,ITEM_NAME_EN,IS_DELETED,ITEM_TYPE,LAST_MODIFIED_BY,LAST_MODIFIED_TIME,DATA_SOURCE,IS_MUST,SUMMARY_ITEM,VALIDATION) values (?,?,?,?,?,?,?,?,?,?,?,?)"];
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         entity.FR_HEADCOUNT_ITEM_ID,
         entity.ITEM_NO,
         entity.ITEM_NAME_CN,
         entity.ITEM_NAME_EN,
         entity.IS_DELETED,
         entity.ITEM_TYPE,
         entity.LAST_MODIFIED_BY,
         entity.LAST_MODIFIED_TIME,
         entity.DATA_SOURCE,
         entity.IS_MUST,
         entity.SUMMARY_ITEM,
         entity.VALIDATION];
        [entity release];
    }
    else if (index == 12)
    {
        NvmMstStoreAuditItemEntity* entity = [[NvmMstStoreAuditItemEntity alloc] initWithDictionary:dictionary];
        NSString* sql = [NSString stringWithFormat:@"INSERT INTO NVM_MST_STOREAUDIT_ITEM (\
                         ITEM_ID,\
                         ITEM_NO,\
                         ITEM_NAME_CN,\
                         ITEM_NAME_EN,\
                         PARENT_ITEM_NO,\
                         PARENT_ITEM_NAME_CN,\
                         PARENT_ITEM_NAME_EN,\
                         STANDARD_SCORE,\
                         LAST_MODIFIED_BY,\
                         LAST_MODIFIED_TIME,\
                         DATA_SOURCE,\
                         PHOTO_NUM,\
                         ITEM_DESCRIPTION_CN,\
                         ITEM_DESCRIPTION_EN,\
                         SCORE_OPTION,\
                         MUST_COMMENT,\
                         ITEM_STATUS) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"];
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         entity.ITEM_ID,
         entity.ITEM_NO,
         entity.ITEM_NAME_CN,
         entity.ITEM_NAME_EN,
         entity.PARENT_ITEM_NO,
         entity.PARENT_ITEM_NAME_CN,
         entity.PARENT_ITEM_NAME_EN,
         entity.STANDARD_SCORE,
         entity.LAST_MODIFIED_BY,
         entity.LAST_MODIFIED_TIME,
         entity.DATA_SOURCE,
         entity.PHOTO_NUM,
         entity.ITEM_DESCRIPTION_CN,
         entity.ITEM_DESCRIPTION_EN,
         entity.SCORE_OPTION,
         entity.MUST_COMMENT,
         entity.ITEM_STATUS];
        [entity release];
    }
    else if (index == 13)
    {
        NvmMstOnSitePhotoZoneEntity* entity = [[NvmMstOnSitePhotoZoneEntity alloc] initWithDictionary:dictionary];
        NSString* sql = [NSString stringWithFormat:@"INSERT INTO NVM_MST_ONSITE_PHOTOZONE (\
                         ZONE_ID,\
                         ZONE_NAME_CN,\
                         ZONE_NAME_EN,\
                         PHOTO_NUM,\
                         ZONE_ORDER,\
                         ZONE_STATUS,\
                         LAST_MODIFIED_BY,\
                         LAST_MODIFIED_TIME,\
                         DATA_SOURCE) values (?,?,?,?,?,?,?,?,?)"];
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         entity.ZONE_ID,
         entity.ZONE_NAME_CN,
         entity.ZONE_NAME_EN,
         entity.PHOTO_NUM,
         entity.ZONE_ORDER,
         entity.ZONE_STATUS,
         entity.LAST_MODIFIED_BY,
         entity.LAST_MODIFIED_TIME,
         entity.DATA_SOURCE];
        [entity release];
    }
}


@end


