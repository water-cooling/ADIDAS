//
//  DownloadItem.m
//  DownloadDemo
//
//  Created by Peter Yuen on 6/26/14.
//  Copyright (c) 2014 CocoaRush. All rights reserved.
//

#import "DownloadItem.h"
#import "DownloadStoreManager.h"
#import "CacheManagement.h"

@interface DownloadItem ()
{
    NSTimer *_progressTimer;
    BOOL _isFristReciveBytes;//第一次返回的bytes是已传输的，防止与本地存储的大小累加
}


-(void)notifyItemStateChanged;
-(void)notifyItemProgressChanged;
-(void)monitorDownloadProgress:(NSTimer *)timer;
@end


@implementation DownloadItem

-(void)setDownloadState:(DownloadItemState)downloadState
{
    self.downloadStateDescription=[DownloadItem getDownloadStateDescriptionFromState:downloadState];
    if(_downloadState==downloadState)
    {
        return;
    }
    _downloadState=downloadState;
    
    [self notifyItemStateChanged];
}

-(void)notifyItemStateChanged
{
    if(self.DownloadItemStateChangedCallback)
    {
        self.DownloadItemStateChangedCallback(self);
    }
}
-(void)notifyItemProgressChanged
{
    if(self.DownloadItemProgressChangedCallback)
    {
        self.DownloadItemProgressChangedCallback(self);
    }
}

-(void)monitorDownloadProgress:(NSTimer *)timer
{
    [self notifyItemProgressChanged];
    
    //update db in background
    dispatch_async(dispatch_get_global_queue(0, 0), ^(void){
        [[DownloadStoreManager sharedInstance]updateDownloadTask:self];
    });
}

+(NSString *)getDownloadStateDescriptionFromState:(DownloadItemState)state
{
    NSString *stateDescription=@"";
    switch (state) {
        case DownloadFailed:
        {
            stateDescription=@"错误";
        }
            break;
        case Downloading:
        {
            stateDescription=@"下载中";
        }
            break;
        case DownloadFinished:
        {
            stateDescription=@"下载完成";
        }
            break;
        case DownloadNotStart:
        {
            stateDescription=@"未下载";
        }
            break;
        case DownloadWait:
        {
            stateDescription=@"等待中";
        }
            break;
        case DownloadPaused:
        {
            stateDescription=@"暂停";
        }
            break;
        default:
            break;
    }
    return stateDescription;
}

-(void)startDownloadTask
{
    [self setTimeOutSeconds:120];
    [self setDelegate:self];
    [self setDownloadProgressDelegate:self];
    [self setValidatesSecureCertificate:NO];
    if ([CacheManagement instance].userEncode&&![[CacheManagement instance].userEncode isEqualToString:@""])
        [self addRequestHeader:@"Authorization"
                        value:[NSString stringWithFormat:@"Basic %@",[CacheManagement instance].userEncode]];
    //  wangzitao
    [self startAsynchronous];
    
    //insert db in background
    dispatch_async(dispatch_get_global_queue(0, 0), ^(void){
        [[DownloadStoreManager sharedInstance]insertDownloadTask:self];
    });

    _progressTimer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(monitorDownloadProgress:) userInfo:nil repeats:YES];
    _isFristReciveBytes=YES;
    self.downloadState=DownloadWait;
    NSLog(@"start download url:%@",self.url);
}

-(void)pauseDownloadTask
{
    [self clearDelegatesAndCancel];
    if(_progressTimer)
    {
        [_progressTimer fire];
        [_progressTimer invalidate];
    }
    self.downloadState=DownloadPaused;
}

-(void)cancelDownloadTask
{
    self.receivedLength=0;
    self.totalLength=0;
    self.downloadPercent=0;
    //delete db in background
    dispatch_async(dispatch_get_global_queue(0, 0), ^(void){
        [[DownloadStoreManager sharedInstance]deleteDownloadTask:[self.url description]];
        
        //remove temp downloaded data
        [self removeTemporaryDownloadFile];
    });
    [self pauseDownloadTask];
    self.downloadState=DownloadNotStart;

    
}


#pragma mark - asi delegate
-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)_responseHeaders
{
    NSLog(@"_responseHeaders=%@",_responseHeaders);
    NSString *rangeString=[_responseHeaders objectForKey:@"Content-Range"];
    if(rangeString)
    {
        int index= [rangeString rangeOfString:@"/"].location;
        if(index!=NSNotFound)
        {
            _totalLength=[[rangeString substringFromIndex:index+1] doubleValue];
        }
    }
    else
    {
        NSString *lengthString=[_responseHeaders objectForKey:@"Content-Length"];
        if(lengthString)
        {
            _totalLength=[lengthString doubleValue];
        }
    }
    self.downloadState=Downloading;
    
    //update db in background
    dispatch_async(dispatch_get_global_queue(0, 0), ^(void){
        [[DownloadStoreManager sharedInstance]updateDownloadTask:self];
    });
}


-(void)requestFinished:(ASIHTTPRequest *)request
{
    if(_progressTimer)
    {
        [_progressTimer invalidate];
    }
    self.downloadState=DownloadFinished;
    
    //finished db in background
    dispatch_async(dispatch_get_global_queue(0, 0), ^(void){
        [[DownloadStoreManager sharedInstance]updateDownloadTask:self];
    });
}

-(void)requestFailed:(ASIHTTPRequest *)_request
{
    NSLog(@"%@",_request.error);
    if(_progressTimer)
    {
        [_progressTimer invalidate];
    }
    self.downloadState=DownloadFailed;
}

#pragma mark - progress delegate
-(void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes
{
    if(_isFristReciveBytes)
    {
        _receivedLength=bytes;
        _isFristReciveBytes=NO;
    }
    else
    {
        _receivedLength+=bytes;
    }
    if(_totalLength!=0)
    {
        self.downloadPercent=_receivedLength/_totalLength;
    }
}


@end
