//
//  CommonUtil.h
//  StoreVisitPack
//
//  Created by joinone on 15/3/2.
//  Copyright (c) 2015年 joinone. All rights reserved.
//

#define kAppDelegate ((AppDelegate *)[[UIApplication sharedApplication]delegate])
#define PHONE_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define PHONE_WIDTH  [UIScreen mainScreen].bounds.size.width
#define ISONTIME [[NSUserDefaults standardUserDefaults] boolForKey:@"ISONTIMEUPLOAD"]

#define kDEFAULT_HEIGHT 42
#define kTimeoutInterval 120
#define kDISMISSTIME 1

#define iPhoneX \
({BOOL iPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
iPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;\
}\
(iPhoneX);})

// Status bar height.
#define  StatusBarHeight      (iPhoneX ? 44.f : 20.f)
// Status bar & navigation bar height.
#define StatusBarAndNavigationBarHeight  (iPhoneX ? 88.f : 64.f)
#define  TabbarHeight         (iPhoneX ? (49.f+34.f) : 49.f)
#define  TabbarSafeBottomMargin         (iPhoneX ? 34.f : 0.f)


#define kDEFECTIVETOKEN @"DefectiveToken"
#define LOGINDATA @"defectiveLogin.plist"
#define HISTORYDATA @"historylist.plist"
#define NOUPLOADDATA @"nouploadlist.plist"
#define READEDNOTICEDATA @"readednoticeplist.plist"

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CommonUtil : NSObject

@property (strong, nonatomic) NSString *defectiveType;

+ (UIColor *)colorWithHexString: (NSString *) hexString ;
+ (UIColor *) colorWithHexString: (NSString *) hexString withAlpha:(float)alp;
+ (NSString *)getPlistPath:(NSString*)filename;
+ (NSString *)SysDocumentPath ;
+ (NSString *)NSDateToNSString:(NSDate *)date ;
+ (NSString *)NSDateNoTimeToNSString:(NSDate *)date ;
+ (NSString *)getDecryKey:(NSString *)account ;
+ (CommonUtil *)instance ;
+ (NSString *)getUUIDByKeyChain;

@end
