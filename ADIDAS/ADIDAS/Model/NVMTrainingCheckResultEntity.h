//
//  NVMTrainingCheckResultEntity.h
//  MobileApp
//
//  Created by 桂康 on 2019/9/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NVMTrainingCheckResultEntity : NSObject

@property (strong,nonatomic) NSString *TRAINING_RESULT_LIST_ID ;
@property (strong,nonatomic) NSString *TRAINING_CHECK_ID ;
@property (strong,nonatomic) NSString *TRAINING_TYPE ;
@property (strong,nonatomic) NSString *TRAINER ;
@property (strong,nonatomic) NSString *TRAIN_COMMENT ;
@property (strong,nonatomic) NSString *TRAINEE_NUMBER ;
@property (strong,nonatomic) NSString *TRAIN_OBJECT ;
@property (strong,nonatomic) NSString *TRAIN_TITLE ;
@property (strong,nonatomic) NSString *REMARK ;
@property (strong,nonatomic) NSString *LAST_MODIFIED_TIME ;
@property (strong,nonatomic) NSString *LAST_MODIFIED_BY ;
@property (strong,nonatomic) NSString *TRAIN_PARTICIPANT;

- (id) initWithFMResultSet:(FMResultSet*)rs ;

@end

NS_ASSUME_NONNULL_END
