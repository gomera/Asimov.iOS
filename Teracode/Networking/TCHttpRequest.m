#import "TCHttpRequest.h"
#import "TCNetworkJob.h"
#import "TCAttachment.h"

#define TIMEOUT_ERROR_CODE -1001

#define TC_HTTPREQUEST_ERROR_TIMEOUT_CODE 100
#define TC_HTTPREQUEST_ERROR_TIMEOUT_MESSAGE @"Timeout"

#define TC_HTTPREQUEST_ERROR_AUTH_CODE 101
#define TC_HTTPREQUEST_ERROR_AUTH_MESSAGE @"Authentication fail"



@interface TCHttpRequest ()

- (NSError *) errorWithCode:(NSInteger)code message: (NSString *) message;

@end


@implementation TCHttpRequest

// just some random text that will never occur in the body
static NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";

- (NSError *) errorWithCode:(NSInteger)code message: (NSString *) message {
    
    NSString *localizedDescription = NSLocalizedString(message, @"");
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:localizedDescription
                                                         forKey:NSLocalizedDescriptionKey];
    return [NSError errorWithDomain: @"Teracode.HttpRequest" code:code userInfo:userInfo];
}

- (void)appendBoundaryToBody:(NSMutableData*)postBody job: (TCNetworkJob *) job {
	[postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding: job.encoding]];
}

- (NSURLRequest *) createMultipartNSURLGenericRequestWithJob: (TCNetworkJob *) job method: (NSString *) method {
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: job.url
														   cachePolicy: NSURLRequestReloadIgnoringCacheData	
													   timeoutInterval: job.timeout];
	
	[request setValue: @"Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_1 like Mac OS X; en-us) AppleWebKit/525.18.1 (KHTML, like Gecko) Version /3.1.1 Mobile/5A347 Safari/525.2Wha" forHTTPHeaderField: @"User-Agent"];
	
	[request setHTTPMethod:method];
	
	// Set headers
	for (NSString *headerKey in job.headers) {
		[request setValue:[job.headers objectForKey:headerKey] forHTTPHeaderField:headerKey];
	}
	
	// @TODO what if there are no params and just files?
	if (job.params && [job.params count] > 0) {
		NSString *contentType = [NSString stringWithFormat: @"multipart/form-data; boundary=%@", stringBoundary];
		[request setValue: contentType forHTTPHeaderField: @"Content-Type"];
		
		NSMutableData *postBody = [NSMutableData data];
		NSStringEncoding encoding = job.encoding;
		
		[self appendBoundaryToBody:postBody job: job];

		// Add parameters
		for (NSString *key in [job.params allKeys]) {
			[postBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key] dataUsingEncoding: encoding]];
			[postBody appendData:[[NSString stringWithString: [[job.params objectForKey: key] description]] dataUsingEncoding: encoding]];
			
			[postBody appendData: [[NSString stringWithString:@"\r\n"] dataUsingEncoding: encoding]];
			[self appendBoundaryToBody:postBody job: job];
		}
		
		// Add Files
		for (NSString *key in [job.files allKeys]) {			
			TCAttachment *attach = (TCAttachment *) [job.files objectForKey: key];
			[postBody appendData: [[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key, attach.filename] dataUsingEncoding:NSUTF8StringEncoding]];
			[postBody appendData: [[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", attach.mime] dataUsingEncoding: encoding]];
			[postBody appendData: attach.data];
			[postBody appendData: [[NSString stringWithString:@"\r\n"] dataUsingEncoding: encoding]];
			[self appendBoundaryToBody:postBody job: job];
		}
		[request setHTTPBody: postBody];
	}
	
	return request;	
}

- (NSURLRequest *) createFormNSURLGenericRequestWithJob: (TCNetworkJob *) job method: (NSString *) method  {
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: job.url
														   cachePolicy: NSURLRequestReloadIgnoringCacheData	
													   timeoutInterval: job.timeout];
	
	[request setValue: @"Mozilla/5.0 (iPhone; U; CPU iPhone OS 3_1 like Mac OS X; en-us) AppleWebKit/525.18.1 (KHTML, like Gecko) Version /3.1.1 Mobile/5A347 Safari/525.2Wha" forHTTPHeaderField: @"User-Agent"];
	
	[request setHTTPMethod:method];

	// Set headers
	for (NSString *headerKey in job.headers) {
		[request setValue:[job.headers objectForKey:headerKey] forHTTPHeaderField:headerKey];
	}
	
	if (job.params && [job.params count] > 0) {
		
		NSString *contentType = [NSString stringWithFormat: @"application/x-www-form-urlencoded"];
		[request setValue: contentType forHTTPHeaderField: @"content-type"];
		
		NSMutableData *postBody = [NSMutableData data];
		NSStringEncoding encoding = job.encoding;
		
		[postBody appendData: [@"\r\n" dataUsingEncoding: encoding]];
		[request setHTTPBody: [[job.params queryString] dataUsingEncoding:encoding]];
	}
	
	return request;	
}

