//
//  Utilities.m
//  WSE
//
//  Created by testing on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Utilities.h"
#import <QuartzCore/QuartzCore.h>
#import "SqliteHelper.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "GTMBase64.h"
#import "JSON.h"
#import "RequestHeader.h"
#import "CommonDefine.h"
#import "CacheManagement.h"
#import <AssetsLibrary/AssetsLibrary.h>
#include <sys/xattr.h>

@implementation Utilities

+ (NSDate *)TransFormate:(NSDate *)selectDate {
    
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    
    NSInteger interval = [zone secondsFromGMTForDate: selectDate];
    
    NSDate *localeDate = [selectDate  dateByAddingTimeInterval: interval];
    
    return localeDate ;
}

//date time字符串转换成NSDate
+ (NSDate *)NSStringToNSDate:(NSString *)string 
{   
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC8"]];
    [formatter setDateFormat:kDEFAULT_DATE_TIME_FORMAT];
    NSDate *date = [formatter dateFromString:string];
    [formatter release];
    return date;
}

//NSDate转换成date time字符串
+ (NSString *)NSDateToNSString:(NSDate *)date 
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC8"]];
    [formatter setDateFormat:kDEFAULT_DATE_TIME_FORMAT];
	NSString *string = [formatter stringFromDate:date];
    [formatter release];
	return string;
}

+(NSString *)NSDateToNSStringUpload:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC8"]];
    [formatter setDateFormat:kDEFAULT_DATA_TIME_FORAMT_UPLOAD];
	NSString *string = [formatter stringFromDate:date];
    [formatter release];
	return string;
}

//NSDate转换成date字符串
+ (NSString *)NSDateToDateString:(NSDate *)date 
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC8"]];
    [formatter setDateFormat:kDEFAULT_DATE_FORMAT];
	NSString *string = [formatter stringFromDate:date];
    [formatter release];
	return string;
}

+ (NSString *)NSDateToDateString2:(NSDate *)date 
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC8"]];
    [formatter setDateFormat:kDEFAULT_DATE_FORMAT2];
	NSString *string = [formatter stringFromDate:date];
    [formatter release];
	return string;
}

+ (NSDate *)NSStringToNSDate2:(NSString *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC8"]];
    [formatter setDateFormat:kDEFAULT_DATE_FORMAT];
    NSDate *date = [formatter dateFromString:string];
    [formatter release];
    return date;
}

// 当前日期时间

+(NSString *)DateTimeNowUpload
{
    return [Utilities NSDateToNSStringUpload:[NSDate date]];
}

+(NSString *) DateTimeNow
{
    return [Utilities NSDateToNSString:[NSDate date]];
}
// 当前日期时间
+(NSString *) DateNow
{
    return [Utilities NSDateToDateString:[NSDate date]];
}
+(NSString *) DateNow2
{
    return [Utilities NSDateToDateString2:[NSDate date]];
}
+(NSString *) GetString:(NSString *) objValue
{
	if (objValue == nil || [objValue isEqualToString:@"null"] || [objValue isEqualToString:@"<null>"]) {
		return @"";
	}
	return objValue;
}


//NSInteger 转化为String
+(NSString *) GetIntToString:(NSInteger) objValue
{
	return [NSString stringWithFormat:@"%d",objValue];
}

+(NSInteger) GetInteger:(NSNumber *) objValue
{
	//if (objValue == @"null" || objValue == @"<null>") {
	//	return 0;
	//}
	if (objValue == nil) {
		return 0;
	}
	return [objValue integerValue];;
}

+(NSString *)GetUUID
{
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, theUUID);
	CFRelease(theUUID);
	return [(NSString *)string autorelease];
}

+(NSString*)CachePath
{
    NSString *iOSVersion = [NSString stringWithFormat:@"%@",[CacheManagement instance].currentiOSVersion];
    float version = [iOSVersion floatValue];
    if (version > 5.0 ||[iOSVersion isEqualToString:@"5.0.1"]==YES)
    {
        NSString * _sysDocument= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *path = [_sysDocument stringByAppendingPathComponent:@"dataFilesCaches"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:path])
        {
            if (![fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil]) {
                NSLog(@"create file fail");
                return NO;
            }
            [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:path] iOSVersion:iOSVersion];
        }
        return path;
    }
    else   //iOS 5.0及其之前的版本 都需要把文件存储在Library/Cache怒录下，防止iCloud自动备份
    {
        return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
}

