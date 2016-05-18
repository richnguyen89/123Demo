//
//  Database.m
//  Phillips
//
//  Created by Nguyen Nang on 1/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Database.h"

@implementation Database

@synthesize resultArray;
@synthesize sqlQuery;

#pragma mark -
#pragma mark init and dealloc

- (id)init
{
    self = [super init];
    if (self) {
 		database = NULL;
        resultArray = [[NSMutableArray alloc] initWithCapacity:10];
	}
	return self;
}

//- (void)dealloc
//{
//    [resultArray removeAllObjects];
//	[resultArray release];
//    [databasePath release];
//    [sqlQuery release];
//	[super dealloc];
//}

#pragma mark -
#pragma mark open and close

- (BOOL)connectToDatabase:(NSString *)dbName ofType:(NSString *) ofType
{
	
	[self copyDatabaseIfNeeded:dbName ofType:ofType];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
	NSString *localDatabasePath = [documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",dbName,ofType]];
	NSLog(@"localDatabasePath %@",localDatabasePath);
	if(!database)
	{
		databasePath = [[NSString alloc] initWithString:localDatabasePath];
        
		return YES;
	}
	return YES;
}

- (BOOL)connectToBundleDatabase:(NSString *)dbName ofType:(NSString *) ofType
{
	
    NSString *bundleDatabasePath = [[NSBundle mainBundle] pathForResource:dbName ofType:ofType];  
	
	if(!database)
	{
		databasePath = [[NSString alloc] initWithString:bundleDatabasePath];
        
		return YES;
	}
	return YES;
}

- (BOOL)close
{
	if(database)
	{
		if( sqlite3_close(database) == SQLITE_OK )
		{
			return YES;
		}
		
		return NO;
	}
	
	return YES;
}

- (void)copyDatabaseIfNeeded:(NSString *)dbName ofType:(NSString *) ofType
{
	NSString *appDatabasePath = [[NSBundle mainBundle] pathForResource:dbName ofType:ofType];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectoryPath = [paths objectAtIndex:0];
	NSString *localDatabasePath = [documentsDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",dbName,ofType]];
	if(![[NSFileManager defaultManager] fileExistsAtPath:localDatabasePath])
	{
        [[NSFileManager defaultManager] copyItemAtPath:appDatabasePath toPath:localDatabasePath error:nil];
	}
    
}

#pragma mark -
#pragma mark SQL execute

-(void) runSQL {
	// Setup the database object
	//sqlite3 *database;
	
	[self.resultArray removeAllObjects];
	
	
    //NSLog(@"databasePath = %@", databasePath);
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        /*
        if (attachPath) {
            const char *sqlStatement = [[NSString stringWithFormat:@"ATTACH DATABASE '%@' as attachDB",attachPath] UTF8String];
            sqlite3_stmt *compiledStatement;
            if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
                while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
                }
            }
        }
         */
		
		// Setup the SQL Statement and compile it for faster access
        //NSLog(@"sqlQuery = %@",self.sqlQuery);
		const char *sqlStatement = [self.sqlQuery UTF8String];
        sqlite3_stmt *compiledStatement;
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// Read the data from the result row
				
				int cnt = sqlite3_column_count(compiledStatement);
				
				NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];
				
				for (int i = 0;i < cnt;i++) {   //Get each column
                    
					NSString *col_name = [NSString stringWithUTF8String:(const char *)sqlite3_column_name(compiledStatement, i)];
                    
                    NSString *col_value;
                    
                    
					switch (sqlite3_column_type(compiledStatement, i)) {
						case SQLITE_NULL:
							col_value = @"";
							break;
						case SQLITE_TEXT: {
							const unsigned char *chars = sqlite3_column_text(compiledStatement, i);
							if (chars == NULL)
								col_value = nil;
							else {
 								col_value = [NSString stringWithUTF8String:(const char *)chars];
                            }
							
							break;
                        }
						case SQLITE_INTEGER:
							col_value = [NSString stringWithFormat:@"%d",sqlite3_column_int(compiledStatement, i)];
							break;
						case SQLITE_FLOAT:
							col_value = [NSString stringWithFormat:@"%f",sqlite3_column_double(compiledStatement, i)];
							break;
						default:
							col_value = @"";
							break;
					}
					[dict setValue:[NSString stringWithString:col_value] forKey:[NSString stringWithString:col_name]];
 				}
				
				[self.resultArray addObject:dict];
			}
            
            
        }
		// Release the compiled statement from memory
        sqlite3_reset(compiledStatement);
		sqlite3_finalize(compiledStatement);
		
	} 
	sqlite3_close(database);
	
	
}
-(void)excuteQueryInsertOrUpdate
{
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        sqlite3_exec(database,
				 [self.sqlQuery UTF8String],
				 NULL, NULL, NULL);
    }
    sqlite3_close(database);
}

-(void)selectTableBook
{
    [self connectToDatabase:@"Book" ofType:@"db"];
    self.sqlQuery = [NSString stringWithFormat:@"SELECT * FROM tbl_book"];
    [self runSQL];
    [self close];
}
@end
