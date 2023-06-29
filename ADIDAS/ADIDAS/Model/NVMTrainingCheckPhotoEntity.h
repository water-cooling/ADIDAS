//
//  NVMTrainingCheckPhotoEntity.h
//  MobileApp
//
//  Created by 桂康 on 2019/9/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NVMTrainingCheckPhotoEntity : NSObject

@property (strong,nonatomic) NSString *TRAINING_PHOTO_LIST_ID ;
@property (strong,nonatomic) NSString *TRAINING_CHECK_ID ;
@property (strong,nonatomic) NSString *PHOTO_TYPE ;
@property (strong,nonatomic) NSString *PHOTO_PATH ;
@property (strong,nonatomic) NSString *COMMENT ;
@property (strong,nonatomic) NSString *LAST_MODIFIED_TIME ;
@property (strong,nonatomic) NSString *LAST_MODIFIED_BY ;

- (id) initWithFMResultSet:(FMResultSet*)rs;

@end

NS_ASSUME_NONNULL_END
