//
//  TCBaseViewController.h
//  Teracode
//
//  Created by Diego Sebastian Mera on 9/14/11.
//  Copyright 2011 Teracode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCViewModel.h"

@interface TCBaseViewController : UIViewController <TCViewModelDelegate> {
    @private
    id<TCViewModel> viewModel;
}

@property (nonatomic, retain) id<TCViewModel> viewModel;

#pragma mark - Template methods

//  This method should update the view based on the contents of the viewModel
- (void)updateViewFromViewModel;

#pragma mark - Overrideables

//  Initialization point. Should call [super initialize]
- (void)initialize;

//  This method should return a ViewModel to be used by the view controller
//  Default implementation creates a ViewModel using classForViewModel.
- (id)createViewModel;

//  This method should return the class for the ViewModel to be used by the view controller
//  Default implementation returns a the class changing Controller with Model.
//  Example: FMBaseViewController will return FMBaseViewModel
- (Class)classForViewModel;

//  Shows a loading indicator.
//  modal: the app can't be used until the load finishes
- (void)showLoadingView:(BOOL)modal;

//  Hides the loading indicator.
- (void)hideLoadingView;

@end
