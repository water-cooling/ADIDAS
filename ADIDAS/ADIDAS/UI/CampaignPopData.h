//
//  CampaignPopData.h
//  ADIDAS
//
//  Created by wendy on 14-5-7.
//
//

#import <Foundation/Foundation.h>

@interface CampaignPopData : NSObject

@property (strong,nonatomic) NSString* campaign_id;
@property (strong,nonatomic) NSString* pop_id;
@property (strong,nonatomic) NSString* vendor_code;
@property (strong,nonatomic) NSString* vendor_email;
@property (strong,nonatomic) NSString* vendor_name;
@property (strong,nonatomic) NSString* last_modified_by;
@property (strong,nonatomic) NSString* last_modified_time;
@property (strong,nonatomic) NSMutableString* pic_serv_name;
@property (strong,nonatomic) NSMutableString* pic_serv_thumbname;
@property (strong,nonatomic) NSString* pop_code;
@property (strong,nonatomic) NSString* pop_name;
@property (strong,nonatomic) NSString* pop_type;
@property (strong,nonatomic) NSString* remark;
@property (strong,nonatomic) NSString* comment;
@property (strong,nonatomic) NSString* picpath;

@property (strong,nonatomic) NSString* MAX_PHOTO_COUNT;
@property (strong,nonatomic) NSString* MIN_PHOTO_COUNT;
@property (strong,nonatomic) NSString* PHOTO_COMMENT;

@end
