//
//  InstallScoreEntity.h
//  ADIDAS
//
//  Created by wendy on 14-5-16.
//
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface InstallScoreEntity : NSObject

@property (strong,nonatomic) NSString* photoPath;
@property (strong,nonatomic) NSString* remark;
@property (strong,nonatomic) NSString* popID;
@property (strong,nonatomic) NSString* Campaign_install_id;

@end
