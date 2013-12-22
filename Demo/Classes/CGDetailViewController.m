//
//  CGDetailViewController.m
//  iCalToDo
//
//  Created by Satoshi Konno on 11/05/16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CGDetailViewController.h"

enum {
CGICALTODO_DETAILVIEWCONTROLLER_SECTION_SUMMARY = 0,
CGICALTODO_DETAILVIEWCONTROLLER_SECTION_INFO,
CGICALTODO_DETAILVIEWCONTROLLER_SECTION_NOTES,
CGICALTODO_DETAILVIEWCONTROLLER_SECTION_COUNT,
};

enum {
CGICALTODO_DETAILVIEWCONTROLLER_SECTION_INFO_CREATED = 0,
CGICALTODO_DETAILVIEWCONTROLLER_SECTION_INFO_MODIFIED,
CGICALTODO_DETAILVIEWCONTROLLER_SECTION_INFO_COMPLETED,
CGICALTODO_DETAILVIEWCONTROLLER_SECTION_INFO_COUNT,
};

#define CGICALTODO_DETAILVIEWCONTROLLER_TEXTFIELD_FONTSIZE              16.0
#define CGICALTODO_DETAILVIEWCONTROLLER_TEXTFIELD_WIDTH                 280.0
#define CGICALTODO_DETAILVIEWCONTROLLER_TEXTFIELD_HEIGHT                30.0
#define CGICALTODO_DETAILVIEWCONTROLLER_TEXTFIELD_XOFFSET               10.0
#define CGICALTODO_DETAILVIEWCONTROLLER_TEXTFIELD_YOFFSET(tableView)    ((tableView.rowHeight - CGICALTODO_DETAILVIEWCONTROLLER_TEXTFIELD_HEIGHT + 6.0) / 2.0)

#define CGICALTODO_DETAILVIEWCONTROLLER_TEXTFIELD_NOTESECTION_SCALE 3.0

@interface CGDetailViewController()
- (UITextField *)createTextFieldWithRect:(CGRect)frame;
- (UITextView *)createTextViewWithRect:(CGRect)frame;
@end

@implementation CGDetailViewController

- (id)initWithTodo:(CGICalendarComponent *)aTodo {
	self = [super initWithStyle: UITableViewStyleGrouped];
	if (self) {
		self.todo = aTodo;
		self.modalMode = NO;
		/* Summary Field */
		self.summaryField = [self createTextFieldWithRect: CGRectMake(CGICALTODO_DETAILVIEWCONTROLLER_TEXTFIELD_XOFFSET,
																	  CGICALTODO_DETAILVIEWCONTROLLER_TEXTFIELD_YOFFSET(self.tableView),
																	  CGICALTODO_DETAILVIEWCONTROLLER_TEXTFIELD_WIDTH,
																	  CGICALTODO_DETAILVIEWCONTROLLER_TEXTFIELD_HEIGHT)];
		self.summaryField.text = aTodo.summary;
		/* Description Field */
		self.descField = [self createTextViewWithRect: CGRectMake(CGICALTODO_DETAILVIEWCONTROLLER_TEXTFIELD_XOFFSET,
																  CGICALTODO_DETAILVIEWCONTROLLER_TEXTFIELD_YOFFSET(self.tableView),
																  CGICALTODO_DETAILVIEWCONTROLLER_TEXTFIELD_WIDTH,
																  self.tableView.rowHeight * CGICALTODO_DETAILVIEWCONTROLLER_TEXTFIELD_NOTESECTION_SCALE - (CGICALTODO_DETAILVIEWCONTROLLER_TEXTFIELD_YOFFSET(self.tableView) * 2))];
		self.descField.text = aTodo.notes;
	}
	return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];

	self.title = self.todo.summary;
	self.navigationController.toolbarHidden = NO;
	if (self.isModalMode) {
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(doDone)];
		self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel target: self action: @selector(doCancel)];
	} else {
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(doDone)];
		 [self setToolbarItems: @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
								  [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCancel target: self action: @selector(doCancel)]]
					  animated: NO];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return CGICALTODO_DETAILVIEWCONTROLLER_SECTION_COUNT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case CGICALTODO_DETAILVIEWCONTROLLER_SECTION_SUMMARY:
			return  1;
		case CGICALTODO_DETAILVIEWCONTROLLER_SECTION_INFO:
			return  CGICALTODO_DETAILVIEWCONTROLLER_SECTION_INFO_COUNT;
		case CGICALTODO_DETAILVIEWCONTROLLER_SECTION_NOTES:
			return  1;
	}
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
		case CGICALTODO_DETAILVIEWCONTROLLER_SECTION_SUMMARY:
			return  @"";
		case CGICALTODO_DETAILVIEWCONTROLLER_SECTION_INFO:
			return  @"";
	 case CGICALTODO_DETAILVIEWCONTROLLER_SECTION_NOTES:
		return  @"Notes";
	}
	return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CGFloat rowHeight = tableView.rowHeight;
	switch (indexPath.section) {
		case CGICALTODO_DETAILVIEWCONTROLLER_SECTION_NOTES:
			rowHeight *= CGICALTODO_DETAILVIEWCONTROLLER_TEXTFIELD_NOTESECTION_SCALE;
			break;
	}
	return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	if (!cell)
		cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue2 reuseIdentifier: CellIdentifier];

	// Configure the cell...
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	NSString *titleString = @"";
	NSString *detailTitleString = @"";
	switch (indexPath.section) {
		case CGICALTODO_DETAILVIEWCONTROLLER_SECTION_SUMMARY:
			[cell.contentView addSubview: self.summaryField];
			break;
		case CGICALTODO_DETAILVIEWCONTROLLER_SECTION_INFO:
			switch (indexPath.row) {
				case CGICALTODO_DETAILVIEWCONTROLLER_SECTION_INFO_CREATED:
					titleString = @"Created";
					detailTitleString = self.todo.created.descriptionISO8601;
					break;
				case CGICALTODO_DETAILVIEWCONTROLLER_SECTION_INFO_MODIFIED:
					titleString = @"Modified";
					detailTitleString = self.todo.lastModified.descriptionISO8601;
					break;
				case CGICALTODO_DETAILVIEWCONTROLLER_SECTION_INFO_COMPLETED:
					titleString = @"Completed";
					detailTitleString = self.todo.completed.descriptionISO8601;
					break;
				default:
					break;
			}
		case CGICALTODO_DETAILVIEWCONTROLLER_SECTION_NOTES:
			[cell.contentView addSubview: self.descField];
			break;
	}
	cell.textLabel.text = titleString;
	cell.detailTextLabel.text = detailTitleString;
	return cell;
}

