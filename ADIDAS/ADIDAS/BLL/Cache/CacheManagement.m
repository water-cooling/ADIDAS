//
//  CacheManagement.m
//  WSE
//
//  Created by testing on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CacheManagement.h"
#import "LoginResultEntity.h"
#import "Utilities.h"
#import "UserInfoManagement.h"

@implementation CacheManagement

@synthesize currentiOSVersion;
@synthesize currentDBUser;
@synthesize currentUser;
@synthesize checkinTime;
@synthesize currentLocation;
@synthesize currStoreList;
@synthesize eventArr;
@synthesize currentStore;
@synthesize lastController;
@synthesize userEncode;
@synthesize lastLoginTime;
@synthesize userLoginName;
@synthesize language;
@synthesize dataSource ;
@synthesize moduleArr;
@synthesize uploadstatu;
@synthesize isFromHistory ;
@synthesize showScoreCard ;

#define DefaultWebServiceTimeoutSeconds 20


static CacheManagement *_instance=nil;

+ (CacheManagement *)instance {
	@synchronized(self){
		if (!_instance) {
			_instance = [[CacheManagement alloc] init];	
		}
	}
	
	return _instance;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (_instance == nil) {
			_instance = [super allocWithZone:zone];
			return _instance; //assignmentandreturnonfirstallocation
		}
	}
	return nil; 	
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)retain {
	return self;
}

-(unsigned)retainCount {
	return UINT_MAX;
    
}

- (oneway void)release {
	
}

- (id)autorelease {
	return self;
}


- (id)init
{
	if(self = [super init])
	{
		//初始化一些数据
        //手机iOS版本
        self.currentiOSVersion  = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] systemVersion]];
        
        //初始化数据库存储的用户信息
        UserInfoManagement * _usermanagement = [[UserInfoManagement alloc] init]; 
        currentDBUser  = [[_usermanagement loadUser] retain]; 
        [_usermanagement release];
        
        if(currentDBUser==nil)
        {
            currentDBUser =[[UserInfoEntity alloc]init] ;
        }

        self.checkinTime = [Utilities DateTimeNow];
        
        //选择的门店信息
        currentStore = [StoreEntity alloc] ;
        //初始化坐标信息
        currentLocation = [LocationEntity alloc] ;
        currentLocation.locationX=@"-1";
        currentLocation.locationY=@"-1";
        
        
        lastController =[UIViewController alloc];
        moduleArr = [NSMutableArray new ];
        //初始化门店列表信息
        currStoreList = [[NSMutableArray alloc] init];
        eventArr = [[NSMutableArray alloc]init];
        uploadstatu  = 0;
        isFromHistory = 0 ;
        
	}
	return self;
}


- (void)dealloc {
    [currentiOSVersion release];
    [currentDBUser  release];
	[currentUser release];
    [currentLocation release];
    [currentStore release];    
    [lastController release];
    [currStoreList release];
    [eventArr release];
    [userEncode release];
    [lastLoginTime release];
    [moduleArr release];
    
    
    if(checkinTime)
	{
		[checkinTime release];
		checkinTime = nil;
	}
    [super dealloc];
}


@end
