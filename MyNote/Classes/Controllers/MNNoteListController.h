//
//  MNNoteListController.h
//  MyNote
//
//  Created by Tatsuya Fukata on 1/23/16.
//  Copyright © 2016 fukata. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef MNNoteListController_h
#define MNNoteListController_h

@interface MNNoteListController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) UITableView *tableView;

@end

#endif /* MNNoteListController_h */
