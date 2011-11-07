
#import "TCNetworkManager.h"

@class TCAPICall;
@class TCAttachment;

@protocol TCAPICallDelegate<NSObject>

- (void) apiCall: (TCAPICall *) apiCall didFinishWithError: (NSError *) error;
- (void) apiCallDidFinishSuccessfully: (TCAPICall *) apiCall;

@optional

- (void) apiCall: (TCAPICall *) apiCall didMakeDownloadProgress: (NSNumber *) progress;
- (void) apiCall: (TCAPICall *) apiCall didMakeUploadProgress: (NSNumber *) progress ;

@end


/**
 * This class performs API calls, sending parameters to the server.
 * The delegate is notified when the API call finishes. If an error 
 * occurrs, it is included as a parameter in the corresponding method.
 */
@interface TCAPICall : NSObject<TCNetworkManagerDelegate> {
	id<TCAPICallDelegate> delegate;
	NSMutableDictionary *params;
	NSMutableDictionary *headers;
	NSMutableDictionary *files;
	TCRequestMethodType method;
	BOOL mock;
	float delay;
	TCNetworkJob *job;
	NSTimeInterval timeout;
	BOOL secure;
	BOOL automaticSignOut;
    BOOL executeImmediately;
    TCJobPriority priority;
}

@property (nonatomic, assign) TCRequestMethodType method;
@property (nonatomic, retain) NSMutableDictionary *params;
@property (nonatomic, retain) NSMutableDictionary *headers;
@property (nonatomic, retain) NSMutableDictionary *files;
@property (nonatomic, assign) id<TCAPICallDelegate> delegate;
@property (nonatomic, assign) BOOL mock;
@property (nonatomic, assign) float delay;
@property (nonatomic, retain) TCNetworkJob *job;
@property (nonatomic, assign) NSTimeInterval timeout;
@property (nonatomic, assign) BOOL secure;
// When an UNAUTHORIZED response is received, automatically logs the user out
@property (nonatomic, assign) BOOL automaticSignOut;
// prevents that the apicall to be enqueue
@property (nonatomic, assign) BOOL executeImmediately;
@property (nonatomic, assign) TCJobPriority priority;

+ (id)apiCallWithDelegate:(id<TCAPICallDelegate>)theDelegate;

- (id) initWithDelegate: (id<TCAPICallDelegate>) theDelegate;
- (NSString *) baseURL;
- (NSString *) secureBaseURL;
- (NSString *) relativePath;
- (NSStringEncoding) encoding;

- (void) addParameter: (id) value forKey: (NSString *) key;
- (void) addParameters: (NSDictionary *) values;
- (void) removeParameterForKey: (NSString *) key;

- (void) addFileParameter: (TCAttachment *) file forKey: (NSString *) key;
- (void) addFileParameters: (NSDictionary *) values;

// By default, this method just notifies the delegate about the successfull result
- (BOOL) processResponse: (NSData *) data error: (NSError **) error;

// This method should be reimplemented for custom error handling based on the HTTP response
- (BOOL) checkResponse: (NSHTTPURLResponse *) response error: (NSError **) error;

- (void) execute;
- (void) cancel;

@end
