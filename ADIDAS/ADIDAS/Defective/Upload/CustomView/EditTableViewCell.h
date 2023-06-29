//
//  EditTableViewCell.h
//  ADIDAS
//
//  Created by 桂康 on 2016/12/19.
//
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol LongPressDelegate <NSObject>

- (void)longPressTap:(NSString *)text withLeftTitle:(NSString *)left;

@end

@interface EditTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UILabel *leftLabel;
@property (retain, nonatomic) IBOutlet UITextField *rightTextField;

@property (strong, nonatomic) NSString *valueType ;
@property (retain, nonatomic) IBOutlet UISwitch *selectWitch;
@property (retain, nonatomic) IBOutlet UIView *reginView;
@property (retain, nonatomic) IBOutlet UITextField *regionTextField;
@property (retain, nonatomic) IBOutlet UITextField *phoneTextField;
@property (retain, nonatomic) IBOutlet UILabel *rightLabel;
@property (assign, nonatomic) id<LongPressDelegate> delegate ;
- (IBAction)longPressLabelAction:(UILongPressGestureRecognizer *)sender;

@end
