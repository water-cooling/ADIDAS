//
//  DateListViewController.h
//  MobileApp
//
//  Created by 桂康 on 2017/11/2.
//

#import <UIKit/UIKit.h>
#import "JTCalendar.h"

@interface DateListViewController : UIViewController<JTCalendarDelegate>
{
    NSArray *returndDataArray ;
}
@property (weak, nonatomic) IBOutlet UILabel *titleTimeLabel;
@property (strong, nonatomic) JTCalendarManager *calendarManager;
@property (weak, nonatomic) IBOutlet JTHorizontalCalendarView *CalendarView;
@property (weak, nonatomic) IBOutlet UIView *canlendarBGView;


- (IBAction)selectMonthAction:(id)sender;

@end
