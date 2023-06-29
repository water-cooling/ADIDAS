//
//  LoadingViewController.h
//  WSE
//
//  Created by testing on 2/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AMapLocationKit/AMapLocationManager.h>

@interface LoadingViewController : UIViewController<AMapLocationManagerDelegate>
{
    IBOutlet UIImageView *loadingImage;
    BOOL isClosed;
}
@property (retain, nonatomic) IBOutlet UIImageView *loadingImage;
@property (strong, nonatomic) AMapLocationManager *locationManager ;

@property (strong,nonatomic) CLLocationManager* locManager;
@end
