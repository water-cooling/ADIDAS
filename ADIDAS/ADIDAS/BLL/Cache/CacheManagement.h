//
//  CacheManagement.h
//  WSE
//
//  Created by testing on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoEntity.h"
#import "LoginResultEntity.h"
#import "LocationEntity.h"
#import "StoreEntity.h"
#import "LeveyTabBarController.h"

@interface CacheManagement : NSObject
{
    UserInfoEntity* currentDBUser;
    LoginResultEntity* currentUser;
    StoreEntity* currentStore;
    LocationEntity* currentLocation;
    UIViewController * lastController; //上一个页面
    NSMutableArray *currStoreList;
    NSString* checkinTime;
}

@property (nonatomic,retain) NSString* currentiOSVersion;

@property (nonatomic,retain) UserInfoEntity* currentDBUser;
@property (nonatomic,retain) LoginResultEntity* currentUser;
@property (nonatomic,retain) StoreEntity* currentStore;
@property (nonatomic,retain) LocationEntity* currentLocation;
@property (assign,nonatomic) LeveyTabBarController* leveyTabbarController;
@property (strong,nonatomic) NSString* SignatureText;
@property (strong,nonatomic) NSString* SignOffText;

@property (nonatomic,retain) UIViewController * lastController;

@property (nonatomic,retain) NSMutableArray *currStoreList;
@property (nonatomic,retain) NSMutableArray *eventArr;


@property (nonatomic,retain) NSString* checkinTime;

@property (nonatomic,retain) NSString* userEncode;//加密的用户信息，用在Http Header中

@property (nonatomic,retain) NSString* userLoginName;
@property (nonatomic,retain) NSString* dataSource;
@property (nonatomic,retain) NSString* currentDate;

@property (nonatomic,assign) BOOL uploaddata;

@property (retain,nonatomic) NSString* CurrentMonthLoinTimes;
@property (retain,nonatomic) NSString* CurrentMonthVisitHours;
@property (retain,nonatomic) NSMutableArray* moduleArr;

//超时时间
@property (nonatomic,retain) NSDate *lastLoginTime;
@property (nonatomic,retain) NSString* currentWorkMainID;
@property (nonatomic,retain) NSString* currentCHKID;   // 检查id
@property (nonatomic,retain) NSString* currentVMCHKID;
@property (nonatomic,retain) NSString* currentCAMPID;  // 活动id
@property (nonatomic,retain) NSString* currentTakeID;
@property (nonatomic,retain) NSString* currentPhotoZone;
@property (nonatomic,retain) NSString* campReason;     // 延迟原因
@property (nonatomic,retain) NSString* campComment;    // 活动物料表备注
@property (nonatomic,retain) NSString* campReasonNote; // 延迟原因备注
@property (nonatomic,retain) NSString* showScoreCard;
@property (nonatomic,retain) NSString* showSpecial ;
@property (nonatomic,retain) NSString *ShowRBK ;
@property (nonatomic,retain) NSArray *listEcCaseTitle ;

@property (assign) int language;
@property (assign) int uploadstatu;
@property (assign) int isFromHistory ;
@property (assign) BOOL toHomeFlag ;

+ (CacheManagement *)instance;
- (id)init;

@end
