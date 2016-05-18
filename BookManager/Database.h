//
//  Database.h
//  Phillips
//
//  Created by Nguyen Nang on 1/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Database : NSObject {
    sqlite3 *database;
	NSString *databasePath;
    //NSString *attachPath;
    
	NSMutableArray *resultArray; 
    NSString *sqlQuery;
}

@property (nonatomic,readonly) NSMutableArray *resultArray;
@property (nonatomic,copy) NSString *sqlQuery;

// Open and close methods
- (BOOL)connectToDatabase:(NSString *)dbName ofType:(NSString *) ofType;
- (BOOL)connectToBundleDatabase:(NSString *)dbName ofType:(NSString *) ofType;
- (BOOL)close;
- (void)copyDatabaseIfNeeded:(NSString *)dbName ofType:(NSString *) ofType;     // Copy database file from bundle path to application's document path

- (void)runSQL;
- (void)excuteQueryInsertOrUpdate;
- (void)selectTableBook;
@end
