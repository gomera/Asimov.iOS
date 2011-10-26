//
//  TCGridViewDelegate.h
//  GridComponent
//
//  Created by Diego Sebastian Mera on 8/4/10.
//  Copyright 2010 Teracode. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCGridView;
@class TCGridCellView;

@protocol TCGridViewDelegate<UIScrollViewDelegate>

@optional
- (void)gridView:(TCGridView *)grid didSelectRow:(NSUInteger)row column:(NSUInteger)column;
- (CGSize)cellSizeForGridView:(TCGridView *)grid;
- (CGSize)cellSeparatorSizeForGridView:(TCGridView *)grid;

@end
