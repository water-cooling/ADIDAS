//
//  DateTimeViewController.h
//  MobileApp
//
//  Created by 桂康 on 2019/10/30.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DateTimePickerDelegate <NSObject>

- (void)currentDate:(NSString *)date withIndex:(NSUInteger)index;

@end

@interface DateTimeViewController : BaseViewController

@property (assign, nonatomic) NSUInteger index;
@property (assign, nonatomic) id<DateTimePickerDelegate> delegate ;
@property (retain, nonatomic) IBOutlet UIView *datePickView;
@property (retain, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (assign, nonatomic) BOOL showComptelteMonth ;
- (IBAction)tabBGView:(id)sender;
- (IBAction)operateAction:(id)sender;

@end

NS_ASSUME_NONNULL_END
