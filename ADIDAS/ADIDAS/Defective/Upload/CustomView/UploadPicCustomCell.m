//
//  UploadPicCustomCell.m
//  ADIDAS
//
//  Created by 桂康 on 2016/12/19.
//
//

#import "UploadPicCustomCell.h"
#import "CommonUtil.h"
#import "UIImageView+YYWebImage.h"
#import "GoodImageCustomCell.h"

@implementation UploadPicCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.ImageCollectView.delegate = self ;
    self.ImageCollectView.dataSource = self ;
}

- (void)setFoldName:(NSString *)foldName {
    
    _foldName = foldName ;

    if (self.webUrlArray && [self.webUrlArray count] && !self.foldName) {
        
        self.imageArray = [NSMutableArray arrayWithArray:self.webUrlArray] ;
    }
    else {
    
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        NSArray *fileList = [fileManager contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],foldName] error:nil];
        
        NSMutableArray *imageAry = [NSMutableArray array];
        
        if (self.webUrlArray && [self.webUrlArray count]) [imageAry addObjectsFromArray:self.webUrlArray] ;
        
        for (NSString *file in fileList) {
            
            if ([[file componentsSeparatedByString:@"_"] count] == 2 &&
                [[[file componentsSeparatedByString:@"."] lastObject] isEqualToString:@"jpg"]) {
                
                [imageAry addObject:[NSString stringWithFormat:@"%@/%@",foldName,file]] ;
            }
        }
        
        self.imageArray = [NSMutableArray arrayWithArray:imageAry];
    }
    
    [self.ImageCollectView reloadData];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if ([self.webUrlArray count] && !self.foldName) return  [self.webUrlArray count] ;
    
    if ([self.imageArray count] == 3) return 3 ;
    return 1 + [self.imageArray count] ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    [collectionView registerClass:[GoodImageCustomCell class] forCellWithReuseIdentifier:@"cell"];
    GoodImageCustomCell *cell = (GoodImageCustomCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if ([self.webUrlArray count] && !self.foldName) {
    
        cell.bgView.hidden = YES ;
        
        if (![[[self.webUrlArray objectAtIndex:indexPath.row] valueForKey:@"SmallPictureUrl"] isEqualToString:@""]) {
            
            [cell.goodImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kWebDefectiveHeadString,[[[self.webUrlArray objectAtIndex:indexPath.row] valueForKey:@"SmallPictureUrl"] substringFromIndex:1]]] placeholder:nil] ;
        }
        else if (![[[self.webUrlArray objectAtIndex:indexPath.row] valueForKey:@"PictureUrl"] isEqualToString:@""]) {
        
            [cell.goodImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kWebDefectiveHeadString,[[[self.webUrlArray objectAtIndex:indexPath.row] valueForKey:@"PictureUrl"] substringFromIndex:1]]] placeholder:nil] ;
        }
        
        return cell ;
    }
    
    cell.bgView.hidden = !(indexPath.row == [self.imageArray count]) ;
    
    if ([self.imageArray count] > indexPath.row) {
        
        id oj = [self.imageArray objectAtIndex:indexPath.row];
        
        if ([oj isKindOfClass:[NSString class]]) {
        
            UIImage *few = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],[self.imageArray objectAtIndex:indexPath.row]]] ;
            
            cell.goodImageView.image = few ;
        }
        
        if ([oj isKindOfClass:[NSDictionary class]]) {
            
            if (![[[self.imageArray objectAtIndex:indexPath.row] valueForKey:@"SmallPictureUrl"] isEqualToString:@""]) {
                
                [cell.goodImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kWebDefectiveHeadString,[[[self.imageArray objectAtIndex:indexPath.row] valueForKey:@"SmallPictureUrl"] substringFromIndex:1]]] placeholder:nil] ;
            }
            else if (![[[self.imageArray objectAtIndex:indexPath.row] valueForKey:@"PictureUrl"] isEqualToString:@""]) {
                
                [cell.goodImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kWebDefectiveHeadString,[[[self.imageArray objectAtIndex:indexPath.row] valueForKey:@"PictureUrl"] substringFromIndex:1]]] placeholder:nil] ;
            }
        }
        
    }
    else cell.goodImageView.image = nil ;
    
    return cell ;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(90.0/320*PHONE_WIDTH,90.0/320*PHONE_WIDTH>117?117:90.0/320*PHONE_WIDTH) ;
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 0, 0, 0) ;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return (PHONE_WIDTH - 30 - (90.0/320*PHONE_WIDTH*3))/2 ;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0 ;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.webUrlArray count] && !self.foldName) {
    
        ImageDetailViewController *controller = [[ImageDetailViewController alloc] initWithNibName:@"ImageDetailViewController" bundle:nil];
        controller.infoDic = [self.webUrlArray objectAtIndex:indexPath.row] ;
        controller.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.vc presentViewController:controller animated:NO completion:nil];
        
        return ;
    }
    
    if (indexPath.row == [self.imageArray count]) {
        
        if (self.foldName) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init]  ;
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera ;
            picker.navigationBar.backgroundColor = [CommonUtil colorWithHexString:@"#1a1b1f"];
            picker.navigationBar.barTintColor = [CommonUtil colorWithHexString:@"#1a1b1f"];
            [picker.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
            [picker.navigationBar setTintColor:[UIColor whiteColor]];
            picker.modalPresentationStyle = UIModalPresentationFullScreen;
            [self.vc presentViewController:picker animated:YES completion:^{}];
        }
        else [self.vc showAlertWithDispear:@"生成文件夹错误,请返回重试!"];
    }
    else {
        
        ImageDetailViewController *controller = [[ImageDetailViewController alloc] initWithNibName:@"ImageDetailViewController" bundle:nil];
        
        controller.DeleteDelegate = self ;
        
        controller.index = indexPath.row ;
        
        id oj = [self.imageArray objectAtIndex:indexPath.row];
        
        if ([oj isKindOfClass:[NSString class]]) {
            
            controller.imageData = [self.imageArray objectAtIndex:indexPath.row] ;
        }
        
        if ([oj isKindOfClass:[NSDictionary class]]) {
        
            controller.imageData = [[self.imageArray objectAtIndex:indexPath.row] valueForKey:@"PictureUrl"] ;
        }
        controller.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.vc presentViewController:controller animated:NO completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [self.vc ShowSVProgressHUD];
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage] ;
    
    UIImageOrientation imageOrientation = image.imageOrientation;
    
    if(imageOrientation != UIImageOrientationUp) {
       
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    
    CGSize size = CGSizeMake(133, 100);
    if(image.size.width < image.size.height) size = CGSizeMake(100, 133);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSString *imageName = [NSUUID UUID].UUIDString ;
    
    NSString *picPath = [NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],self.foldName] ;
    
    NSFileManager* fileMannager = [NSFileManager defaultManager];
    
    if(![fileMannager fileExistsAtPath:picPath])
    {
        [fileMannager createDirectoryAtPath:picPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    
        BOOL res = [UIImageJPEGRepresentation(image, 0.4) writeToFile:[NSString stringWithFormat:@"%@/%@.jpg",picPath,imageName] atomically:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.vc DismissSVProgressHUD];
            
            if (res) {
                
                [self.imageArray addObject:[NSString stringWithFormat:@"%@/%@_s.jpg",self.foldName,imageName]];
                [UIImagePNGRepresentation(reSizeImage) writeToFile:[NSString stringWithFormat:@"%@/%@_s.jpg",picPath,imageName] atomically:YES];
                
                [self.ImageCollectView reloadData];
            }
            else {
                
                [self.vc showAlertWithDispear:@"图片保存失败!"];
                
                if([fileMannager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@_s.jpg",picPath,imageName]]) {
                    
                    [fileMannager removeItemAtPath:[NSString stringWithFormat:@"%@/%@_s.jpg",picPath,imageName] error:nil];
                }
            }
        });
    });
}


- (void)DeleteSelectImageWith:(NSInteger)index {
    
    if ([[self.imageArray objectAtIndex:index] isKindOfClass:[NSString class]]) {
        
        NSFileManager* fileMannager = [NSFileManager defaultManager];
        
        if([fileMannager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],[self.imageArray objectAtIndex:index]]]) {
            
            [fileMannager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",[CommonUtil SysDocumentPath],[self.imageArray objectAtIndex:index]] error:nil];
        }
        
        if([fileMannager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.jpg",[CommonUtil SysDocumentPath],[[[self.imageArray objectAtIndex:index] componentsSeparatedByString:@"_"] firstObject]]]) {
            
            [fileMannager removeItemAtPath:[NSString stringWithFormat:@"%@/%@.jpg",[CommonUtil SysDocumentPath],[[[self.imageArray objectAtIndex:index] componentsSeparatedByString:@"_"] firstObject]] error:nil];
        }
    }

    [self.imageArray removeObjectAtIndex:index] ;
    
    [self.ImageCollectView reloadData];
}



@end

















