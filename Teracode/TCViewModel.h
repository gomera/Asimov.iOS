//
//  TCViewModel.h
//  Teracode
//
//  Created by Emanuel Andrada on 9/15/11.
//  Copyright 2011 Teracode. All rights reserved.
//

@protocol TCViewModel;

@protocol TCViewModelDelegate <NSObject>

- (void)viewModel:(id<TCViewModel>)viewModel willStartLoading:(BOOL)modal;
- (void)viewModelDidFinishLoading:(id<TCViewModel>)viewModel;
- (void)viewModel:(id<TCViewModel>)viewModel didFailLoadingWithError:(NSError *)error;

@end

@protocol TCViewModel <NSObject>

@property (nonatomic, assign) id<TCViewModelDelegate> delegate;

- (void)loadDataIfNeeded;

@end
