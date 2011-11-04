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

- (void)viewModelWillStartLoading:(id<TCViewModel>)viewModel {
    [self showLoadingView];
}

- (void)viewModelDidFinishLoading:(id<TCViewModel>)viewModel {
    [self hideLoadingView];
    [self updateViewFromViewModel];
}

- (void)viewModel:(id<TCViewModel>)viewModel didFailLoadingWithError:(NSError *)error {
    [self hideLoadingView];
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
