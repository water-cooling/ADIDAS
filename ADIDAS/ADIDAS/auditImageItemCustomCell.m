//
//  auditImageItemCustomCell.m
//  MobileApp
//
//  Created by 桂康 on 2021/3/24.
//

#import "auditImageItemCustomCell.h"
#import "CommonUtil.h"

@implementation auditImageItemCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.remindLabel.text = SYSLanguage?@"Please add picture comment":@"请添加图片描述";
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"auditImageItemCustomCell" owner:self options:nil];
        
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
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
        self.layer.borderColor = [[CommonUtil colorWithHexString:@"#d4d5d6"] CGColor];
        self.layer.borderWidth = 1 ;
    }
    return self;
}


- (IBAction)leftAction:(id)sender {
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(detailImage:)]) {
        [self.delegate detailImage:self.index];
    }
}

- (IBAction)rightAction:(id)sender {
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(deleteImage:)]) {
        [self.delegate deleteImage:self.index];
    }
}

- (IBAction)middleAction:(id)sender {
    
    if (self.delegate&&[self.delegate respondsToSelector:@selector(commentImage:)]) {
        [self.delegate commentImage:self.index];
    }
}

@end
