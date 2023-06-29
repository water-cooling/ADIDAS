//
//  LocationEntity.h
//  ADIDAS
//
//  Created by testing on 2/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationEntity : NSObject

@property(nonatomic,copy)NSString * locationX; // 经度值  
@property(nonatomic,copy)NSString * locationY; //纬度值

//Json 对象中获得Dictionary初始化User对象
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end