#pragma mark - Button Actions

- (void)doDone {
	[self.todo incrementSequenceNumber];
	self.todo.summary = self.summaryField.text;
	self.todo.notes = self.descField.text;
	self.todo.lastModified = NSDate.date;

	if (self.delegate)
		[self.delegate icalTodoDetailViewController: self didFinished: self.todo];
	if (self.isModalMode)
		[self dismissViewControllerAnimated: YES completion: nil];
	else
		[self.navigationController popViewControllerAnimated: YES];
}

- (void)doCancel {
	if (self.delegate)
		[self.delegate icalTodoDetailViewController: self didCanceled: self.todo];

	if (self.isModalMode)
		[self dismissViewControllerAnimated: YES completion: nil];
	else
		[self.navigationController popViewControllerAnimated: YES];
}

#pragma mark - TextField

- (UITextField *)createTextFieldWithRect:(CGRect)frame {
	UITextField *textField = [[UITextField alloc] initWithFrame: frame];
	textField.borderStyle = UITextBorderStyleNone;
	textField.textColor = UIColor.blackColor;
	textField.font = [UIFont systemFontOfSize:CGICALTODO_DETAILVIEWCONTROLLER_TEXTFIELD_FONTSIZE];
	textField.backgroundColor = UIColor.whiteColor;
	textField.autocorrectionType = UITextAutocorrectionTypeNo;
	textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	textField.keyboardType = UIKeyboardTypeDefault;
	textField.returnKeyType = UIReturnKeyDefault;
	textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	textField.clearButtonMode = UITextFieldViewModeWhileEditing;
	textField.delegate = self;
	return textField;
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField {
	[textField resignFirstResponder];
	return YES;
}

- (UITextView *)createTextViewWithRect:(CGRect)frame {
	UITextView *textView = [[UITextView alloc] initWithFrame: frame];
	textView.textColor = UIColor.blackColor;
	textView.font = [UIFont systemFontOfSize: CGICALTODO_DETAILVIEWCONTROLLER_TEXTFIELD_FONTSIZE];
	textView.backgroundColor = UIColor.whiteColor;
	textView.autocorrectionType = UITextAutocorrectionTypeNo;
	textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
	textView.keyboardType = UIReturnKeyDone;
	textView.returnKeyType = UIReturnKeyDefault;
	textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
	textView.delegate = self;
	return textView;
}

/*
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	if ([text isEqualToString:@"\n"]) {
		[textView resignFirstResponder];
		[[self tableView] reloadData];
		return NO;
	}
	return YES;
}
 */

@end
