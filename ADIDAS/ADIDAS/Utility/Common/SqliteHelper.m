    //
//  SqliteHelper.m
//  WSE
//
//  Created by  on 11-11-29.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SqliteHelper.h"
#import "Utilities.h"
#import "CacheManagement.h"
#import "CommonDefine.h"

@implementation SqliteHelper

static SqliteHelper *_sharedCommonSqliteHelper = nil;

+ (SqliteHelper *)shareCommonSqliteHelper {
	@synchronized(self) {
		if (_sharedCommonSqliteHelper == nil) {
			_sharedCommonSqliteHelper = [[self alloc] init]; // assignment not done here
		}
		return _sharedCommonSqliteHelper;
	}
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (_sharedCommonSqliteHelper == nil) {
			_sharedCommonSqliteHelper = [super allocWithZone:zone];
			return _sharedCommonSqliteHelper; //assignmentandreturnonfirstallocation
		}
	}
	return nil; 	
}

- (id)copyWithZone:(NSZone *)zone {
	return self;
}

- (id)retain {
	return self;
}

- (unsigned)retainCount {
	return UINT_MAX;
}

- (oneway void)release {
	
}

- (id)autorelease {
	return self;
}


- (id)init {
    if (self = [super init]) 
    {
        BOOL success;
        NSError *error;
        NSFileManager *fm = [NSFileManager defaultManager];
        NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        // 数据库
        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"adidas.db"];
        NSLog(@"%@",writableDBPath);
        //Sqlite 文件是否存在
        success = [fm fileExistsAtPath:writableDBPath];
        
        if (success) {
            @try {
                NSDictionary *version = [NSDictionary dictionaryWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:kDBVERSION]];
                if (version&&![[NSString stringWithFormat:@"%@",[version valueForKey:@"version"]] isEqualToString:[NSString stringWithFormat:@"%d",kDBVERSIONNUMBER]]) {
                    [fm removeItemAtPath:writableDBPath error:nil];
                    success = NO ;
                }
            } @catch (NSException *exception) {
            }
        }
        
        if(!success)
        {   //DB不存在，创建新的DB文件
            NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"adidas.db"];
            success = [fm copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
            if(!success)
            {
                NSLog(@"%@",[error localizedDescription]);
            }
            else 
            {
                NSString *iOSVersion = [NSString stringWithFormat:@"%@",[CacheManagement instance].currentiOSVersion];
                //修改文件属性
                [Utilities addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:writableDBPath] iOSVersion:iOSVersion];
                
                _database = [[FMDatabase databaseWithPath:writableDBPath] retain];
                //For Debug
                [_database setLogsErrors:TRUE];
                [_database setTraceExecution:TRUE];
                if ([_database open]) 
                {
                    [_database setShouldCacheStatements:YES];
                    
                    @try {
                        NSMutableDictionary *version = [NSMutableDictionary dictionaryWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:kDBVERSION]];
                        if (!version) version = [NSMutableDictionary dictionary];
                        [version setValue:[NSString stringWithFormat:@"%d",kDBVERSIONNUMBER] forKey:@"version"] ;
                        [version writeToFile:[documentsDirectory stringByAppendingPathComponent:kDBVERSION] atomically:YES];
                    } @catch (NSException *exception) {
                    }
                } else {
                    NSLog(@"Failed to open database.");
                }
            }
            success = NO;
        }
        if(success){
            _database = [[FMDatabase databaseWithPath:writableDBPath] retain];
            //For Debug
            [_database setLogsErrors:TRUE];
            [_database setTraceExecution:TRUE];
            if ([_database open]) {    //打开DB
                [_database setShouldCacheStatements:YES];
                
                @try {
                    NSMutableDictionary *version = [NSMutableDictionary dictionaryWithContentsOfFile:[documentsDirectory stringByAppendingPathComponent:kDBVERSION]];
                    if (!version){
                        version = [NSMutableDictionary dictionary];
                        [version setValue:[NSString stringWithFormat:@"%d",kDBVERSIONNUMBER] forKey:@"version"] ;
                        [version writeToFile:[documentsDirectory stringByAppendingPathComponent:kDBVERSION] atomically:YES];
                    }
                } @catch (NSException *exception) {
                }
            } else {
                NSLog(@"Failed to open database.");
            }
        }

    }
    return self;
}

- (FMDatabase *) database
{
    
    return _database; 
}

- (BOOL)executeSQL:(NSString*)sql, ... {
	
	va_list args;
    va_start(args, sql);    

//	BOOL result = [_database executeUpdate:sql error:nil withArgumentsInArray:nil orVAList:args];
    
   BOOL result = [_database executeUpdate:sql withArgumentsInArray:nil];
    
	
	if ([_database hadError])
	{
		NSLog(@"Err %d: %@", [_database lastErrorCode], [_database lastErrorMessage]);
	}
	
	va_end(args);
    
	
	//int result = [db changes];
	
	//if ([db hadError]) {
    //NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
	/*	NSException *dbException = [NSException									
     exceptionWithName:@"DBExecuteException"									
     reason:[db lastErrorMessage]									
     userInfo:nil];
     */	
	//	@throw dbException;
	//}
	//if(result>0)
	//	return YES;
	//return NO;
	
	return result;
}


-(BOOL)executeSQL:(FMDatabase *) fmDB SqlString:(NSString *)sql,...
{
	va_list args;
    va_start(args, sql);    
//	BOOL result = [fmDB executeUpdate:sql error:nil withArgumentsInArray:nil orVAList:args];
	 BOOL result = [_database executeUpdate:sql withVAListArray:args];

    
	if ([fmDB hadError])
	{
		NSLog(@"Err %d: %@", [fmDB lastErrorCode], [fmDB lastErrorMessage]);
	}
	
	va_end(args);
	return result;
}




- (FMResultSet *)selectResult:(NSString *)sql {

	FMResultSet *rs = [_database executeQuery:sql];
	
	if ([_database hadError]) {
		//NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
		NSException *dbException = [NSException									
									exceptionWithName:@"DBExecuteException"									
									reason:[_database lastErrorMessage]									
									userInfo:nil];
		
		@throw dbException; 
		
	}
	
	return rs;
	
}

- (void) dealloc {
    if (_database) {
        [_database close];
        [_database release];
    }
	[super dealloc];
	
}

@end
