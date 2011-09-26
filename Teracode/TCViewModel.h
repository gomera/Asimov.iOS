//
//  TCViewModel.h
//  Teracode
//
//  Created by Emanuel Andrada on 9/15/11.
//  Copyright 2011 Teracode. All rights reserved.
//

@protocol TCViewModel;

@protocol TCViewModelDelegate <NSObject>

//  The ViewModel starts to load asynchronous data.
//  ref is a reference to a object that will be sended back when the load ends.
- (void)viewModel:(id<TCViewModel>)viewModel willStartLoading:(BOOL)modal ref:(id)ref;

//  The ViewModel finish loading data.
//  ref is a reference to a object previously sended in willStartLoading.
//      Could be nil if the loading was synchronized.
- (void)viewModel:(id<TCViewModel>)viewModel didFinishLoading:(id)ref;

//  The ViewModel failed to load data.
//  ref is a reference to a object previously sended in willStartLoading.
//      Could be nil if the loading was synchronized.
- (void)viewModel:(id<TCViewModel>)viewModel didFailLoadingWithError:(NSError *)error ref:(id)ref;

@end

@protocol TCViewModel <NSObject>

//  The ViewModel delegate.
@property (nonatomic, assign) id<TCViewModelDelegate> delegate;

//  Loads the data if it's not ready.
- (void)loadDataIfNeeded;

@end


@protocol TCListViewModel <TCViewModel>

//  Returns the number of objects in the list.
- (NSUInteger)objectsCount;

//  Returns the object at the given index.
- (id)objectAtIndex:(NSUInteger)index;

//  Indicates that the list is empty.
//  objectsCount could return 0 if the list is empty or
//  the list is not loaded yet, so this help to disambiguate.
- (BOOL)listIsEmpty;

@end

@protocol TCPaginatedListViewModel <TCListViewModel>

//  Loads the next page.
- (void)loadNextPage;

//  Indicates if there are more pages to load.
- (BOOL)hasMorePages;

@end

@protocol TCSectionedListViewModel <TCViewModel>

//  Returns the number of sections.
- (NSUInteger)sectionsCount;

//  Returns the number of objects in a given section.
- (NSUInteger)objectsCountInSection:(NSUInteger)section;

//  Returns the object at the given indexPath.
//  indexPath should have two levels (section / row).
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;

@end
