//
//  WBGMoreKeyboard+CollectionView.m
//  WBGKeyboards
//
//  Created by Jason on 2016/10/24.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import "WBGMoreKeyboard+CollectionView.h"
#import "WBGMoreKeyboardCell.h"
#import "YYCategories.h"
#import "Masonry.h"

#define     SPACE_TOP        15
#define     WIDTH_CELL       60
#define     EDGE_TOP        (SPACE_TOP-10)

@implementation WBGMoreKeyboard (CollectionView)

#pragma mark - Public Methods -
- (void)registerCellClass
{
    [self.collectionView registerClass:[WBGMoreKeyboardCell class] forCellWithReuseIdentifier:@"WBGMoreKeyboardCell"];
}

#pragma mark - Delegate -
//MARK: UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.chatMoreKeyboardData.count / self.pageItemCount + (self.chatMoreKeyboardData.count % self.pageItemCount == 0 ? 0 : 1);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.pageItemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WBGMoreKeyboardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WBGMoreKeyboardCell" forIndexPath:indexPath];
    NSUInteger index = indexPath.section * self.pageItemCount + indexPath.row;
    NSUInteger tIndex = [self p_transformIndex:index];  // 矩阵坐标转置
    if (tIndex >= self.chatMoreKeyboardData.count) {
        [cell setItem:nil];
    }
    else {
        [cell setItem:self.chatMoreKeyboardData[tIndex]];
    }
    __weak typeof(self) weakSelf = self;
    [cell setClickBlock:^(WBGMoreKeyboardItem *sItem) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(moreKeyboard:didSelectedFunctionItem:)]) {
            [weakSelf.delegate moreKeyboard:weakSelf didSelectedFunctionItem:sItem];
        }
    }];
    return cell;
}

//MARK: UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(WIDTH_CELL, (collectionView.height - SPACE_TOP) / 2 * 0.93);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return (collectionView.width - WIDTH_CELL * self.pageItemCount / 2) / (self.pageItemCount / 2 + 1);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return (collectionView.height - SPACE_TOP) / 2 * 0.07;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CGFloat space = (collectionView.width - WIDTH_CELL * self.pageItemCount / 2) / (self.pageItemCount / 2 + 1);
    return UIEdgeInsetsMake(EDGE_TOP*2, space, EDGE_TOP*2, space);
}
//Mark: UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.pageControl setCurrentPage:(int)(scrollView.contentOffset.x / scrollView.width)];
}

#pragma mark - Private Methods -
- (NSUInteger)p_transformIndex:(NSUInteger)index
{
    NSUInteger page = index / self.pageItemCount;
    index = index % self.pageItemCount;
    NSUInteger x = index / 2;
    NSUInteger y = index % 2;
    return self.pageItemCount / 2 * y + x + page * self.pageItemCount;
}

#pragma mark - # Getter
- (NSInteger)pageItemCount
{
    return (int)(WIDTH_SCREEN / (WIDTH_CELL * 1.3)) * 2;
}

@end
