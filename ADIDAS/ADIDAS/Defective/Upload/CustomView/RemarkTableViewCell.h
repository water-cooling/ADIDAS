//
//  RemarkTableViewCell.h
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/3.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface RemarkTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *textView;
@property (nonatomic,copy)TextFieldValueChange textBlock;
@property (retain, nonatomic) IBOutlet UILabel *titleLab;

@end

NS_ASSUME_NONNULL_END
