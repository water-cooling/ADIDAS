//
//  HeadImageManager.h
//  FuelTreasureProject
//
//  Created by 吴仕海 on 4/13/15.
//  Copyright (c) 2015 XiTai. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^ImageHandle)(UIImage*);
typedef void(^FailBlock)(NSString*);

@interface HeadImageManager : NSObject
@property(nonatomic,copy)ImageHandle imageHandle;
@property(nonatomic,copy)ImageHandle failHandle;

+ (HeadImageManager *)sharedInstance;
+ (void)alertUploadHeaderImageActionSheet:(UIViewController *)controller imageSuccess:(ImageHandle)success;
@end
