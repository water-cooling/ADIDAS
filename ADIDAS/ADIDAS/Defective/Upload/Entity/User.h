//
//  User.h
//  ADIDAS
//
//  Created by 桂康 on 2016/12/22.
//
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *StoreEmail ;

@property (strong, nonatomic) NSString *StoreManagePhone ;

@property (strong, nonatomic) NSString *StorePhone ;

@property (strong, nonatomic) NSString *UserAccount ;

@property (strong, nonatomic) NSString *UserNameCN ;

@property (strong, nonatomic) NSArray *listCaseTitle ;

@property (strong, nonatomic) NSArray *listNoticeHeader ;

@property (strong, nonatomic) NSString *Token ;

@property (strong, nonatomic) NSString *Requestor ;

@property (strong, nonatomic) NSString *MustPicture;

@property (strong, nonatomic) NSString *PostAddress;

@property(nonatomic,strong) NSString * LinkMan;
@property(nonatomic,strong) NSString * LinkTel;
@property(nonatomic,strong) NSString * Address;


- (id)initWith:(NSDictionary *)dic ;

@end
