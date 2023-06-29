//
//  RoIssuePhotoEntity.h
//  MobileApp
//
//  Created by 桂康 on 2018/1/4.
//

#import <Foundation/Foundation.h>

@interface RoIssuePhotoEntity : NSObject

@property (strong,nonatomic) NSString* IST_ISSUE_PHOTO_LIST_ID;
@property (strong,nonatomic) NSString* ISSUE_CHECK_ID;
@property (strong,nonatomic) NSString* ISSUE_ZONE_CODE;
@property (strong,nonatomic) NSString* ISSUE_ZONE_NAME;
@property (strong,nonatomic) NSString* RESPONSIBLE_PERSON;
@property (strong,nonatomic) NSString* COMPLETE_DATE;
@property (strong,nonatomic) NSString* ISSUE_ZONE_NAME_EN;
@property (strong,nonatomic) NSString* ISSUE_SOLUTION;
@property (strong,nonatomic) NSString* PHOTO_PATH1;
@property (strong,nonatomic) NSString* PHOTO_PATH2;
@property (strong,nonatomic) NSString* COMMENT;
@property (strong,nonatomic) NSString* SERVER_INSERT_TIME;
@property (strong,nonatomic) NSString* LAST_MODIFIED_BY;
@property (strong,nonatomic) NSString* LAST_MODIFIED_TIME;


-(id) initWithFMResultSet:(FMResultSet*)rs;

@end
