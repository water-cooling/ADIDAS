//
//  ArticleNoTableViewCell.h
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/4.
//

#import <UIKit/UIKit.h>
#import "CreatTableModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ArticleNoTableViewCell : UITableViewCell
@property (nonatomic,weak) CreatTableModel *creatTableModel;
@property (retain, nonatomic) IBOutlet UILabel *rightLab;
@property (retain, nonatomic) IBOutlet UILabel *leftLab;
@property (nonatomic,copy)dispatch_block_t block;

@end

NS_ASSUME_NONNULL_END
