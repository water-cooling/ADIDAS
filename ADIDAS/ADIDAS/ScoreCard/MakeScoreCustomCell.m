//
//  MakeScoreCustomCell.m
//  MobileApp
//
//  Created by 桂康 on 2017/11/28.
//

#import "MakeScoreCustomCell.h"
#import "SqliteHelper.h"
#import "Utilities.h"
#import "CommonDefine.h"
#import "CacheManagement.h"

@implementation MakeScoreCustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.remarkTextView.delegate = self ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)leftAction:(id)sender {
    
    self.buttonType = self.scoreLabel.text  ;
    [self.remarkTextView resignFirstResponder];
    [self.leftButton setBackgroundImage:ISKIDS?[UIImage imageNamed:@"formorange2.png"]:[UIImage imageNamed:@"form2.png"] forState:UIControlStateNormal];
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
    
    if (![self getScoreCardItem]) {
        
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_SCORECARD_ITEM_DETAIL (SCORECARD_CHECK_PHOTO_ID,SCORECARD_ITEM_DETAIL_ID,STANDARD_SCORE,REMARK,SCORECARD_ITEM_ID) values (?,?,?,?,?)"];
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         self.scoreCardCheckPhotoId,
         self.ScoreCardItemDetailId,
         self.scoreLabel.text,
         self.remarkTextView.text,
         self.ScoreCardItemId];
    }
    else {
        
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        NSString* sql_ = [NSString stringWithFormat:@"UPDATE NVM_IST_SCORECARD_ITEM_DETAIL SET STANDARD_SCORE = '%@' where SCORECARD_CHECK_PHOTO_ID = '%@' and SCORECARD_ITEM_DETAIL_ID = '%@' and SCORECARD_ITEM_ID = '%@' ",self.scoreLabel.text,self.scoreCardCheckPhotoId,self.ScoreCardItemDetailId,self.ScoreCardItemId] ;
        
        [db executeUpdate:sql_];
    }
}

- (IBAction)rightAction:(id)sender {
    
    self.buttonType = @"0" ;
    if([self.remarkTextView.text isEqualToString:@""]) [self.remarkTextView becomeFirstResponder];
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"form1.png"] forState:UIControlStateNormal];
    [self.rightButton setBackgroundImage:ISKIDS?[UIImage imageNamed:@"formorange2.png"]:[UIImage imageNamed:@"form2.png"] forState:UIControlStateNormal];
    
    if (![self getScoreCardItem]) {
        
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_SCORECARD_ITEM_DETAIL (SCORECARD_CHECK_PHOTO_ID,SCORECARD_ITEM_DETAIL_ID,STANDARD_SCORE,REMARK,SCORECARD_ITEM_ID) values (?,?,?,?,?)"];
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
         self.scoreCardCheckPhotoId,
         self.ScoreCardItemDetailId,
         @"0",
         self.remarkTextView.text,
         self.ScoreCardItemId];
    }
    else {
        
        FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
        NSString* sql_ = [NSString stringWithFormat:@"UPDATE NVM_IST_SCORECARD_ITEM_DETAIL SET STANDARD_SCORE = '0' ,REMARK = '%@' where SCORECARD_CHECK_PHOTO_ID = '%@' and SCORECARD_ITEM_DETAIL_ID = '%@' and SCORECARD_ITEM_ID = '%@' ",self.remarkTextView.text,self.scoreCardCheckPhotoId,self.ScoreCardItemDetailId,self.ScoreCardItemId] ;
        
        [db executeUpdate:sql_];
    }
}


