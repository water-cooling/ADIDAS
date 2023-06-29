//
//  VisitStoreEntity.h
//  VM
//
//  Created by leo.you on 14-8-1.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"

@interface VisitStoreEntity : NSObject

@property (strong,nonatomic) NSString* IST_STORE_PHOTO_LIST_ID;
@property (strong,nonatomic) NSString* TAKE_ID;
@property (strong,nonatomic) NSString* STORE_ZONE;
@property (strong,nonatomic) NSString* PHOTO_TYPE;
@property (strong,nonatomic) NSString* INITIAL_PHOTO_PATH;
@property (strong,nonatomic) NSString* COMPRESS_PHOTO_PATH;
@property (strong,nonatomic) NSString* COMMENT;
@property (strong,nonatomic) NSString* SERVER_INSERT_TIME;
@property (strong,nonatomic) NSString* LAST_MODIFIED_BY;
@property (strong,nonatomic) NSString* LAST_MODIFIED_TIME;
@property (assign) NSInteger order_no;

-(id) initWithFMResultSet:(FMResultSet*)rs;

@end
