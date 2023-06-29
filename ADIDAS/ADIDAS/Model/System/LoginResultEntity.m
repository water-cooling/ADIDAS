//
//  LoginResultEntity.m
//  ADIDAS
//
//  Created by testing on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginResultEntity.h"
#import "JSON.h"

@implementation LoginResultEntity

@synthesize UserId=_UserId,UserName=_UserName,CheckFlag=_CheckFlag,CheckError=_CheckError,IsStoreManager=_IsStoreManager,UserType=_UserType,TempStoreCode=_TempStoreCode,UpgradeUrl=_UpgradeUrl,NewVersion=_NewVersion,OutTimeFlag=_OutTimeFlag,OutTimeError=_OutTimeError,OutTimeMin,dataSource=_dataSource,MustVersion=_MustVersion,StoreAdjustModeCN=_StoreAdjustModeCN,StoreAdjustModeEN=_StoreAdjustModeEN,BeforeZoneAdjustModeCN=_BeforeZoneAdjustModeCN,BeforeZoneAdjustModeEN=_BeforeZoneAdjustModeEN,AfterZoneAdjustModeCN=_AfterZoneAdjustModeCN,AfterZoneAdjustModeEN=_AfterZoneAdjustModeEN,TrainingTitleEN=_TrainingTitleEN,TrainingTitleCN=_TrainingTitleCN;
@synthesize isLogin=_isLogin;

- (id)initWithDictionary:(NSDictionary *)dictionary {
	if (self = [super init]) {
		self.UserId = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"UserId"]];
		self.UserName = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"UserName"]];
		self.CheckFlag = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"CheckFlag"]];
        self.CheckError = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"CheckError"]];
		self.IsStoreManager = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"IsStoreManager"]];
		self.UserType = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"UserType"]];
        self.TempStoreCode = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"TempStoreCode"]];
		self.UpgradeUrl = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"UpgradeUrl"]];
		self.NewVersion = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"NewVersion"]];
        self.OutTimeFlag = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"OutTimeFlag"]];
		self.OutTimeError = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"OutTimeError"]];
        self.OutTimeMin = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"MobileOutTime"]];
        self.userPosition = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"UserTitle"]];
        self.dataSource = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"DataSource"]];
        self.MustVersion = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"MustVersion"]];
        self.StoreAdjustModeCN = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"StoreAdjustModeCN"]];
        self.StoreAdjustModeEN = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"StoreAdjustModeEN"]];
        self.BeforeZoneAdjustModeCN = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"BeforeZoneAdjustModeCN"]];
        self.BeforeZoneAdjustModeEN = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"BeforeZoneAdjustModeEN"]];
        self.AfterZoneAdjustModeCN = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"AfterZoneAdjustModeCN"]];
        self.AfterZoneAdjustModeEN = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"AfterZoneAdjustModeEN"]];
        self.TrainingTitleCN = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"TrainingTitleCN"]];
        self.TrainingTitleEN = [NSString stringWithFormat:@"%@",[dictionary valueForKey:@"TrainingTitleEN"]];
	}
	return self;
}

- (void)dealloc {
    [_UserId release];
    [_UserName release];
    [_CheckFlag release];
    [_CheckError release];
    [_IsStoreManager release];
    [_UserType release];
    [_TempStoreCode release];
    [_UpgradeUrl release];
    [_NewVersion release];
    [_OutTimeFlag release];
    [_OutTimeError release];
    [OutTimeMin release];
    [_isLogin release];
    [_dataSource release];
    [_MustVersion release];
    [_BeforeZoneAdjustModeEN release];
    [_StoreAdjustModeCN release];
    [_StoreAdjustModeEN release];
    [_BeforeZoneAdjustModeCN release];
    [_AfterZoneAdjustModeEN release];
    [_AfterZoneAdjustModeCN release];
    [_TrainingTitleCN release];
    [_TrainingTitleEN release];
    self.userPosition = nil;
    [super dealloc];
}
@end
