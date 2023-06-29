//
//  ScoreCardAfterViewController.h
//  MobileApp
//
//  Created by 桂康 on 2017/12/7.
//

#import <UIKit/UIKit.h>
#import "EditPicViewController.h"


@interface ScoreCardAfterViewController : UIViewController<UIImagePickerControllerDelegate,
UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,selectPicDelegate>

@property (strong, nonatomic) NSArray *dataSourceArray ;
@property (strong, nonatomic) NSArray *checkPhotoIdArray ;
@property (retain, nonatomic) IBOutlet UITableView *AfterTableView;
@property (assign, nonatomic) NSInteger currentSelectIndex;
@property (strong, nonatomic) NSString *currentSelectType ;
@property (strong,nonatomic) UIImagePickerController* photoPicker;
@property (strong, nonatomic) NSString *commentDate ;
@property (retain, nonatomic) IBOutlet UIView *ImageBGView;
@property (retain, nonatomic) IBOutlet UIImageView *bigImage;
@end
