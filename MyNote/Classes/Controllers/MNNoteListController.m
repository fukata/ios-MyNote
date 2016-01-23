//
//  MNNoteListController.m
//  MyNote
//
//  Created by Tatsuya Fukata on 1/23/16.
//  Copyright © 2016 fukata. All rights reserved.
//

#import "MNNoteListController.h"
#import "MNNoteDetailController.h"
#import "MNDatabase.h"

@implementation MNNoteListController


- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"MNNoteListController.viewDidLoad");
    _items = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"MNNoteListController.viewWillAppear");
    [self.navigationItem setTitle:@"MyNote"];
    
    NSMutableArray<UIBarButtonItem *> *rightItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *addNoteButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addNoteDidTouchDown)];
    [rightItems addObject:addNoteButtonItem];
    [self.navigationItem setRightBarButtonItems:rightItems animated:YES];
    
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.view = _tableView;
    self.view.autoresizesSubviews = YES;
    
    [self loadData];
}

- (void)addNoteDidTouchDown {
    NSLog(@"MNNoteListController.addNoteDidTouchDown");
    MNNoteDetailController *c = [[MNNoteDetailController alloc] init];
    [c setEditMode:MN_NOTE_EDIT_MODE_ADD];
    [[self navigationController] pushViewController:c animated:YES];
}

- (void)loadData {
    NSLog(@"MNNoteListController.loadData");
    NSArray *items = [[MNDatabase getSHaredInstance] findData:MN_TABLE_NOTES];
    [_items removeAllObjects];
    for (int i=0; i<items.count; i++) {
        [_items addObject:[items objectAtIndex:i]];
    }
   
    NSLog(@"items=%lu", (unsigned long)_items.count);
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *identifier = @"notes";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSMutableDictionary *data = [_items objectAtIndex:indexPath.row];
    cell.textLabel.text = data[@"content"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MNNoteDetailController *c = [[MNNoteDetailController alloc] init];
    NSMutableDictionary *data = [_items objectAtIndex:indexPath.row];
    [c setEditMode:MN_NOTE_EDIT_MODE_EDIT];
    [c setNoteId:[data[@"id"] integerValue]];
    [[self navigationController] pushViewController:c animated:YES];   
}

@end