//
//  ExerciseViewController.h
//  MobileApp
//
//  Created by 桂康 on 2019/9/17.
//

#import <UIKit/UIKit.h>
#import "UploadManagement.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExerciseViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UploadManagementDelegate>
{
    NSMutableArray *keyboardArray ;
    NSMutableArray *studentArray ;
    NSMutableArray *pointArray ;
}

@property (strong,nonatomic) UploadManagement* uploadManage;
@property (strong,nonatomic) UITableView* ExerciseTableView;
@property (strong,nonatomic) UIView* waitView;
@property (strong, nonatomic) NSMutableArray *dataSourceArray ;
@property (strong, nonatomic) NSMutableArray *resultSourceArray ;
@property (strong, nonatomic) NSMutableArray *photoSourceArray ;

- (void)resetImage:(NSMutableArray *)image with:(NSString *)type;

@end

NS_ASSUME_NONNULL_END
