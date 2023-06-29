//
//  IST_WORK_MAIN.m
//  ADIDAS
//
//  Created by joinone on 15/1/26.
//
//

#import "IST_WORK_MAIN.h"

@implementation IST_WORK_MAIN

- (id)initWithDictionary:(NSDictionary *)dic {

    if (self = [super init]) {
        
        self.WORK_MAIN_ID = [dic valueForKey:@"WORK_MAIN_ID"];
        self.STORE_CODE = [dic valueForKey:@"STORE_CODE"];
        self.STORE_NAME = [dic valueForKey:@"STORE_NAME"];
        self.STORE_ADDRESS = [dic valueForKey:@"STORE_ADDRESS"];
        self.STORE_TEL = [dic valueForKey:@"STORE_TEL"];
        self.OPERATE_USER = [dic valueForKey:@"OPERATE_USER"];
        self.SELECT_STORE_MOTHED = [[dic valueForKey:@"SELECT_STORE_MOTHED"] intValue];
        self.CHECK_IN_TIME = [dic valueForKey:@"CHECK_IN_TIME"];
        self.CHECK_OUT_TIME = [dic valueForKey:@"CHECK_OUT_TIME"];
        self.TIME_LENGTH = [dic valueForKey:@"TIME_LENGTH"];
        self.STATUS = [[dic valueForKey:@"STATUS"] intValue];
        self.REMARK = [dic valueForKey:@"REMARK"];
        self.CHECKIN_LOCATION_X = [dic valueForKey:@"CHECKIN_LOCATION_X"];
        self.CHECKIN_LOCATION_Y = [dic valueForKey:@"CHECKIN_LOCATION_Y"];
        self.CHECKOUT_LOCATION_X = [dic valueForKey:@"CHECKOUT_LOCATION_X"];
        self.CHECKOUT_LOCATION_Y = [dic valueForKey:@"CHECKOUT_LOCATION_Y"];
        self.VISIT_DURATION = [dic valueForKey:@"VISIT_DURATION"];
        self.SER_INSERT_TIME = [dic valueForKey:@"SER_INSERT_TIME"];
     }
    return self ;
}


- (id)initWithFMResultSet:(FMResultSet *)rs {

    if (self = [super init]) {
        
        self.WORK_MAIN_ID = [rs stringForColumn:@"WORK_MAIN_ID"];
        self.STORE_CODE = [rs stringForColumn:@"STORE_CODE"];
        self.STORE_NAME = [rs stringForColumn:@"STORE_NAME"];
        self.STORE_ADDRESS = [rs stringForColumn:@"STORE_ADDRESS"];
        self.STORE_TEL = [rs stringForColumn:@"STORE_TEL"];
        self.OPERATE_USER = [rs stringForColumn:@"OPERATE_USER"];
        self.SELECT_STORE_MOTHED = [[rs stringForColumn:@"SELECT_STORE_MOTHED"] intValue];
        self.CHECK_IN_TIME = [rs stringForColumn:@"CHECK_IN_TIME"];
        self.CHECK_OUT_TIME = [rs stringForColumn:@"CHECK_OUT_TIME"];
        self.TIME_LENGTH = [rs stringForColumn:@"TIME_LENGTH"];
        self.STATUS = [[rs stringForColumn:@"STATUS"] intValue];
        self.REMARK = [rs stringForColumn:@"REMARK"];
        self.CHECKIN_LOCATION_X = [rs stringForColumn:@"CHECKIN_LOCATION_X"];
        self.CHECKIN_LOCATION_Y = [rs stringForColumn:@"CHECKIN_LOCATION_Y"];
        self.CHECKOUT_LOCATION_X = [rs stringForColumn:@"CHECKOUT_LOCATION_X"];
        self.CHECKOUT_LOCATION_Y = [rs stringForColumn:@"CHECKOUT_LOCATION_Y"];
        self.VISIT_DURATION = [rs stringForColumn:@"VISIT_DURATION"];
        self.SER_INSERT_TIME = [rs stringForColumn:@"SER_INSERT_TIME"];
    }
    return self ;
}


@end









