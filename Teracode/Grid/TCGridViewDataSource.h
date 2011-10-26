//
//  TCGridViewDataSource.h
//  GridComponent
//
//  Created by Emanuel Andrada on 7/28/10.
//  Copyright 2010 Teracode. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCGridView;
@class TCGridCellView;

@protocol TCGridViewDataSource<NSObject>

- (NSInteger)numberOfColumnsInGridView:(TCGridView *)grid;
- (NSInteger)numberOfRowsInGridView:(TCGridView *)grid;

- (TCGridCellView *)gridView:(TCGridView *)grid viewForCellAtRow:(NSInteger)row column:(NSInteger)column;

@end
