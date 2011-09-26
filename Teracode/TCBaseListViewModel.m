//
//  TCBaseListViewModel.m
//  Teracode
//
//  Created by Emanuel Andrada on 9/26/11.
//  Copyright 2011 Teracode. All rights reserved.
//

#import "TCBaseListViewModel.h"


@implementation TCBaseListViewModel

@dynamic delegate;
@synthesize objects;

- (NSUInteger)objectsCount {
    return [objects count];
}

- (id)objectAtIndex:(NSUInteger)index {
    return [objects objectAtIndex:index];
}

- (BOOL)listIsEmpty {
    return [self objectsCount] && (self.status & TCViewModelStatusLoaded) == TCViewModelStatusLoaded;
}

@end
