//
//  ListItemEntity.h
//  ADIDAS
//
//  Created by testing on 3/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListItemEntity : NSObject

@property(nonatomic,copy)NSString *itemID;
@property(nonatomic,copy)NSString *itemName;

//Json 对象中获得Dictionary初始化User对象
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
