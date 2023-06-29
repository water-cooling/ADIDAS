//
//  InstallScoreEntity.m
//  ADIDAS
//
//  Created by wendy on 14-5-16.
//
//

#import "InstallScoreEntity.h"

@implementation InstallScoreEntity

@synthesize remark,photoPath,popID,Campaign_install_id;

-(id) initWithFMResultSet:(FMResultSet*)rs
{
	if(self = [super init])
	{
        self.remark = [rs stringForColumnIndex:7];
        self.photoPath = [rs stringForColumnIndex:3];
        self.popID = [rs stringForColumnIndex:0];
        self.Campaign_install_id = [rs stringForColumnIndex:1];
	}
	return self;
}

@end
