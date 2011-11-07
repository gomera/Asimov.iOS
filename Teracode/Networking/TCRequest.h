
typedef enum {
	TCRequestMethodTypeGet = 0,
	TCRequestMethodTypePut,
	TCRequestMethodTypePost,
	TCRequestMethodTypeDelete
} TCRequestMethodType;

@class TCNetworkJob;
@class TCRequest;

@protocol TCRequestDelegate <NSObject>

- (void) request: (TCRequest *) request didFinishWithData: (NSData *) data response: (NSHTTPURLResponse *) response;
- (void) request: (TCRequest *) request didFinishWithError: (NSError *) error;

@optional
- (void) request: (TCRequest *) request didMakeDownloadProgress: (NSNumber *) progress;
- (void) request: (TCRequest *) request didMakeUploadProgress: (NSNumber *) progress ;

@end


@interface TCRequest : NSObject {
	id<TCRequestDelegate> delegate;
	NSMutableData *receivedData;
	NSHTTPURLResponse *response;
	float requestProgress;
	NSUInteger bytesReceived;
}

@property (nonatomic, retain) NSMutableData *receivedData;
@property (nonatomic, retain) NSHTTPURLResponse *response;
@property (nonatomic, assign) id<TCRequestDelegate> delegate;

- (id) initWithRequestDelegate: (id<TCRequestDelegate>) theDelegate;

- (void) executeJob: (TCNetworkJob *) job;
- (void) cancel;

@end