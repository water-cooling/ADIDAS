//
//  VMScoreCardPhotoEntity.h
//  MobileApp
//
//  Created by 桂康 on 2017/11/1.
//

#import <Foundation/Foundation.h>

@interface VMScoreCardPhotoEntity : NSObject

@property (strong,nonatomic) NSString* SCORECARD_CHECK_PHOTO_ID;
@property (strong,nonatomic) NSString* PHOTO_ZONE_NAME_CN;
@property (strong,nonatomic) NSString* COMMENT;
@property (strong,nonatomic) NSString* PHOTO_PATH1;
@property (strong,nonatomic) NSString* PHOTO_PATH2;
@property (strong,nonatomic) NSString* PHOTO_WEB_PATH1;
@property (strong,nonatomic) NSString* PHOTO_WEB_PATH2;
@property (strong,nonatomic) NSString* PHOTO_UPLOAD_PATH1;
@property (strong,nonatomic) NSString* PHOTO_UPLOAD_PATH2;
@property (strong,nonatomic) NSString* SCORECARD_CHK_ID ;
@property (strong,nonatomic) NSString* SCORECARD_ITEM_ID ;

-(id)initWithFMResultSet:(FMResultSet*)rs;

@end
