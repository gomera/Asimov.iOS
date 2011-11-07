//
//  TCPaginatedListAPICall.m
//  Teracode
//
//  Created by Emanuel Andrada on 6/15/11.
//  Copyright 2011 Teracode. All rights reserved.
//

#import "TCPaginatedListAPICall.h"


@implementation TCPaginatedListAPICall

@synthesize pageOffset;
@synthesize pageSize;

- (id)initWithDelegate:(id <TCAPICallDelegate>)theDelegate {
	self = [super initWithDelegate:theDelegate];
	if (self != nil) {
		self.pageOffset = 1; // default
		self.pageSize = 25; // default
	}
	return self;
}

- (void)execute {
	[self addParameter:[NSNumber numberWithUnsignedInt:self.pageSize] forKey:@"pageSize"];
	[self addParameter:[NSNumber numberWithUnsignedInt:self.pageOffset] forKey:@"page"];

	[super execute];
}

@end
