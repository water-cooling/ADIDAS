//
//  RailManageViewController.h
//  ADIDAS
//
//  Created by wendy on 14-4-23.
//
//

#import <UIKit/UIKit.h>
#import "RailManageTableViewCell.h"
#import "UploadManagement.h"
#import "FilterView.h"
#import "XMLWriter.h"
#import "ManageScoreEntity.h"

@interface RailManageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UploadManagementDelegate>
{
    UITableView* railmanageTableView;
    UploadManagement* uploadManage;
    
}
@property (strong,nonatomic) ManageScoreEntity* CurrentmanageResultEntity;
@property (strong,nonatomic) NSString* item_id;

@property (strong,nonatomic) UITableView* railmanageTableView;
@property (strong,nonatomic) ASIFormDataRequest* request;
@property (strong,nonatomic) NSMutableArray* lastScoreArray;
@property (assign,nonatomic) NSInteger Y_num;
@property (assign,nonatomic) NSInteger N_num;
@property (assign,nonatomic) NSInteger NA_num;
@property (assign,nonatomic) NSInteger TOTAL_num;

//@property (strong,nonatomic) NSMutableArray* railmanageIssueList;

@property (strong,nonatomic) UILabel* textlabel;
@property (strong,nonatomic) NSMutableArray* resultArr;
@property (strong,nonatomic) UploadManagement* uploadManage;
@property (strong,nonatomic) NSMutableArray* resultPicArr;
@property (assign,nonatomic) NSInteger totalScore;
@property (strong,nonatomic) NSMutableArray* resultPicNameArr;
@property (strong,nonatomic) FilterView* filterview;


@property (strong,nonatomic) UIButton* totalScoreButton;
@property (strong,nonatomic) UIButton* YButton;
@property (strong,nonatomic) UIButton* NButton;
@property (strong,nonatomic) UIButton* NAButton;

@property (strong,nonatomic) NSMutableArray* FilterArrY;
@property (strong,nonatomic) NSMutableArray* FilterArrN;
@property (strong,nonatomic) NSMutableArray* FilterArrNA;

@property (strong,nonatomic) NSMutableArray* tableviewSourceArr;

@property (assign) NSInteger rowNumber;


@property (strong,nonatomic) UIProgressView* progressview;

@end
