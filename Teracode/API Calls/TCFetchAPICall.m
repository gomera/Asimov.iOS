#import "TCFetchAPICall.h"
#import "TCJSONParser.h"


@implementation TCFetchAPICall

@synthesize responseData;
@synthesize userInfo;

- (id) initWithDelegate: (id<TCAPICallDelegate>) theDelegate {
    self = [super initWithDelegate:theDelegate];
	if (self) {
		self.method = TCRequestMethodTypeGet;
	}
	return self;
}

- (BOOL) processResponseData: (NSData *) data httpResponse: (NSHTTPURLResponse *) response error: (NSError **) error {
    // Let the superclass process the response
    BOOL result = [super processResponseData:data httpResponse:response error:error];
    
    // If everything went fine, parse the response
    if (result) {
        id<TCParser> parser = [[[[self class] parserClass] alloc] init];
        
        self.responseData = [parser parse: data encoding: self.job.encoding error: error];
        
        [parser release];
        
        // Set the result based on whether the response could be parsed without errors or not
        result = (*error == nil);
    }
    
    return result;
}

- (void) dealloc {
	[responseData release];
	[userInfo release];
	[super dealloc];
}

#pragma mark - Default parser

+ (Class)parserClass {
    return [TCJSONParser class];
}

@end
