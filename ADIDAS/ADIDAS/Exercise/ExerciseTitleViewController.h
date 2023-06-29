//
//  ExerciseTitleViewController.h
//  MobileApp
//
//  Created by 桂康 on 2021/4/27.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SelectExerciseTitleDelegate <NSObject>

- (void)currentTitle:(NSString *)title withIndex:(NSUInteger)index;

@end

@interface ExerciseTitleViewController : BaseViewController
{
    NSMutableArray *resultArray;
}
@property (strong, nonatomic) NSArray *dataSourceAry;
@property (assign, nonatomic) NSUInteger index;
@property (strong, nonatomic) NSString *oldString;
@property (assign, nonatomic) id<SelectExerciseTitleDelegate> delegate ;
@property (retain, nonatomic) IBOutlet UIView *filterView;
@property (retain, nonatomic) IBOutlet UITableView *filterTableView;


- (IBAction)cancelAction:(id)sender;
- (IBAction)sureAction:(id)sender;
- (IBAction)dismissView:(id)sender;

@end

NS_ASSUME_NONNULL_END
