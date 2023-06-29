//
//  HomeOrderModel.h
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/5/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeOrderModel : NSObject
@property (nonatomic , copy) NSString              * CaseNumber;
@property (nonatomic , copy) NSString              * Division;
@property (nonatomic , copy) NSString              * IsNew;
@property (nonatomic , copy) NSString              * CaseCategory;
@property (nonatomic , copy) NSString              * CaseStatus;
@property (nonatomic , copy) NSString              * ArticleList;
@property (nonatomic , copy) NSString              * CaseDate;
@property (nonatomic , copy) NSString              * PictureUrl;
@end

NS_ASSUME_NONNULL_END
