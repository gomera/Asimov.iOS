//
//  TCTableViewController.m
//  Teracode
//
//  Created by Emanuel Andrada on 9/26/11.
//  Copyright 2011 Teracode. All rights reserved.
//

#import "TCTableViewController.h"


@implementation TCTableViewController

@synthesize tableView = _tableView;

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.tableView) {
        [NSException raise:@"TC.tableViewNotSet" format:@"TCTableViewController: view was loaded but tableView outlet was not set."];
    }
    if ([self respondsToSelector:@selector(customizeTableView)]) {
        [self customizeTableView];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.tableView = nil;
}

#pragma mark -

- (void)updateViewFromViewModel {
    [super updateViewFromViewModel];
    [self.tableView reloadData];
}

#pragma mark - Table View data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    [NSException raise:@"TC.incompleteImplementation" format:@"subclasses of TCTableViewController should implement tableView:numberOfRowsInSection:"];
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [self tableViewObjectAtIndexPath:indexPath];
    
    NSString *cellIdentifier = [self cellIdentifierForObject:(id)object atIndexPath:indexPath];
    UITableViewCell *cell = [self createCell:cellIdentifier];
    if (![cell.reuseIdentifier isEqualToString:cellIdentifier]) {
        [NSException raise:@"TC.cellIdentifierDoesNotMatch" format:@"Cell Identifier does not match (%@ / %@)", cellIdentifier, cell.reuseIdentifier];
    }
    [self fillCell:cell withObject:object atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	id object = [self tableViewObjectAtIndexPath:indexPath];
	[self performActionForObject:object atIndexPath:indexPath];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Template methods

- (id)tableViewObjectAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (NSString *)cellIdentifierForObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    return @"Cell";
}

- (UITableViewCell *)createCell:(NSString *)cellIdentifier {
	UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:[self defaultTableViewCellStyle]
													reuseIdentifier:cellIdentifier] autorelease];
	cell.detailTextLabel.font = [UIFont systemFontOfSize:11.];
	return cell;
}

- (void)fillCell:(UITableViewCell *)cell withObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
	// empty implementation
}

- (void)performActionForObject:(id)object atIndexPath:(NSIndexPath *)indexPath {
    // empty implementation
}

- (UITableViewCellStyle)defaultTableViewCellStyle {
    return UITableViewCellStyleSubtitle;
}

@end
