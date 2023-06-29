//
//  CommonUtil.m
//  StoreVisitPack
//
//  Created by joinone on 15/3/2.
//  Copyright (c) 2015年 joinone. All rights reserved.
//

#import "CommonUtil.h"
#import "GTMBase64.h"
#import "SqliteHelper.h"
#include <sys/xattr.h>
#import "User.h"
#import "KeyChainStore.h"
#import <AdSupport/AdSupport.h>

@implementation CommonUtil

static CommonUtil *_instance=nil;

+ (CommonUtil *)instance {
    @synchronized(self){
        if (!_instance) {
            _instance = [[CommonUtil alloc] init];
        }
    }
    
    return _instance;
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

+ (UIColor *) colorWithHexString: (NSString *) hexString withAlpha:(float)alp{
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
            alpha = alp;
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


+ (NSString *)getPlistPath:(NSString*)filename{
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [path objectAtIndex:0];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:filename];
    
    return filePath;
}


/**  获取UUID*/
+ (NSString *)getUUIDByKeyChain{
    // 这个key的前缀最好是你的BundleID
    NSString *strUUID = (NSString *)[KeyChainStore load:@"com.adidas.enterprise.MobileApp.uuid"];
    //首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || !strUUID) {
        // 获取UUID 这个是要引入<AdSupport/AdSupport.h>的
        strUUID = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];

        if (strUUID.length == 0 || [strUUID isEqualToString:@"00000000-0000-0000-0000-000000000000"]) {
            //生成一个uuid的方法
            CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
            strUUID = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidRef));
            CFRelease(uuidRef);
        }
        //将该uuid保存到keychain
        [KeyChainStore save:@"com.adidas.enterprise.MobileApp.uuid" data:strUUID];
    }
    return strUUID;
}



//沙盒Documents目录
+ (NSString *)SysDocumentPath {
    
    //iOS 5.0.1及其以后版本
    //需要在系统Documents目录中创建一个文件夹，设置 Do not backup 属性，防止被APP Store Reject
    NSString *iOSVersion = [[UIDevice currentDevice] systemVersion] ; ;
    float version = [iOSVersion floatValue];
    if (version > 5.0 ||[iOSVersion isEqualToString:@"5.0.1"]==YES)
    {
        NSString * _sysDocument= [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *path = [_sysDocument stringByAppendingPathComponent:@"defectiveImage"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:path])
        {
            if (![fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil]) {
                NSLog(@"create file fail");
                return @"";
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

+ (NSString *)NSDateToNSString:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC8"]];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *string = [formatter stringFromDate:date];

    return string;
}

+ (NSString *)NSDateNoTimeToNSString:(NSDate *)date {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC8"]];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *string = [formatter stringFromDate:date];
    
    return string;
}

+ (NSString *)getDecryKey:(NSString *)account{
    
    if (!account) {
        
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[CommonUtil getPlistPath:LOGINDATA]];
        
        User *savedUser = [[User alloc] initWith:dic] ;
        
        account = savedUser.UserAccount ;
    }
    
    NSString *str = [NSString stringWithFormat:@"%.f",pow(10, (16-account.length))];
    
    return [NSString stringWithFormat:@"%@%@",account,[str substringFromIndex:1]];
}

+ (void)clearData {

//    NSMutableArray *foldName = [NSMutableArray array];
//    
//    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:[CommonUtil getPlistPath:LOGINDATA]];
//    
//    NSString *useraccount = @"" ;
//    
//    if ([dic valueForKey:@"UserAccount"] && ![[dic valueForKey:@"UserAccount"] isEqual:[NSNull null]]) {
//        
//        useraccount = [dic valueForKey:@"UserAccount"] ;
//    }
//    
//    NSArray *noupload = [NSArray arrayWithContentsOfFile:[self getPlistPath:[NSString stringWithFormat:@"%@_%@",[useraccount uppercaseString],NOUPLOADDATA]]];
//    NSArray *history = [NSArray arrayWithContentsOfFile:[self getPlistPath:[NSString stringWithFormat:@"%@_%@",[useraccount uppercaseString],HISTORYDATA]]];
//    
//    for (NSDictionary *dic in noupload) {
//        
//        [foldName addObject:[[dic allKeys] firstObject]] ;
//    }
//    
//    for (NSDictionary *dic in history) {
//        
//        [foldName addObject:[[dic allKeys] firstObject]] ;
//    }
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager] ;
//    
//    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@",[CommonUtil SysDocumentPath]] error:nil];
//    
//    for (NSString *fold in fileList) {
//        
//        if (![foldName containsObject:fold]) {
//            
//            [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],fold] error:nil];
//        }
//    }
}

@end







