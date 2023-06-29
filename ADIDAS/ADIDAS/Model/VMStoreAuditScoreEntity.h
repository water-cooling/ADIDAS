//
//  VMStoreAuditScoreEntity.h
//  ADIDAS
//
//  Created by wendy on 14-5-4.
//
//

#import <Foundation/Foundation.h>

@interface VMStoreAuditScoreEntity : NSObject

@property (strong,nonatomic) NSString* score;
@property (strong,nonatomic) NSString* comment;
@property (strong,nonatomic) NSString* item_id;
@property (strong,nonatomic) NSString* check_id;
@property (strong,nonatomic) NSString* check_detail_id;
@property (strong,nonatomic) NSArray* picArray;
@property (strong,nonatomic) NSString* LAST_MODIFIED_BY;
@property (strong,nonatomic) NSString* LAST_MODIFIED_TIME;
@property (assign) NSInteger item_no;

+(VMStoreAuditScoreEntity*)getinstance;
-(void)cleanScore;

@end
