//
//  TCGridCellViewDelegate.h
//  GridComponent
//
//  Created by Diego Sebastian Mera on 8/5/10.
//  Copyright 2010 Teracode. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCGridCellView;

@protocol TCGridCellViewDelegate

- (void)gridCellWasSelected:(TCGridCellView *)cell;

@end
