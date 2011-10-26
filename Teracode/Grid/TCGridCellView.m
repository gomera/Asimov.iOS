//
//  TCGridCellView.m
//  GridComponent
//
//  Created by Emanuel Andrada on 7/28/10.
//  Copyright 2010 Teracode. All rights reserved.
//

#import "TCGridCellView.h"
#import "TCGridCellView+GridView.h"
#import "TCGridCellViewDelegate.h"

@implementation TCGridCellView

@synthesize reuseIdentifier = _reuseIdentifier;

- (id)initWithReuseIdentifier:(NSString *)identifier {
	self = [super init];
    if (self) {
		_reuseIdentifier = [identifier copy];
    }
    return self;
}

#pragma mark -

- (NSInteger)currentColumn {
	return _currentColumn;
}

- (void)setCurrentColumn:(NSInteger)currentColumn {
	_currentColumn = currentColumn;
}

- (NSInteger)currentRow {
	return _currentRow;
}

- (void)setCurrentRow:(NSInteger)currentRow {
	_currentRow = currentRow;
}

- (id<TCGridCellViewDelegate>)delegate {
	return _delegate;
}

- (void)setDelegate:(id <TCGridCellViewDelegate>)delegate {
	_delegate = delegate;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[_delegate gridCellWasSelected: self];
}

#pragma mark -

- (void)dealloc {
	[_reuseIdentifier release];
	
    [super dealloc];
}


@end
