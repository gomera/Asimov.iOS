//
//  TCGridView.m
//  GridComponent
//
//  Created by Emanuel Andrada on 7/28/10.
//  Copyright 2010 Teracode. All rights reserved.
//

#import "TCGridView.h"
#import "TCGridCellView+GridView.h"

@interface TCGridView (private)

- (void)setup;
- (void)loadDataIfNeeded;

- (void)adjustContentSize;
- (NSInteger)columnAtOffset:(CGFloat)offset;
- (NSInteger)rowAtOffset:(CGFloat)offset;
- (NSInteger)firstVisibleColumn;
- (NSInteger)lastVisibleColumn;
- (NSInteger)firstVisibleRow;
- (NSInteger)lastVisibleRow;
- (CGPoint)positionForCellAtColumn:(NSInteger)column row:(NSInteger)row;

- (void)updateVisibleCells;

@end


@implementation TCGridView

@synthesize dataSource = _dataSource;
@synthesize delegate = _gridDelegate;
@synthesize cellSize = _cellSize;
@synthesize separatorSize = _separatorSize;

- (void)setup {
	_visibleCells = [[NSMutableArray alloc] init];
	_reusableCells = [[NSMutableArray alloc] init];
	
	// Default cell and separator size
	_cellSize = CGSizeMake(106., 106.);
	_separatorSize = CGSizeMake(1., 1.);

}

