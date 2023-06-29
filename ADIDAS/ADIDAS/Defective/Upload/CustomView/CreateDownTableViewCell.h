//
//  CreateDownTableViewCell.h
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/1.
//

#import <UIKit/UIKit.h>
#import "CreatTableModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateDownTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UILabel *leftLabel;
@property (retain, nonatomic) IBOutlet UITextField *inputTextView;
@property (nonatomic,copy)dispatch_block_t block;
@property (nonatomic,weak) CreatTableModel *creatTableModel;
@property (nonatomic,weak) NSMutableDictionary *dict;

@end

NS_ASSUME_NONNULL_END