//沙盒Documents目录
+(NSString *) SysDocumentPath
{
    //iOS 5.0.1及其以后版本
    //需要在系统Documents目录中创建一个文件夹，设置 Do not backup 属性，防止被APP Store Reject
    NSString *iOSVersion = [NSString stringWithFormat:@"%@",[CacheManagement instance].currentiOSVersion];
    float version = [iOSVersion floatValue];  
    if (version > 5.0 ||[iOSVersion isEqualToString:@"5.0.1"]==YES)
    {
        NSString * _sysDocument= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *path = [_sysDocument stringByAppendingPathComponent:@"dataCaches"];
        NSFileManager *fileManager = [NSFileManager defaultManager];  
        if (![fileManager fileExistsAtPath:path])
        {  
            if (![fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil]) {  
                NSLog(@"create file fail");  
                return NO;  
            }  
            [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:path] iOSVersion:iOSVersion]; 
        }  
        return path;
    }
    else   //iOS 5.0及其之前的版本 都需要把文件存储在Library/Cache怒录下，防止iCloud自动备份
    {
        return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
}

//设置文件不备份扩展属性
+(BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL iOSVersion:(NSString *) iOSVersion
{  
    float version = [iOSVersion floatValue];  
    if (version > 5.0 && [iOSVersion isEqualToString:@"5.0.1"]==NO)  
    {
        assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
        NSError *error = nil;
        BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(!success){
            NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        }
        return success;
    }  
    else 
    {
        const char* filePath = [[URL path] fileSystemRepresentation];  
        const char* attrName = "com.apple.MobileBackup";  
        u_int8_t attrValue = 1;  
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);  
        return result== 0;  
    }
}

+ (UIColor *) colorWithHexString: (NSString *) hexString {
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

//系统字体颜色
+(UIColor *)GetWhiteLableColor
{
    return [UIColor whiteColor];
}
//Nav Title Color
+(UIColor *)GetNavTitleColor
{
    return [UIColor colorWithRed:57.0/255.0 green:89.0/255.0 blue:102.0/255.0 alpha:1.0];
}
+(UIColor *)GetCommomLableColor
{
    return [UIColor colorWithRed:94.0/255.0 green:33.0/255.0 blue:9.0/255.0 alpha:1.0];
}
+(UIColor *)GetGridTitleColor
{
    return [UIColor colorWithRed:23.0/255.0 green:108.0/255.0 blue:149.0/255.0 alpha:1.0];
}
+(UIColor *)GetGridRemarkColor
{
    return [UIColor colorWithRed:94.0/255.0 green:94.0/255.0 blue:94.0/255.0 alpha:1.0];
}
+(UIColor *)GetGridRowColor1
{
    return [UIColor colorWithRed:247.0/255.0 green:245.0/255.0 blue:246.0/255.0 alpha:1.0];
}
+(UIColor *)GetGridRowColor2
{
    return [UIColor colorWithRed:233.0/255.0 green:232.0/255.0 blue:230.0/255.0 alpha:1.0];
}
//弹出提示信息
+(void) alertMessage:(NSString *)resultString 
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:resultString delegate:self 
                                          cancelButtonTitle:SYSLanguage?@"OK":@"确定"
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
}

+(void) alertMessage:(NSString *)resultString delegate:(id /*<UIAlertViewDelegate>*/)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示信息", nil)  
                                                    message:resultString delegate:delegate 
                                          cancelButtonTitle:SYSLanguage?@"OK":@"确定"
                                          otherButtonTitles: nil];
    [alert show];
    [alert release];
}

