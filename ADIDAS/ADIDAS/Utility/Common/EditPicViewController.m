//
//  EditPicViewController.m
//  ADIDAS
//
//  Created by 桂康 on 15/11/18.
//
//

#import "EditPicViewController.h"
#import "CommonUtil.h"

@interface EditPicViewController ()

@end

@implementation EditPicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBarHidden = NO ;
    
    self.operateView.backgroundColor = [CommonUtil colorWithHexString:@"#3b3b3f"];
    self.defaultImageView.contentMode = UIViewContentModeScaleAspectFit ;
    [self.defaultImageView setImage:self.selectedImage] ;
    self.DrawImageView.delegate = self ;
    self.DrawImageView.drawTool = ACEDrawingToolTypeRectagleStroke;
    self.DrawImageView.lineWidth = 1 ;
    self.DrawImageView.lineAlpha = 1 ;
    self.DrawImageView.lineColor = [UIColor redColor];
    
    self.navigationItem.title = SYSLanguage?@"Edit Pic":@"编辑" ;

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:SYSLanguage?@"Save": @"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = item ;
    
    [self.clearButton setTitle:SYSLanguage?@"Clear": @"清除" forState:UIControlStateNormal] ;
    [self.undoButton setTitle:SYSLanguage?@"Undo": @"撤销" forState:UIControlStateNormal] ;
    [self.redoButton setTitle:SYSLanguage?@"Redo": @"恢复" forState:UIControlStateNormal] ;
    [self.colorBtn setTitle:SYSLanguage?@"Red": @"红色" forState:UIControlStateNormal] ;
}

- (void)save {

    if (!self.undoButton.enabled&&!self.redoButton.enabled) {
        
        [self.delegate selectPicWith:self.selectedImage];
    }
    else {
    
        UIGraphicsBeginImageContextWithOptions(self.defaultImageView.bounds.size, YES, 1);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        CGImageRef imageRef = viewImage.CGImage;
        CGRect rect =CGRectMake(0, 0, self.defaultImageView.bounds.size.width,self.defaultImageView.bounds.size.height);//这里可以设置想要截图的区域
        CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
        UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
        
        [self.delegate selectPicWith:sendImage];
    }
    
    if (self.isPushFrom) [self.navigationController popViewControllerAnimated:YES] ;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)dealloc {
    [_operateView release];
    [_undoButton release];
    [_redoButton release];
    [_colorBtn release];
    [_clearButton release];
    [super dealloc];
}

- (IBAction)operationAction:(id)sender {

    UIButton *btn = (UIButton *)sender ;
    
    if (btn.tag == 10) {  //撤销
        
        [self.DrawImageView undoLatestStep];
        [self updateButtonStatus];
    }
    
    if (btn.tag == 20) {  //恢复
        
        [self.DrawImageView redoLatestStep];
        [self updateButtonStatus];
    }
    
    if (btn.tag == 30) {  //清除
        
        [self.DrawImageView clear];
        [self updateButtonStatus];
    }
    
    if (btn.tag == 40) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                    initWithTitle:SYSLanguage?@"Choose Color": @"选择颜色"
                    delegate:self
                    cancelButtonTitle:SYSLanguage?@"Cancel": @"取消"
                    destructiveButtonTitle:nil
                    otherButtonTitles:SYSLanguage?@"Black":@"黑色",
                                      SYSLanguage?@"Red":@"红色",
                                      SYSLanguage?@"Green":@"绿色",
                                      SYSLanguage?@"Blue":@"蓝色", nil];
        
        [actionSheet showInView:self.view];
    }

}

- (void)drawingView:(ACEDrawingView *)view didEndDrawUsingTool:(id<ACEDrawingTool>)tool;
{
    [self updateButtonStatus];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.cancelButtonIndex != buttonIndex) {
        
     
        switch (buttonIndex) {
            case 0:
                [self.colorBtn setTitle:[actionSheet buttonTitleAtIndex:buttonIndex] forState:UIControlStateNormal];
                self.DrawImageView.lineColor = [UIColor blackColor];
                break;
                
            case 1:
                [self.colorBtn setTitle:[actionSheet buttonTitleAtIndex:buttonIndex] forState:UIControlStateNormal];
                self.DrawImageView.lineColor = [UIColor redColor];
                break;
                
            case 2:
                [self.colorBtn setTitle:[actionSheet buttonTitleAtIndex:buttonIndex] forState:UIControlStateNormal];
                self.DrawImageView.lineColor = [UIColor greenColor];
                break;
                
            case 3:
                [self.colorBtn setTitle:[actionSheet buttonTitleAtIndex:buttonIndex] forState:UIControlStateNormal];
                self.DrawImageView.lineColor = [UIColor blueColor];
                break;
        }
    }
}

- (void)updateButtonStatus
{
    self.undoButton.enabled = [self.DrawImageView canUndo];
    self.redoButton.enabled = [self.DrawImageView canRedo];
    if ([self.DrawImageView canUndo]) {
        [self.undoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    }
    else {
        [self.undoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal] ;
    }
    
    
    if ([self.DrawImageView canRedo]) {
        [self.redoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal] ;
    }
    else {
        [self.redoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal] ;
    }
}


@end















