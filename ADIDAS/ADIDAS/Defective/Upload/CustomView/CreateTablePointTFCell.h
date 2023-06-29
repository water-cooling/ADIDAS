//
//  CreateTablePoinTFCell.h
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/3.
//

#import <UIKit/UIKit.h>
#import "CreatTableModel.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^TextFieldValueChange)(NSString* _Nullable text);

@interface CreateTablePointTFCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *titleLab;
@property (retain, nonatomic) IBOutlet UITextField *inputTextfield;
@property (nonatomic,copy)dispatch_block_t pointBlock;
@property (nonatomic,copy)TextFieldValueChange textBlock;
@property (nonatomic,weak) CreatTableModel *creatTableModel;
@property (nonatomic,weak) NSMutableDictionary *dict;

@end

NS_ASSUME_NONNULL_END