- (void)setScoreCardCheckPhotoId:(NSString *)scoreCardCheckPhotoId {
    
    self.remarkTextView.delegate = self ;
    _scoreCardCheckPhotoId = scoreCardCheckPhotoId ;
    
    VmScoreCardScoreEntity *entity = [self getScoreCardItem];
    
    if (entity) {
        
        if (entity.STANDARD_SCORE&&![entity.STANDARD_SCORE isEqual:[NSNull null]]) {
            
            if ([entity.STANDARD_SCORE isEqualToString:self.scoreLabel.text]) {
                
                self.buttonType = self.scoreLabel.text ;
                [self.leftButton setBackgroundImage:ISKIDS?[UIImage imageNamed:@"formorange2.png"]:[UIImage imageNamed:@"form2.png"] forState:UIControlStateNormal];
            }
            if ([entity.STANDARD_SCORE isEqualToString:@"0"]) {
                
                self.buttonType = @"0" ;
                [self.rightButton setBackgroundImage:ISKIDS?[UIImage imageNamed:@"formorange2.png"]:[UIImage imageNamed:@"form2.png"] forState:UIControlStateNormal];
            }
        }
        
        self.remarkTextView.text = entity.REMARK ;
    }
    else if ([self.scoredArray count]) {
        
        for (NSDictionary *score in self.scoredArray) {
            
            BOOL isSave = false ;
            NSString *saveScore = @"" ;
            if ([[score valueForKey:@"SCORECARD_ITEM_DETAIL_ID"] isEqualToString:self.ScoreCardItemDetailId]) {
                
                if ([score valueForKey:@"COMMENT"]&&![[score valueForKey:@"COMMENT"] isEqual:[NSNull null]]&&![[score valueForKey:@"COMMENT"] isEqual:@""]) {
                    
                    self.remarkTextView.text = [score valueForKey:@"COMMENT"] ;
                    isSave = YES ;
                }
                
                if ([score valueForKey:@"SCORE"]&&![[score valueForKey:@"SCORE"] isEqual:[NSNull null]]) {
                    
                    if ([[score valueForKey:@"SCORE"] isEqual:self.scoreLabel.text]) {
                        
                        self.buttonType = self.scoreLabel.text ;
                        [self.leftButton setBackgroundImage:ISKIDS?[UIImage imageNamed:@"formorange2.png"]:[UIImage imageNamed:@"form2.png"] forState:UIControlStateNormal];
                        saveScore = [score valueForKey:@"SCORE"] ;
                        isSave = YES ;
                    }
                    
                    if ([[score valueForKey:@"SCORE"] isEqual:@"0"]) {
                        
                        self.buttonType = @"0" ;
                        [self.rightButton setBackgroundImage:ISKIDS?[UIImage imageNamed:@"formorange2.png"]:[UIImage imageNamed:@"form2.png"] forState:UIControlStateNormal];
                        saveScore = [score valueForKey:@"SCORE"] ;
                        isSave = YES ;
                    }
                    
                }
                
                if (isSave) {
                    
                    NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_SCORECARD_ITEM_DETAIL (SCORECARD_CHECK_PHOTO_ID,SCORECARD_ITEM_DETAIL_ID,STANDARD_SCORE,REMARK,SCORECARD_ITEM_ID) values (?,?,?,?,?)"];
                    FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
                    [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
                     self.scoreCardCheckPhotoId,
                     self.ScoreCardItemDetailId,
                     saveScore,
                     self.remarkTextView.text,
                     self.ScoreCardItemId];
                }
            }
            
        }
    }
    
    if ([self.remarkTextView.text isEqualToString:@""]) {
        
        self.showLabel.hidden = NO ;
    }
    else self.showLabel.hidden = YES ;

}

- (void)textViewDidChange:(UITextView *)textView {
    
    if (textView.text.length == 0) {
        
        self.showLabel.hidden = NO;
    }
    else{
        
        self.showLabel.hidden = YES;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (self.buttonType&&([self.buttonType isEqualToString:self.scoreLabel.text]||[self.buttonType isEqualToString:@"0"])) {
        
        if (![self getScoreCardItem]) {
            
            NSString *sql = [NSString stringWithFormat:@"INSERT INTO NVM_IST_SCORECARD_ITEM_DETAIL (SCORECARD_CHECK_PHOTO_ID,SCORECARD_ITEM_DETAIL_ID,STANDARD_SCORE,REMARK,SCORECARD_ITEM_ID) values (?,?,?,?,?)"];
            FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
            [[SqliteHelper shareCommonSqliteHelper]executeSQL:db SqlString:sql,
             self.scoreCardCheckPhotoId,
             self.ScoreCardItemDetailId,
             self.buttonType,
             self.remarkTextView.text,
             self.ScoreCardItemId];
        }
        else {
            
            FMDatabase* db = [SqliteHelper shareCommonSqliteHelper].database;
            NSString* sql_ = [NSString stringWithFormat:@"UPDATE NVM_IST_SCORECARD_ITEM_DETAIL SET REMARK = '%@' ,STANDARD_SCORE ='%@'  where SCORECARD_CHECK_PHOTO_ID = '%@' and SCORECARD_ITEM_DETAIL_ID = '%@'  and SCORECARD_ITEM_ID = '%@' ",self.remarkTextView.text,self.buttonType,self.scoreCardCheckPhotoId,self.ScoreCardItemDetailId,self.ScoreCardItemId] ;
            
            [db executeUpdate:sql_];
        }
    }
}


- (VmScoreCardScoreEntity *)getScoreCardItem {
    
    VmScoreCardScoreEntity *entity = nil ;
    
    NSString *sql = [NSString stringWithFormat:@"Select * FROM NVM_IST_SCORECARD_ITEM_DETAIL where SCORECARD_CHECK_PHOTO_ID = '%@' and SCORECARD_ITEM_DETAIL_ID = '%@' and SCORECARD_ITEM_ID = '%@' ",self.scoreCardCheckPhotoId,self.ScoreCardItemDetailId,self.ScoreCardItemId];
    
    FMResultSet *rs = nil;
    @try
    {
        rs = [[SqliteHelper shareCommonSqliteHelper] selectResult:sql];
        while ([rs next])
        {
            entity = [[VmScoreCardScoreEntity alloc] initWithFMResultSet:rs];
            break ;
        }
    }
    @catch (NSException *e)
    {
        @throw e;
    }
    @finally
    {
        if (rs)[rs close];
    }
    
    return  entity;
}

@end















