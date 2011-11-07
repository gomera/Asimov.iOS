//
//  NSException+TeraCode.h
//  Teracode
//
//  Created by Diego Sebastian Mera on 11/4/11.
//  Copyright 2011 Teracode. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSException (NSException_TeraCode)

+ (void) throwUnsupportedException;

+ (void) throwExceptionWithName:(NSString *)name reason:(NSString *)reason;

@end
