//
//  ApplyListTableViewCell.h
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ApplyListTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *orderNumerLab;
@property (retain, nonatomic) IBOutlet UILabel *orderTimeLab;
@property (retain, nonatomic) IBOutlet UILabel *orderStatusLab;

@end

NS_ASSUME_NONNULL_END