- (id)initWithCoder:(NSCoder *)decoder {
	self = [super initWithCoder:decoder];
    if (self) {
		[self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
    if (self) {
		[self setup];
    }
    return self;
}

#pragma mark -

- (void)loadDataIfNeeded {
	if (!_dataIsLoaded) {

		if ([_gridDelegate respondsToSelector:@selector(cellSizeForGridView:)]) {
			_cellSize = [_gridDelegate cellSizeForGridView:self];
		}
		
		if ([_gridDelegate respondsToSelector:@selector(cellSeparatorSizeForGridView:)]) {
			_separatorSize = [_gridDelegate cellSeparatorSizeForGridView:self];
		}
		
		_numberOfCols = [_dataSource numberOfColumnsInGridView:self];
		_numberOfRows = [_dataSource numberOfRowsInGridView:self];
		
		
		_currentFirstCol = _currentFirstRow = -1; // invalid data, to invalidate cache
		// remove all views
		[_visibleCells makeObjectsPerformSelector:@selector(removeFromSuperview)];
		[_visibleCells removeAllObjects];
		[_reusableCells removeAllObjects];
		
		[self adjustContentSize];
		_dataIsLoaded = YES;
	}
}

- (void)reloadData {
	_dataIsLoaded = NO;
	[self loadDataIfNeeded];
	[self updateVisibleCells];
}

#pragma mark -
#pragma mark Layout Cells

- (void)adjustContentSize {
	CGSize contentSize;
	
	if (self.pagingEnabled) {
		NSInteger columns = (self.bounds.size.width + _separatorSize.width) / (_cellSize.width + _separatorSize.width);
		NSInteger rows = (self.bounds.size.height + _separatorSize.height) / (_cellSize.height + _separatorSize.height);
		contentSize.width = ((_numberOfCols - 1) / columns + 1) * self.bounds.size.width;
		contentSize.height = ((_numberOfRows - 1) / rows + 1) * self.bounds.size.height;
	} else {
		contentSize.width = (_cellSize.width + _separatorSize.width) * _numberOfCols - _separatorSize.width;
		contentSize.height = (_cellSize.height + _separatorSize.height) * _numberOfRows - _separatorSize.height;
	}
	self.contentSize = contentSize;
}

- (NSInteger)columnAtOffset:(CGFloat)offset {
	if (self.pagingEnabled) {
		NSInteger columns = (self.bounds.size.width + _separatorSize.width) / (_cellSize.width + _separatorSize.width);
		NSInteger page = offset / self.bounds.size.width;
		return page * columns + (offset - page * self.bounds.size.width) / (_cellSize.width + _separatorSize.width);
	}
	else {
		return offset / (_cellSize.width + _separatorSize.width);
	}
}

- (NSInteger)rowAtOffset:(CGFloat)offset {
	if (self.pagingEnabled) {
		NSInteger rows = (self.bounds.size.height + _separatorSize.height) / (_cellSize.height + _separatorSize.height);
		NSInteger page = offset / self.bounds.size.height;
		return page * rows + (offset - page * self.bounds.size.height) / (_cellSize.height + _separatorSize.height);
	}
	else {
		return offset / (_cellSize.height + _separatorSize.height);
	}
}

- (NSInteger)firstVisibleColumn {
	NSInteger col = [self columnAtOffset:self.contentOffset.x];
	
	return (col > 0)? col: 0;
}

- (NSInteger)lastVisibleColumn {
	NSInteger col = [self columnAtOffset:self.contentOffset.x + self.bounds.size.width];
	
	return (col < _numberOfCols)? col: _numberOfCols - 1;
}

- (NSInteger)firstVisibleRow {
	NSInteger row = [self rowAtOffset:self.contentOffset.y];
	
	return (row > 0)? row: 0;
}

- (NSInteger)lastVisibleRow {
	NSInteger row = [self rowAtOffset:self.contentOffset.y + self.bounds.size.height];
	
	return (row < _numberOfRows)? row:_numberOfRows - 1;
}

- (CGPoint)positionForCellAtColumn:(NSInteger)column row:(NSInteger)row {
	if (self.pagingEnabled) {
		CGPoint pos;
		NSInteger columns = (self.bounds.size.width + _separatorSize.width) / (_cellSize.width + _separatorSize.width);
		NSInteger rows = (self.bounds.size.height + _separatorSize.height) / (_cellSize.height + _separatorSize.height);
		pos.x = (column % columns) * (_cellSize.width + _separatorSize.width) + (column / columns) * self.bounds.size.width;
		pos.y = (row % rows) * (_cellSize.height + _separatorSize.height) + (row / rows) * self.bounds.size.height;
		return pos;
	}
	return CGPointMake(column * (_cellSize.width + _separatorSize.width), row * (_cellSize.height + _separatorSize.height));
}

- (void)updateVisibleCells {
	NSInteger firstCol = [self firstVisibleColumn], lastCol = [self lastVisibleColumn];
	NSInteger firstRow = [self firstVisibleRow], lastRow = [self lastVisibleRow];
	NSInteger numberOfVisibleCells = (lastCol - firstCol + 1) * (lastRow - firstRow + 1);
	
	// don't do anything if the visible cells will not change
	if (firstCol == _currentFirstCol && lastCol == _currentLastCol && firstRow == _currentFirstRow && lastRow == _currentLastRow) {
		return;
	}
	_currentFirstCol = firstCol;
	_currentLastCol = lastCol;
	_currentFirstRow = firstRow;
	_currentLastRow = lastRow;
	
	// remove cells that are no more visible
	NSArray *array = [_visibleCells copy];
	
	for (TCGridCellView *cell in array) {
		if (cell.currentColumn < firstCol || cell.currentColumn > lastCol ||
			cell.currentRow < firstRow || cell.currentRow > lastRow) {
			// cell is outside the visible area
			[_reusableCells addObject:cell];
			[_visibleCells removeObject:cell];
			[cell removeFromSuperview];
		}
	}
	[array release];
	
	if ([_visibleCells count] == numberOfVisibleCells) {
		// all cells are visible, so exit
		return;
	}
	
	// add new visible cells
	for (NSInteger col = firstCol; col <= lastCol; col++) {
		for (NSInteger row = firstRow; row <= lastRow; row++) {
			NSInteger index = (col - firstCol) * (lastRow - firstRow + 1) + row - firstRow;
			TCGridCellView *cell = nil;
			if ([_visibleCells count] > index) {
				cell = [_visibleCells objectAtIndex:index];
			}
			if (!cell || cell.currentColumn != col || cell.currentRow != row) {
				// new visible cell
				cell = [_dataSource gridView:self viewForCellAtRow:row column:col];
				cell.currentColumn = col;
				cell.currentRow = row;
				cell.delegate = self;
				CGRect frame;
				frame.origin = [self positionForCellAtColumn:col row:row];
				frame.size = _cellSize;
				cell.frame = frame;
				[_visibleCells insertObject:cell atIndex:index];
				[self insertSubview:cell atIndex:index];
			}
		}
	}
}

- (void)layoutSubviews {
	[self loadDataIfNeeded];
	[self updateVisibleCells];
	
	[super layoutSubviews];
}

#pragma mark -
#pragma mark Reuse Cells

- (TCGridCellView *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier {
	TCGridCellView *cell = nil;
	for (TCGridCellView *aCell in _reusableCells) {
		if ([aCell.reuseIdentifier isEqualToString:identifier]) {
			cell = aCell;
			break;
		}
	}
	if (cell) {
		[[cell retain] autorelease];
		[_reusableCells removeObject:cell];
	}
	return cell;
}

#pragma mark -
#pragma mark Cell delegate

- (void)gridCellWasSelected:(TCGridCellView *)cell {
	if ([_gridDelegate respondsToSelector:@selector(gridView:didSelectRow:column:)]) {
		[_gridDelegate gridView:self didSelectRow:cell.currentRow column:cell.currentColumn];
	}
}

#pragma mark -

- (void)dealloc {
	[_visibleCells release];
	[_reusableCells release];
	
    [super dealloc];
}

@end
