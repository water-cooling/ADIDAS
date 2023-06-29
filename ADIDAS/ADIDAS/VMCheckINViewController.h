//
//  VMCheckINViewController.h
//  ADIDAS
//
//  Created by wendy on 14-8-28.
//
//

#import <UIKit/UIKit.h>
@class StoreListViewController;

@interface VMCheckINViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (strong,nonatomic)NSArray* returnArray;

@property (weak,nonatomic) IBOutlet UIImageView* storeimageview;

@property (weak,nonatomic) IBOutlet UILabel* storecodeLabel;

@property (weak,nonatomic) IBOutlet UILabel* storenameLabel;

@property (weak,nonatomic) IBOutlet UILabel* storeAddress;

@property (weak,nonatomic) IBOutlet UIButton* checkInbtn;

@property (strong,nonatomic) NSString* StorePicString;

@property (weak,nonatomic) IBOutlet UILabel* codeTitle;
@property (weak,nonatomic) IBOutlet UILabel* nameTitle;
@property (weak,nonatomic) IBOutlet UILabel* addressTitle;
@property (weak,nonatomic) IBOutlet UILabel* historyTitle;


@property (weak,nonatomic) IBOutlet UIImageView* imageview1;
@property (weak,nonatomic) IBOutlet UIImageView* imageview2;
@property (weak,nonatomic) IBOutlet UIImageView* imageview3;
@property (weak,nonatomic) IBOutlet UIImageView* imageview4;
@property (weak,nonatomic) IBOutlet UIImageView* imageview5;

@property (weak,nonatomic) IBOutlet UILabel* label1;
@property (weak,nonatomic) IBOutlet UILabel* label2;
@property (weak,nonatomic) IBOutlet UILabel* label3;
@property (weak,nonatomic) IBOutlet UILabel* label4;
@property (weak,nonatomic) IBOutlet UILabel* label5;

@property (weak,nonatomic) StoreListViewController* superviewController;
@property (strong,nonatomic) UIImagePickerController* photoPicker;

@property (assign) BOOL hasStorePic;

@end
