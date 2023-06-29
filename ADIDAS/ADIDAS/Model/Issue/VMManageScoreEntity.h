//
//  ManageScoreData.h
//  ADIDAS
//
//  Created by wendy on 14-5-4.
//
//

#import <Foundation/Foundation.h>

@interface VMManageScoreEntity : NSObject

@property (assign,nonatomic) NSString* score;
@property (strong,nonatomic) NSString* comment;
@property (strong,nonatomic) NSString* item_id;
@property (strong,nonatomic) NSString* check_id;
@property (strong,nonatomic) NSString* check_item_id;
@property (strong,nonatomic) NSString* picpath1;
@property (strong,nonatomic) NSString* picpath2;
@property (strong,nonatomic) NSString* reason;
@property (strong,nonatomic) NSString* LAST_MODIFIED_BY;
@property (strong,nonatomic) NSString* LAST_MODIFIED_TIME;
@property (assign) NSInteger item_no;

+(VMManageScoreEntity*)getinstance;
-(void)cleanScore;

@end
