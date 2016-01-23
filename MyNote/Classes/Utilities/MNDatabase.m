//
//  MNDatabase.m
//  MyNote
//
//  Created by Tatsuya Fukata on 1/23/16.
//  Copyright © 2016 fukata. All rights reserved.
//

#import "MNDatabase.h" 

static MNDatabase *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation MNDatabase

+(MNDatabase*) getSHaredInstance {
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL] init];
        BOOL created = [sharedInstance createDb];
        if (!created) {
            NSLog(@"Failed create database.");
        }
    }
    return sharedInstance;
}

-(BOOL) createDb {
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"mynote.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
    if ([filemgr fileExistsAtPath: databasePath ] == NO) {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
            char *errMsg;
            const char *sql_stmt = "create table if not exists notes (id integer primary key, content text);";
            if (sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
    }
    return isSuccess;
}

- (BOOL) insertData: (NSString *)tableName :(NSMutableDictionary *)data {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK) {
        NSArray *keys = [data allKeys];
        NSString *keysStr = [[data allKeys] componentsJoinedByString:@", "];
        NSString *valuesStr = @"";
        for (int i=0; i<keys.count; i++) {
            if (i > 0) {
                valuesStr = [valuesStr stringByAppendingString:@","];
            }
            NSString *key = keys[i];
            valuesStr = [valuesStr stringByAppendingString:[NSString stringWithFormat:@"\"%@\"", data[key]]];
        }
        
        NSString *insertSql = [NSString stringWithFormat:@"insert into %@ (%@) values (%@);", tableName, keysStr, valuesStr];
        NSLog(@"sql=%@", insertSql);
        
        const char *insert_stmt = [insertSql UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE) {
            sqlite3_reset(statement);
            sqlite3_close(database);
            return YES;
        } else {
            NSString *errorMessage = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_errmsg(database)];
            NSLog(@"error=%@", errorMessage);
            sqlite3_reset(statement);
            sqlite3_close(database);
            return NO;
        }
    }
    return NO;
}

- (BOOL) updateData:(NSString *)tableName :(NSInteger)dataId :(NSMutableDictionary *)data {
    return NO;
}

- (BOOL) deleteData:(NSString *)tableName :(NSInteger)dataId {
    return NO;
}

- (NSArray *) findData:(NSString *)tableName {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"select * from %@", tableName];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *results = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            int columnCount = sqlite3_column_count(statement);
            while (sqlite3_step(statement) == SQLITE_ROW) {
                NSMutableDictionary *row = [[NSMutableDictionary alloc] init];
                for (int i=0; i<columnCount; i++) {
                    NSString *columnName = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_name(statement, i)];
                    const char *rawValue = (const char *) sqlite3_column_text(statement, i);
                    if (rawValue != NULL) {
                        NSString *value = [[NSString alloc] initWithUTF8String: (const char *) sqlite3_column_text(statement, i)];
                        [row setObject:value forKey:columnName];
                    }
                }
               
                [results addObject:row];
            }
            sqlite3_reset(statement);
        }
        sqlite3_close(database);
        return results;
    }
    return nil;
}

- (NSArray *) findDataWithId:(NSString *)tableName :(NSInteger *)dataId {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"select * from %@", tableName];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                NSString *name = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:name];
                NSString *department = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 1)];
                [resultArray addObject:department];
                NSString *year = [[NSString alloc]initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 2)];
                [resultArray addObject:year];
                return resultArray;
            } else {
                NSLog(@"Not found");
                return nil;
            }
            sqlite3_reset(statement);
        }
    }
    return nil;
}
@end