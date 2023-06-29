//
//  OnSiteEntity.h
//  VM
//
//  Created by leo.you on 14-8-1.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"

@interface OnSiteEntity : NSObject

@property (strong,nonatomic) NSString *ONSITE_CHECK_ID;
@property (strong,nonatomic) NSString *ONSITE_CHECK_DETAIL_ID;
@property (strong,nonatomic) NSString *ZONE_ID;
@property (strong,nonatomic) NSString *BEFORE_PHOTO_PATH;
@property (strong,nonatomic) NSString *AFTER_PHOTO_PATH;
@property (strong,nonatomic) NSString *BEFORE_ADJUSTMENT_MODE;
@property (strong,nonatomic) NSString *AFTER_ADJUSTMENT_MODE;
@property (strong,nonatomic) NSString *COMMENT;
@property (strong,nonatomic) NSString *LAST_MODIFIED_BY;
@property (strong,nonatomic) NSString *LAST_MODIFIED_TIME;

-(id) initWithFMResultSet:(FMResultSet*)rs;

@end
