#include "TCRequest.h"

@implementation TCRequest

@synthesize delegate;
@synthesize receivedData;
@synthesize response;

- (id) initWithRequestDelegate: (id<TCRequestDelegate>) theDelegate {
    self = [super init];
	if (self) {
		self.delegate = theDelegate;
		requestProgress = 0.0f;
		bytesReceived = 0;
	}
	return self;
}

- (void) executeJob: (TCNetworkJob *) job {
	@throw [NSException exceptionWithName: @"UnsupportedOperationException" reason: @"MORequest must not be used directly" userInfo: nil];
}

- (void) cancel {
	self.delegate = nil;
}

- (void) dealloc {
	[receivedData release];
	[response release];
	[super dealloc];
}

@end