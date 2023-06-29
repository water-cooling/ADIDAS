//
//  StoreEntity.h
//  ADIDAS
//
//  Created by testing on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreEntity : NSObject


@property(nonatomic,copy)NSString *CheckFlag;
@property(nonatomic,copy)NSString *CheckError;
@property(nonatomic,copy)NSString *StoreCode;
@property(nonatomic,copy)NSString *StoreName;
@property(nonatomic,copy)NSString *StorePhone;
@property(nonatomic,copy)NSString *StoreAddress;
@property(nonatomic,copy)NSString *StoreRemark;
@property(nonatomic,copy)NSString *StoreStatus;
@property(nonatomic,copy)NSString *SelectMethod;
@property(nonatomic,copy)NSString *IsCampaign;

//Json 对象中获得Dictionary初始化User对象
- (id)initWithDictionary:(NSDictionary *)dictionary;

- (id)initWithDictionary2:(NSDictionary *)dictionary;

- (id)initWithDictionary3:(NSDictionary *)dictionary;
//将User对象转化为Json String
- (NSString *)ToJSONString;

@end
