//
//  ExerciseCustomCell.h
//  MobileApp
//
//  Created by 桂康 on 2019/9/18.
//

#import <UIKit/UIKit.h>
#import "WBGImageEditor.h"
#import "ImageDetailViewController.h"
#import "ExerciseStudentCustomCell.h"
#import "ExerciseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExerciseCustomCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,WBGImageEditorDelegate,WBGImageEditorDataSource,DeleteSelectImageDelegate,UITableViewDelegate,UITableViewDataSource,ExerciseStudentDelegate>


@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
@property (retain, nonatomic) IBOutlet UITextField *valueTextField;
@property (retain, nonatomic) IBOutlet UIView *shortView;
@property (retain, nonatomic) IBOutlet UIView *tallView;
@property (retain, nonatomic) IBOutlet UILabel *secTitleLabel;
@property (retain, nonatomic) IBOutlet UITextView *valueTextView;
@property (retain, nonatomic) IBOutlet UILabel *holderLabel;
@property (retain, nonatomic) IBOutlet UIView *picView;
@property (retain, nonatomic) IBOutlet UILabel *picTitleLabel;
@property (retain, nonatomic) IBOutlet UICollectionView *picCollectView;
@property (strong, nonatomic) NSMutableArray *imageArray;
@property (strong, nonatomic) NSMutableArray *saveArray ;
@property (strong, nonatomic) ExerciseViewController *vc ;
@property (strong, nonatomic) NSString *checkId ;
@property (assign, nonatomic) NSInteger currentIndex ;
@property (strong, nonatomic) NSMutableArray *dataArray ;
@property (retain, nonatomic) IBOutlet UITableView *studentTableView;

@end

NS_ASSUME_NONNULL_END
