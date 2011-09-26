//
//  TCTableViewController.h
//  Teracode
//
//  Created by Emanuel Andrada on 9/26/11.
//  Copyright 2011 Teracode. All rights reserved.
//

#import "TCBaseViewController.h"

@interface TCTableViewController : TCBaseViewController <UITableViewDataSource, UITableViewDelegate> {
    @private
    UITableView *_tableView;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

#pragma mark - Template Methods

//  Returns an object that contains data to display in a row.
//  Could be nil (ie, when displaying fixed cells).
- (id)tableViewObjectAtIndexPath:(NSIndexPath *)indexPath;

//	Returns the cell identifier to use for a given object.
//	Override it when there are different types of cells in the same table or in case that
//		a cell is loaded from a nib and has a different identifier than the default "Cell".
//  You could determine the cellIdentifier from object or indexPath.
//  Default implementation: returns @"Cell".
- (NSString *)cellIdentifierForObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

//	Returns a new cell for use with that cellIdentifier.
//	Override it when you want to use a different cell than a standard UITableViewCell
//		with Subtitle style.
//  Default implementation: returns a UITableViewCell with defaultTableViewCellStyle
- (UITableViewCell *)createCell:(NSString *)cellIdentifier;

//	Override it to fill the cell with the object values.
//	Change the cast on cell and object to match your own classes.
- (void)fillCell:(id)cell withObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

//	Override it to perform an action when tapping on an object's cell.
//	Change the cast on object to match your own classes.
- (void)performActionForObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

//  Default table view cell style
//  Default implementation: return UITableViewCellStyleSubtitle.
- (UITableViewCellStyle)defaultTableViewCellStyle;

@end

//  Customization point:
//  This category is not implemented by the framework. You could implement it in your
//      project and perform all the customization you need for your all your view controllers.
@interface TCTableViewController (Customization)

//  Called on viewDidLoad
- (void)customizeTableView;

@end
