//
//  FrIssuePhotoZoneEntity.h
//  MobileApp
//
//  Created by 桂康 on 2018/1/4.
//

#import <Foundation/Foundation.h>

@interface FrIssuePhotoZoneEntity : NSObject

@property (strong,nonatomic) NSString* ISSUE_ZONE_CODE;
@property (strong,nonatomic) NSString* ISSUE_ZONE_NAME_CN;
@property (strong,nonatomic) NSString* ISSUE_ZONE_NAME_EN;
@property (assign,nonatomic) NSString* ORDER_NO;
@property (strong,nonatomic) NSString* REMARK;
@property (assign,nonatomic) NSString* IS_DELETED;
@property (strong,nonatomic) NSString* ISSUE_TYPE;
@property (assign,nonatomic) NSString* IS_MUST;
@property (strong,nonatomic) NSString* LAST_MODIFIED_BY;
@property (strong,nonatomic) NSString* LAST_MODIFIED_TIME;
@property (strong,nonatomic) NSString* DATASOURCE;


-(id)initWithDictionary:(NSDictionary *)dictionary;
-(id) initWithFMResultSet:(FMResultSet *)rs;


@end
