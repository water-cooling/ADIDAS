//
//  FileListCell.h
//  VM
//
//  Created by wendy on 14-7-16.
//  Copyright (c) 2014年 com.joinonesoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface FileListCell : UITableViewCell<ASIProgressDelegate>

@property (weak,nonatomic) IBOutlet UILabel* sizelabel;
@property (weak, nonatomic) IBOutlet UILabel *lblPercent;
@property (weak,nonatomic) IBOutlet UILabel* fileNameLabel;
@property (weak,nonatomic) IBOutlet UILabel* fileSizeLabel;
@property (weak, nonatomic) IBOutlet UIButton *btnOperate;
@property (weak,nonatomic) IBOutlet UIButton* deleteButton;
@property (weak,nonatomic) IBOutlet UIImageView* fileImage;
@property (strong,nonatomic) NSString* urlstring;
@property (strong,nonatomic) NSString* urlfilestring;

@property (weak,nonatomic) IBOutlet UIProgressView* downloadProgress;
@property(nonatomic,copy)void(^DowningCellOperateClick)(FileListCell *cell);
@property(nonatomic,copy)void(^DowningCellCancelClick)(FileListCell *cell);

-(void)downloadImage:(NSString*)string;

- (IBAction)operateClick:(id)sender;
- (IBAction)cancelClick:(id)sender;


@end
