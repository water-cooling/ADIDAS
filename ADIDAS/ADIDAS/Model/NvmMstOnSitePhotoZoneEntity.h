//
//  NvmMstOnSitePhotoZoneEntity.h
//  VM
//
//  Created by wendy on 14-7-19.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"

@interface NvmMstOnSitePhotoZoneEntity : NSObject

@property (strong,nonatomic) NSString* ZONE_ID;
@property (strong,nonatomic) NSString* ZONE_ID_NEW;
@property (strong,nonatomic) NSString* ZONE_NAME_CN;
@property (strong,nonatomic) NSString* ZONE_NAME_EN;
@property (strong,nonatomic) NSString* PHOTO_NUM;
@property (strong,nonatomic) NSString* ZONE_ORDER;
@property (strong,nonatomic) NSString* ZONE_STATUS;
@property (strong,nonatomic) NSString* LAST_MODIFIED_BY;
@property (strong,nonatomic) NSString* LAST_MODIFIED_TIME;
@property (strong,nonatomic) NSString* DATA_SOURCE;
@property (strong,nonatomic) NSString* BEFORE_PHOTO_PATH;
@property (strong,nonatomic) NSString* AFTER_PHOTO_PATH;
@property (strong,nonatomic) NSString* BEFORE_ADJUSTMENT_MODE;
@property (strong,nonatomic) NSString* AFTER_ADJUSTMENT_MODE;
@property (strong,nonatomic) NSString* COMMENT;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (id)initWithFMResultSet:(FMResultSet*)rs;
- (id)initWithFirstFMResultSet:(FMResultSet*)rs;

@end
