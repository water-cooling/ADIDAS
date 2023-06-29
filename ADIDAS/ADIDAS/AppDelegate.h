//
//  AppDelegate.h
//  ADIDAS
//
//  Created by testing on 2/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

#define UMENG_APPKEY @"4ff573235270155c01000008"  //Joinone 的Key

#define DEVICE_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define DEVICE_WID  [UIScreen mainScreen].bounds.size.width
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define  APPDelegate (AppDelegate*)[UIApplication sharedApplication].delegate
#define SYS_YELLOW [UIColor colorWithPatternImage:[UIImage imageNamed:@"Forme4.png"]]
#define IOSVersion   [[[UIDevice currentDevice]systemVersion]floatValue]


#define IMAGE_CONTENT  @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: image/jpeg\r\n\r\n"
#define STRING_CONTENT @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n"
#define MULTIPART @"multipart/form-data; boundary=------------0x0x0x0x0x0x0x0x"
#define NOTIFY_AND_LEAVE(X) {[self cleanup:X]; return;}
#define DATA(X)        [X dataUsingEncoding:NSUTF8StringEncoding]

#define NO_NETWORK @"No network"


@class Reachability;
@class VMStoreMenuViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    // 关于网络连接的Reachability对象
    Reachability *hostReach;
             
}


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIWindow *splashWindow;
@property (strong, nonatomic) NSTimer *SaveTimer ;
@property (strong,nonatomic) UINavigationController* navController;
@property (strong,nonatomic) NSMutableArray* railmanageIssueList;

@property (strong,nonatomic) NSMutableArray* outTime_Work_Main_ID_List;
@property (strong,nonatomic) NSMutableArray* outTime_IST_CHK_ID_List;


@property (strong,nonatomic) NSMutableArray* Store_NA_List;
@property (strong,nonatomic) NSMutableArray* lastScoreArray;
@property (strong,nonatomic) NSMutableArray* VMlastScoreArray;

// vm
@property (strong,nonatomic) NSMutableArray* outTime_NVM_IST_VM_CHECK_List;     // 过期检查主表
@property (assign,readwrite) NSInteger UploadFileNum;
@property (strong,nonatomic) NSMutableArray* VM_CHECK_ItemList;

@property (assign,nonatomic) VMStoreMenuViewController *menuController;


-(BOOL)checkNetWork;
-(void)CountUploadFileNum;



@end
