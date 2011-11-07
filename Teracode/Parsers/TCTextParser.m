//
//  TCTextParser.m
//  Teracode
//
//  Created by Emanuel Andrada on 7/12/11.
//  Copyright 2011 Teracode. All rights reserved.
//

#import "TCTextParser.h"

@implementation TCTextParser

- (id) parse: (NSData *) data encoding: (NSStringEncoding) encoding error: (NSError **) error {
	NSString *text = [[NSString alloc] initWithData: data encoding: encoding];
	return [text autorelease];
}

@end
