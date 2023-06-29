//
//  User.m
//  ADIDAS
//
//  Created by 桂康 on 2016/12/22.
//
//

#import "User.h"

@implementation User

- (id)initWith:(NSDictionary *)dic {

    if (self = [super init]) {
        
        NSUserDefaults *df = [NSUserDefaults standardUserDefaults];

        
        if ([dic valueForKey:@"UserAccount"] && ![[dic valueForKey:@"UserAccount"] isEqual:[NSNull null]]) {
            
            self.UserAccount = [[NSString stringWithFormat:@"%@",[dic valueForKey:@"UserAccount"]] uppercaseString] ;
        }
        else self.UserAccount = @"" ;
        
        
        
        
        if ([dic valueForKey:@"UserNameCN"] && ![[dic valueForKey:@"UserNameCN"] isEqual:[NSNull null]]) {
            
            self.UserNameCN = [dic valueForKey:@"UserNameCN"] ;
        }
        else self.UserNameCN = @"" ;
        
        if ([dic valueForKey:@"MustPicture"] && ![[dic valueForKey:@"MustPicture"] isEqual:[NSNull null]]) {
            
            self.MustPicture = [dic valueForKey:@"MustPicture"] ;
        }
        else self.MustPicture = @"" ;
        
        
        
        if ([dic valueForKey:@"listCaseTitle"] && ![[dic valueForKey:@"listCaseTitle"] isEqual:[NSNull null]]) {
            
            self.listCaseTitle = [dic valueForKey:@"listCaseTitle"] ;
        }
        else self.listCaseTitle = [NSArray array] ;
        
        
        
        
        if ([dic valueForKey:@"listNoticeHeader"] && ![[dic valueForKey:@"listNoticeHeader"] isEqual:[NSNull null]]) {
            
            self.listNoticeHeader = [dic valueForKey:@"listNoticeHeader"] ;
        }
        else self.listNoticeHeader = [NSArray array] ;
        
        
        
        
        if ([dic valueForKey:@"Token"] && ![[dic valueForKey:@"Token"] isEqual:[NSNull null]]) {
            
            self.Token = [dic valueForKey:@"Token"] ;
        }
        else self.Token = @"" ;
        
        
        
        
        if ([dic valueForKey:@"Requestor"] && ![[dic valueForKey:@"Requestor"] isEqual:[NSNull null]]) {
            
            self.Requestor = [dic valueForKey:@"Requestor"] ;
        }
        else self.Requestor = @"" ;
        
        
        
        if ([dic valueForKey:@"PostAddress"] && ![[dic valueForKey:@"PostAddress"] isEqual:[NSNull null]]) {
            
            self.PostAddress = [dic valueForKey:@"PostAddress"] ;
        }
        else self.PostAddress = @"" ;
        
        
        
        
        if ([dic valueForKey:@"StoreEmail"] && ![[dic valueForKey:@"StoreEmail"] isEqual:[NSNull null]] && ![[dic valueForKey:@"StoreEmail"] isEqualToString:@""]) {
            
            self.StoreEmail = [dic valueForKey:@"StoreEmail"] ;
        }
        else self.StoreEmail = ([df stringForKey:[NSString stringWithFormat:@"StoreEmail_%@",[self.UserAccount uppercaseString]]] ? [df stringForKey:[NSString stringWithFormat:@"StoreEmail_%@",[self.UserAccount uppercaseString]]] : @"") ;
        
        
        
        
        if ([dic valueForKey:@"StoreManagePhone"] && ![[dic valueForKey:@"StoreManagePhone"] isEqual:[NSNull null]] && ![[dic valueForKey:@"StoreManagePhone"] isEqualToString:@""]) {
            
            self.StoreManagePhone = [dic valueForKey:@"StoreManagePhone"] ;
        }
        else self.StoreManagePhone = ([df stringForKey:[NSString stringWithFormat:@"StoreManagePhone_%@",[self.UserAccount uppercaseString]]] ? [df stringForKey:[NSString stringWithFormat:@"StoreManagePhone_%@",[self.UserAccount uppercaseString]]] : @"") ;
        
        
        
        
        if ([dic valueForKey:@"StorePhone"] && ![[dic valueForKey:@"StorePhone"] isEqual:[NSNull null]] && ![[dic valueForKey:@"StorePhone"] isEqualToString:@""]) {
            
            self.StorePhone = [dic valueForKey:@"StorePhone"] ;
        }
        else self.StorePhone = ([df stringForKey:[NSString stringWithFormat:@"StorePhone_%@",[self.UserAccount uppercaseString]]] ? [df stringForKey:[NSString stringWithFormat:@"StorePhone_%@",[self.UserAccount uppercaseString]]] : @"") ;
    }
    
    return self ;
}

@end
