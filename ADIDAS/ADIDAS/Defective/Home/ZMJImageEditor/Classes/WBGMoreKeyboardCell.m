//
//  WBGMoreKeyboardCell.m
//  WBGKeyboards
//
//  Created by Jason on 2016/10/24.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "WBGMoreKeyboardCell.h"
#import "UIColor+TLChat.h"
#import "Masonry.h"

@interface WBGMoreKeyboardCell ()

@property (nonatomic, strong) UIButton *iconButton;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation WBGMoreKeyboardCell

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.iconButton];
        [self.contentView addSubview:self.titleLabel];
        [self p_addMasonry];
    }
    return self;
}

- (void)setItem:(WBGMoreKeyboardItem *)item
{
    _item = item;
    if (item == nil) {
        [self.titleLabel setHidden:YES];
        [self.iconButton setHidden:YES];
        [self setUserInteractionEnabled:NO];
        return;
    }
    [self setUserInteractionEnabled:YES];
    [self.titleLabel setHidden:NO];
    [self.iconButton setHidden:NO];
    [self.titleLabel setText:item.title];
    [self.iconButton setImage:item.image ?: [UIImage imageNamed:item.imagePath] forState:UIControlStateNormal];
}

#pragma mark - Event Response -
- (void)iconButtonDown:(UIButton *)sender
{
    self.clickBlock(self.item);
}

#pragma mark - Private Methods -
- (void)p_addMasonry
{
    [self.iconButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView);
        make.centerX.mas_equalTo(self.contentView);
        make.width.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.iconButton.mas_width);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView).mas_offset(-10);
    }];
}

#pragma mark - Getter -
- (UIButton *)iconButton
{
    if (_iconButton == nil) {
        _iconButton = [[UIButton alloc] init];
        [_iconButton.layer setMasksToBounds:YES];
//        [_iconButton.layer setCornerRadius:5.0f];
//        [_iconButton.layer setBorderWidth:BORDER_WIDTH_1PX];
//        [_iconButton.layer setBorderColor:[UIColor grayColor].CGColor];
//        [_iconButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorGrayLine]] forState:UIControlStateHighlighted];
        [_iconButton addTarget:self action:@selector(iconButtonDown:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _iconButton;
}

- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_titleLabel setTextColor:[UIColor grayColor]];
    }
    return _titleLabel;
}


@end