+(void) alertMessageSelected:(NSString *)resultString delegate:(id)delegate
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:resultString delegate:delegate 
                                          cancelButtonTitle:SYSLanguage?@"OK":@"确定"
                                          otherButtonTitles:SYSLanguage?@"Cancel":@"取消", nil ];
    [alert show];
    [alert release];
}


//添加左边返回按钮
+(void) createLeftBarButton:(UIViewController *)view  clichEvent:(SEL)clichEvent
{
    UIButton *back =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 21)];
	[back addTarget:view action:clichEvent forControlEvents:UIControlEventTouchUpInside];	
	[back setImage:[UIImage imageNamed:@"back_cn.png"] forState:UIControlStateNormal];
    if (SYSLanguage == EN)
    {
        [back setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    }
//    back.contentMode = UIViewContentModeLeft;
//	[back setTitle:NSLocalizedString(@"btnBackText", nil) forState:UIControlStateNormal];
	back.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
	back.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
    
	UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:back];
	view.navigationItem.leftBarButtonItem = backButtonItem;
	[back release];
	[backButtonItem release]; 
}

//添加Bar右边按钮
+(void) createRightBarButton:(UIViewController *)view clichEvent:(SEL)clichEvent btnSize:(CGSize)btnSize btnTitle:(NSString *) btnTitle
{
    UIButton *btn =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnSize.width , btnSize.height)];
    
	[btn addTarget:view action:clichEvent forControlEvents:UIControlEventTouchUpInside];	
	[btn setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
	[btn setTitle:btnTitle forState:UIControlStateNormal];
	btn.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
	btn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    if (SYSLanguage == EN)
    {
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:13.0];
    }
	UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
	view.navigationItem.rightBarButtonItem = rightButtonItem;
	[btn release];
	[rightButtonItem release]; 
}

//添加Bar右边按钮 图片按钮
+(void) createRightBarPicButton:(UIViewController *)view 
                     clichEvent:(SEL)clichEvent 
                        btnSize:(CGSize)btnSize 
                       btnImage:(UIImage *) btnImage
                       btnTitle:(NSString *) btnTitle
{
    UIButton *btn =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnSize.width , btnSize.height)];
	[btn addTarget:view action:clichEvent forControlEvents:UIControlEventTouchUpInside];	
	[btn setBackgroundImage:btnImage forState:UIControlStateNormal];
	btn.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [btn setTitleColor:[UIColor colorWithRed:71.0/255.0 green:71.0/255.0 blue:71.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    if(btnTitle !=nil && [btnTitle isEqualToString:@""]==NO)
    {
        [btn setTitle:btnTitle forState:UIControlStateNormal];
    }
    btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    
	UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
	view.navigationItem.rightBarButtonItem = rightButtonItem;
	[btn release];
	[rightButtonItem release]; 
}



//显示进度滚轮指示器
+(void)showWaiting
{
    // Initialization code
    CGRect frame = CGRectMake(0, 0, 320,  [UIScreen mainScreen].bounds.size.height); //[parent frame]
    UIView *theView = [[UIView alloc] initWithFrame:frame];
    
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
//    bgView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"alert_bg.png"]];
    bgView.alpha =0.7;
    [theView addSubview:bgView];
    [bgView release];

    [theView setTag:9999];
    
    UIView *showView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 200, 100)];
    showView.center = theView.center;
    showView.backgroundColor = [UIColor blackColor];
    showView.alpha = 0.5;
    showView.layer.cornerRadius = 8;
//    showView.layer.borderWidth = 2;
//    showView.layer.borderColor = [UIColor whiteColor].CGColor;
//    showView.layer.masksToBounds = YES;
    
    //Loading 图标
    UIActivityIndicatorView* progressInd = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(80, 10, 40, 40)];
    [progressInd startAnimating];
    progressInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    //Loading 文字
    UILabel *waitingLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 180, 100)];
    waitingLable.text =@"请稍等,正在执行...";
    if (SYSLanguage == EN)
    {
        waitingLable.text = @"Processing,please wait …";
    }
    waitingLable.textColor = [UIColor whiteColor];
    waitingLable.textAlignment = NSTextAlignmentCenter;
    waitingLable.font = [UIFont boldSystemFontOfSize:16];
    waitingLable.backgroundColor = [UIColor clearColor];
    [showView addSubview:progressInd];
    [showView addSubview:waitingLable];
      
    CAKeyframeAnimation * animation; 
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"]; 
    animation.duration = 0.3; 
    animation.delegate = self;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]]; 
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]]; 
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]]; 
    animation.values = values;
    [showView.layer addAnimation:animation forKey:nil];
    [theView addSubview:showView];
    [progressInd release];
    [waitingLable release];
    [showView release];
    
    [[UIApplication sharedApplication].keyWindow addSubview:theView];
    [theView release];
}

