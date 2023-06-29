//
//  DatePickerViewController.h
//  ADIDAS
//
//  Created by 桂康 on 2016/12/26.
//
//

#import "BaseViewController.h"

@protocol DatePickerDelegate <NSObject>

- (void)currentDate:(NSString *)date ;

@end

@interface DatePickerViewController : BaseViewController<UIPickerViewDelegate,UIPickerViewDataSource>

@property (assign, nonatomic) id<DatePickerDelegate> delegate ;
@property (retain, nonatomic) IBOutlet UIView *datePickView;
@property (retain, nonatomic) IBOutlet UIPickerView *datePicker;
@property (strong, nonatomic) NSArray *yearArray ;
@property (strong, nonatomic) NSArray *monthArray ;
@property (strong, nonatomic) NSArray *dayArray ;


- (IBAction)tabBGView:(id)sender;
- (IBAction)operateAction:(id)sender;


@end
