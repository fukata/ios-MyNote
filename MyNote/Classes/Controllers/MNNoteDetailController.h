//
//  MNNoteDetailController.h
//  MyNote
//
//  Created by Tatsuya Fukata on 1/23/16.
//  Copyright © 2016 fukata. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef MNNoteDetailController_h
#define MNNoteDetailController_h

#define MN_NOTE_EDIT_MODE_ADD 1
#define MN_NOTE_EDIT_MODE_EDIT 2
#define MN_NOTE_EDIT_MODE_SHOW 3

@interface MNNoteDetailController : UIViewController

@property (nonatomic) NSInteger editMode;
@property (nonatomic) NSInteger noteId;

- (void) setEditMode:(NSInteger)editMode;
- (void) setNoteId:(NSInteger)noteId;

@end

#endif /* MNNoteDetailController_h */