+(void)showWaiting:(NSString*)message
{
    // Initialization code
    CGRect frame = CGRectMake(0, 0, 320,  [UIScreen mainScreen].bounds.size.height); //[parent frame]
    UIView *theView = [[UIView alloc] initWithFrame:frame];
    
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    //    bgView.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"alert_bg.png"]];
    bgView.alpha =0.7;
    [theView addSubview:bgView];
    [bgView release];
    
    [theView setTag:9999];
    
    UIView *showView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 80, 80)];
    showView.center = theView.center;
    showView.backgroundColor = [UIColor darkGrayColor];
    showView.layer.cornerRadius = 8;
    showView.layer.borderWidth = 2;
    showView.layer.borderColor = [UIColor whiteColor].CGColor;
    showView.layer.masksToBounds = YES;
    
    //Loading 图标
    UIActivityIndicatorView* progressInd = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(20, 10, 40, 40)];
    [progressInd startAnimating];
    progressInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    //Loading 文字
    UILabel *waitingLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 70, 20)];
    waitingLable.text = message;
    waitingLable.textColor = [UIColor whiteColor];
    waitingLable.textAlignment = NSTextAlignmentCenter;
    waitingLable.font = [UIFont systemFontOfSize:14];
    waitingLable.backgroundColor = [UIColor clearColor];
    [showView addSubview:progressInd];
    [showView addSubview:waitingLable];
    
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    animation.delegate = self;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [showView.layer addAnimation:animation forKey:nil];
    [theView addSubview:showView];
    [progressInd release];
    [waitingLable release];
    [showView release];
    
    [[UIApplication sharedApplication].keyWindow addSubview:theView];
    [theView release];
}

//消除滚动轮指示器
+(void)closeWaiting
{
//    [[parent viewWithTag:9999] removeFromSuperview];
    [[[UIApplication sharedApplication].keyWindow viewWithTag:9999] removeFromSuperview];
}



//********网络链接失败提示框

+(void) showNetworkErrorView
{
    UIView *_telBgView=[[UIApplication sharedApplication].keyWindow viewWithTag:999];
    if(_telBgView ==nil)
    {
        _telBgView = [[UIView alloc] initWithFrame:CGRectMake(0, -480, DEWIDTH, 480)];
        _telBgView.backgroundColor = [UIColor clearColor]; 
        _telBgView.tag=999;
        
        UIView * _telTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEWIDTH, 64)];
        _telTopView.backgroundColor = [UIColor blackColor];
        _telTopView.alpha = 0.7f;        
        [_telBgView addSubview:_telTopView];
        [_telTopView release];
        
        UILabel *labPhoneNum = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, DEWIDTH-40, 20)];
        labPhoneNum.textAlignment = NSTextAlignmentCenter;
        labPhoneNum.backgroundColor = [UIColor clearColor];
        labPhoneNum.font = [UIFont boldSystemFontOfSize:16.0];
        labPhoneNum.textColor=[UIColor whiteColor];
        labPhoneNum.tag=100;
        labPhoneNum.text = @"网络错误";
        if (SYSLanguage == EN) {
            labPhoneNum.text = @"Network error";
        }
        //添加阴影
        labPhoneNum.shadowColor = [UIColor blackColor];
        labPhoneNum.shadowOffset = CGSizeMake(0, -1.0);
        [_telTopView addSubview:labPhoneNum];
        [labPhoneNum release];
        
        [[UIApplication sharedApplication].keyWindow addSubview:_telBgView];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.8f];
        _telBgView.frame = CGRectMake(0, 0, DEWIDTH, 480);
        [UIView commitAnimations];
        [_telBgView release];
    }
    else
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.8f];
        _telBgView.frame = CGRectMake(0, 0, DEWIDTH, 480);
        [UIView commitAnimations];
    }
    
    [NSThread detachNewThreadSelector:@selector(InitializeWaitTask) toTarget:self withObject:nil];
}

