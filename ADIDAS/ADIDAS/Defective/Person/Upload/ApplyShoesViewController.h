//
//  ApplyShoesViewController.h
//  MobileApp
//
//  Created by 王师傅 Mac on 2023/6/3.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    NewDetailShoe,
    NewDetailDress,
    NewDetailComponent,
} NewDetailType;


@interface ApplyShoesViewController : BaseViewController
@property (retain, nonatomic) IBOutlet UIButton *addBtn;
@property (retain, nonatomic) IBOutlet UILabel *totalLab;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NewDetailType detailType;
@property (nonatomic, strong) NSDictionary* dict;
@property (nonatomic, assign) BOOL isNormalShoe;
@property (nonatomic, strong) NSArray* picArr;
@property (nonatomic, strong) NSString* folderName;


@end

NS_ASSUME_NONNULL_END
