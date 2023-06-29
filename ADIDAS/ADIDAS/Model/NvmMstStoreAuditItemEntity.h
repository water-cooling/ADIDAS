//
//  NvmMstStoreAuditItemEntity.h
//  MobileApp
//
//  Created by 桂康 on 2018/7/13.
//

#import <Foundation/Foundation.h>

@interface NvmMstStoreAuditItemEntity : NSObject

@property (strong, nonatomic) NSString* ITEM_ID;
@property (strong, nonatomic) NSString* ITEM_NO;
@property (strong, nonatomic) NSString* ITEM_NAME_CN;
@property (strong, nonatomic) NSString* ITEM_NAME_EN;
@property (strong, nonatomic) NSString* PARENT_ITEM_NO;
@property (strong, nonatomic) NSString* PARENT_ITEM_NAME_CN;
@property (strong, nonatomic) NSString* PARENT_ITEM_NAME_EN;
@property (strong, nonatomic) NSString* STANDARD_SCORE;
@property (strong, nonatomic) NSString* LAST_MODIFIED_BY;
@property (strong, nonatomic) NSString* LAST_MODIFIED_TIME;
@property (strong, nonatomic) NSString* DATA_SOURCE;
@property (strong, nonatomic) NSString* PHOTO_NUM;
@property (strong, nonatomic) NSString* ITEM_STATUS;
@property (strong, nonatomic) NSString* ITEM_DESCRIPTION_CN;
@property (strong, nonatomic) NSString* ITEM_DESCRIPTION_EN;
@property (strong, nonatomic) NSString* SCORE_OPTION;
@property (strong, nonatomic) NSString* CHECK_RESULT;
@property (strong, nonatomic) NSString* MUST_COMMENT;

-(id)initWithDictionary:(NSDictionary *)dictionary;
-(id)initWithFMResultSet:(FMResultSet *)rs;

@end
