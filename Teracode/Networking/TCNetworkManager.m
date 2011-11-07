#import <UIKit/UIKit.h>
#import "TCNetworkManager.h"
#import "TCReachability.h"

#define JOB_KEY @"job"
#define ERROR_KEY   @"error"

@interface TCNetworkManager ()
@property (nonatomic, retain) TCReachability *internetReach;

- (void) stopUpdatingReachability;

// Shows an activity message, modal
- (void)showActivityMessage:(TCNetworkJob *)currentJob;
// Hides the activity message
- (void)hideActivityMessage:(TCNetworkJob *)currentJob;

- (TCNetworkJob *)jobForRequest:(TCRequest *)request;
- (TCNetworkJob *)urgentJobInArray:(NSMutableArray *)jobArray;

- (void)jobDidFinishWithError:(NSDictionary *)info;

@end

@implementation TCNetworkManager

@synthesize internetReach;

+ (TCNetworkManager *) manager {
	static TCNetworkManager *instance = nil;
	if (instance == nil) {
		instance = [[TCNetworkManager alloc] init];
	}
	
	return instance;
}

@synthesize networkJobs;
@synthesize currentJobs;

- (id) init {
    self = [super init];
	if (self) {
		self.networkJobs = [[NSMutableArray alloc] init];
		self.currentJobs = [[NSMutableArray alloc] init];
		self.internetReach = [TCReachability reachabilityForInternetConnection];
	}	
	return self;
}

- (void) dealloc {
    for (TCNetworkJob *job  in self.currentJobs) {
        [self hideActivityMessage:job];
    }
	
	[self stopUpdatingReachability];
	[networkJobs release];
    [currentJobs release];
	[internetReach release];
	[super dealloc];
}

#pragma mark network communication methods

- (void) executeNextJob {
	customLog(@"Trying to execute a job");   
    

    TCNetworkJob *nextJob = [self urgentJobInArray:self.networkJobs];
    if (!nextJob && [self.currentJobs count] == 0) {
        nextJob = [self.networkJobs lastObject];
    }
    if(!nextJob) {
        // nothing to do
        return;
    }
    [nextJob retain];
    // unqueue job
    [self.networkJobs removeObject:nextJob];
                    
#ifndef MOCK_API_CALLS // Only check for internet connection if not using mock files
    if ([self.internetReach currentReachabilityStatus] != NotReachable) {
#endif

        [self.currentJobs addObject:nextJob];
        [self showActivityMessage:nextJob];
        customLog(@"Execute job %@", nextJob);
        [nextJob execute: self];

#ifndef MOCK_API_CALLS
    } else { // no internet
        NSError *error = [NSError errorWithDomain: @"TeraCode.NetworkManager" code: 100 userInfo: nil];
        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                              nextJob, JOB_KEY, error, ERROR_KEY, nil];
        [self performSelector:@selector(jobDidFinishWithError:) withObject:info afterDelay:0.];
    }
#endif
    
    [nextJob release];   
}

- (void)jobDidFinishWithError:(NSDictionary *)info {
    TCNetworkJob *job = [info objectForKey:JOB_KEY];
    NSError *error = [info objectForKey:ERROR_KEY];
    [job.delegate connectionDidFinishWithError:error];
}

- (void) cancelJob: (TCNetworkJob *) job {
	if ([self.currentJobs containsObject:job]) {
		[self hideActivityMessage:job];
		
		[job cancel];
		[self.currentJobs removeObject:job];
	}
	[self.networkJobs removeObject: job];
}

- (TCNetworkJob *)createJobForURL:(NSURL *)url
                           params:(NSDictionary *)params
                          headers:(NSDictionary *)headers
                            files:(NSDictionary *)files
                           method:(TCRequestMethodType)method
                          timeout:(NSTimeInterval)timeout
                         priority:(TCJobPriority)priority
                         delegate:(id<TCNetworkManagerDelegate>)delegate {
	TCNetworkJob *networkJob = [[[TCNetworkJob alloc] init] autorelease];
	networkJob.params = params;
	networkJob.headers = headers;
	networkJob.files = files;
	networkJob.url = url;
	networkJob.method = method;
	networkJob.timeout = timeout;
	networkJob.delegate = delegate;
	
	// queue job
    switch (priority) {
        case TCJobPriorityNormal:
            [self.networkJobs insertObject:networkJob atIndex:0];
            break;
        case TCJobPriorityHigh:
            [self.networkJobs addObject:networkJob];
            break;
    }
	
#ifdef DEBUG
	customLog(@"Create job %@ for delegate %@", networkJob, networkJob.delegate);
	NSString *methodName = nil;
	switch (networkJob.method) {
		case TCRequestMethodTypeGet:
			methodName = @"GET";
			break;
		case TCRequestMethodTypePut:
			methodName = @"PUT";
			break;
		case TCRequestMethodTypePost:
			methodName = @"POST";
			break;
		case TCRequestMethodTypeDelete:
			methodName = @"DELETE";
			break;
		default:
			methodName = @"POST";
			break;
	}
	
	customLog(@"Request method: %@", methodName);
	customLog(@"Request params: %@", [networkJob.params queryString]);
#endif
	
	return networkJob;
}

