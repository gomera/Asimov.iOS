//
//  TCBaseListViewController.h
//  Teracode
//
//  Created by Emanuel Andrada on 9/26/11.
//  Copyright 2011 Teracode. All rights reserved.
//

#import "TCTableViewController.h"

@interface TCBaseListViewController : TCTableViewController {
    
}

@property (nonatomic, retain) id<TCListViewModel> viewModel;

@end
