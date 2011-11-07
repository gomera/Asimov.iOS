#import "TCNetworkJob.h"
#import "TCRequest.h"
#import "TCRequestFactory.h"

@implementation TCNetworkJob

@synthesize params;
@synthesize headers;
@synthesize url;
@synthesize method;
@synthesize request;
@synthesize files;
@synthesize timeout;
@synthesize delegate;
@synthesize executeImmediately;
@synthesize encoding;
@synthesize mock;
@synthesize delay;

- (void) execute: (id<TCRequestDelegate>) requestDelegate {	
	TCRequest *aRequest = [TCRequestFactory newRequestWithDelegate: requestDelegate job: self];
	self.request = aRequest;
	[aRequest release];
	
	[self.request executeJob: self];
}

- (void) cancel {
	self.delegate = nil;
	[self.request cancel];
	self.request = nil;
}

- (void) dealloc {
	[request release];
	[params release];
	[headers release];
	[files release];
	[url release];
	[super dealloc];
}

@end
