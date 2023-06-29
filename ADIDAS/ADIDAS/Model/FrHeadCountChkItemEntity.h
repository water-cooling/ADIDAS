//
//  FrHeadCountChkItemEntity.h
//  MobileApp
//
//  Created by 桂康 on 2018/7/13.
//

#import <Foundation/Foundation.h>

@interface FrHeadCountChkItemEntity : NSObject

@property (strong,nonatomic) NSString* FR_HEADCOUNT_CHK_ITEM_ID;
@property (strong,nonatomic) NSString* FR_HEADCOUNT_CHK_ID;
@property (strong,nonatomic) NSString* FR_HEADCOUNT_ITEM_ID;
@property (assign,nonatomic) NSString* RESULT;

-(id)initWithFMResultSet:(FMResultSet *)rs;

@end
