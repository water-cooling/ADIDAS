//
//  NVMTrainingCheckPhotoEntity.m
//  MobileApp
//
//  Created by 桂康 on 2019/9/27.
//

#import "NVMTrainingCheckPhotoEntity.h"

@implementation NVMTrainingCheckPhotoEntity

- (id) initWithFMResultSet:(FMResultSet*)rs {
    if (self = [super init])
    {
        self.TRAINING_PHOTO_LIST_ID = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"TRAINING_PHOTO_LIST_ID"]];
        self.TRAINING_CHECK_ID = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"TRAINING_CHECK_ID"]];
        self.PHOTO_TYPE = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"PHOTO_TYPE"]];
        self.PHOTO_PATH = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"PHOTO_PATH"]];
        self.COMMENT = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"COMMENT"]];
        self.LAST_MODIFIED_TIME = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"LAST_MODIFIED_TIME"]];
        self.LAST_MODIFIED_BY = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"LAST_MODIFIED_BY"]];
        
        if ([self.TRAINING_PHOTO_LIST_ID.lowercaseString containsString:@"null"]) self.TRAINING_PHOTO_LIST_ID = @"" ;
        if ([self.TRAINING_CHECK_ID.lowercaseString containsString:@"null"]) self.TRAINING_CHECK_ID = @"" ;
        if ([self.PHOTO_TYPE.lowercaseString containsString:@"null"]) self.PHOTO_TYPE = @"" ;
        if ([self.PHOTO_PATH.lowercaseString containsString:@"null"]) self.PHOTO_PATH = @"" ;
        if ([self.COMMENT.lowercaseString containsString:@"null"]) self.COMMENT = @"" ;
        if ([self.LAST_MODIFIED_TIME.lowercaseString containsString:@"null"]) self.LAST_MODIFIED_TIME = @"" ;
        if ([self.LAST_MODIFIED_BY.lowercaseString containsString:@"null"]) self.LAST_MODIFIED_BY = @"" ;
    }
    return  self;
}

@end
