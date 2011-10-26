//
//  TCGridView.h
//  GridComponent
//
//  Created by Emanuel Andrada on 7/28/10.
//  Copyright 2010 Teracode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCGridViewDataSource.h"
#import "TCGridCellViewDelegate.h"
#import "TCGridViewDelegate.h"

@class TCGridCellView;

@interface TCGridView : UIScrollView<TCGridCellViewDelegate> {
	@private
	id<TCGridViewDelegate> _gridDelegate;
	id<TCGridViewDataSource> _dataSource;
		
	CGSize _cellSize;
	CGSize _separatorSize;
	
	NSMutableArray *_visibleCells;
	NSMutableArray *_reusableCells;
	
	BOOL _dataIsLoaded;
	NSInteger _numberOfCols;
	NSInteger _numberOfRows;
	NSInteger _currentFirstCol;
	NSInteger _currentLastCol;
	NSInteger _currentFirstRow;
	NSInteger _currentLastRow;
}

@property (nonatomic, assign) IBOutlet id<TCGridViewDataSource> dataSource;
@property (nonatomic, assign) id<TCGridViewDelegate> delegate;
@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) CGSize separatorSize;

- (TCGridCellView *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier;
- (void)reloadData;

@end
