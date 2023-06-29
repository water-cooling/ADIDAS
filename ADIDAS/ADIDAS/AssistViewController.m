//
//  AssistViewController.m
//  VM
//
//  Created by wendy on 14-7-16.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import "AssistViewController.h"
#import "CommonDefine.h"
#import "ASIHTTPRequest.h"
#import "NSString+SBJSON.h"
#import <MediaPlayer/MediaPlayer.h>
#import "LeveyTabBarController.h"
#import "Utilities.h"
#import "DownloadItem.h"
#import "DownloadManager.h"
#import "Utility.h"
#import "FileListCell.h"
#import "CacheManagement.h"
#import "QLPreviewController+Title.h"
#import "CommonUtil.h"

@interface AssistViewController ()
{
    DownloadItem *item;
    NSMutableArray *_urlArr;
    NSMutableDictionary *_urllist;
    NSMutableDictionary *_downinglist;
    NSMutableDictionary *_finishedlist;
}

- (IBAction)cancelAll:(id)sender;
- (IBAction)startAll:(id)sender;
- (IBAction)pauseAllClick:(id)sender;
- (IBAction)origDataClick;


-(void)updateUIByDownloadItem:(DownloadItem *)downItem;

@end

@implementation AssistViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kDownloadManagerNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

-(void)updateCell:(FileListCell *)cell withDownItem:(DownloadItem *)downItem
{
//    cell.lblTitle.text=[downItem.url description];
//    cell.downloadProgress.hidden = NO;
    cell.deleteButton.hidden = NO;
    cell.lblPercent.text=[[NSString stringWithFormat:@"%0.2f",downItem.downloadPercent*100] stringByAppendingString:@"%"];
    cell.downloadProgress.progress = downItem.downloadPercent;
//    [cell.btnOperate setTitle:downItem.downloadStateDescription forState:UIControlStateNormal];
    if (downItem.downloadState == Downloading) {
        [cell.btnOperate setBackgroundImage:[UIImage imageNamed:@"loading.png"] forState:UIControlStateNormal];
        cell.deleteButton.hidden = YES;
        cell.downloadProgress.hidden = NO;
    }
    else if (downItem.downloadState == DownloadFinished) {
        [cell.btnOperate setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        cell.downloadProgress.hidden = YES;
        cell.deleteButton.hidden = NO;
    }
    else if (downItem.downloadState == DownloadNotStart) {
        [cell.btnOperate setBackgroundImage:[UIImage imageNamed:@"download.png"] forState:UIControlStateNormal];
        cell.deleteButton.hidden = YES;
        cell.downloadProgress.hidden = YES;
    }
}

-(void)updateUIByDownloadItem:(DownloadItem *)downItem
{
    DownloadItem *findItem=[_urllist objectForKey:[downItem.url description]];
    if(findItem==nil)
    {
        return;
    }
    findItem.downloadStateDescription = downItem.downloadStateDescription;
    findItem.downloadPercent = downItem.downloadPercent;
    findItem.downloadState = downItem.downloadState;
    switch (downItem.downloadState) {
        case DownloadFinished:
        {
            
        }
            break;
        case DownloadFailed:
        {
            
        }
            break;
        default:
            break;
    }
    
    int index = (int)[_urlArr indexOfObject:findItem];
    FileListCell *cell=(FileListCell *)[self.FileListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
    [self updateCell:cell withDownItem:downItem];
}

-(void)downloadNotification:(NSNotification *)notif
{
    DownloadItem *notifItem=notif.object;
    //    NSLog(@"%@,%d,%f",notifItem.url,notifItem.downloadState,notifItem.downloadPercent);
    [self updateUIByDownloadItem:notifItem];
}


-(void)buttontap:(id)cell
{
    FileListCell* Cell = cell;

    NSArray* filearr = [Cell.urlfilestring componentsSeparatedByString:@"/"];
    NSString* filePathString = [[Utilities CachePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",[filearr lastObject]]];
    self.filepath = filePathString;
    QLPreviewController *previewController = [[QLPreviewController alloc] init];
    previewController.title = Cell.fileNameLabel.text;
    previewController.dataSource = self;
    previewController.delegate = self;

    previewController.currentPreviewItemIndex = Cell.tag;
    [[self navigationController] pushViewController:previewController animated:YES];
    [self.leveyTabBarController hidesTabBar:YES animated:YES];

}

-(void)getFileListArray
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString* urlString = [NSString stringWithFormat:kGetFileList,kWebDataString,[CacheManagement instance].userLoginName];
        NSURL *url = [NSURL URLWithString:urlString];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        
        [request setValidatesSecureCertificate:NO];
        [request setRequestMethod:@"GET"];
        [request addRequestHeader:@"Accept" value:@"application/json"];
        [request addRequestHeader:@"Content-Type" value:@"application/json"];
        
        //添加ISA 密文验证
        if ([CacheManagement instance].userEncode&&![[CacheManagement instance].userEncode isEqualToString:@""])
            [request addRequestHeader:@"Authorization"
                             value:[NSString stringWithFormat:@"Basic %@",[CacheManagement instance].userEncode] ];
        
        [request setTimeOutSeconds:200];
        [request startSynchronous];
        
        NSError *error = [request error];
        
        if (!error)
        {
            NSString *response = [request responseString];
            
            NSArray *resultAry = nil ;
            if (![response JSONValue]) {
                NSString *aesString = [AES128Util AES128Decrypt:response key:[CommonUtil getDecryKey:[CacheManagement instance].currentDBUser.userName]]  ;
                resultAry = [aesString JSONValue] ;
            }else {
                resultAry = [response JSONValue];
            }
            
            [self.fileListArray addObjectsFromArray:resultAry];

            dispatch_async(dispatch_get_main_queue(), ^{
                [self origDataClick];
                if ([self.fileListArray count] == 0)
                {
                    self.label.text = SYSLanguage?@"There is no document":@"当前无辅助文档";
                    self.label.hidden = NO;
                }
                else
                {
                    self.label.hidden = YES;
                }

            });
        }
    });
}

- (void)origDataClick
{
    _urllist=[NSMutableDictionary new];
    _urlArr = [NSMutableArray new];
    for (id obj in self.fileListArray)
    {
        NSString* fileurl = [NSString stringWithFormat:@"%@%@",kWebMobileHeadString,[ obj objectForKey:@"DocFileUrl"]];
        
        DownloadItem *downItem=[[DownloadItem alloc]init];
        downItem.url=[NSURL URLWithString:fileurl];
        DownloadItem *task=[[DownloadManager sharedInstance] getDownloadItemByUrl:[downItem.url description]];
        downItem.downloadPercent=task.downloadPercent;
        if(task)
        {
            downItem.downloadState=task.downloadState;
        }
        else
        {
            downItem.downloadState=DownloadNotStart;
        }
        
        [_urllist setObject:downItem forKey:[downItem.url description]];
        [_urlArr addObject:downItem];
    }
    [self.FileListTableView reloadData];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 0)
    {
        if(buttonIndex == 1)
        {
            NSArray* filearr = [self.downloadcell.urlfilestring componentsSeparatedByString:@"/"];
            
            NSFileManager *fileManager=[NSFileManager defaultManager];
            
            if(![fileManager fileExistsAtPath:[Utilities CachePath]])
            {
                [fileManager createDirectoryAtPath:[Utilities CachePath] withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSString *desPath=[[Utilities CachePath] stringByAppendingPathComponent:[filearr lastObject]];
            
            [[DownloadManager sharedInstance]startDownload:self.downloadcell.urlfilestring withLocalPath:desPath];
            self.downloadcell = nil;
        }
    }
    else if(alertView.tag == 1)
    {
        if (buttonIndex == 1)
        {
            [[DownloadManager sharedInstance]cancelDownload:self.downloadcell.urlfilestring];
            self.downloadcell = nil;
        }
    }
    
}


#pragma mark - tableview

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FileListCell* cell = (FileListCell*)[tableView cellForRowAtIndexPath:indexPath];
    self.downloadcell = cell;
    
    if([[DownloadManager sharedInstance]isExistInDowningQueue:cell.urlfilestring])
    {
        [[DownloadManager sharedInstance]pauseDownload:cell.urlfilestring];
        return;
    }
    if (([[DownloadManager sharedInstance]isExistInFinshQueue:cell.urlfilestring]))
    {
        [self buttontap:cell];
        return;
    }
    NSString* title = [NSString stringWithFormat:@"该文件大小为%@,是否确定下载?",cell.fileSizeLabel.text];
    NSString* cancel = @"取消";
    NSString* sure = @"确定";
    if (SYSLanguage == EN) {
        title = [NSString stringWithFormat:@"The size of file is %@, are you sure to download?",cell.fileSizeLabel.text];;
        cancel = @"Cancel";
        sure = @"OK";
    }
    UIAlertView* av = [[UIAlertView alloc]initWithTitle:title message:nil delegate:self cancelButtonTitle:cancel otherButtonTitles:sure, nil];
    av.tag = 0;
    [av show];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.fileListArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DownloadItem *downItem=[_urlArr objectAtIndex:indexPath.row];
//    NSString *url=[downItem.url description];
//    NSArray* filearr = [[[self.fileListArray objectAtIndex:indexPath.row]objectForKey:@"DocFileUrl"] componentsSeparatedByString:@"/"];
    
    static NSString *cellIdentity=@"DowningCell";
    FileListCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if(cell==nil)
    {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"FileListCell" owner:self options:nil] lastObject];
    }
    cell.tag = indexPath.row;
    
    cell.urlstring = [NSString stringWithFormat:@"%@%@",kWebMobileHeadString,[[self.fileListArray objectAtIndex:indexPath.row]objectForKey:@"DocLogoUrl"]];
    cell.urlfilestring = [NSString stringWithFormat:@"%@%@",kWebMobileHeadString,[[self.fileListArray objectAtIndex:indexPath.row]objectForKey:@"DocFileUrl"]];
    cell.fileNameLabel.text = [[self.fileListArray objectAtIndex:indexPath.row]objectForKey:SYSLanguage?@"DocNameEn":@"DocName"];
    cell.fileSizeLabel.text = [[[self.fileListArray objectAtIndex:indexPath.row]objectForKey:@"DocFileSize"]stringValue];
    float size = [cell.fileSizeLabel.text floatValue];
    size = size / (1024*1024);
    cell.fileSizeLabel.text = [NSString stringWithFormat:@"%.2fM",size];
    
    cell.DowningCellOperateClick=^(FileListCell *cell){
        
        if([[DownloadManager sharedInstance]isExistInDowningQueue:cell.urlfilestring])
        {
            [[DownloadManager sharedInstance]pauseDownload:cell.urlfilestring];
            return;
        }
        if (([[DownloadManager sharedInstance]isExistInFinshQueue:cell.urlfilestring]))
        {
            [self buttontap:cell];
            return;
        }
//        NSString *desPath=[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[[Utility sharedInstance] md5HexDigest:cell.urlfilestring]];
//
        self.downloadcell = cell;
        NSString* title = [NSString stringWithFormat:@"该文件大小为%@,是否确定下载?",cell.fileSizeLabel.text];
        if (cell.downloadProgress.progress > 0) {
            title = @"继续下载文档吗?";
        }
        NSString* cancel = @"取消";
        NSString* sure = @"确定";
        if (SYSLanguage == EN) {
            title = [NSString stringWithFormat:@"The size of file is %@, are you sure to download?",cell.fileSizeLabel.text];
            cancel = @"Cancel";
            sure = @"Sure";
            if (cell.downloadProgress.progress > 0)
            {
                title = [NSString stringWithFormat:@"The size of file is %@, are you sure to continue?",cell.fileSizeLabel.text];
            }
        }
        UIAlertView* av = [[UIAlertView alloc]initWithTitle:title message:nil delegate:self cancelButtonTitle:cancel otherButtonTitles:sure, nil];
        av.tag = 0;
        [av show];
    };
    cell.DowningCellCancelClick=^(FileListCell *cell)
    {
        NSString* title = @"是否删除";
        NSString* cancel = @"取消";
        NSString* sure = @"确定";
        if (SYSLanguage == EN) {
            title = [NSString stringWithFormat:@"Delete?"];
            cancel = @"Cancel";
            sure = @"OK";
        }
        UIAlertView* av = [[UIAlertView alloc]initWithTitle:title message:nil delegate:self cancelButtonTitle:cancel otherButtonTitles:sure, nil];
        av.tag = 1;
        self.downloadcell = cell;
        [av show];
        
//        [[DownloadManager sharedInstance]cancelDownload:cell.urlfilestring];
    };
    [cell downloadImage:cell.urlstring];
    [self updateCell:cell withDownItem:downItem];
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadNotification:) name:kDownloadManagerNotification object:nil];
    _downinglist=[NSMutableDictionary new];
    _finishedlist=[NSMutableDictionary new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(movieFinishedCallback)
     
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
     
                                               object:nil]; //播放完后的通知
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        
        self.navigationController.navigationBar.titleTextAttributes =[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    }   
    self.title = @"辅助";
    if (SYSLanguage == EN) {
        self.title = @"Documents";
    }
    self.FileListTableView.tableFooterView = [[UIView alloc] init];
    self.fileListArray = [[NSMutableArray alloc]init];
    [self getFileListArray];
}

- (void)viewWillDisappear:(BOOL)animated {


}





-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.leveyTabBarController hidesTabBar:NO animated:YES];
}



-(void)movieFinishedCallback
{
    [self.leveyTabBarController hidesTabBar:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    if ([self isViewLoaded] && [self.view window] == nil)
    {
        self.view = nil;
        self.fileListArray = nil;
    }

}


- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{
    //    NSInteger numToPreview = 0;
    //
    //	numToPreview = [self.dirArray count];
    //
    //    return numToPreview;
	return 1;
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller
{
    // if the preview dismissed (done button touched), use this method to post-process previews
}

// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
//	[previewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"click.png"] forBarMetrics:UIBarMetricsDefault];
    
    NSURL *fileURL = nil;
//    NSIndexPath *selectedIndexPath = [readTable indexPathForSelectedRow];
//	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *documentDir = [documentPaths objectAtIndex:0];
    
	fileURL = [NSURL fileURLWithPath:self.filepath];
    NSLog(@"file url:~~~~~~~ %@",fileURL);
    return fileURL;
}

#pragma mark - UIDocumentInteractionControllerDelegate

- (NSString *)applicationDocumentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return self;
}




@end
