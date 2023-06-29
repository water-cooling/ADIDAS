//
//  NewsDetailViewController.h
//  ADIDAS
//
//  Created by 桂康 on 2016/12/16.
//
//

#import "BaseViewController.h"

@interface NewsDetailViewController : BaseViewController

@property (strong, nonatomic) NSDictionary *dataDic ;
@property (retain, nonatomic) IBOutlet UIWebView *newsDetailWebView;

@end
