//
//  TCServerCRUDAPICall.m
//  Teracode
//
//  Created by Damian Ferrai on 12/27/10.
//  Copyright 2010 Teracode. All rights reserved.
//

#import "TCServerCRUDAPICall.h"


@implementation TCServerCRUDAPICall

@synthesize type;

- (void)execute {
	switch (self.type) {
		case TCAPICallTypeCreate:
			self.method = TCRequestMethodTypePost;
			break;
		case TCAPICallTypeRead:
			self.method = TCRequestMethodTypeGet;
			break;
		case TCAPICallTypeUpdate:
			self.method = TCRequestMethodTypePost;
			break;
		case TCAPICallTypeDelete:
			self.method = TCRequestMethodTypePost;
			break;
		default:
			break;
	}
	
	[super execute];
}

@end
