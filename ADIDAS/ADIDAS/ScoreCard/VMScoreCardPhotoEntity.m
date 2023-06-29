//
//  VMScoreCardPhotoEntity.m
//  MobileApp
//
//  Created by 桂康 on 2017/11/1.
//

#import "VMScoreCardPhotoEntity.h"

@implementation VMScoreCardPhotoEntity

-(id) initWithFMResultSet:(FMResultSet*)rs
{
    if(self = [super init])
    {
        self.SCORECARD_CHECK_PHOTO_ID = [rs stringForColumn:@"SCORECARD_CHECK_PHOTO_ID"];
        self.PHOTO_ZONE_NAME_CN = [rs stringForColumn:@"PHOTO_ZONE_NAME_CN"];
        self.PHOTO_PATH1 = [rs stringForColumn:@"PHOTO_PATH1"];
        self.PHOTO_PATH2 = [rs stringForColumn:@"PHOTO_PATH2"];
        self.PHOTO_WEB_PATH1 = [rs stringForColumn:@"PHOTO_WEB_PATH1"];
        self.PHOTO_WEB_PATH2 = [rs stringForColumn:@"PHOTO_WEB_PATH2"];
        self.PHOTO_UPLOAD_PATH1 = [rs stringForColumn:@"PHOTO_UPLOAD_PATH1"];
        self.PHOTO_UPLOAD_PATH2 = [rs stringForColumn:@"PHOTO_UPLOAD_PATH2"];
    }
    return self;
}

@end
