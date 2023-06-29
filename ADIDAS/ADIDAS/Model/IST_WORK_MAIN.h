//
//  IST_WORK_MAIN.h
//  ADIDASeeeee
//
//  Created by joinone on 15/1/26.
//
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"

@interface IST_WORK_MAIN : NSObject

@property (strong, nonatomic) NSString *WORK_MAIN_ID ;
@property (strong, nonatomic) NSString *STORE_CODE ;
@property (strong, nonatomic) NSString *STORE_NAME ;
@property (strong, nonatomic) NSString *STORE_ADDRESS ;
@property (strong, nonatomic) NSString *STORE_TEL ;
@property (strong, nonatomic) NSString *OPERATE_USER ;
@property (assign, nonatomic) int       SELECT_STORE_MOTHED ;
@property (strong, nonatomic) NSString *CHECK_IN_TIME ;
@property (strong, nonatomic) NSString *CHECK_OUT_TIME ;
@property (assign, nonatomic) int       TIME_LENGTH ;
@property (assign, nonatomic) int       STATUS ;
@property (strong, nonatomic) NSString *REMARK ;
@property (strong, nonatomic) NSString *CHECKIN_LOCATION_X ;
@property (strong, nonatomic) NSString *CHECKIN_LOCATION_Y ;
@property (strong, nonatomic) NSString *CHECKOUT_LOCATION_X ;
@property (strong, nonatomic) NSString *CHECKOUT_LOCATION_Y ;
@property (strong, nonatomic) NSString *VISIT_DURATION ;
@property (strong, nonatomic) NSString *SER_INSERT_TIME ;

- (id)initWithDictionary:(NSDictionary *)dic ;
-(id) initWithFMResultSet:(FMResultSet*)rs ;

@end
