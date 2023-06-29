//
//  VmScoreCardScoreEntity.h
//  MobileApp
//
//  Created by 桂康 on 2017/11/28.
//

#import <Foundation/Foundation.h>

@interface VmScoreCardScoreEntity : NSObject

@property (strong,nonatomic) NSString* SCORECARD_CHECK_PHOTO_ID;
@property (strong,nonatomic) NSString* SCORECARD_ITEM_DETAIL_ID;
@property (strong,nonatomic) NSString* STANDARD_SCORE;
@property (strong,nonatomic) NSString* REMARK;
@property (strong,nonatomic) NSString* SCORECARD_ITEM_ID ;

-(id) initWithFMResultSet:(FMResultSet*)rs;

@end
