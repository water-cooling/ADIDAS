//
//  SyncDataViewController.h
//  ADIDAS
//
//  Created by testing on 3/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SyncParaVersionEntity.h"
#import "IssueManagement.h"

@interface SyncDataViewController : UIViewController<IssueManagementDelegate>
{
    NSMutableArray *syncVersions;
    IssueManagement *_management;
    SyncParaVersionEntity *currSyncData;
    NSInteger tableCount;
    float amountDone;
    UIProgressView * _progressView;
    UILabel * _progressText;
}

@property (nonatomic,retain) NSMutableArray *syncVersions;

@end
