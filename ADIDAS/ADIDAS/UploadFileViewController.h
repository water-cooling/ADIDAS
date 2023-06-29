//
//  UploadFileViewController.h
//  VM
//
//  Created by leo.you on 14-8-7.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UploadFileViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    dispatch_queue_t _serialQueue;
}

@property (weak,nonatomic) IBOutlet UITableView* UploadFileTableview;
@property (strong,nonatomic) NSMutableArray* uploadFileArr;

@property (strong,nonatomic) NSMutableArray* rail_checkArr;
@property (strong,nonatomic) NSString* RailCheck_XML;
@property (strong,nonatomic) NSMutableArray* resultPicNameArr;

@property (weak,nonatomic) IBOutlet UIProgressView* bottomProgressView;


@property (assign)  __block float uploadedNum;
@property (assign) float allFileNum;


@end
