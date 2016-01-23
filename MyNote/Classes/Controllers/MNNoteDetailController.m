//
//  MNNoteDetailController.m
//  MyNote
//
//  Created by Tatsuya Fukata on 1/23/16.
//  Copyright © 2016 fukata. All rights reserved.
//

#import "MNNoteDetailController.h"

@implementation MNNoteDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"MNNoteDetailController.viewDidLoad");
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"MNNoteDetailController.viewWillAppear");
    switch (_editMode) {
        case MN_NOTE_EDIT_MODE_ADD:
            [self.navigationItem setTitle:@"Add"];
            break;
        case MN_NOTE_EDIT_MODE_EDIT:
            [self.navigationItem setTitle:@"Edit"];
            break;
        case MN_NOTE_EDIT_MODE_SHOW:
            [self.navigationItem setTitle:@"Show"];
            break;
        default:
            NSLog(@"Invalid edit mode.");
            break;
    }
    
    NSMutableArray<UIBarButtonItem *> *rightItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *saveNoteButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveNoteDidTouchDown)];
    [rightItems addObject:saveNoteButtonItem];
    [self.navigationItem setRightBarButtonItems:rightItems animated:YES];
  
    UITextView *textView = [[UITextView alloc] init];
    self.view = textView;
    self.view.autoresizesSubviews = YES;
}

- (void) saveNoteDidTouchDown {
    NSLog(@"MNNoteDetailController.saveNoteDidTouchDown");
}

- (void) setEditMode:(NSInteger)editMode {
    _editMode = editMode;
}

- (void) setNoteId:(NSInteger)noteId {
    _noteId = noteId;
}

@end