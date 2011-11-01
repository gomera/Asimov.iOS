//
//  TCBaseViewController.m
//  Teracode
//
//  Created by Diego Sebastian Mera on 9/14/11.
//  Copyright 2011 Teracode. All rights reserved.
//

#import "TCBaseViewController.h"

@implementation TCBaseViewController

@synthesize viewModel;

#pragma mark - View Controller lifecycle

- (void)initialize {
    self.viewModel = [self createViewModel];
    if ([self respondsToSelector:@selector(customizeViewController)]) {
        [self customizeViewController];
    }
    loadingRefs = [[NSMutableArray alloc] init];
}

- (id)init {
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder: aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)dealloc {
    if (self == viewModel.delegate) {
        // ensure that viewModel will not send new delegate messages
        viewModel.delegate = nil;
    }
    [viewModel release];
    [loadingRefs release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateViewFromViewModel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel loadDataIfNeeded];
}

#pragma mark - ViewModel delegate methods

- (void)viewModel:(id<TCViewModel>)viewModel willStartLoading:(BOOL)modal ref:(id)ref {
    [self showLoadingView:modal ref:ref];
}

- (void)viewModel:(id<TCViewModel>)viewModel didFinishLoading:(id)ref {
    [self hideLoadingView:ref];
    [self updateViewFromViewModel];
}

- (void)viewModel:(id<TCViewModel>)viewModel didFailLoadingWithError:(NSError *)error ref:(id)ref {
    [self hideLoadingView:ref];
}

#pragma mark - Overrideables

- (id)createViewModel {
    id<TCViewModel> aViewModel = [[[self classForViewModel] alloc] init];
    aViewModel.delegate = self;
    return [aViewModel autorelease];
}

- (Class)classForViewModel {
    // default implementation: replace 'Controller' with 'Model' in the class name
    NSString *className = [NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"Controller" withString:@"Model"];
    return NSClassFromString(className);
}

- (void)showLoadingView:(BOOL)modal ref:(id)ref {
    if (!modal) {
        // if first loading, show loading indicator
        if ([loadingRefs count] == 0) {
            [self showLoadingView];
        }
        [loadingRefs addObject:ref];
    }
    else {
        // @TODO: show a modal loading view
    }
}

- (void)hideLoadingView:(id)ref {
    if (ref) {
        // there is a ref to a previously started loading
        if ([loadingRefs containsObject:ref]) {
            // loading was non-modal
            [loadingRefs removeObject:ref];
            if ([loadingRefs count]) {
                // loadings count reach zero, so hide the loading view
                [self hideLoadingView];
            }
        }
        else {
            // @TODO: hide modal loading view
        }
    }
}

- (void)showLoadingView {
    // @TODO: add a loading indicator
}

- (void)hideLoadingView {
    // @TODO: remove the loading indicator
}

#pragma mark - Template methods

- (void)updateViewFromViewModel {
    // default implementation: do nothing
}

@end
