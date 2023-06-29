//
//  ExerciseCustomCell.m
//  MobileApp
//
//  Created by 桂康 on 2019/9/18.
//

#import "ExerciseCustomCell.h"
#import "CommonUtil.h"
#import "GoodImageCustomCell.h"
#import "Utilities.h"
#import "CommonDefine.h"
#import "NVMTrainingCheckPhotoEntity.h"
#import "ExerciseViewController.h"


@implementation ExerciseCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageArray = [NSMutableArray array];
    self.picCollectView.delegate = self ;
    self.picCollectView.dataSource = self ;
    self.valueTextField.delegate = self ;
    self.valueTextView.delegate = self ;
    self.studentTableView.delegate = self ;
    self.studentTableView.dataSource = self ;
}

- (void)setImageArray:(NSMutableArray *)imageArray{
    
    _imageArray = imageArray;
    [self.picCollectView reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.imageArray count] == 4) return 4 ;
    if ([self.imageArray count] < 2) return 2 ;
    return 1 + [self.imageArray count] ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView registerClass:[GoodImageCustomCell class] forCellWithReuseIdentifier:@"cell"];
    GoodImageCustomCell *cell = (GoodImageCustomCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.bgView.hidden = (4 == [self.imageArray count]) ;
    
    if ([self.imageArray count] > indexPath.row) {
        cell.bgView.hidden = YES;
        NVMTrainingCheckPhotoEntity *oj = [self.imageArray objectAtIndex:indexPath.row];
        
        UIImage *few = [[UIImage alloc] initWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[Utilities SysDocumentPath],[oj.PHOTO_PATH stringByReplacingOccurrencesOfString:@".jpg" withString:@"_s.jpg"]]] ;
        
        cell.goodImageView.image = few ;
        
        cell.goodImageView.layer.borderColor = [[CommonUtil colorWithHexString:@"#d4d5d6"] CGColor];
        
        cell.goodImageView.layer.borderWidth = 1 ;
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
        longPressGesture.minimumPressDuration = 1.0f;
        [cell addGestureRecognizer:longPressGesture];
    }
    else {
        cell.goodImageView.image = nil ;
    }
    
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
    
    self.currentIndex = indexPath.row ;

    if ([self.picTitleLabel.text containsString:@"课堂"] || [self.picTitleLabel.text containsString:@"实操"]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init]  ;
        picker.delegate = self;
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        picker.sourceType = sourceType ;
        picker.navigationBar.backgroundColor = [CommonUtil colorWithHexString:@"#1a1b1f"];
        picker.navigationBar.barTintColor = [CommonUtil colorWithHexString:@"#1a1b1f"];
        [picker.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
        [picker.navigationBar setTintColor:[UIColor whiteColor]];
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.vc presentViewController:picker animated:YES completion:^{}];
    }
    
    if ([self.picTitleLabel.text containsString:@"远程"]) {
        
        UIAlertController *controller = [UIAlertController alertControllerWithTitle:SYSLanguage?@"Please Select Photo Type":@"请选择照片类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet] ;
        
        UIAlertAction *ok1 = [UIAlertAction actionWithTitle:SYSLanguage?@"Album":@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init]  ;
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary ;
            picker.navigationBar.backgroundColor = [CommonUtil colorWithHexString:@"#1a1b1f"];
            picker.navigationBar.barTintColor = [CommonUtil colorWithHexString:@"#1a1b1f"];
            [picker.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
            [picker.navigationBar setTintColor:[UIColor whiteColor]];
            picker.modalPresentationStyle = UIModalPresentationFullScreen;
            [self.vc presentViewController:picker animated:YES completion:^{}];
        }];
        
        UIAlertAction *ok2 = [UIAlertAction actionWithTitle:SYSLanguage?@"Camera":@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init]  ;
            picker.delegate = self;
            UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
            if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
            picker.sourceType = sourceType ;
            picker.navigationBar.backgroundColor = [CommonUtil colorWithHexString:@"#1a1b1f"];
            picker.navigationBar.barTintColor = [CommonUtil colorWithHexString:@"#1a1b1f"];
            [picker.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
            [picker.navigationBar setTintColor:[UIColor whiteColor]];
            picker.modalPresentationStyle = UIModalPresentationFullScreen;
            [self.vc presentViewController:picker animated:YES completion:^{}];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:SYSLanguage?@"Cancel":@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [controller addAction:ok1] ;
        [controller addAction:ok2] ;
        [controller addAction:cancel] ;
        [self.vc presentViewController:controller animated:YES completion:^{}];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    WBGImageEditor *editor = [[WBGImageEditor alloc] initWithImage:image delegate:self dataSource:self] ;
    editor.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.vc presentViewController:editor animated:YES completion:nil];
}

