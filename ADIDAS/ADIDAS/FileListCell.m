//
//  FileListCell.m
//  VM
//
//  Created by wendy on 14-7-16.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import "FileListCell.h"
#import "ASIHTTPRequest.h"
#import "CacheManagement.h"

@implementation FileListCell

- (IBAction)operateClick:(id)sender {
    if(self.DowningCellOperateClick)
    {
        self.DowningCellOperateClick(self);
    }
    
}

- (IBAction)cancelClick:(id)sender {
    if(self.DowningCellCancelClick)
    {
        self.DowningCellCancelClick(self);
    }
}

-(NSData*) sendHttpRequest:(NSString *) urlString
{
    ASIHTTPRequest*  request = nil;
    NSString* urlstr = urlString;
    NSURL *url = [NSURL URLWithString:[urlstr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    
    request = [[ASIHTTPRequest alloc]initWithURL:url];
    [request setValidatesSecureCertificate:NO];
    
    //添加ISA 密文验证
    if ([CacheManagement instance].userEncode&&![[CacheManagement instance].userEncode isEqualToString:@""])
        [request addRequestHeader:@"Authorization"
                        value:[NSString stringWithFormat:@"Basic %@",[CacheManagement instance].userEncode]];
    
	[request startSynchronous];
    NSError *error = [request error];
    NSData *response = nil;
    if (!error) {
        response = [request responseData];
    }
    return response;
}

-(void)downloadImage:(NSString*)string
{
    // 先判断本地是否有缓存
    
    NSString* imagePathString = [NSString stringWithFormat:@"%@/Library/Caches/images%@", NSHomeDirectory(), string];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePathString]) {
        // remove 0 size file
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:imagePathString error:nil];
        unsigned long long fileSize = [attributes fileSize];
        if (fileSize == 0) {
            [[NSFileManager defaultManager] removeItemAtPath:imagePathString error:nil];
        }
        else
        {
            [self.fileImage setImage:[UIImage imageWithContentsOfFile:imagePathString]];
            NSLog(@"从本地读取");
            return;
        }
    }
    
    __block NSData* data;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        data = [self sendHttpRequest:string];
        [[NSFileManager defaultManager] createDirectoryAtPath:imagePathString withIntermediateDirectories:YES attributes:nil error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:imagePathString error:nil];
        
        [[NSFileManager defaultManager] createFileAtPath:imagePathString contents:data attributes:nil];
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [self.fileImage setImage:[UIImage imageWithData:data]];
                       });
        
    });
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.sizelabel.text = SYSLanguage?@"Size:":@"大小:";
}
@end
