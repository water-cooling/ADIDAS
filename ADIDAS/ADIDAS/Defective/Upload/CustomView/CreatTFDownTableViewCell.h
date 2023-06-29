//
//  CreatTFDownTableViewCell.h
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/3.
//

#import <UIKit/UIKit.h>
#import "CreatTableModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^TextFieldValueChange)(NSString* _Nullable text);

@interface CreatTFDownTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UILabel *leftLabel;
@property (retain, nonatomic) IBOutlet UITextField *inputTextView;
@property (nonatomic,copy)TextFieldValueChange textBlock;
@property (nonatomic,weak) CreatTableModel *creatTableModel;
@property (nonatomic,copy)dispatch_block_t block;
@property (nonatomic,weak) NSMutableDictionary *dict;

@end

NS_ASSUME_NONNULL_END
