//
//  CGTableViewController.m
//  iCalToDo
//
//  Created by Satoshi Konno on 5/14/11.
//  Copyright 2011 Satoshi Konno. All rights reserved.
//

#import "CGTableViewController.h"
#import "CGDetailViewController.h"
#import "CGViewCheckButton.h"

NSString * const CGTableViewControllerTitle = @"ToDo";
NSUInteger const CGTableViewControllerCheckedImageSize = 32;
NSUInteger const CGTableViewControllerImageOffset = 6;
NSString * const CGTableViewControllerImageCheckedNone = @"chk_none.png";
NSString * const CGTableViewControllerImageCheckedDone = @"chk_done.png";

NSUInteger const CGTableViewControllerCellCheckbuttonTag = 1;

@interface CGTableViewController ()

@property (nonatomic, strong) NSString *calendarPath;
@property (nonatomic, strong) CGICalendar *calendar;
@property (nonatomic, strong) NSMutableArray *todos;
@property (nonatomic, strong) UIImage *chkBaseImage;
@property (nonatomic, strong) UIImage *chkNoneImage;
@property (nonatomic, strong) UIImage *chkDoneImage;

- (CGICalendarObject *)firstCalendarObject;
- (void)reloadTodoComponents;
- (BOOL)saveCalendar;
- (void)setCheckButtonHidden:(BOOL)flag indexPath:(NSIndexPath *)indexPath;

@end

@implementation CGTableViewController

- (id)initWithPath:(NSString *)path {
	self = [self init];
	if (self) {
		[self setPath:path];
	}
	return self;
}

#pragma mark - iCalendar methods

- (void)setPath:(NSString *)path {
	[self setCalendarPath:path];
	[self setCalendar:[CGICalendar new]];
	[[self calendar] parseWithPath:path error:nil];
}

- (CGICalendarObject *)firstCalendarObject {
	if (self.calendar.objects.count <= 0)
		[self.calendar addObject: CGICalendarObject.object];
   return [self.calendar objectAtIndex: 0];;
}

- (BOOL)saveCalendar {
	return [self.calendar writeToFile: self.calendarPath];
}

- (void)reloadTodoComponents {
	CGICalendarObject *icalObj = self.firstCalendarObject;
	self.todos = icalObj.todos.mutableCopy;
}

