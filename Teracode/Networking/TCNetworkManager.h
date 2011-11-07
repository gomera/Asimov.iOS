#import "TCNetworkJob.h"
#import "TCRequest.h"
#import "TCReachability.h"

typedef enum {
    TCJobPriorityHigh,
    TCJobPriorityNormal
} TCJobPriority;

@protocol TCNetworkManagerDelegate <NSObject>

- (void) connectionDidFinishWithData: (NSData *) data response: (NSHTTPURLResponse *) response;
- (void) connectionDidFinishWithError: (NSError *) error;

@optional
- (void) connectionDidMakeDownloadProgress: (NSNumber *) progress;
- (void) connectionDidMakeUploadProgress: (NSNumber *) progress;

@end

@interface TCNetworkManager : NSObject<TCRequestDelegate> {
		NSMutableArray *networkJobs;
		TCReachability* internetReach;
@private
		NSMutableArray *currentJobs;
}

+ (TCNetworkManager *) manager;

@property (nonatomic, retain) NSMutableArray *networkJobs;
@property (nonatomic, retain) NSMutableArray *currentJobs;

- (TCNetworkJob *)createJobForURL:(NSURL *)url
                           params:(NSDictionary *)params
                          headers:(NSDictionary *)headers
                            files:(NSDictionary *)files
                           method:(TCRequestMethodType)method
                          timeout:(NSTimeInterval)timeout
                         priority:(TCJobPriority)priority
                         delegate:(id<TCNetworkManagerDelegate>)delegate;

- (void) cancelJob: (TCNetworkJob *) job;
- (void) executeNextJob;

@end
