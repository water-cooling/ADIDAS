//
//  AddProductViewController.h
//  ADIDAS
//
//  Created by 桂康 on 2016/12/19.
//
//

#import "BaseViewController.h"

@protocol CompeleteDelegate <NSObject>

- (void)refreshList ;

@end

@interface AddProductViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

/**
 *完成后刷新数据
 */
@property (assign, nonatomic) id<CompeleteDelegate> delegate ;


/*
 *用于显示的数据数组
 */
@property (strong, nonatomic) NSArray *dataAry ;

/*
 *用于显示的view数组
 */
@property (strong, nonatomic) NSArray *viewAry ;


/*
 *全部的view数组
 */
@property (strong, nonatomic) NSArray *totalViewAry ;

/*
 *全部的数据数组
 */
@property (strong, nonatomic) NSArray *totalOriginAry ;

/*
 *判断是否显示左上角的返回按钮 (只有一个可编辑的detailview，下面没有东西)
 */
@property (assign, nonatomic) BOOL isShowBack ;

/*
 *用于判断是否查看详情还是编辑（2 什么都没有  1 显示完成申请单 不传值 显示上传和保存）
 */
@property (strong, nonatomic) NSString *showOperate ;

/*
 *当前的单号，判断是新建还是历史单
 */
@property (strong, nonnull) NSString *caseNumber ;

/*
 *当前的图片文件夹名称，判断新建文件夹还是老文件
 */
@property (strong, nonatomic) NSString *folderString ;

@property (strong, nonatomic) NSString *caseStatus ;

@property (retain, nonatomic) IBOutlet UITableView *ProductTableView;


@end
