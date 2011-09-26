//
//  TCBaseViewModel.m
//  Teracode
//
//  Created by Emanuel Andrada on 9/15/11.
//  Copyright 2011 Teracode. All rights reserved.
//

#import "TCBaseViewModel.h"

@implementation TCBaseViewModel

@synthesize delegate;
@synthesize status;

#pragma mark - Interface

- (void)loadDataIfNeeded {
    if (![self dataIsLoaded] && ![self dataIsLoading]) {
        [self loadData];
    }
}
        
#pragma mark - Template Methods

- (void)loadData {
    
}

#pragma mark - Utils
        
- (BOOL)dataIsLoaded {
    return (status & TCViewModelStatusLoaded) == TCViewModelStatusLoaded;
}

- (BOOL)dataIsLoading {
    return (status & TCViewModelStatusLoading) == TCViewModelStatusLoading;
}

- (void)willStartLoading:(BOOL)modal ref:(id)ref {
    self.status = TCViewModelStatusLoading;
    [self.delegate viewModel:self willStartLoading:modal ref:ref];
}

- (void)didFinishLoading:(id)ref {
    self.status = TCViewModelStatusLoaded;
    [self.delegate viewModel:self didFinishLoading:ref];
}

- (void)didFailLoadingWithError:(NSError *)error ref:(id)ref {
    self.status = TCViewModelStatusUnloaded;
    [self.delegate viewModel:self didFailLoadingWithError:error ref:ref];
}

@end
