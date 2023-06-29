//
//  DetailTitleTableViewCell.h
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/4.
//

#import <UIKit/UIKit.h>
#import "CreatTableModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DetailTitleTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *titleLab;
@property (retain, nonatomic) IBOutlet UILabel *DesTitleLab;
@property (nonatomic,weak) CreatTableModel *creatTableModel;
@property (nonatomic,weak) NSDictionary *dict;

@end

NS_ASSUME_NONNULL_END
