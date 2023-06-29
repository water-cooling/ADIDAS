//
//  NVMTrainingCheckResultEntity.m
//  MobileApp
//
//  Created by 桂康 on 2019/9/27.
//

#import "NVMTrainingCheckResultEntity.h"

@implementation NVMTrainingCheckResultEntity

- (id) initWithFMResultSet:(FMResultSet*)rs {
    if (self = [super init]) {
        
        self.TRAINING_RESULT_LIST_ID = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"TRAINING_RESULT_LIST_ID"]];
        self.TRAINING_CHECK_ID = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"TRAINING_CHECK_ID"]];
        self.TRAINING_TYPE = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"TRAINING_TYPE"]];
        self.TRAINER = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"TRAINER"]];
        self.TRAIN_COMMENT = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"TRAIN_COMMENT"]];
        self.TRAINEE_NUMBER = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"TRAINEE_NUMBER"]];
        self.TRAIN_OBJECT = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"TRAIN_OBJECT"]];
        self.TRAIN_TITLE = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"TRAIN_TITLE"]];
        self.REMARK = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"REMARK"]];
        self.LAST_MODIFIED_TIME = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"LAST_MODIFIED_TIME"]];
        self.LAST_MODIFIED_BY = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"LAST_MODIFIED_BY"]];
        self.TRAIN_PARTICIPANT = [NSString stringWithFormat:@"%@",[rs stringForColumn:@"TRAIN_PARTICIPANT"]];
        
        if ([self.TRAINING_RESULT_LIST_ID.lowercaseString containsString:@"null"]) self.TRAINING_RESULT_LIST_ID = @"" ;
        if ([self.TRAINING_CHECK_ID.lowercaseString containsString:@"null"]) self.TRAINING_CHECK_ID = @"" ;
        if ([self.TRAINING_TYPE.lowercaseString containsString:@"null"]) self.TRAINING_TYPE = @"" ;
        if ([self.TRAINER.lowercaseString containsString:@"null"]) self.TRAINER = @"" ;
        if ([self.TRAIN_COMMENT.lowercaseString containsString:@"null"]) self.TRAIN_COMMENT = @"" ;
        if ([self.TRAINEE_NUMBER.lowercaseString containsString:@"null"]) self.TRAINEE_NUMBER = @"" ;
        if ([self.TRAIN_OBJECT.lowercaseString containsString:@"null"]) self.TRAIN_OBJECT = @"" ;
        if ([self.TRAIN_TITLE.lowercaseString containsString:@"null"]) self.TRAIN_TITLE = @"" ;
        if ([self.REMARK.lowercaseString containsString:@"null"]) self.REMARK = @"" ;
        if ([self.LAST_MODIFIED_TIME.lowercaseString containsString:@"null"]) self.LAST_MODIFIED_TIME = @"" ;
        if ([self.LAST_MODIFIED_BY.lowercaseString containsString:@"null"]) self.LAST_MODIFIED_BY = @"" ;
        if ([self.TRAIN_PARTICIPANT.lowercaseString containsString:@"null"]) self.TRAIN_PARTICIPANT = @"" ;
    }
    return  self;
}

@end