#pragma mark TCRequestDelegate

- (void) request: (TCRequest *) request didFinishWithData: (NSData *) data response: (NSHTTPURLResponse *) response {
	TCNetworkJob *currentJob = [self jobForRequest:request];
    
#ifdef DEBUG
	customLog(@"Request %@ for job %@ [%@] finish", request, currentJob, currentJob.request);
	customLog(@"Response statusCode: %d", response.statusCode);
	customLog(@"Response headers: %@", [response allHeaderFields]);
	
    NSString *responseString = [[NSString alloc] initWithData: data encoding: currentJob.encoding];
    customLog(@"Response data: %@", responseString);	
    [responseString release];
	
#endif
	
	[currentJob.delegate connectionDidFinishWithData: data response: response];
	
	[self hideActivityMessage:currentJob];
	
	[self.currentJobs removeObject:currentJob];
	
	customLog(@"NetworkManager: getting another job from the queue");
	
	[self executeNextJob];
}

- (void) request: (TCRequest *) request didFinishWithError: (NSError *) error {
	TCNetworkJob *currentJob = [self jobForRequest:request];
	customLog(@"Request %@ for job %@ [%@] finished with error", request, currentJob, currentJob.request);
	
	[currentJob.delegate connectionDidFinishWithError: error];
	
	[self hideActivityMessage:currentJob];
	
	[self.currentJobs removeObject:currentJob];	
	[self executeNextJob];
}

- (void) request: (TCRequest *) request didMakeDownloadProgress: (NSNumber *) progress {
    TCNetworkJob *currentJob = [self jobForRequest:request];
	if ([currentJob.delegate respondsToSelector:@selector(connectionDidMakeDownloadProgress:)]) {
		[currentJob.delegate connectionDidMakeDownloadProgress:progress];
	}
}

- (void) request: (TCRequest *) request didMakeUploadProgress: (NSNumber *) progress  {
    TCNetworkJob *currentJob = [self jobForRequest:request];
	if ([currentJob.delegate respondsToSelector:@selector(connectionDidMakeUploadProgress:)]) {
		[currentJob.delegate connectionDidMakeUploadProgress:progress];
	}
}

#pragma mark -
#pragma mark Reachability

- (void) startUpdatingReachability {
	// Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
	// method "reachabilityChanged" will be called. 
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
	
	[internetReach startNotifier];
}

- (void) stopUpdatingReachability {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[internetReach stopNotifier];
}

//Called by Reachability whenever status changes.
- (void) reachabilityChanged: (NSNotification* )note {
#ifndef HIDE_LOGS // to avoid compiler warning
	TCReachability* curReach = [note object];
	customLog(@"curReach: %d", [curReach currentReachabilityStatus]);
	NSParameterAssert([curReach isKindOfClass: [TCReachability class]]);
#endif
}

#pragma mark -
#pragma mark Activity message

- (void)showActivityMessage:(TCNetworkJob *)currentJob {

    // Display the network activity indicator in the status bar
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: YES];
    NSNotification *notification = [NSNotification notificationWithName:TC_NETWORKING_LOADING_START_NOTIFICATION object: currentJob];
    
    [[NSNotificationCenter defaultCenter] postNotification: notification];
}

- (void)hideActivityMessage:(TCNetworkJob *)currentJob  {
	// Hide the network activity indicator in the status bar
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible: NO];
    NSNotification *notification = [NSNotification notificationWithName:TC_NETWORKING_LOADING_START_NOTIFICATION object: currentJob];
    
    [[NSNotificationCenter defaultCenter] postNotification: notification];
}

#pragma mark private methods

- (TCNetworkJob *)jobForRequest:(TCRequest *)request{
    for(TCNetworkJob *job in self.currentJobs)
    {
        if ([job.request isEqual:request]) {
            return job;
        }
    }
    
    return nil;
}

- (TCNetworkJob *)urgentJobInArray:(NSMutableArray *)jobArray{
    TCNetworkJob *urgentJob = nil;
    for (TCNetworkJob *job in jobArray) {
        if (job.executeImmediately) {
            urgentJob = job;
            break;
        }
    }        
    return urgentJob;
}

@end