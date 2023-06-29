//
//  FrHeadCountItemEntity.h
//  MobileApp
//
//  Created by 桂康 on 2018/7/13.
//

#import <Foundation/Foundation.h>

@interface FrHeadCountItemEntity : NSObject

@property (strong, nonatomic) NSString* FR_HEADCOUNT_ITEM_ID;
@property (strong, nonatomic) NSString* ITEM_NO;
@property (strong, nonatomic) NSString* ITEM_NAME_CN;
@property (strong, nonatomic) NSString* ITEM_NAME_EN;
@property (strong, nonatomic) NSString* IS_DELETED;
@property (strong, nonatomic) NSString* ITEM_TYPE;
@property (strong, nonatomic) NSString* LAST_MODIFIED_BY;
@property (strong, nonatomic) NSString* LAST_MODIFIED_TIME;
@property (strong, nonatomic) NSString* DATA_SOURCE;
@property (strong, nonatomic) NSString* RESULT;
@property (strong, nonatomic) NSString* IS_MUST;
@property (strong, nonatomic) NSString* SUMMARY_ITEM;
@property (strong, nonatomic) NSString* VALIDATION;

-(id)initWithDictionary:(NSDictionary *)dictionary;
-(id)initWithFMResultSet:(FMResultSet *)rs;

@end
