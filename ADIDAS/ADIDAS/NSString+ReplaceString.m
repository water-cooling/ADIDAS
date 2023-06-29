//
//  NSString+ReplaceString.m
//  ADIDAS
//
//  Created by 桂康 on 15/6/16.
//
//

#import "NSString+ReplaceString.h"

@implementation NSString (ReplaceString)

- (NSString *)getReplaceString {

    NSString *str1 = @"&" ;
    NSString *str2 = @"<" ;
    NSString *str3 = @"/>";
    NSString *str4 = @"'" ;
    NSString *str5 = @"\"";
    NSString *str6 = @">" ;
    
    NSString *trimmedString = [self stringByReplacingOccurrencesOfString:str1 withString:@""];
    trimmedString = [trimmedString stringByReplacingOccurrencesOfString:str2 withString:@""];
    trimmedString = [trimmedString stringByReplacingOccurrencesOfString:str3 withString:@""];
    trimmedString = [trimmedString stringByReplacingOccurrencesOfString:str4 withString:@""];
    trimmedString = [trimmedString stringByReplacingOccurrencesOfString:str5 withString:@""];
    trimmedString = [trimmedString stringByReplacingOccurrencesOfString:str6 withString:@""];
    
    return trimmedString ;
}

@end
