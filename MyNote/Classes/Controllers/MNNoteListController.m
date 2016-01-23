//
//  MNNoteListController.m
//  MyNote
//
//  Created by Tatsuya Fukata on 1/23/16.
//  Copyright © 2016 fukata. All rights reserved.
//

#import "MNNoteListController.h"
#import "MNNoteDetailController.h"

@implementation MNNoteListController


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"MNNoteListController.viewDidLoad");
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"MNNoteListController.viewWillAppear");
    [self.navigationItem setTitle:@"MyNote"];
    
    NSMutableArray<UIBarButtonItem *> *rightItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *addNoteButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addNoteDidTouchDown)];
    [rightItems addObject:addNoteButtonItem];
    [self.navigationItem setRightBarButtonItems:rightItems animated:YES];
    
    UITableView *tableView = [[UITableView alloc] init];
    self.view = tableView;
    self.view.autoresizesSubviews = YES;
}

- (void)addNoteDidTouchDown {
    NSLog(@"MNNoteListController.addNoteDidTouchDown");
    MNNoteDetailController *c = [[MNNoteDetailController alloc] init];
    [c setEditMode:MN_NOTE_EDIT_MODE_ADD];
    [[self navigationController] pushViewController:c animated:YES];
}
@end