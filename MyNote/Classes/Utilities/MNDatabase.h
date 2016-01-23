//
//  MNDatabase.h
//  MyNote
//
//  Created by Tatsuya Fukata on 1/23/16.
//  Copyright © 2016 fukata. All rights reserved.
//

#ifndef MNDatabase_h
#define MNDatabase_h

#define MN_TABLE_NOTES @"notes"

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface MNDatabase : NSObject {
    NSString *databasePath;
}

+(MNDatabase*) getSHaredInstance;
-(BOOL) createDb;
-(NSInteger) insertData:(NSString *) tableName :(NSMutableDictionary *) data;
-(BOOL) updateData:(NSString *) tableName :(NSInteger) dataId :(NSMutableDictionary *) data;
-(BOOL) deleteData:(NSString *) tableName :(NSInteger) dataId;
-(NSArray*) findData:(NSString *) tableName;
-(NSDictionary*) findDataWithId:(NSString *) tableName :(NSInteger)dataId;

@end


#endif /* MNDatabase_h */
