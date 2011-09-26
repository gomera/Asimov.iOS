//
//  TCBaseListViewModel.h
//  Teracode
//
//  Created by Emanuel Andrada on 9/26/11.
//  Copyright 2011 Teracode. All rights reserved.
//

#import "TCBaseViewModel.h"

@interface TCBaseListViewModel : TCBaseViewModel <TCListViewModel> {
    @private
    NSArray *objects;
}

@property (nonatomic, copy) NSArray *objects;

@end
