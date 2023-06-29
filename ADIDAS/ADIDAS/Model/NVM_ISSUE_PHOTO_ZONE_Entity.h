//
//  NVM_ISSUE_PHOTO_ZONE_Entity.h
//  VM
//
//  Created by wendy on 14-7-19.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"

@interface NVM_ISSUE_PHOTO_ZONE_Entity : NSObject

@property (strong,nonatomic) NSString* ISSUE_ZONE_CODE;
@property (strong,nonatomic) NSString* ISSUE_ZONE_NAME_CN;
@property (strong,nonatomic) NSString* ISSUE_ZONE_NAME_EN;
@property (assign,nonatomic) NSInteger ORDER_NO;
@property (strong,nonatomic) NSString* REMARK;
@property (assign,nonatomic) NSInteger IS_DELETED;
@property (strong,nonatomic) NSString* ISSUE_TYPE;
@property (assign,nonatomic) NSInteger IS_MUST;
@property (strong,nonatomic) NSString* LAST_MODIFIED_BY;
@property (strong,nonatomic) NSString* LAST_MODIFIED_TIME;
@property (strong,nonatomic) NSString* DATASOURCE;


-(id)initWithDictionary:(NSDictionary *)dictionary;
-(id) initWithFMResultSet:(FMResultSet*)rs;

@end
