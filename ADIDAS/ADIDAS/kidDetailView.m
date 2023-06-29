//
//  kidDetailView.m
//  ADIDAS
//
//  Created by 桂康 on 2017/7/31.
//
//

#import "kidDetailView.h"
#import "CommonUtil.h"
#import "CommonDefine.h"
#import "AppDelegate.h"
#import "Utilities.h"
#import "UIImage+resize.h"


@implementation kidDetailView


- (void)awakeFromNib {

    [super awakeFromNib];
    self.label.text = SYSLanguage?@"Please input remark":@"请输入说明";
    self.comment_textview.delegate = self ;
    self.photo_1.delegate = self;
    self.photo_2.delegate = self;
}

- (IBAction)scor:(id)sender {
    
    UIButton* button = (UIButton*)sender;
    NSInteger tag = button.tag;
    CGRect aframe = self.secondpageview.frame ;
    
    if (tag == 1)
    {
        self.reasonBtn.hidden = YES;
        self.reason = nil;
        aframe.origin.y = 57;
        self.scoreResult = self.maxScore ;
        [self.YES_btn setBackgroundImage:[UIImage imageNamed:@"formorange2.png"] forState:UIControlStateNormal];
        [self.NO_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        [self.NA_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        [self.comment_textview resignFirstResponder];
    }
    else if (tag == 2)
    {
        if ([self.reasonsArr count] == 0 || ([self.reasonsArr count] == 1 && ([[self.reasonsArr firstObject] isEqualToString:@""]||![self.reasonsArr firstObject])))
        {
            self.reasonBtn.hidden = YES;
            self.reason = @"";
        }
        else
        {
            self.reasonBtn.hidden = NO;
            [self selectreason:nil];
            aframe.origin.y = 90 ;
        }
        self.scoreResult = @"-1";
        
        [self.YES_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        [self.NO_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        [self.NA_btn setBackgroundImage:[UIImage imageNamed:@"formorange2.png"] forState:UIControlStateNormal];
    }
    else if (tag == 0)
    {
        self.reasonBtn.hidden = YES;
        self.reason = nil;
        aframe.origin.y = 57;
        self.scoreResult = @"0" ;
        [self.comment_textview becomeFirstResponder];
        
        [self.YES_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
        [self.NO_btn setBackgroundImage:[UIImage imageNamed:@"formorange2.png"] forState:UIControlStateNormal];
        [self.NA_btn setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
    }
    
    self.secondpageview.frame = aframe ;
    
    CGRect frameIV = self.itemView.frame ;
    frameIV.size.height = aframe.size.height + aframe.origin.y ;
    self.itemView.frame = frameIV ;
    self.itemScrollView.contentSize = CGSizeMake(0, frameIV.size.height+frameIV.origin.y) ;
}

- (IBAction)selectreason:(id)sender {
    
    UIActionSheet* ac = [[UIActionSheet alloc]initWithTitle:SYSLanguage?@"Choose reason": @"选择原因" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    
    for (NSString* title in self.reasonsArr)
    {
        [ac addButtonWithTitle:title];
    }
    [ac showInView:self.bgview];
}


- (IBAction)leftPicDetailAction:(id)sender {

    if ([self.picpath_1 length]> 0) {

        [self.delegate showBigImage:self.picpath_1];
    }
}


- (IBAction)rightPicDetailAction:(id)sender {

    if ([self.picpath_2 length]> 0) {
        
        [self.delegate showBigImage:self.picpath_2];
    }
}

- (void)setPicpath_1:(NSString *)picpath_1 {
    
    _picpath_1 = picpath_1 ;
    if (picpath_1.length > 0) self.firButton.hidden = NO ;
    else self.firButton.hidden = YES ;
}

- (void)setPicpath_2:(NSString *)picpath_2 {
    _picpath_2 = picpath_2 ;
    if (picpath_2.length > 0) self.secButton.hidden = NO ;
    else self.secButton.hidden = YES ;
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (actionSheet.title == nil)
    {
        if (buttonIndex == 0)
        {
            if (self.tag == 111)
            {
                [[NSFileManager defaultManager]removeItemAtPath:self.picpath_1 error:nil];
                self.picpath_1 = nil;
                self.photo_1.image = [UIImage imageNamed:SYSLanguage?@"takepic_en_new.png": @"takepic_new.png"];
            }
            else
            {
                [[NSFileManager defaultManager]removeItemAtPath:self.picpath_2 error:nil];
                self.picpath_2 = nil;
                self.photo_2.image = [UIImage imageNamed:SYSLanguage?@"takepic_en_new.png": @"takepic_new.png"];
            }
        }
    }

    if ([actionSheet.title isEqualToString: SYSLanguage?@"Choose reason": @"选择原因"])
    {
        self.reason = [self.reasonsArr objectAtIndex:buttonIndex];
        [self.reasonBtn setTitle:self.reason forState:UIControlStateNormal];
    }
    if ([self.reason isEqualToString:SYSLanguage?@"Other reason":@"其他原因"] || [self.reason isEqualToString:SYSLanguage?@"Other reason":@"其他"])
    {
        [self.comment_textview becomeFirstResponder];
    }
    else
    {
        [self.comment_textview resignFirstResponder];
        
    }
}




-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    //    if ([text isEqualToString:@"\x20"])
    //    {
    //        return NO;
    //    }
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (IOSVersion >= 7.0)
    {
        NSTimeInterval animationDuration = 0.25f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        self.bgview.frame =CGRectMake(0, 64, self.bgview.frame.size.width, self.bgview.frame.size.height);
        [UIView commitAnimations];
    }
    else
    {
        NSTimeInterval animationDuration = 0.25f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        self.bgview.frame =CGRectMake(0, 0, self.bgview.frame.size.width, self.bgview.frame.size.height);
        [UIView commitAnimations];
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.label.hidden = NO;
    }else{
        self.label.hidden = YES;
    }
}


-(void)takePic:(id)sender
{
    if ([self.scoreResult isEqualToString:@"3"])
    {
        UIAlertView* av = [[UIAlertView alloc]initWithTitle:nil message:SYSLanguage?@"Can not scoring can not take pictures": @"未打分不能拍照" delegate:self cancelButtonTitle:SYSLanguage?@"OK": @"确定" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    TapLongPressImageView* touchPhoto = (TapLongPressImageView*)sender;
    self.tag = touchPhoto.tag;
    
    if (ISFROMEHK) {
        
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:SYSLanguage?@"Choose Picture":@"选择照片" delegate:self cancelButtonTitle:SYSLanguage?@"Cancel":@"取消" destructiveButtonTitle:nil otherButtonTitles:SYSLanguage?@"Camera":@"拍照",SYSLanguage?@"Album":@"从手机相册选择",nil];
        sheet.tag = 100000 ;
        [sheet showInView:self.bgview];
    }
    else {
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        UIImagePickerController *photoPicker = [[UIImagePickerController alloc]init];
        photoPicker.sourceType = sourceType;
        photoPicker.delegate = self;
        photoPicker.modalPresentationStyle = UIModalPresentationFullScreen;
        [kAppDelegate.window.rootViewController presentViewController:photoPicker animated:YES completion:nil];
    }
}

- (void)saveImageToPhotos:(UIImage*)savedImage {
    
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    
    NSString *msg = nil ;
    if(error != nil){
        msg = [error localizedDescription] ;
    }else{
        
        msg = @"保存图片成功" ;
    }
    NSLog(@"保存图片结果: %@",msg) ;
}

#pragma mark - photo

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    [picker dismissViewControllerAnimated:YES completion:nil];
    
    WBGImageEditor *editor = [[WBGImageEditor alloc] initWithImage:image delegate:self dataSource:self] ;
    editor.modalPresentationStyle = UIModalPresentationFullScreen;
    [kAppDelegate.window.rootViewController presentViewController:editor animated:YES completion:nil];
}


#pragma mark - WBGImageEditorDelegate
- (void)imageEditor:(WBGImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image {
    
    [self setImageValueWith:image];
    [editor.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageEditorDidCancel:(WBGImageEditor *)editor {
    
}

- (NSArray<WBGMoreKeyboardItem *> *)imageItemsEditor:(WBGImageEditor *)editor {
    return @[];
}

- (void)setImageValueWith:(UIImage *)image {
    
    if (self.tag == 111)
    {
        self.photo_1.image = [image scaleToSize:CGSizeMake(100, 100)];
        
        //        NSString* cachePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Private Documents/Images/%@/%@",[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode]];
        if (self.picpath_1 == nil)
        {
            self.picpath_1 = [NSString stringWithFormat:kVMPicturePathString,[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,@"VM_CHECK",[NSString stringWithFormat:@"%d",(int)self.No]];
            
            NSFileManager* fileMannager = [NSFileManager defaultManager];
            if(![fileMannager fileExistsAtPath:self.picpath_1])
            {
                [fileMannager createDirectoryAtPath:self.picpath_1 withIntermediateDirectories:YES attributes:nil error:nil];
            }
        }
        [Utilities saveImage:image imgPath:self.picpath_1];
    }
    else
    {
        self.photo_2.image = [image scaleToSize:CGSizeMake(100, 100)];
        
        if (self.picpath_2 == nil)
        {
            self.picpath_2 = [NSString stringWithFormat:kVMPicturePathString,[Utilities SysDocumentPath],[Utilities DateNow],[CacheManagement instance].currentStore.StoreCode,@"VM_CHECK",[NSString stringWithFormat:@"%d.1",(int)self.No]];
            NSFileManager* fileMannager = [NSFileManager defaultManager];
            if(![fileMannager fileExistsAtPath:self.picpath_2])
            {
                [fileMannager createDirectoryAtPath:self.picpath_2 withIntermediateDirectories:YES attributes:nil error:nil];
            }
            
        }
        [Utilities saveImage:image imgPath:self.picpath_2];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)deletePic:(id)sender
{
    UILongPressGestureRecognizer* longpress = (UILongPressGestureRecognizer*)sender;
    self.tag = longpress.view.tag;
    if (longpress.state == UIGestureRecognizerStateBegan)
    {
        UIActionSheet* ac = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:SYSLanguage?@"Cancel": @"取消" destructiveButtonTitle:SYSLanguage?@"Delete": @"删除" otherButtonTitles:nil, nil];
        [ac showInView:self.bgview];
    }
}



@end















