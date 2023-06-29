//
//  AssistViewController.h
//  VM
//
//  Created by wendy on 14-7-16.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASINetworkQueue.h"
#import "FileListCell.h"
#import <QuickLook/QuickLook.h>


@interface AssistViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ASIHTTPRequestDelegate,UIAlertViewDelegate,QLPreviewControllerDataSource,QLPreviewControllerDelegate,UIDocumentInteractionControllerDelegate>
{
    
    NSArray *musicPathArray ;
}

@property (weak,nonatomic) IBOutlet UITableView* FileListTableView;

@property (weak,nonatomic) IBOutlet UILabel* label;

@property (strong,nonatomic) NSMutableArray* fileListArray;

@property (strong,nonatomic) FileListCell* downloadcell;

@property (strong,nonatomic) NSString* filepath;







@end
