//
//  PlanEntity.h
//  VM
//
//  Created by wendy on 14-7-17.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlanEntity : NSObject

//@property (strong,nonatomic) NSString* END_DATE;
@property (strong,nonatomic) NSString* LastModifiedBy;
@property (strong,nonatomic) NSString* Remark;
@property (strong,nonatomic) NSString* TaskName;
@property (strong,nonatomic) NSString* TaskType;
@property (strong,nonatomic) NSString* VisitDate;
@property (strong,nonatomic) NSString* VisitPlanMainId;
@property (strong,nonatomic) NSArray*  lstStoreInfo;

//@property (strong,nonatomic) NSString* TOTAL_HOURS;
//@property (strong,nonatomic) NSString* UPDATE_ID;
//@property (strong,nonatomic) NSString* USER_ID;
//@property (strong,nonatomic) NSString* VISIT_PLAN_MAIN_ID;

@end
