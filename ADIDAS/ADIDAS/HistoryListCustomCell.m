//
//  HistoryListCustomCell.m
//  ADIDAS
//
//  Created by joinone on 15/1/26.
//
//

#import "HistoryListCustomCell.h"
#import "Utilities.h"

@implementation HistoryListCustomCell

- (void)awakeFromNib {
    // Initialization code
    
    self.CheckInLabel.text = SYSLanguage?@"check in :":@"签入时间:" ;
    self.StoreAddressLabel.textColor = [Utilities colorWithHexString:@"#565656"];
    self.StoreNameLabel.textColor = [Utilities colorWithHexString:@"#565656"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_CheckinTimeLabel release];
    [_StoreNameLabel release];
    [_StoreAddressLabel release];
    [_CheckInLabel release];
    [super dealloc];
}
@end