+ (void)InitializeWaitTask {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [NSThread sleepForTimeInterval:3]; //线程暂停2秒
	[self performSelectorOnMainThread:@selector(InitializeFinishedTask) withObject:nil waitUntilDone:NO];
    [pool release];
}

+ (void) InitializeFinishedTask
{
    [self closeNetworkErrorView];
}

+(void) closeNetworkErrorView
{
    UIView *_telView=[[UIApplication sharedApplication].keyWindow viewWithTag:999];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5f];
    _telView.frame = CGRectMake(0, -480, DEWIDTH, 480);
    [UIView commitAnimations];
    
}

//**********


//********提示信息提示框

+(void) showAlertMessageView:(NSString *) message
{
    UIView *_telBgView=[[UIApplication sharedApplication].keyWindow viewWithTag:1000];
//    [_telBgView release];
//    _telBgView = nil;
    if(_telBgView ==nil)
    {
        _telBgView = [[UIView alloc] initWithFrame:CGRectMake(0, -480, DEWIDTH, 480)];
        _telBgView.backgroundColor = [UIColor clearColor]; 
        _telBgView.tag=1000;
        
        UIView * _telTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEWIDTH, 64)];
        _telTopView.backgroundColor = [UIColor blackColor];
        _telTopView.alpha = 0.7f;        
        [_telBgView addSubview:_telTopView];
        [_telTopView release];
        
        UILabel *labPhoneNum = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, DEWIDTH-40, 20)];
        labPhoneNum.textAlignment = NSTextAlignmentCenter;
        labPhoneNum.backgroundColor = [UIColor clearColor];
        labPhoneNum.font = [UIFont boldSystemFontOfSize:16.0];
        labPhoneNum.textColor=[UIColor whiteColor];
        labPhoneNum.tag=100;
        labPhoneNum.text = message;
        //添加阴影
        labPhoneNum.shadowColor = [UIColor blackColor];
        labPhoneNum.shadowOffset = CGSizeMake(0, -1.0);
        [_telTopView addSubview:labPhoneNum];
        [labPhoneNum release];
        
        [[UIApplication sharedApplication].keyWindow addSubview:_telBgView];
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.1f];
        _telBgView.frame = CGRectMake(0, 0, DEWIDTH, 480);
        [UIView commitAnimations];
        [_telBgView release];
    }
    else
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.1f];
        _telBgView.frame = CGRectMake(0, 0, DEWIDTH, 480);
        [UIView commitAnimations];
    }
    
    [NSThread detachNewThreadSelector:@selector(InitializeAlertMessageWaitTask) toTarget:self withObject:nil];
}

+ (void)InitializeAlertMessageWaitTask {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [NSThread sleepForTimeInterval:2]; //线程暂停2秒
	[self performSelectorOnMainThread:@selector(closeAlertMessageView) withObject:nil waitUntilDone:NO];
    [pool release];
}

+(void) closeAlertMessageView
{
    UIView *_telView=[[UIApplication sharedApplication].keyWindow viewWithTag:1000];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5f];
    _telView.frame = CGRectMake(0, -480, DEWIDTH, 480);
    [UIView commitAnimations];
}

//**********



//保存图片
+ (void) saveImage:(UIImage *)image imgPath:(NSString *)imgPath {
    
    NSFileManager* filemanager = [NSFileManager defaultManager];
    [filemanager removeItemAtPath:imgPath error:nil];
    CGFloat fixelW = CGImageGetWidth(image.CGImage);
    CGFloat fixelH = CGImageGetHeight(image.CGImage);
    [[self resetSizeOfImageData:image maxSize:1000 maxWith:fixelW maxHeight:fixelH] writeToFile:[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[imgPath componentsSeparatedByString:@"dataCaches"] lastObject]] atomically:YES];
