//
//  UploadPicCustomCell.m
//  ADIDAS
//
//  Created by 桂康 on 2016/12/19.
//
//

#import "ApplyPicTableViewCell.h"
#import "CommonUtil.h"
#import "UIImageView+YYWebImage.h"
#import "GoodImageCustomCell.h"
#import "CommonDefine.h"

@implementation ApplyPicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.collectionView registerClass:[GoodImageCustomCell class] forCellWithReuseIdentifier:@"cell"];

    self.collectionView.delegate = self ;
    self.collectionView.dataSource = self ;
}

- (void)setImageArray:(NSMutableArray *)imageArray{
    if (imageArray) {
        _imageArray = imageArray;
        [self.collectionView reloadData];
    }
}
- (void)setWebUrlArray:(NSArray *)webUrlArray{
    if (webUrlArray) {
        _webUrlArray = webUrlArray;
        [self.collectionView reloadData];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.imageArray) {
        if ([self.imageArray count] == 2) return 2 ;
        
        return 1 + [self.imageArray count] ;
        
    }else{
        if(self.webUrlArray){
            return self.webUrlArray.count;
        }else{
            return 1;
        }
        
    }
   
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodImageCustomCell *cell = (GoodImageCustomCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    if (self.webUrlArray) {
        cell.bgView.hidden = YES;
        id data =[self.webUrlArray objectAtIndex:indexPath.row];
        if ([data isKindOfClass:[NSDictionary class]]) {
            [cell.goodImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kWebDefectiveHeadString,[[[self.webUrlArray objectAtIndex:indexPath.row] valueForKey:@"PictureUrl"] substringFromIndex:1]]] placeholder:nil] ;
            }
    }else{
        
        if (self.imageArray) {
            cell.bgView.hidden = NO;
            if (indexPath.row < self.imageArray.count) {
                UIImage *few = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],[self.imageArray objectAtIndex:indexPath.row]]] ;
                cell.goodImageView.image = few ;
            }else{
                cell.bgView.hidden = YES;
                cell.goodImageView.image = [UIImage imageNamed:@"icon_shopping_addaddress"];
                
            }
        }else{
            cell.bgView.hidden = YES;
            cell.goodImageView.image = [UIImage imageNamed:@"icon_shopping_addaddress"];
        }
        
        
    }

    
    return cell ;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (PHONE_WIDTH-60)/4;
    return CGSizeMake(width,width) ;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0) ;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 10;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0 ;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.imageArray) {
        if (indexPath.row < self.imageArray.count) {
            if (self.bigBlock) {
                self.bigBlock(indexPath.row);
            }
        }else{
            if (self.pickBlock) {
                self.pickBlock();
            }
            
        }
    }
    
    
    if (self.webUrlArray) {
        if (self.bigBlock) {
            self.bigBlock(indexPath.row);
        }
    }
}


@end

















