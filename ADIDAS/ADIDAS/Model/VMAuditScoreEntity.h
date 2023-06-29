//
//  VMAuditScoreEntity.h
//  ADIDAS
//
//  Created by wendy on 14-5-15.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface VMAuditScoreEntity : NSObject

@property (strong,nonatomic) NSString* STOREAUDIT_CHECK_DETAIL_ID;
@property (strong,nonatomic) NSString* STOREAUDIT_CHECK_ID;
@property (strong,nonatomic) NSString* ITEM_ID;
@property (strong,nonatomic) NSString* CHECK_RESULT;
@property (strong,nonatomic) NSString* COMMENT;
@property (strong,nonatomic) NSArray* PHOTO_PATHS;
@property (strong,nonatomic) NSString* LAST_MODIFIED_BY;
@property (strong,nonatomic) NSString* LAST_MODIFIED_TIME;
@property (strong,nonatomic) NSString* PHOTO_NUM;
@property (strong,nonatomic) NSString* TOTAL;
@property (strong,nonatomic) NSString* ITEM_NAME_EN;
@property (strong,nonatomic) NSString* SCORE_OPTION;

-(id)initWithFMResultSet:(FMResultSet*)rs;

@end
