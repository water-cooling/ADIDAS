//
//  LanguageViewController.h
//  ADIDAS
//
//  Created by wendy on 14-9-3.
//
//

#import <UIKit/UIKit.h>
#import "IssueManagement.h"
#import "NSString+SBJSON.h"


@interface LanguageViewController : UIViewController<IssueManagementDelegate>


@property (retain, nonatomic) IBOutlet UIImageView *naviImageView;

@property (strong,nonatomic) IssueManagement* issueManagement;


@end
