//
//  MNNoteDetailController.m
//  MyNote
//
//  Created by Tatsuya Fukata on 1/23/16.
//  Copyright © 2016 fukata. All rights reserved.
//

#import "MNNoteDetailController.h"
#import "MNDatabase.h"

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
  
    _textView = [[UITextView alloc] init];
    self.view = _textView;
    self.view.autoresizesSubviews = YES;
}

- (void) saveNoteDidTouchDown {
    NSLog(@"MNNoteDetailController.saveNoteDidTouchDown");
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    switch (_editMode) {
        case MN_NOTE_EDIT_MODE_ADD:
            [data setObject:[_textView text] forKey:@"content"];
            NSInteger rowId = [[MNDatabase getSHaredInstance] insertData:MN_TABLE_NOTES :data];
            if (rowId > 0) {
                NSLog(@"Successful");
                [self setEditMode:MN_NOTE_EDIT_MODE_EDIT];
                [self setNoteId:rowId];
            } else {
                NSLog(@"Failed");
            }
            
            break;
        case MN_NOTE_EDIT_MODE_EDIT:
            break;
        default:
            break;
    }
}

- (void) setEditMode:(NSInteger)editMode {
    _editMode = editMode;
}

- (void) setNoteId:(NSInteger)noteId {
    _noteId = noteId;
}

@end