//
//  IssueTrackingViewController.h
//  MobileApp
//
//  Created by 桂康 on 2020/12/2.
//

#import <UIKit/UIKit.h>
#import "UploadManagement.h"

NS_ASSUME_NONNULL_BEGIN

@interface IssueTrackingViewController : UIViewController<UploadManagementDelegate>
{
    NSMutableArray *viewArrays ;
    NSArray *dataSourceArray ;
    NSMutableDictionary *statusDic ;
}

@property (strong,nonatomic) UploadManagement* uploadManage;
@property (strong, nonatomic) NSString *trackingCheckId ;
@property (retain, nonatomic) IBOutlet UIView *bgView;
@property (retain, nonatomic) IBOutlet UIView *imageBGView;
@property (retain, nonatomic) IBOutlet UIImageView *detailImageView;
@property (retain, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (retain, nonatomic) IBOutlet UIPageControl *bottomPageControl;

- (IBAction)cancelAction:(id)sender;
- (IBAction)submitAction:(id)sender;
- (IBAction)disappearView:(id)sender;


@end

NS_ASSUME_NONNULL_END
