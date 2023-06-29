//
//  LoginResultEntity.h
//  ADIDAS
//
//  Created by testing on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"

@interface LoginResultEntity : NSObject

@property(nonatomic,copy)NSString *dataSource;
@property(nonatomic,copy)NSString *UserId;
@property(nonatomic,copy)NSString *UserName;
@property(nonatomic,copy)NSString *CheckFlag;
@property(nonatomic,copy)NSString *CheckError;
@property(nonatomic,copy)NSString *IsStoreManager;
@property(nonatomic,copy)NSString *UserType;
@property(nonatomic,copy)NSString *TempStoreCode;
@property(nonatomic,copy)NSString *UpgradeUrl;
@property(nonatomic,copy)NSString *NewVersion;
@property(nonatomic,copy)NSString *MustVersion;
@property(nonatomic,copy)NSString *OutTimeFlag;
@property(nonatomic,copy)NSString *OutTimeError;
@property(nonatomic,copy)NSString *OutTimeMin;//超时分钟数
@property(nonatomic,copy)NSString *userPosition;
@property(nonatomic,copy)NSString *StoreAdjustModeCN;
@property(nonatomic,copy)NSString *StoreAdjustModeEN;
@property(nonatomic,copy)NSString *AfterZoneAdjustModeCN;
@property(nonatomic,copy)NSString *AfterZoneAdjustModeEN;
@property(nonatomic,copy)NSString *BeforeZoneAdjustModeCN;
@property(nonatomic,copy)NSString *BeforeZoneAdjustModeEN;
@property(nonatomic,copy)NSString *TrainingTitleEN;
@property(nonatomic,copy)NSString *TrainingTitleCN;

@property(nonatomic,copy)NSString *isLogin;

- (id)initWithDictionary:(NSDictionary *)dictionary;


@end
