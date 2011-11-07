#import "TCFakeAPIRequest.h"
#import "TCNetworkJob.h"
#import "TCFakeHTTPResponse.h"

@interface TCFakeAPIRequest ()

- (void) requestDidFinish: (NSTimer *) theTimer;
- (NSError *) errorResponse;

@end


@implementation TCFakeAPIRequest


- (NSError *) errorResponse {
    
    NSString *localizedDescription = NSLocalizedString(@"There was an error while trying to process the mocked response", @"");
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:localizedDescription
                                                         forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain: @"Teracode.FakeAPIRequest" code: 100 userInfo:userInfo];
}


- (NSString *) keyFromJob: (TCNetworkJob *) job {
	NSString *urlRelativePath = [job.url relativePath];

	NSMutableString *apiAction = [NSMutableString stringWithString: urlRelativePath];
    
	NSCharacterSet *trimSet = [NSCharacterSet characterSetWithCharactersInString: @"/."];
	NSMutableString *key = [NSMutableString stringWithString: [apiAction stringByTrimmingCharactersInSet: trimSet]];
	[key replaceOccurrencesOfString: @"/" withString: @"_" options: NSCaseInsensitiveSearch range: NSMakeRange(0, [key length])];
	[key replaceOccurrencesOfString: @"?" withString: @"_" options: NSCaseInsensitiveSearch range: NSMakeRange(0, [key length])];
	[key replaceOccurrencesOfString: @"&" withString: @"_" options: NSCaseInsensitiveSearch range: NSMakeRange(0, [key length])];
	[key replaceOccurrencesOfString: @"=" withString: @"_" options: NSCaseInsensitiveSearch range: NSMakeRange(0, [key length])];
	[key replaceOccurrencesOfString: @":" withString: @"_" options: NSCaseInsensitiveSearch range: NSMakeRange(0, [key length])];
	[key replaceOccurrencesOfString: @"." withString: @"_" options: NSCaseInsensitiveSearch range: NSMakeRange(0, [key length])];
	
	return key;
}

- (NSData *) responseDataWithJob: (TCNetworkJob *) job error: (NSError **) error {
	
	NSString *key = [self keyFromJob: job];
	NSString *type = @"json";
	
	customLog(@"Mock file: %@.%@", key, type);
	
	NSString *file = [[NSBundle mainBundle] pathForResource: key ofType: type];
    
    return [NSData dataWithContentsOfFile: file];
}

- (void) executeJob: (TCNetworkJob *)job {
	NSNumber *delay = [NSNumber numberWithDouble:  (job.delay > 0 ? job.delay : .0f)];
	[NSTimer scheduledTimerWithTimeInterval: [delay doubleValue] target: self selector: @selector(requestDidFinish:) userInfo: job repeats: NO];
}

- (void) requestDidFinish: (NSTimer *) theTimer {
	TCFakeHTTPResponse *fakeHTTPResponse = [[TCFakeHTTPResponse alloc] init];
	fakeHTTPResponse.mockedStatusCode = 200;
	
	NSError *error;
	TCNetworkJob *job = (TCNetworkJob *) theTimer.userInfo;
	NSData *data = [self responseDataWithJob: job error: &error];
	if (data) {
		[self.delegate request: self didFinishWithData: data response: fakeHTTPResponse];
	} else {
		[self.delegate request: self didFinishWithError: [self errorResponse]];
	}
	[fakeHTTPResponse release];
}



@end
