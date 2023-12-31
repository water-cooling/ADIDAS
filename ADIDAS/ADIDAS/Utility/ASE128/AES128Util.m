//
//  AES128Util.m
//  ASE128Demo
//
//  Created by zhenghaishu on 11/11/13.
//  Copyright (c) 2013 Youku.com inc. All rights reserved.
//

#import "AES128Util.h"
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"

@implementation AES128Util

+(NSString *)AES128Encrypt:(NSString *)plainText key:(NSString *)key
{
    NSString *tempKey = @"" ;
    for (int x = 0; x < key.length; x++) {
        NSString *temp = [key substringWithRange:NSMakeRange(x, 1)];
        int asciiCode = [temp characterAtIndex:0]+x+1;
        if (asciiCode > 126) asciiCode = 126;
        NSString *string = [NSString stringWithFormat:@"%c", asciiCode];
        tempKey = [NSString stringWithFormat:@"%@%@",tempKey,string];
    }
    
    NSString *ivString = @"" ;
    for (int x = 0; x < key.length; x++) {
        NSString *temp = [key substringWithRange:NSMakeRange(x, 1)];
        int asciiCode = [temp characterAtIndex:0]-x-1;
        if (asciiCode < 33) asciiCode = 33;
        NSString *string = [NSString stringWithFormat:@"%c", asciiCode];
        ivString = [NSString stringWithFormat:@"%@%@",ivString,string];
    }
    
    key = tempKey;
    
    char keyPtr[kCCKeySizeAES128+1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    
    char ivPtr[kCCBlockSizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [ivString getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        return [GTMBase64 stringByEncodingData:resultData];

    }
    free(buffer);
    return nil;
}


+(NSString *)AES128Decrypt:(NSString *)encryptText key:(NSString *)key
{
    NSString *tempKey = @"" ;
    for (int x = 0; x < key.length; x++) {
        NSString *temp = [key substringWithRange:NSMakeRange(x, 1)];
        int asciiCode = [temp characterAtIndex:0]+x+1;
        if (asciiCode > 126) asciiCode = 126;
        NSString *string = [NSString stringWithFormat:@"%c", asciiCode];
        tempKey = [NSString stringWithFormat:@"%@%@",tempKey,string];
    }
    
    NSString *ivString = @"" ;
    for (int x = 0; x < key.length; x++) {
        NSString *temp = [key substringWithRange:NSMakeRange(x, 1)];
        int asciiCode = [temp characterAtIndex:0]-x-1;
        if (asciiCode < 33) asciiCode = 33;
        NSString *string = [NSString stringWithFormat:@"%c", asciiCode];
        ivString = [NSString stringWithFormat:@"%@%@",ivString,string];
    }
    
    key = tempKey;
    
    
    char keyPtr[kCCKeySizeAES128 + 1];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData *data = [GTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    
    
    char ivPtr[kCCBlockSizeAES128+1];
    memset(ivPtr, 0, sizeof(ivPtr));
    [ivString getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          ivPtr,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        return [[[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding] autorelease];
    }
    free(buffer);
    return nil;
}

@end