//    [UIImageJPEGRepresentation(image, 1.0f) writeToFile:[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[imgPath componentsSeparatedByString:@"dataCaches"] lastObject]] atomically:YES];
}

+ (void)saveThumImage:(UIImage *)image imgPath:(NSString *)imgPath {
    
    CGSize size = CGSizeMake(512, 384);
    if(image.size.width < image.size.height)
    {
        size = CGSizeMake(384, 512);
    }
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSFileManager* filemanager = [NSFileManager defaultManager];
    [filemanager removeItemAtPath:imgPath error:nil];

    [UIImageJPEGRepresentation(reSizeImage, 0.3f) writeToFile:[NSString stringWithFormat:@"%@%@",[Utilities SysDocumentPath],[[imgPath componentsSeparatedByString:@"dataCaches"] lastObject]] atomically:YES];
}

+ (NSData *)resetSizeOfImageData:(UIImage *)sourceImage maxSize:(NSInteger)maxSize maxWith:(float)mW maxHeight:(float)mH{
    //先判断当前质量是否满足要求，不满足再进行压缩
    __block NSData *finallImageData = UIImageJPEGRepresentation(sourceImage,1.0);
    NSUInteger sizeOrigin   = finallImageData.length;
    NSUInteger sizeOriginKB = sizeOrigin / 1000;
    
    if (sizeOriginKB <= maxSize) {
        return finallImageData;
    }
    
    //保存压缩系数
    NSMutableArray *compressionQualityArr = [NSMutableArray array];
    CGFloat avg   = 1.0/250;
    CGFloat value = avg;
    for (int i = 250; i >= 1; i--) {
        value = i*avg;
        [compressionQualityArr addObject:@(value)];
    }
    
    __block NSData *canCompressMinData = [NSData data];
    [self halfFuntion:compressionQualityArr image:sourceImage sourceData:finallImageData maxSize:maxSize resultBlock:^(NSData *finallData, NSData *tempData) {
        finallImageData = finallData;
        canCompressMinData = tempData;
    }];

    if (finallImageData.length==0) {
        finallImageData = canCompressMinData;
    }
    return finallImageData;
}

#pragma mark 二分法
///二分法，block回调中finallData长度不为零表示最终压缩到了指定的大小，如果为零则表示压缩不到指定大小。tempData表示当前能够压缩到的最小值。
+ (void)halfFuntion:(NSArray *)arr image:(UIImage *)image sourceData:(NSData *)finallImageData maxSize:(NSInteger)maxSize resultBlock:(void(^)(NSData *finallData, NSData *tempData))block {
    
    NSData *tempData = [NSData data];
    NSUInteger start = 0;
    NSUInteger end = arr.count - 1;
    NSUInteger index = 0;
    NSUInteger difference = NSIntegerMax;
    while(start <= end) {
        index = start + (end - start)/2;
        finallImageData = UIImageJPEGRepresentation(image,[arr[index] floatValue]);
        NSUInteger sizeOrigin = finallImageData.length;
        NSUInteger sizeOriginKB = sizeOrigin / 1000;
        NSLog(@"当前降到的质量：%ld", (unsigned long)sizeOriginKB);
        
        if (sizeOriginKB > maxSize) {
            start = index + 1;
        } else if (sizeOriginKB < maxSize) {
            if (maxSize-sizeOriginKB < difference) {
                difference = maxSize-sizeOriginKB;
                tempData = finallImageData;
            }
            if (index<=0) {
                break;
            }
            end = index - 1;
        } else {
            break;
        }
    }
    NSData *d = [NSData data];
    if (tempData.length==0) {
        d = finallImageData;
    }
    if (block) {
        block(tempData, d);
    }
}


