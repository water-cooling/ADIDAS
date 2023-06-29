//
//  VmCheckCategoryEntity.h
//  ADIDAS
//
//  Created by 桂康 on 2017/7/30.
//
//

#import <Foundation/Foundation.h>

@interface VmCheckCategoryEntity : NSObject

@property (assign,nonatomic) NSString* DATA_SOURCE;
@property (strong,nonatomic) NSString* IS_DELETED;
@property (strong,nonatomic) NSString* LAST_MODIFIED_BY;
@property (assign,nonatomic) NSInteger LAST_MODIFIED_TIME;
@property (strong,nonatomic) NSString* NAME_CN;
@property (strong,nonatomic) NSString* NAME_EN;
@property (strong,nonatomic) NSString* ORDER_NO;
@property (strong,nonatomic) NSString* PARENT_CATEGORY_ID;
@property (strong,nonatomic) NSString* REMARK_CN;
@property (assign,nonatomic) NSInteger REMARK_EN;
@property (strong,nonatomic) NSString* VM_CATEGORY_ID;


//Json 对象中获得Dictionary初始化User对象
- (id)initWithDictionary:(NSDictionary *)dictionary;

-(id) initWithFMResultSet:(FMResultSet*)rs;

@end
