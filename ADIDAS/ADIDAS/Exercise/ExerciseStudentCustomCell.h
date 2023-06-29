//
//  ExerciseStudentCustomCell.h
//  MobileApp
//
//  Created by 桂康 on 2019/10/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ExerciseStudentDelegate <NSObject>

- (void)deleteStucent:(NSInteger)index ;

@end

@interface ExerciseStudentCustomCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *leftTitleLabel;
@property (retain, nonatomic) IBOutlet UIButton *deleteButton;
@property (retain, nonatomic) IBOutlet UITextField *rightTextField;
- (IBAction)deleteAction:(id)sender;
@property (assign, nonatomic) id<ExerciseStudentDelegate> delegate ;


@end

NS_ASSUME_NONNULL_END
