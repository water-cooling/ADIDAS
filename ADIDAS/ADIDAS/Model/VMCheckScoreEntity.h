//
//  CheckScoreEntity.h
//  ADIDAS
//
//  Created by wendy on 14-5-15.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface VMCheckScoreEntity : NSObject

@property (strong,nonatomic) NSString* VM_CHK_ITEM_ID;
@property (strong,nonatomic) NSString* VM_CHK_ID;
@property (strong,nonatomic) NSString* ITEM_ID;
@property (strong,nonatomic) NSString* SCORE;
@property (strong,nonatomic) NSString* REASON;
@property (strong,nonatomic) NSString* COMMENT;
@property (strong,nonatomic) NSString* PHOTO_PATH1;
@property (strong,nonatomic) NSString* PHOTO_PATH2;
@property (strong,nonatomic) NSString* LAST_MODIFIED_BY;
@property (strong,nonatomic) NSString* LAST_MODIFIED_TIME;

-(id)initWithFMResultSet:(FMResultSet*)rs;

@end
