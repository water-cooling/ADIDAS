//
//  SyncParaVersionEntity.h
//  ADIDAS
//
//  Created by testing on 3/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"

@interface IssueItemEntity : NSObject

@property(nonatomic,copy)NSString *itemID;
@property(nonatomic,copy)NSString *categoryID;
@property(nonatomic,copy)NSString *nameCN;
@property(nonatomic,copy)NSString *nameEN;
@property(nonatomic,copy)NSString *orderNo;
@property(nonatomic,copy)NSString *remark;
@property(nonatomic,copy)NSString *lastModifyBy;
@property(nonatomic,copy)NSString *lastModifyTime;
@property(nonatomic,copy)NSString *isDeleted;
//Json 对象中获得Dictionary初始化User对象
- (id)initWithDictionary:(NSDictionary *)dictionary;
//数据库字段转化
-(id) initWithFMResultSet:(FMResultSet*)resultSet;
@end