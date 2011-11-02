//
//  TCGridCellView+GridView.h
//  GridComponent
//
//  Created by Emanuel Andrada on 7/28/10.
//  Copyright 2010 Teracode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCGridCellView.h"

@protocol TCGridCellViewDelegate;


/*
 this category is intended to show this interface to TCGridView
 and hide it to the rest of the app
*/
@interface TCGridCellView (GridView)

@property (nonatomic, assign) NSInteger currentColumn;
@property (nonatomic, assign) NSInteger currentRow;
@property (nonatomic, assign) id<TCGridCellViewDelegate> delegate;

@end
