//
//  TCAppDelegate.m
//  Teracode
//
//  Created by Diego Sebastian Mera on 1/7/10.
//  Copyright 2010 TeraCode. All rights reserved.
//

#import "TCAppDelegate.h"


@implementation TCAppDelegate

@synthesize window=_window;

@synthesize currentViewController;
@synthesize switchViewController;

- (void)dealloc {
    [_window release];
    [switchViewController release];
    [currentViewController release];
    [super dealloc];
}

@end
