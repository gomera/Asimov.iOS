//
//  TCPaginatedListAPICall.h
//  Teracode
//
//  Created by Emanuel Andrada on 6/15/11.
//  Copyright 2011 Teracode. All rights reserved.
//

#import "TCFetchAPICall.h"

//
// Abstract base class for the API calls that fetch results divided into pages.
//
// IMPORTANT: the relativePath method is NOT implemented in this abstract class. 
// Subclasses must implement it.
//
@interface TCPaginatedListAPICall : TCFetchAPICall {
	NSUInteger pageOffset;
	NSUInteger pageSize;
}

@property (nonatomic, assign) NSUInteger pageOffset;
@property (nonatomic, assign) NSUInteger pageSize;

@end