- (void)setCheckButtonHidden:(BOOL)hidden indexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [self.tableView cellForRowAtIndexPath: indexPath];
	CGViewCheckButton *checkButton = (CGViewCheckButton *)[cell viewWithTag: CGTableViewControllerCellCheckbuttonTag];
	checkButton.hidden = hidden;
	cell.imageView.image = (hidden ? nil : self.chkBaseImage);
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];

	self.title = CGTableViewControllerTitle;

	self.chkNoneImage = [UIImage imageNamed: CGTableViewControllerImageCheckedNone];
	self.chkDoneImage = [UIImage imageNamed: CGTableViewControllerImageCheckedDone];

	// Uncomment the following line to clear selection between presentations.
	// self.clearsSelectionOnViewWillAppear = NO;

	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	self.navigationItem.rightBarButtonItem = self.editButtonItem;

	self.navigationController.toolbarHidden = NO;
	[self setToolbarItems: @[[[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemRefresh target: self action: @selector(doRefresh)],
							 [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target: nil action: nil],
							 [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemAdd target: self action: @selector(doAdd)]]
				 animated: NO];

	NSString *icalPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent: @"MyToDo.ics"];
	[self setPath: icalPath];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	[self reloadTodoComponents];

	return self.todos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";

	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
	if (!cell)
		cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: CellIdentifier];

	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	CGICalendarComponent *todoComp = self.todos[indexPath.row];

	cell.textLabel.text = todoComp.summary;
	cell.detailTextLabel.text = todoComp.created.descriptionISO8601;

	cell.imageView.image = self.chkBaseImage;
	cell.imageView.image = [todoComp hasPropertyForName: CGICalendarPropertyCompleted] ? self.chkDoneImage : self.chkNoneImage;

	CGViewCheckButton *todoCheckButton = [[CGViewCheckButton alloc] initWithTodoComponent: todoComp];
	[todoCheckButton addTarget: self action: @selector(checkButtonAction:) forControlEvents: UIControlEventTouchUpInside];
	//[todoCheckButton setImage:[todoComp hasPropertyForName:CG_ICALENDAR_PROERTY_COMPLETED] ? self.chkDoneImage : self.chkNoneImage forState: UIControlStateNormal];
	todoCheckButton.tag = CGTableViewControllerCellCheckbuttonTag;
	todoCheckButton.frame = CGRectMake(CGTableViewControllerImageOffset, //cell.imageView.frame.origin.x,
									   CGTableViewControllerImageOffset, //cell.imageView.frame.origin.y,
									   todoCheckButton.frame.size.width,
									   todoCheckButton.frame.size.height);
	[cell addSubview: todoCheckButton];

	return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the specified item to be editable.
	//[self setCheckButtonHidden:YES indexPath:indexPath];
	return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	/*
	NSUInteger tableCellIndexes[2];
	tableCellIndexes[0] = 0;
	for (int n=0; n<[[self todos] count]; n++) {
		tableCellIndexes[1] = n;
		[self setCheckButtonHidden:NO indexPath:[NSIndexPath indexPathWithIndexes:tableCellIndexes length:2]];
	}
	*/

	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the row from the data source
		CGICalendarObject *icalObj = self.firstCalendarObject;
		CGICalendarComponent *todoComp = self.todos[indexPath.row];

		[self.todos removeObject:todoComp];
		[icalObj removeComponent:todoComp];
		[self saveCalendar];

		[tableView deleteRowsAtIndexPaths: @[indexPath] withRowAnimation: UITableViewRowAnimationFade];
	}
	else if (editingStyle == UITableViewCellEditingStyleInsert) {
		// Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
	}
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
	if(fromIndexPath.section == toIndexPath.section) {
	  if(self.todos && toIndexPath.row < self.todos.count) {
		  CGICalendarObject *icalObj = self.firstCalendarObject;
		  CGICalendarComponent *todoComp = [self.todos objectAtIndex: fromIndexPath.row];

		  [self.todos removeObject:todoComp];
		  [self.todos insertObject:todoComp atIndex:toIndexPath.row];

		  [icalObj removeComponent:todoComp];
		  [icalObj insertComponent:todoComp atIndex:toIndexPath.row];

		  [self saveCalendar];
		}
	}
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	// Return NO if you do not want the item to be re-orderable.
	return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	CGICalendarComponent *todoComp = self.todos[indexPath.row];
	CGDetailViewController *todoDetailViewController = [[CGDetailViewController alloc] initWithTodo:todoComp];
	todoDetailViewController.delegate = self;
	[self.navigationController pushViewController:todoDetailViewController animated:YES];
}

#pragma mark -
#pragma mark - Button Actions

- (void)doRefresh {
	[self.tableView reloadData];
}

- (void)doAdd {
	CGICalendarComponent *newTodoComp = [CGICalendarComponent todo];
	CGDetailViewController *todoDetailViewController = [[CGDetailViewController alloc] initWithTodo:newTodoComp];
	todoDetailViewController.delegate = self;
	todoDetailViewController.modalMode = YES;
	[self presentViewController:[[UINavigationController alloc] initWithRootViewController:todoDetailViewController]
					   animated:YES
					 completion:nil];
}

#pragma mark -
#pragma mark - CGDetailViewController Delegate

- (void)icalTodoDetailViewController:(CGDetailViewController *)icalTodoDetailViewController didFinished:(CGICalendarComponent *)todo {
	CGICalendarObject *icalObj = self.firstCalendarObject;

	if ([icalObj indexOfComponent:todo] == NSNotFound)
		[icalObj addComponent:todo];

	[self saveCalendar];

	[self.tableView reloadData];
}

- (void)icalTodoDetailViewController:(CGDetailViewController *)icalTodoDetailViewController didCanceled:(CGICalendarComponent *)todo {

}

#pragma mark -
#pragma mark - Check Button Action

-(void)checkButtonAction:(id)inSender {
	CGViewCheckButton *todoCheckButton = (CGViewCheckButton *)inSender;
	CGICalendarComponent *todoComp = todoCheckButton.todoComponent;
	UITableViewCell *cell = (UITableViewCell *)todoCheckButton.superview;

	if ([todoComp hasPropertyForName:CGICalendarPropertyCompleted]) {
		cell.imageView.image = self.chkNoneImage;
		[todoComp removePropertyForName:CGICalendarPropertyCompleted];
	}
	else {
		cell.imageView.image = self.chkDoneImage;
		todoComp.completed = NSDate.date;
	}

	[self saveCalendar];
}

@end
