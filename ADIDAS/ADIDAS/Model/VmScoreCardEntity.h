//
//  VmScoreCardEntity.h
//  MobileApp
//
//  Created by 桂康 on 2017/10/25.
//

#import <Foundation/Foundation.h>

@interface VmScoreCardEntity : NSObject

@property (strong,nonatomic) NSString* SCORECARD_ITEM_ID;
@property (strong,nonatomic) NSString* ITEM_NO;
@property (strong,nonatomic) NSString* ITEM_NAME_CN;
@property (strong,nonatomic) NSString* ITEM_NAME_EN;
@property (strong,nonatomic) NSString* IS_DELETED;
@property (strong,nonatomic) NSString* STANDARD_SCORE;
@property (strong,nonatomic) NSString* LAST_MODIFIED_BY;
@property (strong,nonatomic) NSString* LAST_MODIFIED_TIME;
@property (strong,nonatomic) NSString* REMARK_CN;
@property (strong,nonatomic) NSString* REMARK_EN;
@property (strong,nonatomic) NSString* PHOTO_ZONE_CN ;
@property (strong,nonatomic) NSString* PHOTO_ZONE_EN ;
@property (strong,nonatomic) NSString* IS_KIDS ;

//Json 对象中获得Dictionary初始化User对象
- (id)initWithDictionary:(NSDictionary *)dictionary;

-(id) initWithFMResultSet:(FMResultSet*)rs;

@end
