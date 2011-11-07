#import "TCRequestFactory.h"
#import "TCNetworkJob.h"
#import "TCRequest.h"
#import "TCHttpRequest.h"
#import "TCFakeAPIRequest.h"

@implementation TCRequestFactory

+ (TCRequest *) newRequestWithDelegate: (id<TCRequestDelegate>) delegate job: (TCNetworkJob *) job {
	
	TCRequest *request = nil;
	if (job.mock) {
		request = [[TCFakeAPIRequest alloc] initWithRequestDelegate: delegate];
	} else {
		request = [[TCHttpRequest alloc] initWithRequestDelegate: delegate];
	}
	
	
	customLog(@"Request %@ created", request);
	
	return request;
}

@end
