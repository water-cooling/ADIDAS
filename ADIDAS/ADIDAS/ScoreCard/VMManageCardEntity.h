//
//  VMManageCardEntity.h
//  MobileApp
//
//  Created by 桂康 on 2017/10/26.
//

#import <Foundation/Foundation.h>

@interface VMManageCardEntity : NSObject


@property (strong,nonatomic) NSString* comment;
@property (strong,nonatomic) NSString* scorecard_item_id;
@property (strong,nonatomic) NSString* scorecard_check_id;
@property (strong,nonatomic) NSString* scorecard_check_photo_id;
@property (strong,nonatomic) NSString* picpath1;
@property (strong,nonatomic) NSString* picpath2;
@property (strong,nonatomic) NSString* reason;
@property (strong,nonatomic) NSString* LAST_MODIFIED_BY;
@property (strong,nonatomic) NSString* LAST_MODIFIED_TIME;
@property (assign) NSInteger item_no;

+(VMManageCardEntity*)getinstance;
-(void)cleanScore;

@end
