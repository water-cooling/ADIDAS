//
//  GoodImageCustomCell.m
//  ADIDAS
//
//  Created by 桂康 on 2016/12/19.
//
//

#import "GoodImageCustomCell.h"
#import "CommonUtil.h"


@implementation GoodImageCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"GoodImageCustomCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
        
        self.bgView.layer.borderColor = [[CommonUtil colorWithHexString:@"#d4d5d6"] CGColor];
        self.bgView.layer.borderWidth = 1 ;
       
    }
    return self;
}



@end
