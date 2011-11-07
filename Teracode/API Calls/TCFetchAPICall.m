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

- (BOOL) processResponse: (NSData *) data error:(NSError **)error {
	id<TCParser> parser = [[[[self class] parserClass] alloc] init];
    
    self.responseData = [parser parse: data encoding: self.job.encoding error: error];

	[parser release];
    
    return *error == nil;
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