- (NSURLRequest *) createNSURLGetRequestWithJob: (TCNetworkJob *) job {
	NSMutableString *urlString = [NSMutableString stringWithString:[job.url absoluteString]];
	
	if ([job.params count] > 0) {
		// We need to add the parameters to the query string.
		[urlString appendFormat:@"?%@", [job.params queryString]];
	}
	
	customLog (@"Request URL: %@", urlString);
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:urlString]
														   cachePolicy: NSURLRequestReloadIgnoringCacheData	
													   timeoutInterval: job.timeout];
	[request setHTTPMethod: @"GET"];

	// Set headers
	for (NSString *headerKey in job.headers) {
		[request setValue:[job.headers objectForKey:headerKey] forHTTPHeaderField:headerKey];
	}
	
	return request;
}

- (NSURLRequest *) createNSURLGenericRequestWithJob: (TCNetworkJob *) job method: (NSString *) method {
	if ([job.files count] > 0) {
		// Multipart
		return [self createMultipartNSURLGenericRequestWithJob:job method:method];
	} else {
		// Form
		return [self createFormNSURLGenericRequestWithJob:job method:method];
	}
}

- (NSURLRequest *) createNSURLPutRequestWithJob: (TCNetworkJob *) job {
	return [self createNSURLGenericRequestWithJob:job method:@"PUT"];
}

- (NSURLRequest *) createNSURLPostRequestWithJob: (TCNetworkJob *) job {
	return [self createNSURLGenericRequestWithJob:job method:@"POST"];
}

- (NSURLRequest *) createNSURLDeleteRequestWithJob: (TCNetworkJob *) job {
	return [self createNSURLGenericRequestWithJob:job method:@"DELETE"];	
}

- (NSURLRequest *) createNSURLRequestWithJob: (TCNetworkJob *) job {
	
	NSURLRequest *request = nil;
	
	switch (job.method) {
		case TCRequestMethodTypeGet:
			request = [self createNSURLGetRequestWithJob:job];
			break;
		case TCRequestMethodTypePut:
			request = [self createNSURLPutRequestWithJob:job];
			break;
		case TCRequestMethodTypePost:
			request = [self createNSURLPostRequestWithJob:job];
			break;
		case TCRequestMethodTypeDelete:
			request = [self createNSURLDeleteRequestWithJob:job];
			break;
	}
	
	return request;
}

- (void) executeJob: (TCNetworkJob *) job {
	requestProgress = 0.0f;
	bytesReceived = 0.0f;
	
	NSURLRequest *request = [self createNSURLRequestWithJob: job];		
	customLog(@"Executing HTTP Request at: %@", [request URL]);
	[[NSURLConnection alloc] initWithRequest: request delegate: self startImmediately: YES];
}


#pragma mark NSURLConnection implementation

- (void) connection: (NSURLConnection *) connection didReceiveResponse: (NSURLResponse *) theResponse {
	self.response = (NSHTTPURLResponse *) theResponse;
	self.receivedData = [NSMutableData data];
}

- (void) connection: (NSURLConnection *) connection didReceiveData: (NSData *) data {
	[self.receivedData appendData: data];
	
	NSInteger receivedLength = [data length];
	bytesReceived = (bytesReceived + receivedLength);
	if([self.response expectedContentLength] != NSURLResponseUnknownLength) {
		requestProgress = (float) bytesReceived / (float) [self.response expectedContentLength];
		if ([self.delegate respondsToSelector:@selector(request:didMakeDownloadProgress:)]) {
			[self.delegate request: self didMakeDownloadProgress: [NSNumber numberWithFloat:requestProgress]];
		}
	}	
#ifdef DEBUG
	else {
		customLog (@"Response expectedContentLength is unknown");
	}
#endif
}

- (void) connection: (NSURLConnection *) connection didFailWithError: (NSError *) error {
    [connection release];
	self.receivedData = nil;
	
    // inform the user
    //in place of NSErrorFailingURLStringKey the application should use NSURLErrorFailingURLStringErrorKey but it is supported on ios 4 and later
    customLog(@"Connection failed! Error - %@ %@",
			  [error localizedDescription],
			  [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
	
	if (error.code == TIMEOUT_ERROR_CODE) {
		// Timeout error. Don't show the default message
		error = [self errorWithCode:TC_HTTPREQUEST_ERROR_TIMEOUT_CODE message: TC_HTTPREQUEST_ERROR_TIMEOUT_MESSAGE];
	}
	
	[self.delegate request: self didFinishWithError: error];
}

- (void) connectionDidFinishLoading: (NSURLConnection *) connection {
    [connection release];
	[self.delegate request: self didFinishWithData: self.receivedData response: self.response];
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_3_0) {
	
	float progress = (float) totalBytesWritten / (float)totalBytesExpectedToWrite ;
	
	if ([self.delegate respondsToSelector:@selector(request:didMakeUploadProgress:)]) {
		[self.delegate request: self didMakeUploadProgress: [NSNumber numberWithFloat:progress]];
	}
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace { // @TODO analyze
	if ([protectionSpace authenticationMethod] == NSURLAuthenticationMethodServerTrust) {
		return YES; 
	} else {
		return NO;
	}
}

// Called if the HTTP request receives an authentication challenge.
-(void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	if([challenge previousFailureCount] == 0) {
		NSURLCredential *newCredential;
        newCredential = [NSURLCredential credentialForTrust:[[challenge protectionSpace] serverTrust]]; // @TODO analyze
        [[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
    } else {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
		NSError* error = [self errorWithCode:TC_HTTPREQUEST_ERROR_AUTH_CODE message: TC_HTTPREQUEST_ERROR_AUTH_MESSAGE];
		[self.delegate request: self didFinishWithError: error];
    }
}

@end
