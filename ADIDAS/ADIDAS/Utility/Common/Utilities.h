//
//  Utilities.h
//  WSE
//
//  Created by testing on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject

//date time字符串转换成NSDate
+ (NSDate *)NSStringToNSDate:(NSString *)string;
+ (NSDate *)NSStringToNSDate2:(NSString *)string ;
//NSDate转换成date time字符串
+ (NSString *)NSDateToNSString:(NSDate *)date ;

// 上传时间戳标志
+ (NSString *)DateTimeNowUpload;
+ (NSDate *)TransFormate:(NSDate *)date ;

//NSDate转换成date字符串 日期格式2012-01-01
+ (NSString *)NSDateToDateString:(NSDate *)date ;
//日期格式 20120101
+ (NSString *)NSDateToDateString2:(NSDate *)date;
// 当前日期时间
+ (NSString *) DateTimeNow;
// 当前日期 日期格式2012-01-01
+(NSString *) DateNow;
// 当前日期 日期格式 20120101
+(NSString *) DateNow2;
//验证是否过期
//+(BOOL) checkIsTimeOut;

+ (NSString *)GetUUID;
//NSInteger 转化为String
+(NSString *) GetIntToString:(NSInteger) objValue;
+ (NSString *) GetString:(NSString *) objValue;
+ (NSInteger) GetInteger:(NSNumber *) objValue;
//沙盒Documents目录
+(NSString *) SysDocumentPath;
//缓存目录
+(NSString*)CachePath;
//设置文件不备份扩展属性
+(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL iOSVersion:(NSString *) iOSVersion;
//系统文字颜色
+(UIColor *)GetWhiteLableColor;
+(UIColor *)GetNavTitleColor;
+(UIColor *)GetCommomLableColor;
+(UIColor *)GetGridTitleColor;
+(UIColor *)GetGridRemarkColor;
+(UIColor *)GetGridRowColor1;
+(UIColor *)GetGridRowColor2;
+ (UIColor *) colorWithHexString: (NSString *) hexString;

//添加左边返回按钮
+(void) createLeftBarButton:(UIViewController *)view clichEvent:(SEL)clichEvent;
+(void) createRightBarButton:(UIViewController *)view clichEvent:(SEL)clichEvent btnSize:(CGSize)btnSize btnTitle:(NSString *) btnTitle;
//添加Bar右边按钮 图片按钮
+(void) createRightBarPicButton:(UIViewController *)view 
                     clichEvent:(SEL)clichEvent 
                        btnSize:(CGSize)btnSize 
                       btnImage:(UIImage *) btnImage
                       btnTitle:(NSString *) btnTitle;
//弹出提示信息
+(void) alertMessage:(NSString *)resultString ;
+(void) alertMessage:(NSString *)resultString delegate:(id /*<UIAlertViewDelegate>*/)delegate;
+(void) alertMessageSelected:(NSString *)resultString delegate:(id)delegate;

//显示进度滚轮指示器
+(void) showWaiting;
+(void)showWaiting:(NSString*)message;
//消除滚动轮指示器
+(void) closeWaiting;
//********网络链接失败提示框
+(void) showNetworkErrorView;
+(void) showAlertMessageView:(NSString *) message;
//保存图片
+(void) saveImage:(UIImage *)image imgPath:(NSString *) imgPath;
//保存小图片
+ (void)saveThumImage:(UIImage *)image imgPath:(NSString *)imgPath;
//判断Issue表的编号
+(NSInteger) getIssueTableIndex:tableName;
// 友盟跟踪
//+(void) umengTracking:(NSString*)eventId userCode:(NSString *) userCode;


//+ (void)createAlbumInPhoneAlbum ;
+ (void)saveToAlbumWithMetadata:(NSDictionary *)metadata
                      imageData:(NSData *)imageData
                completionBlock:(void (^)(void))completionBlock
                   failureBlock:(void (^)(NSError *error))failureBlock ;

@end





















