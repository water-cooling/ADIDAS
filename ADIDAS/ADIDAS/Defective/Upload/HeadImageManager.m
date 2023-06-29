//
//  HeadImageManager.m
//  FuelTreasureProject
//
//  Created by 吴仕海 on 4/13/15.
//  Copyright (c) 2015 XiTai. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "HeadImageManager.h"
#import <CoreServices/CoreServices.h>

@interface HeadImageManager ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, weak) UIViewController *presentViewController;
@end

@implementation HeadImageManager
+ (HeadImageManager *)sharedInstance{
    static HeadImageManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(& onceToken,^{
        sharedInstance = [[self alloc]init];
    });
    return sharedInstance;
}

+ (void)alertUploadHeaderImageActionSheet:(UIViewController *)controller imageSuccess:(ImageHandle)success {
    [HeadImageManager sharedInstance].imageHandle = success;

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"打开照相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[HeadImageManager sharedInstance] takePhoto];
    }];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从手机相册获取" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[HeadImageManager sharedInstance] LocalPhoto];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cameraAction];
    [alertVC addAction:photoAction];
    [alertVC addAction:cancelAction];
 
    
    [controller presentViewController:alertVC animated:YES completion:nil];
 
    [HeadImageManager sharedInstance].presentViewController = controller;
}



- (void) takePhoto{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:@"请在设备的设置-隐私-相机中允许访问相机" preferredStyle:UIAlertControllerStyleAlert];
      
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[HeadImageManager sharedInstance] LocalPhoto];
        }];
        
        [alertVC addAction:sureAction];
   
        [self.presentViewController presentViewController:alertVC animated:YES completion:nil];

        return;
    }
    NSArray *aviliableMediaTypes  = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    BOOL canTakePicture = NO;
    for (NSString *mediaType in aviliableMediaTypes) {
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
            // 支持拍照
            canTakePicture = YES;
            break;
        }
    }
    // 检查是否支持拍照
    if (!canTakePicture) {
        //[self presentFailLogoSheet:L(@"not support take photos")];
//        DDLogDebug(@"not support take photos");
//        [self.presentViewController alertMessage:@"该设备不支持拍照"];
        return;
    }
    
    // 创建图片给选取控制器
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [imagePicker.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [imagePicker.navigationBar setTintColor:[UIColor blackColor]];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    // 设置所支持的类型，设置只能拍照，或则只能录像，或者两者都可以
    NSString *requiredMediaType = ( NSString *)kUTTypeImage;
    imagePicker.mediaTypes = [[NSArray alloc]initWithObjects:requiredMediaType, nil];
    // 允许用户进行编辑
    imagePicker.allowsEditing = NO;
    // 设置委托对象
    imagePicker.delegate = self;
    [self.presentViewController presentViewController:imagePicker animated:YES completion:nil];
}

- (void)LocalPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    [picker.navigationBar setBackgroundColor:[UIColor whiteColor]];
    [picker.navigationBar setTintColor:[UIColor blackColor]];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = NO;
    [self.presentViewController presentViewController:picker animated:YES completion:nil];
}

#pragma mark imagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // 获取媒体类型
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    // 判断是图片或视频
    if ([mediaType isEqualToString:(NSString*)kUTTypeImage]) {
        // 获得用户编辑后的图像
        UIImage *orginalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        [self uploadImage:orginalImage];
    }
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)uploadImage:(UIImage *)image{
    if (!image) {
        return;
    }
    _imageHandle(image);
}
@end
