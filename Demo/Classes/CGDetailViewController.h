//
//  CGDetailViewController.h
//  iCalToDo
//
//  Created by Satoshi Konno on 11/05/16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGICalendar.h"

@class CGDetailViewController;

@protocol CGDetailViewControllerDelegate <NSObject>

@required
- (void)icalTodoDetailViewController:(CGDetailViewController *)icalTodoDetailViewController didFinished:(CGICalendarComponent *)todo;
- (void)icalTodoDetailViewController:(CGDetailViewController *)icalTodoDetailViewController didCanceled:(CGICalendarComponent *)todo;

@end

@interface CGDetailViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) CGICalendarComponent *todo;
@property (nonatomic, strong) id<CGDetailViewControllerDelegate> delegate;
@property (nonatomic, strong) UITextField *summaryField;
@property (nonatomic, strong) UITextView *descField;
@property (nonatomic, assign, getter = isModalMode) BOOL modalMode;

- (id)initWithTodo:(CGICalendarComponent *)aTodo;

@end
