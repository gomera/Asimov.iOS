//
//  TCBaseViewModel.h
//  Teracode
//
//  Created by Emanuel Andrada on 9/15/11.
//  Copyright 2011 Teracode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TCViewModel.h"

typedef enum {
    TCViewModelStatusUnloaded,
    TCViewModelStatusLoading,
    TCViewModelStatusLoaded
} TCViewModelStatus;

@interface TCBaseViewModel : NSObject <TCViewModel> {
    @private
    id<TCViewModelDelegate> delegate;
    TCViewModelStatus status;
}

@property (nonatomic, assign) TCViewModelStatus status;

#pragma mark - Template Methods

- (void)loadData;

#pragma mark - Utils

- (BOOL)dataIsLoaded;
- (BOOL)dataIsLoading;

//  Call this method when starting an async data loading
- (void)willStartLoading;

//  Call this method when loading finishes
- (void)didFinishLoading;

//  Call this method when loading fails
- (void)didFailLoadingWithError:(NSError *)error;

@end
