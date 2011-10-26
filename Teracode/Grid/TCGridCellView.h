//
//  TCGridCellView.h
//  GridComponent
//
//  Created by Emanuel Andrada on 7/28/10.
//  Copyright 2010 Teracode. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCGridCellViewDelegate;

@interface TCGridCellView : UIView {
	@private
	NSString *_reuseIdentifier;
	NSInteger _currentColumn;
	NSInteger _currentRow;
	
	id<TCGridCellViewDelegate> _delegate;
}

@property (nonatomic, retain) NSString *reuseIdentifier;

- (id)initWithReuseIdentifier:(NSString *)identifier;

@end
