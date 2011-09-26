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
    
    // current non modal loading / saving refs
    NSMutableArray *loadingRefs;
}

@property (nonatomic, retain) id<TCViewModel> viewModel;

#pragma mark - Template methods

//  This method should update the view based on the contents of the viewModel
- (void)updateViewFromViewModel;

#pragma mark - Customization points

//  Initialization point. Should call [super initialize]
- (void)initialize;

//  This method should return a ViewModel to be used by the view controller
//  Default implementation creates a ViewModel using classForViewModel.
- (id)createViewModel;

//  This method should return the class for the ViewModel to be used by the view controller
//  Default implementation returns a the class changing Controller with Model.
//  Example: FMBaseViewController will return FMBaseViewModel
- (Class)classForViewModel;

//  Shows a non-modal loading indicator.
- (void)showLoadingView;

//  Hides the non-modal loading indicator.
- (void)hideLoadingView;

//  Shows a loading indicator.
//  modal: the app can't be used until the load finishes.
//  ref: a reference to later hide the indicator, useful if there are several
//      loadings at the same time.
//  Default implementation: call showLoadingView first time a non-modal
//      loading starts. Display the modal indicator when modal.
- (void)showLoadingView:(BOOL)modal ref:(id)ref;

//  Hides the loading indicator started by the given ref (modal and non-modal).
//  Default implementation: removes the non-modal indicator when the loadings count
//      reachs zero.
- (void)hideLoadingView:(id)ref;

@end

//  Customization point:
//  This category is not implemented by the framework. You could implement it in your
//      project and perform all the customization you need for your all your view controllers.
@interface TCBaseViewController (Customization)

//  Called on initialization
- (void)customizeViewController;

@end
