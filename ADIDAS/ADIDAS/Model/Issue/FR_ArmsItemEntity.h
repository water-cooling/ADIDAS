//
//  FR_ArmsItemEntity.h
//  ADIDAS
//
//  Created by wendy on 14-5-13.
//
//

#import <Foundation/Foundation.h>

@interface FR_ArmsItemEntity : NSObject

@property (assign,nonatomic) NSString* item_id;
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
@property (strong,nonatomic) NSString* last_modified_time;
@property (strong,nonatomic) NSString* DATASOURCE;
//Json 对象中获得Dictionary初始化User对象
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
