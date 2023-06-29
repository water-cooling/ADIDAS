//
//  RemarkTableViewCell.h
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/3.
//

#import <UIKit/UIKit.h>
typedef void(^TextFieldValueChange)(NSString* _Nullable text);
NS_ASSUME_NONNULL_BEGIN

@interface RemarkTableViewCell : UITableViewCell<UITextViewDelegate>
@property (retain, nonatomic) IBOutlet UITextView *textView;
@property (retain, nonatomic) IBOutlet UILabel *placeHodleLab;
@property (nonatomic,copy)TextFieldValueChange textBlock;
@property (retain, nonatomic) IBOutlet UILabel *titleLab;

@end

NS_ASSUME_NONNULL_END
