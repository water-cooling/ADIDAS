//
//  SqliteHelper.h
//  WSE
//
//  Created by  on 11-11-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FMDatabase.h"

@interface SqliteHelper : NSObject {
    
    @private 
    FMDatabase *_database;
}


+ (SqliteHelper *)shareCommonSqliteHelper;

- (FMDatabase *) database;
- (BOOL)executeSQL:(NSString *)sql,...;
- (BOOL)executeSQL:(FMDatabase *) fmDB SqlString:(NSString *)sql,...;
- (FMResultSet *)selectResult:(NSString *)sql;

@end
