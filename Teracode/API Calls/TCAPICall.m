#import "TCAPICall.h"
#import "TCAttachment.h"

#define API_AUTH_SEPARATOR @"--"
#define API_MOCK_ATTRIBUTE_KEY @"mock";

@implementation TCAPICall

@synthesize delegate;
@synthesize params;
@synthesize headers;
@synthesize files;
@synthesize method;
@synthesize mock;
@synthesize delay;
@synthesize job;
@synthesize timeout;
@synthesize secure;
@synthesize automaticSignOut;
@synthesize executeImmediately;
@synthesize priority;

- (id) initWithDelegate: (id<TCAPICallDelegate>) theDelegate {
    self = [super init];
	if (self) {
		self.params = [NSMutableDictionary dictionary];
		self.headers = [NSMutableDictionary dictionary];
		self.files = [NSMutableDictionary dictionary];
		self.delegate = theDelegate;
		self.method = TCRequestMethodTypeGet;
		self.mock = NO;
#ifdef MOCK_API_CALLS
		self.mock = YES;
#endif
		self.delay = 0.5f;
		self.timeout = 30.0f;
		self.secure = NO; // default
		self.automaticSignOut = YES; // default
        self.executeImmediately = NO;
        self.priority = TCJobPriorityNormal;
	}
	return self;
}

- (NSString *) baseURL {
    [NSException throwUnsupportedException];
    return @"";
}

- (NSString *) secureBaseURL {
    [NSException throwUnsupportedException];
    return @"";
}

- (NSString *)relativePath {
	// This method MUST be implemented by subclasses
	[NSException throwUnsupportedException];
	return nil;
}

+ (id)apiCallWithDelegate:(id<TCAPICallDelegate>)theDelegate {
    TCAPICall *apiCall = [[self alloc] initWithDelegate:theDelegate];
    return [apiCall autorelease];
}

#pragma mark -
#pragma mark Parameter functions

- (void) addParameter: (id) value forKey: (NSString *) key {
	if ([key length] > 0 && value != nil) {
		[self.params setObject: value forKey: key];
	}
}

- (void) addParameters: (NSDictionary *) values {
	for (NSString *key in [values allKeys]) {
		[self addParameter: [values objectForKey: key] forKey: key];
	}
}

- (void) removeParameterForKey: (NSString *) key {
	[self.params removeObjectForKey: key];
}

- (void) addFileParameter: (TCAttachment *) file forKey: (NSString *) key {
	[self.files setObject: file forKey: key];
}

- (void) addFileParameters: (NSDictionary *) values {
	for (NSString *key in [values allKeys]) {
		[self addFileParameter: [values objectForKey: key] forKey: key];
	}
}

#pragma mark -

- (void) cancel {
	self.delegate = nil;
	[[TCNetworkManager manager] cancelJob: self.job];
    [[TCNetworkManager manager] executeNextJob];
}

- (void) authenticate {
}

- (NSStringEncoding) encoding {
    return NSUTF8StringEncoding;
}

- (void) execute {
		
	[self authenticate];
	
    NSURL *baseUrl = [NSURL URLWithString:((self.secure) ? [self secureBaseURL] : [self baseURL])];
    NSURL *url = [NSURL URLWithString:[self relativePath] relativeToURL:baseUrl];

	customLog(@"API: execute [%@]", self);
	
	self.job = [[TCNetworkManager manager] createJobForURL: url 
													params: self.params 
												   headers: self.headers 
													 files: self.files 
													method: self.method 
												   timeout: self.timeout 
                                                  priority:self.priority
												  delegate: self];
	
    self.job.executeImmediately = self.executeImmediately;
    self.job.encoding = [self encoding];
    self.job.mock = self.mock;
    self.job.delay = self.delay;
	
	customLog(@"API: Job %@ created [%@]", self.job, self);
	customLog(@"API: executeNextJob [%@]", self);
	[[TCNetworkManager manager] executeNextJob];
}

- (BOOL) processResponseData: (NSData *) data httpResponse: (NSHTTPURLResponse *) response error: (NSError **) error {
    return YES;
}

#pragma mark -
#pragma mark TCNetworkManagerDelegate

- (void) connectionDidFinishWithError: (NSError *) error {
	[self.delegate apiCall: self didFinishWithError: error];
}

- (void) connectionDidFinishWithData: (NSData *)data response: (NSHTTPURLResponse *)response {
	NSError *error = nil;
	if ([self processResponseData: data httpResponse: response error: &error]) {
        [self.delegate apiCallDidFinishSuccessfully: self];
	} else {
		[self.delegate apiCall: self didFinishWithError: error];
	}
}

- (void) connectionDidMakeDownloadProgress:(NSNumber *)progress {
	if ([delegate respondsToSelector:@selector(apiCall:didMakeDownloadProgress:)]) {
		[self.delegate apiCall: self didMakeDownloadProgress:progress];
	}
}

- (void) connectionDidMakeUploadProgress:(NSNumber *)progress {
	if ([delegate respondsToSelector:@selector(apiCall:didMakeUploadProgress:)]) {
		[self.delegate apiCall: self didMakeUploadProgress:progress];
	}
}

- (void) dealloc {
	[params release];
	[headers release];
	[files release];
	[job release];
	[super dealloc];
}

@end
