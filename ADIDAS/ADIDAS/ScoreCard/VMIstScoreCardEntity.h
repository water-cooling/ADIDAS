//
//  VMIstScoreCardEntity.h
//  MobileApp
//
//  Created by 桂康 on 2017/10/26.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"


@interface VMIstScoreCardEntity : NSObject

@property (strong,nonatomic) NSString* SCORECARD_CHECK_PHOTO_ID;
@property (strong,nonatomic) NSString* SCORECARD_CHK_ID;
@property (strong,nonatomic) NSString* SCORECARD_ITEM_ID;
@property (strong,nonatomic) NSString* COMMENT;
@property (strong,nonatomic) NSString* PHOTO_PATH1;
@property (strong,nonatomic) NSString* PHOTO_PATH2;
@property (strong,nonatomic) NSString* LAST_MODIFIED_BY;
@property (strong,nonatomic) NSString* LAST_MODIFIED_TIME;

-(id)initWithFMResultSet:(FMResultSet*)rs;

@end
