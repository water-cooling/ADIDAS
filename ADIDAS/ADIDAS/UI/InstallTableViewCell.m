//
//  InstallTableViewCell.m
//  ADIDAS
//
//  Created by wendy on 14-5-4.
//
//

#import "InstallTableViewCell.h"
#import "Utilities.h"
#import "CommonDefine.h"
#import "CacheManagement.h"
#import <Foundation/Foundation.h>

@implementation InstallTableViewCell
@synthesize describeLabel,describeStr;
@synthesize photoPicker;


// 同步访问方法
-(NSData*) sendHttpRequest:(NSString *) urlString
{
    // 先检查ASIHttpRequest是否为空，没空先relase,防止多次调用此函数
    ASIHTTPRequest*  request = nil;
    NSString* urlstr = [NSString stringWithFormat:@"%@%@",kWebMobileHeadString,urlString];
    //里面有中文。需要转化为NSUTF8StringEncoding
    NSURL *url = [NSURL URLWithString:[urlstr stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    
    request = [[ASIHTTPRequest alloc]initWithURL:url];
    [request setValidatesSecureCertificate:NO];
    
    //添加ISA 密文验证
    if ([CacheManagement instance].userEncode&&![[CacheManagement instance].userEncode isEqualToString:@""])
        [request addRequestHeader:@"Authorization"
                         value:[NSString stringWithFormat:@"Basic %@",[CacheManagement instance].userEncode]];
    
	[request startSynchronous];
    NSError *error = [request error];
    NSData *response = nil;
    if (!error)
    {
        response = [request responseData];
    }
    return response;
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(scrollScrollView:) userInfo:nil repeats:YES];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(openCamera)];
    [self.takephotoImage addGestureRecognizer:tap];
//    UILongPressGestureRecognizer* longpress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(showAs:)];
//    longpress.minimumPressDuration = 0.5;
//    [self.takephotoImage addGestureRecognizer:longpress];
    self.inputView.layer.cornerRadius = 5 ;
    self.inputView.layer.borderColor = [[Utilities colorWithHexString:@"#45999999"] CGColor];
    self.inputView.layer.borderWidth = 1 ;
    self.inputView.layer.masksToBounds = YES ;
}

-(void)showAs:(id)sender
{
    UILongPressGestureRecognizer* longpress = (UILongPressGestureRecognizer*)sender;
    if (longpress.state == UIGestureRecognizerStateBegan)
    {
        UIActionSheet* as = [[UIActionSheet alloc]initWithTitle:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:@"删除"
                                              otherButtonTitles:nil, nil];
        [as showInView:self.superview.superview];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [[NSFileManager defaultManager]removeItemAtPath:self.picpath error:nil];
        self.takephotoImage.image = [UIImage imageNamed:@"takepic.png"];
        self.resultLabel.text = nil;
        self.resultLabel.hidden = YES;
        self.picButton.hidden = YES ;
    }
}

- (void)saveImageToPhotos:(UIImage *)savedImage {
    
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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSFileManager* fileMannager = [NSFileManager defaultManager];
    if(![fileMannager fileExistsAtPath:self.picpath])
    {
        [fileMannager createDirectoryAtPath:self.picpath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    [Utilities saveImage:image imgPath:self.picpath];
    self.takephotoImage.image = image;
    self.picButton.hidden = NO ;
    self.resultLabel.hidden = NO;
    [self.delegate resetSourceData:self.currentIndex];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)openCamera
{
    if (!self.photoPicker) {
        
        self.photoPicker = [[UIImagePickerController alloc]init];
        self.photoPicker.delegate = self;
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        self.photoPicker.sourceType = sourceType;
    }
    [self.delegate openCamera:self.photoPicker];
}

-(IBAction)showLargePic:(id)sender
{
    [self.delegate showLargePic:self.pic_name];
}

-(void)configUI
{
    self.describeLabel.numberOfLines = 1;
    self.describeLabel.frame = CGRectMake(0, 0, 1000, 40);
    [self.describeLabel setUserInteractionEnabled:YES];
    self.describeLabel.text = self.describeStr;
    [self.describeLabel sizeToFit];
    self.scroll_width = self.describeLabel.frame.size.width;
    [self.textscrllview setDelegate:self];
    [self.textscrllview setScrollEnabled:YES];
    [self.textscrllview setUserInteractionEnabled:YES];
    [self.textscrllview setDirectionalLockEnabled:NO];
    [self.textscrllview setContentSize:CGSizeMake(self.scroll_width, 40)];
    if (self.describeLabel.frame.size.width > self.textscrllview.frame.size.width)
    {
        [self.timer setFireDate:[NSDate distantPast]];
    }
    else
    {
        [self.timer setFireDate:[NSDate distantFuture]];
    }
    [self downloadImage:self.pic_name_thumb];
}



-(void)downloadImage:(NSString*)string
{
    // 先判断本地是否有缓存
    
    NSString* imagePathString = [NSString stringWithFormat:@"%@/Library/Caches/images%@", NSHomeDirectory(), string];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePathString]) {
        // remove 0 size file
        NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:imagePathString error:nil];
        unsigned long long fileSize = [attributes fileSize];
        if (fileSize == 0) {
            [[NSFileManager defaultManager] removeItemAtPath:imagePathString error:nil];
        }
        else
        {
            [self.demoPhoto setImage:[UIImage imageWithContentsOfFile:imagePathString] forState:UIControlStateNormal];
            NSLog(@"从本地读取");
            return;
        }
    }
    
    NSData* data= [self sendHttpRequest:string];
    [[NSFileManager defaultManager] createDirectoryAtPath:imagePathString withIntermediateDirectories:YES attributes:nil error:nil];
    [[NSFileManager defaultManager] removeItemAtPath:imagePathString error:nil];
    
    [[NSFileManager defaultManager] createFileAtPath:imagePathString contents:data attributes:nil];
    
    [self.demoPhoto setImage:[UIImage imageWithData:data] forState:UIControlStateNormal];
}


-(void)beginScroll
{
}

- (void)scrollScrollView:(NSTimer *)timer
{
    CGPoint newScrollViewContentOffset = self.textscrllview.contentOffset;
    
    //向上移动 1px
    newScrollViewContentOffset.x += 1;
    
    newScrollViewContentOffset.x = MAX(0, newScrollViewContentOffset.x);
    
    //如果到顶了，timer中止
    if (newScrollViewContentOffset.x > self.scroll_width)
    {
        self.textscrllview.contentOffset = CGPointMake(0, 0);
        return;
    }
    
    //最后设置scollView's contentOffset
    self.textscrllview.contentOffset = newScrollViewContentOffset;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPicpath:(NSString *)picpath {

    _picpath = picpath ;
    
    NSFileManager* fileMannager = [NSFileManager defaultManager];
    if ([picpath length] > 0) {
        
        if([fileMannager fileExistsAtPath:picpath]) self.picButton.hidden = NO ;
        else self.picButton.hidden = YES ;
    }
    else self.picButton.hidden = YES ;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

- (IBAction)picAction:(id)sender {
    
    [self.delegate showLargePic:self.picpath];
}

- (IBAction)inputAction:(id)sender {
    
    [self.delegate inputComment:self.currentIndex];
}






@end
