//
//  CreatTableModel.h
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CreateTableCellType) {
    CreateTableTFCell,//单纯输入框
    CreateTableDownCell,//只能选择
    CreateTableTFDownCell,//选择又能输入
    CreateTablePointDownCell,//带说明的选择又能输入
    CreateTablePoinTFCell,//带说明的输入
    CreateTablePicCell,
    CreateTableReMarkCell,
    CreateTableTitleShowCell,//货单
    CreateTableReMarkArticleNoCell,//货单

};

@interface CreatTableModel : NSObject
// 名称
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *pointTitle;
@property (nonatomic, copy)NSString *pointDesTitle;

@property (nonatomic, copy)NSString *placeholder;
// 表单对应的字段
@property (nonatomic, copy)NSString *key;
// 表单对应的value

@property (nonatomic, copy)NSString *value;
//是否是数字键盘
@property (nonatomic, assign)BOOL isNumerKeyBoard;

//cell图片
@property (nonatomic,copy) NSString *imageName;
// cell的类型
@property (nonatomic, assign)CreateTableCellType cellType;
@property (nonatomic,assign) BOOL textFieldShowBtn;
@end


NS_ASSUME_NONNULL_END
