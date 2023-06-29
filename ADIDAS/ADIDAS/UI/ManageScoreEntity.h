//
//  ManageScoreData.h
//  ADIDAS
//
//  Created by wendy on 14-5-4.
//
//

#import <Foundation/Foundation.h>

@interface ManageScoreEntity : NSObject

@property (assign,nonatomic) NSInteger score;
@property (strong,nonatomic) NSString* comment;
@property (strong,nonatomic) NSString* item_id;
@property (strong,nonatomic) NSString* check_id;
@property (strong,nonatomic) NSString* check_item_id;
@property (strong,nonatomic) NSString* picpath1;
@property (strong,nonatomic) NSString* picpath2;
@property (strong,nonatomic) NSString* reason;
@property (assign) NSInteger item_no;


+(ManageScoreEntity*)getinstance;
-(void)cleanScore;

@end
