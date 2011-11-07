//
//  NSException+TeraCode.m
//  Teracode
//
//  Created by Diego Sebastian Mera on 11/4/11.
//  Copyright 2011 Teracode. All rights reserved.
//

#import "NSException+TeraCode.h"


@implementation NSException (NSException_TeraCode)


+ (void) throwUnsupportedException {
	[self throwExceptionWithName: @"UnsupportedOperationException" 
                          reason: @"This object does not support this method, or it is not intended to be used this way."];
}

+ (void) throwExceptionWithName:(NSString *)name reason:(NSString *)reason {
	@throw [self exceptionWithName: name
                            reason: reason
                          userInfo: nil];
}

@end