//判断Issue表的编号
+(NSInteger) getIssueTableIndex:tableName
{
    NSInteger index=0;
    if([tableName isEqualToString:kSTORE_ISSUE_CATEGORY])
        index=1;
    else if([tableName isEqualToString:kSTORE_ISSUE_ITEM])
        index=2;
    else if([tableName isEqualToString:kNVM_VM_CHECK_ITEM])         // 检查表项
        index=3;
    else if ([tableName isEqualToString:kNVM_ISSUE_PHOTO_ZONE])
        index=4;
    else if ([tableName isEqualToString:kNVM_STORE_PHOTO_ZONE])
        index=5;
    else if ([tableName isEqualToString:@"FR_ARMS_ITEM"])
        index=6;
    else if ([tableName isEqualToString:@"NVM_VM_CHECK_CATEGORY"])
        index=7;
    else if ([tableName isEqualToString:@"NVM_VM_SCORECARD_ITEM"])
        index=8;
    else if ([tableName isEqualToString:@"NVM_VM_SCORECARD_ITEM_DETAIL"])
        index=9;
    else if ([tableName isEqualToString:@"FR_ISSUE_PHOTO_ZONE"])
        index=10;
    else if ([tableName isEqualToString:@"FR_HEADCOUNT_ITEM"])
        index=11;
    else if ([tableName isEqualToString:@"NVM_MST_STOREAUDIT_ITEM"])
        index=12;
    else if ([tableName isEqualToString:@"NVM_MST_ONSITE_PHOTOZONE"])
        index=13;
    return index;
}

//+ (void)createAlbumInPhoneAlbum
//{
//    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
//    NSMutableArray *groups = [[NSMutableArray alloc]init];
//    ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop)
//    {
//        if (group)
//        {
//            [groups addObject:group];
//        }
//        
//        else
//        {
//            BOOL haveHDRGroup = NO;
//            
//            for (ALAssetsGroup *gp in groups)
//            {
//                NSString *name =[gp valueForProperty:ALAssetsGroupPropertyName];
//                
//                if ([name isEqualToString:@"Mobile Solution"])
//                {
//                    haveHDRGroup = YES;
//                }
//            }
//            
//            if (!haveHDRGroup)
//            {
//                
//                [assetsLibrary addAssetsGroupAlbumWithName:@"Mobile Solution"
//                                               resultBlock:^(ALAssetsGroup *group)
//                 {
//                     [groups addObject:group];
//                     
//                 }
//                failureBlock:nil];
//                
//                haveHDRGroup = YES;
//            }
//        }
//        
//    };
//    //创建相簿
//    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:listGroupBlock failureBlock:nil];
//}

+ (void)saveToAlbumWithMetadata:(NSDictionary *)metadata
                      imageData:(NSData *)imageData
                completionBlock:(void (^)(void))completionBlock
                   failureBlock:(void (^)(NSError *error))failureBlock
{
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    void (^AddAsset)(ALAssetsLibrary *, NSURL *) = ^(ALAssetsLibrary *assetsLibrary, NSURL *assetURL) {
        [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                
                if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"Mobile Solution"]) {
                    [group addAsset:asset];
                    if (completionBlock) {
                        completionBlock();
                    }
                }
            } failureBlock:^(NSError *error) {
                if (failureBlock) {
                    failureBlock(error);
                }
            }];
        } failureBlock:^(NSError *error) {
            if (failureBlock) {
                failureBlock(error);
            }
        }];
    };
    
    [assetsLibrary writeImageDataToSavedPhotosAlbum:imageData metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
        
            [assetsLibrary addAssetsGroupAlbumWithName:@"Mobile Solution" resultBlock:^(ALAssetsGroup *group) {
                if (group) {
                    [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                        [group addAsset:asset];
                        if (completionBlock) {
                            completionBlock();
                        }
                    } failureBlock:^(NSError *error) {
                        if (failureBlock) {
                            failureBlock(error);
                        }
                    }];
                } else {
                    AddAsset(assetsLibrary, assetURL);
                }
            } failureBlock:^(NSError *error) {
                AddAsset(assetsLibrary, assetURL);
            }];
    }];
}

@end


