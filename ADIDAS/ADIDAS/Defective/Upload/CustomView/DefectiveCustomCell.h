//
//  DefectiveCustomCell.h
//  ADIDAS
//
//  Created by 桂康 on 2016/12/19.
//
//

#import <UIKit/UIKit.h>

@interface DefectiveCustomCell : UITableViewCell <UITextViewDelegate>

@property (retain, nonatomic) IBOutlet UITextView *defectiveTextView;
@property (retain, nonatomic) IBOutlet UILabel *placeHoladLabel;


@end
