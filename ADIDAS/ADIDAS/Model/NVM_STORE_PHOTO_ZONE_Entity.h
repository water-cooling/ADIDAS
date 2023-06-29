//
//  NVM_STORE_PHOTO_ZONE_Entity.h
//  VM
//
//  Created by wendy on 14-7-19.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"

@interface NVM_STORE_PHOTO_ZONE_Entity : NSObject

@property (strong,nonatomic) NSString* PHOTO_ZONE_CODE;
@property (strong,nonatomic) NSString* PHOTO_ZONE_NAME_CN;
@property (strong,nonatomic) NSString* PHOTO_ZONE_NAME_EN;
@property (assign) NSInteger ORDER_NO;
@property (strong,nonatomic) NSString* REMARK;
@property (assign,nonatomic) NSInteger IS_DELETED;
@property (strong,nonatomic) NSString* DATASOURCE;
@property (assign,nonatomic) NSInteger IS_MUST;
@property (strong,nonatomic) NSString* LAST_MODIFIED_BY;
@property (strong,nonatomic) NSString* LAST_MODIFIED_TIME;
@property (assign) NSInteger *ZONE_TYPE ;


-(id)initWithDictionary:(NSDictionary *)dictionary;
-(id) initWithFMResultSet:(FMResultSet*)rs;

@end
