//
//  VM_CHECK_ITEM_Entity.h
//  VM
//
//  Created by wendy on 14-7-19.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"

@interface VM_CHECK_ITEM_Entity : NSObject

@property (strong,nonatomic) NSString* VM_ITEM_ID;
@property (strong,nonatomic) NSString* VM_CATEGORY_ID;
@property (assign,nonatomic) NSInteger ITEM_NO;
@property (strong,nonatomic) NSString* ITEM_NAME_CN;
@property (strong,nonatomic) NSString* ITEM_NAME_EN;
@property (strong,nonatomic) NSString* ITEM_ICON;
@property (strong,nonatomic) NSString* REASON_CN;
@property (strong,nonatomic) NSString* REASON_EN;
@property (strong,nonatomic) NSString* ORDER_NO;
@property (strong,nonatomic) NSString* SCORE_OPTION;
@property (strong,nonatomic) NSString* REMARK_CN;
@property (strong,nonatomic) NSString* REMARK_EN;
@property (assign,nonatomic) NSInteger IS_KEY;
@property (assign,nonatomic) NSInteger IS_DELETED;
@property (strong,nonatomic) NSString* STANDARD_SCORE;
@property (strong,nonatomic) NSString* LAST_MODIFIED_BY;
@property (strong,nonatomic) NSString* LAST_MODIFIED_TIME;
@property (strong,nonatomic) NSString* DATASOURCE;

//Json 对象中获得Dictionary初始化User对象
- (id)initWithDictionary:(NSDictionary *)dictionary;

// 从数据库中获取的
-(id) initWithFMResultSet:(FMResultSet*)rs;

@end
