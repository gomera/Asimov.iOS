//
//  NSDictionary+TeraCode.m
//  Teracode
//
//  Created by Diego Sebastian Mera on 11/4/11.
//  Copyright 2011 Teracode. All rights reserved.
//

#import "NSDictionary+TeraCode.h"


@implementation NSDictionary (NSDictionary_TeraCode)

- (NSString *) queryString {
    
    NSMutableArray *params = [[NSMutableArray alloc] init];
	
	for (NSString *key in [self allKeys]) {
		NSString *value = [[[self objectForKey: key] description] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
		NSString *pair = [NSString stringWithFormat:@"%@=%@", key, value];
		[params addObject: pair];
	}
	
	NSString *queryString = [NSString stringWithFormat:@"%@", [params componentsJoinedByString:@"&"]];
	[params release];
	
	return queryString;
}

@end
