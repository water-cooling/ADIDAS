//
//  RailManageSingleIssueData.h
//  ADIDAS
//
//  Created by wendy on 14-4-25.
//
//

#import <Foundation/Foundation.h>

@interface RailManageSingleIssueData : NSObject

@property (strong,nonatomic) NSString* item_id;
@property (strong,nonatomic) NSString* item_name_cn;
@property (strong,nonatomic) NSString* item_name_en;
@property (assign,nonatomic) NSInteger item_NO;
@property (strong,nonatomic) NSString* remark_cn;
@property (strong,nonatomic) NSString* remark_en;
@property (strong,nonatomic) NSString* last_modified_by;
@property (strong,nonatomic) NSString* reason_cn;
@property (strong,nonatomic) NSString* reason_en;
@property (assign,nonatomic) NSInteger isdelete;
@property (strong,nonatomic) NSString* score_option;
@property (strong,nonatomic) NSString* datetime;

@end
