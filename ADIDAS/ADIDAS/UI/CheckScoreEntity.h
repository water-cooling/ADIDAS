//
//  CheckScoreEntity.h
//  ADIDAS
//
//  Created by wendy on 14-5-15.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface CheckScoreEntity : NSObject

@property (strong,nonatomic) NSString* FR_ARMS_CHK_ITEM_ID;
@property (strong,nonatomic) NSString* FR_ARMS_CHK_ID;
@property (strong,nonatomic) NSString* FR_ARMS_ITEM_ID;
@property (assign,nonatomic) NSInteger score;
@property (strong,nonatomic) NSString* reason;
@property (strong,nonatomic) NSString* comment;
@property (strong,nonatomic) NSString* photo_path1;
@property (strong,nonatomic) NSString* photo_path2;

-(id) initWithFMResultSet:(FMResultSet*)rs;

@end
