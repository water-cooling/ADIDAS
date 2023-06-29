//
//  TextFieldTableViewCell.h
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/1.
//

#import <UIKit/UIKit.h>
#import "CreatTableModel.h"
typedef void(^TextFieldValueChange)(NSString* _Nullable text);
NS_ASSUME_NONNULL_BEGIN

@interface TextFieldTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UILabel *leftLabel;
@property (retain, nonatomic) IBOutlet UITextField *inputTextView;
@property (nonatomic,copy)TextFieldValueChange textBlock;
@property (nonatomic,weak) CreatTableModel *creatTableModel;
@property (nonatomic,weak) NSMutableDictionary *dict;

@end

NS_ASSUME_NONNULL_END