#pragma mark - WBGImageEditorDelegate
- (void)imageEditor:(WBGImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image {

    [editor.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self setImageValueWith:image];
}

- (void)imageEditorDidCancel:(WBGImageEditor *)editor {
    
}

- (NSArray<WBGMoreKeyboardItem *> *)imageItemsEditor:(WBGImageEditor *)editor {
    return @[];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)setImageValueWith:(UIImage *)image {
    
    NSString *dateStr = [Utilities DateNow];
    
    NSString *path = [NSString stringWithFormat:kVMPicturePathString,[Utilities SysDocumentPath],dateStr,[CacheManagement instance].currentStore.StoreCode,@"TRAINING",[Utilities GetUUID]];
    
    NSFileManager* fileMannager = [NSFileManager defaultManager];
    
    if(![fileMannager fileExistsAtPath:path])
    {
        [fileMannager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    [fileMannager removeItemAtPath:path error:nil] ;
    [Utilities saveImage:image imgPath:path];
    [Utilities saveThumImage:image imgPath:[path stringByReplacingOccurrencesOfString:@".jpg" withString:@"_s.jpg"]];
    
    NSString *photoType = @"" ;
    if ([self.picTitleLabel.text containsString:@"课堂"]) {
        photoType = @"1";
    }
    if ([self.picTitleLabel.text containsString:@"实操"]) {
        photoType = @"2";
    }
    if ([self.picTitleLabel.text containsString:@"远程"]) {
        photoType = @"3";
    }
    
    if ([self.imageArray count] > self.currentIndex) {
        NVMTrainingCheckPhotoEntity *photo = [self.imageArray objectAtIndex:self.currentIndex];
        photo.TRAINING_CHECK_ID = self.checkId;
        photo.PHOTO_TYPE = photoType;
        if([fileMannager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",[Utilities SysDocumentPath],photo.PHOTO_PATH]]){
            [fileMannager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",[Utilities SysDocumentPath],photo.PHOTO_PATH] error:nil];
        }
        if([fileMannager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",[Utilities SysDocumentPath],[photo.PHOTO_PATH stringByReplacingOccurrencesOfString:@".jpg" withString:@"_s.jpg"]]]){
            [fileMannager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",[Utilities SysDocumentPath],[photo.PHOTO_PATH stringByReplacingOccurrencesOfString:@".jpg" withString:@"_s.jpg"]] error:nil];
        }
        photo.PHOTO_PATH = [[path componentsSeparatedByString:@"dataCaches/"] lastObject];
    }
    else {
        NVMTrainingCheckPhotoEntity *photo = [[NVMTrainingCheckPhotoEntity alloc] init];
        photo.TRAINING_PHOTO_LIST_ID = [NSUUID UUID].UUIDString;
        photo.TRAINING_CHECK_ID = self.checkId;
        photo.PHOTO_TYPE = photoType;
        photo.PHOTO_PATH = [[path componentsSeparatedByString:@"dataCaches/"] lastObject];
        [self.imageArray addObject:photo];
    }
    ExerciseViewController *exercise = (ExerciseViewController *)self.vc ;
    [exercise resetImage:self.imageArray with:photoType];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
   
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder] ;
        return NO ;
    }
    
    NSString *str1 = @"&" ;
    NSString *str2 = @"<" ;
    NSString *str3 = @"/>";
    NSString *str4 = @"'" ;
    NSString *str5 = @"\"";
    NSString *str6 = @">" ;
    
    return !([text isEqualToString:str1]||[text isEqualToString:str2]||[text isEqualToString:str3]||
             [text isEqualToString:str4]||[text isEqualToString:str5]||[text isEqualToString:str6]) ;
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length == 0) {
        
        self.holderLabel.hidden = NO;
    }
    else{
        
        self.holderLabel.hidden = YES;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (!self.tallView.hidden&&self.saveArray) {
        
        if ([self.secTitleLabel.text containsString:@"备注"]) @try {[self.saveArray replaceObjectAtIndex:8 withObject:textView.text];} @catch (NSException *exception) {} ;
    }
}

-(void)cellLongPress:(UILongPressGestureRecognizer *)longRecognizer{
    
    if (longRecognizer.state == UIGestureRecognizerStateBegan) {

        [self becomeFirstResponder];
        CGPoint location = [longRecognizer locationInView:self.picCollectView];
        NSIndexPath * indexPath = [self.picCollectView indexPathForItemAtPoint:location];
        
        if (self.imageArray.count > indexPath.row) {
            NVMTrainingCheckPhotoEntity *entity = [self.imageArray objectAtIndex:indexPath.row];
            ImageDetailViewController *controller = [[ImageDetailViewController alloc] initWithNibName:@"ImageDetailViewController" bundle:nil];
            controller.trainingPath = entity.PHOTO_PATH ;
            controller.DeleteDelegate = self ;
            controller.index = indexPath.row ;
            controller.modalPresentationStyle = UIModalPresentationFullScreen;
            [self.vc presentViewController:controller animated:NO completion:nil];
        }
    }
}


- (void)DeleteSelectImageWith:(NSInteger)index {
    
    if (self.imageArray.count > index) {
        NVMTrainingCheckPhotoEntity *photo = [self.imageArray objectAtIndex:index];
        NSFileManager* fileMannager = [NSFileManager defaultManager];
        if([fileMannager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",[Utilities SysDocumentPath],photo.PHOTO_PATH]]){
            [fileMannager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",[Utilities SysDocumentPath],photo.PHOTO_PATH] error:nil];
        }
        if([fileMannager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@",[Utilities SysDocumentPath],[photo.PHOTO_PATH stringByReplacingOccurrencesOfString:@".jpg" withString:@"_s.jpg"]]]){
            [fileMannager removeItemAtPath:[NSString stringWithFormat:@"%@/%@",[Utilities SysDocumentPath],[photo.PHOTO_PATH stringByReplacingOccurrencesOfString:@".jpg" withString:@"_s.jpg"]] error:nil];
        }
        [self.imageArray removeObjectAtIndex:index];
        NSString *photoType = @"" ;
        if ([self.picTitleLabel.text containsString:@"课堂"]) {
            photoType = @"1";
        }
        if ([self.picTitleLabel.text containsString:@"实操"]) {
            photoType = @"2";
        }
        if ([self.picTitleLabel.text containsString:@"远程"]) {
            photoType = @"3";
        }
        ExerciseViewController *exercise = (ExerciseViewController *)self.vc ;
        [exercise resetImage:self.imageArray with:photoType];
    }
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    
    _dataArray = dataArray;
    [self.studentTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell" ;
    ExerciseStudentCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nibAry = [[NSBundle mainBundle] loadNibNamed:@"ExerciseStudentCustomCell" owner:self options:nil];
        for (UIView *view in nibAry) {
            if ([view isKindOfClass:[ExerciseStudentCustomCell class]]) {
                cell = (ExerciseStudentCustomCell *)view ;
                break ;
            }
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone ;
    cell.backgroundColor = [CommonUtil colorWithHexString:@"#26b8f2" withAlpha:0.1];
    CGRect frame = cell.leftTitleLabel.frame ;
    id element = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([element isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)element ;
        cell.leftTitleLabel.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"name"]];
        cell.rightTextField.text = [NSString stringWithFormat:@"%@",[dic valueForKey:@"count"]];
        frame.size.width = PHONE_WIDTH - 57 - 120 ;
        cell.rightTextField.hidden = NO ;
    }
    
    if ([element isKindOfClass:[NSString class]]) {
        NSString *cont = (NSString *)element ;
        cell.leftTitleLabel.text = [NSString stringWithFormat:@"%d. %@",(int)indexPath.row+1,cont];
        frame.size.width = PHONE_WIDTH - 57 - 42 ;
        cell.rightTextField.hidden = YES ;
        cell.leftTitleLabel.adjustsFontSizeToFitWidth = YES ;
    }
    
    cell.leftTitleLabel.frame = frame ;
    cell.deleteButton.tag = indexPath.row ;
    cell.delegate = self ;
    return cell ;
}

- (void)deleteStucent:(NSInteger)index {
    
    UIAlertController *others = [UIAlertController alertControllerWithTitle:@"提示" message:@"请确认是否删除" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.dataArray removeObjectAtIndex:index];
        [self.vc.ExerciseTableView reloadData];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [others addAction:cancel];[others addAction:ok];
    [self.vc presentViewController:others animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 40 ;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    id element = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([element isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)element ;
        NSString *currentuser = [NSString stringWithFormat:@"%@",[dic valueForKey:@"name"]];
        NSString *currentcount = [NSString stringWithFormat:@"%@",[dic valueForKey:@"count"]];
        UIAlertController *others = [UIAlertController alertControllerWithTitle:nil message:@"培训人数" preferredStyle:UIAlertControllerStyleAlert];
        [others addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = [NSString stringWithFormat:@"请输入%@培训人数",currentuser];
            textField.text = currentcount ;
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (others.textFields.count&&others.textFields.firstObject.text.intValue > 0) {
                
                NSDictionary *dic = @{@"name":currentuser,@"count":others.textFields.firstObject.text};
                [self.dataArray replaceObjectAtIndex:indexPath.row withObject:dic];
                [self.vc.ExerciseTableView reloadData];
                
            } else {
                ALERTVIEW(@"请输入大于0的数字");
            }
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [others addAction:cancel];[others addAction:ok];
        [self.vc presentViewController:others animated:YES completion:nil];
    }
    
    if ([element isKindOfClass:[NSString class]]) {
        NSString *cont = (NSString *)element ;
        UIAlertController *others = [UIAlertController alertControllerWithTitle:nil message:@"培训内容" preferredStyle:UIAlertControllerStyleAlert];
        [others addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入培训内容";
            textField.text = cont ;
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        }];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (others.textFields.count&&others.textFields.firstObject.text.length > 0) {
                
                [self.dataArray replaceObjectAtIndex:indexPath.row withObject:others.textFields.firstObject.text];
                [self.vc.ExerciseTableView reloadData];
                
            } else {
                ALERTVIEW(@"请输入培训内容");
            }
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [others addAction:cancel];[others addAction:ok];
        [self.vc presentViewController:others animated:YES completion:nil];
    }
    
    
    
    
    
                   
}


@end
