//
//  TCBaseListViewController.m
//  Teracode
//
//  Created by Emanuel Andrada on 9/26/11.
//  Copyright 2011 Teracode. All rights reserved.
//

#import "TCBaseListViewController.h"


@implementation TCBaseListViewController

@dynamic viewModel;

#pragma mark - Table View data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel objectsCount];
}

- (id)tableViewObjectAtIndexPath:(NSIndexPath *)indexPath {
    return [self.viewModel objectAtIndex:indexPath.row];
}
@end
